"""Microservicio de IA "Ángel" - LoveMakeup C.A.

Ejecutar:  uvicorn main:app --reload --port 8000
Docs automáticas (Swagger):  http://localhost:8000/docs
"""
import logging
import time

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from auth import verificar_token
from config import get_settings
from llm import conversar
from nlp import extraer_perfil
from schemas import ConsultaChat, RespuestaChat

log = logging.getLogger("angel")
logging.basicConfig(level=logging.INFO)


app = FastAPI(title="Ángel - Asesor de belleza LoveMakeup", version="1.0.0")

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

    perfil = extraer_perfil(mensaje)

    try:
        texto = await conversar(mensaje, perfil, consulta.historial)
    except Exception as e:
        log.exception("Error conversando con Qwen a través de Groq")
        raise HTTPException(502, "Ángel no pudo conectarse con el servicio de IA") from e

    log.info("chat atendido en %.0f ms", (time.perf_counter() - t0) * 1000)
    return RespuestaChat(respuesta=texto, perfil=perfil, productos=[])
