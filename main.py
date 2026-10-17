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
from auth import verificar_token
from config import get_settings
from llm import generar_embedding, redactar_respuesta
from nlp import extraer_perfil, texto_para_embedding
from schemas import ConsultaChat, RespuestaChat

log = logging.getLogger("angel")
logging.basicConfig(level=logging.INFO)


@asynccontextmanager
async def lifespan(app: FastAPI):
    await db.init_pool()
    yield
    await db.close_pool()


app = FastAPI(title="Ángel - Asesor de belleza LoveMakeup", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[o.strip() for o in get_settings().cors_origins.split(",")],
    allow_methods=["POST", "GET"],
    allow_headers=["Authorization", "Content-Type"],
)


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.post("/api/chat", response_model=RespuestaChat)
async def chat(consulta: ConsultaChat, _usuario: dict = Depends(verificar_token)):
    t0 = time.perf_counter()

    mensaje = consulta.mensaje.strip()
    if not mensaje:
        raise HTTPException(422, "El mensaje no puede estar vacío")

    # 1) PLN: perfil del usuario (RF-01)
    perfil = extraer_perfil(mensaje)

    # 2) Embedding de la consulta
    try:
        vec = await generar_embedding(texto_para_embedding(mensaje, perfil))
    except Exception as e:
        log.exception("Error generando embedding")
        raise HTTPException(502, "Error en el servicio de IA") from e

    # 3) Consulta híbrida SQL + vectores (RF-02, RF-03)
    productos = await db.buscar_productos(vec, perfil, limite=5)

    # 4) Redacción de la respuesta con datos reales
    texto = await redactar_respuesta(mensaje, perfil, productos)

    log.info("chat atendido en %.0f ms", (time.perf_counter() - t0) * 1000)
    return RespuestaChat(respuesta=texto, perfil=perfil, productos=productos)
