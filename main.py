"""Microservicio de IA "Ángel" - LoveMakeup C.A.

Ejecutar:  uvicorn main:app --reload --port 8000
Docs automáticas (Swagger):  http://localhost:8000/docs
"""
import logging
import time
from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

import db
import seed
from auth import verificar_token
from config import get_settings
from llm import describir_imagen, generar_embedding, redactar_respuesta
from nlp import extraer_perfil, texto_para_embedding
from schemas import (
    ConsultaChat,
    MensajeHistorial,
    RespuestaChat,
    SolicitudReindexacion,
)

log = logging.getLogger("angel")
logging.basicConfig(level=logging.INFO)


@asynccontextmanager
async def lifespan(app: FastAPI):
    await db.init_pool()
    try:
        yield
    finally:
        await db.close_pool()
        await seed.cerrar_cliente()


app = FastAPI(title="Ángel - Asesor de belleza LoveMakeup", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[o.strip() for o in get_settings().cors_origins.split(",")],
    allow_methods=["POST", "GET"],
    allow_headers=["Authorization", "Content-Type"],
)


@app.get("/health")
async def health():
    try:
        await db.healthcheck()
    except Exception as e:
        log.exception("Health check de base de datos falló")
        raise HTTPException(503, "Base de datos no disponible") from e
    return {"status": "ok"}


@app.post("/api/reindexar")
async def reindexar(
    solicitud: SolicitudReindexacion,
    usuario_payload: dict = Depends(verificar_token),
):
    if usuario_payload.get("scope") != "angel:reindex":
        raise HTTPException(403, "El token no tiene permiso para reindexar")

    try:
        procesados = await seed.ejecutar_reindexacion(
            solicitud.tipo,
            id=solicitud.id,
            ids=solicitud.ids,
            solo_pendientes=solicitud.solo_pendientes,
        )
    except LookupError as e:
        raise HTTPException(404, str(e)) from e
    except seed.ErrorReindexacion as e:
        log.exception("Reindexación parcial de %s", solicitud.tipo)
        cantidad = sum(e.procesados.values())
        raise HTTPException(
            502,
            detail={
                "mensaje": f"{e}. Se procesaron {cantidad} registro(s) antes del fallo.",
                "procesados": cantidad,
                "detalle": e.procesados,
            },
        ) from e
    except Exception as e:
        log.exception("Falló la reindexación de %s", solicitud.tipo)
        raise HTTPException(
            502,
            detail={
                "mensaje": (
                    "No se pudo completar la reindexación. Revise la conexión con "
                    "MariaDB, la configuración de OpenRouter y los logs del servicio."
                ),
                "procesados": 0,
                "detalle": {},
            },
        ) from e

    total = sum(procesados.values())
    return {
        "estado": "completado",
        "tipo": solicitud.tipo,
        "procesados": total,
        "detalle": procesados,
        "mensaje": (
            f"Reindexación completada: {total} registro(s) procesado(s)"
            if total
            else "No había registros que reindexar"
        ),
    }


@app.post("/api/chat", response_model=RespuestaChat)
async def chat(consulta: ConsultaChat, usuario_payload: dict = Depends(verificar_token)):
    t0 = time.perf_counter()

    # Identidad real (memoria por usuario): sub del token. Invitados = anon_*
    usuario = (usuario_payload or {}).get("sub") or ""
    es_anonimo = usuario.startswith("anon")

    mensaje = consulta.mensaje.strip()
    if not mensaje:
        raise HTTPException(422, "El mensaje no puede estar vacío")

    # 1) PLN: perfil del usuario (RF-01)
    perfil = extraer_perfil(mensaje)

    # 1a) Memoria: historial del usuario desde la BD; respaldo con el que
    #     mandó el widget si la memoria aún no existe.
    historial: list[MensajeHistorial] = []
    if usuario and not es_anonimo:
        try:
            historial = await db.leer_conversacion(usuario, get_settings().historial_prompt)
        except Exception:
            log.exception("No se pudo leer la memoria del usuario; sigue sin memoria")
    if not historial and consulta.historial:
        historial = consulta.historial

    # 1b) Fase de visión: describir la(s) foto(s) si el cliente envió imágenes.
    #     La descripción es texto: entra al perfil, al embedding y al prompt.
    descripcion_foto = ""
    if consulta.imagenes:
        try:
            descripcion_foto = await describir_imagen(consulta.imagenes, mensaje)
            if descripcion_foto:
                perfil = extraer_perfil(mensaje + " " + descripcion_foto)
                log.info("Visión: %s", descripcion_foto[:120])
        except Exception:
            log.exception("Fase de visión falló; continúa solo con texto")

    # 2) Embedding de la consulta
    try:
        vec = await generar_embedding(texto_para_embedding(mensaje, perfil, descripcion_foto))
    except Exception as e:
        log.exception("Error generando embedding")
        raise HTTPException(502, "Error en el servicio de IA") from e

    # 3) Consulta híbrida SQL + vectores (RF-02, RF-03)
    try:
        productos = await db.buscar_productos(vec, perfil, limite=5)
    except db.CatalogoSinIndexarError as e:
        log.error("%s", e)
        raise HTTPException(503, str(e)) from e

    # 3b) Base de conocimiento: fichas internas afines a la consulta
    try:
        fichas = await db.buscar_conocimiento(vec)
    except Exception:
        log.exception("No se pudo buscar en la base de conocimiento")
        fichas = []

    # 4) Redacción de la respuesta con datos reales
    texto = await redactar_respuesta(
        mensaje, perfil, productos, descripcion_foto, historial, fichas
    )

    # 5) Memoria: guardar el intercambio (best-effort; solo usuarios reales)
    if usuario and not es_anonimo:
        try:
            await db.guardar_conversacion(
                usuario,
                [("usuario", mensaje[:1000]), ("asistente", texto[:1000])],
            )
        except Exception:
            log.exception("No se pudo guardar la conversación en memoria")

    log.info("chat atendido en %.0f ms", (time.perf_counter() - t0) * 1000)
    return RespuestaChat(respuesta=texto, perfil=perfil, productos=productos)
