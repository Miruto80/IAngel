"""Pruebas unitarias (XP): PLN y JWT. Ejecutar: pytest -v"""
import asyncio
import os
import time
from types import SimpleNamespace

os.environ.setdefault("DB_HOST", "127.0.0.1")
os.environ.setdefault("DB_PORT", "3306")
os.environ.setdefault("DB_USER", "angel")
os.environ.setdefault("DB_PASSWORD", "")
os.environ.setdefault("DB_NAME", "test")
os.environ.setdefault("JWT_SECRET", "secreto_de_pruebas")
os.environ.setdefault("JWT_ALGORITHM", "HS256")
os.environ.setdefault("OPENAI_API_KEY", "")
os.environ.setdefault("EMBEDDING_MODEL", "text-embedding-3-small")
os.environ.setdefault("GROQ_API_KEY", "")
os.environ.setdefault("LLM_MODEL", "qwen/qwen3.8-27b")
os.environ.setdefault("LLM_TIMEOUT_SECONDS", "1.0")
os.environ.setdefault("CORS_ORIGINS", "http://localhost")

import jwt  # noqa: E402
from fastapi import HTTPException  # noqa: E402
from fastapi.security import HTTPAuthorizationCredentials  # noqa: E402
import pytest  # noqa: E402

from auth import verificar_token  # noqa: E402
from db import embedding_a_texto, similitud_coseno  # noqa: E402
import llm  # noqa: E402
from nlp import extraer_perfil  # noqa: E402
from schemas import PerfilDetectado  # noqa: E402


def test_detecta_piel_grasa_y_presupuesto():
    p = extraer_perfil("Tengo la piel grasa y con acné, busco una base de menos de $15")
    assert p.tipo_piel == "grasa"
    assert "acne" in p.necesidades
    assert p.categoria == "base"
    assert p.precio_max == 15.0


def test_detecta_piel_seca():
    p = extraer_perfil("mi piel está muy reseca, qué crema me recomiendas")
    assert p.tipo_piel == "seca"
    assert p.categoria == "skincare"


def test_jwt_valido():
    token = jwt.encode({"sub": "1", "exp": time.time() + 60}, "secreto_de_pruebas", algorithm="HS256")
    cred = HTTPAuthorizationCredentials(scheme="Bearer", credentials=token)
    assert verificar_token(cred)["sub"] == "1"


def test_jwt_invalido():
    cred = HTTPAuthorizationCredentials(scheme="Bearer", credentials="basura")
    with pytest.raises(HTTPException) as e:
        verificar_token(cred)
    assert e.value.status_code == 401


def test_similitud_coseno():
    assert similitud_coseno([1.0, 0.0], [1.0, 0.0]) == pytest.approx(1.0)
    assert similitud_coseno([1.0, 0.0], [0.0, 1.0]) == pytest.approx(0.0)


def test_embedding_a_texto_exige_1536_dimensiones():
    with pytest.raises(ValueError, match="1536"):
        embedding_a_texto([0.1])


def test_redactar_respuesta_usa_groq_en_stream(monkeypatch):
    class Stream:
        async def __aiter__(self):
            yield SimpleNamespace(choices=[SimpleNamespace(delta=SimpleNamespace(content="Respuesta "))])
            yield SimpleNamespace(choices=[SimpleNamespace(delta=SimpleNamespace(content="de Ángel"))])

    class Completions:
        async def create(self, **kwargs):
            self.request = kwargs
            return Stream()

    completions = Completions()
    cliente = SimpleNamespace(chat=SimpleNamespace(completions=completions))
    monkeypatch.setattr(llm, "_groq", cliente)

    respuesta = asyncio.run(
        llm.redactar_respuesta("Busco una crema", PerfilDetectado(), [])
    )

    assert respuesta == "Respuesta de Ángel"
    assert completions.request["model"] == "qwen/qwen3.8-27b"
    assert completions.request["stream"] is True
    assert completions.request["messages"][0]["role"] == "system"
