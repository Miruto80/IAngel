"""Pruebas unitarias (XP): PLN y JWT. Ejecutar: pytest -v"""
import asyncio
import os
import time
from pathlib import Path
from types import SimpleNamespace

os.environ.setdefault("DB_HOST", "127.0.0.1")
os.environ.setdefault("DB_PORT", "3306")
os.environ.setdefault("DB_USER", "angel")
os.environ.setdefault("DB_PASSWORD", "")
os.environ.setdefault("DB_NAME", "test")
os.environ.setdefault("JWT_PUBLIC_KEY_PATH", os.devnull)
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
from cryptography.hazmat.primitives import serialization  # noqa: E402
from cryptography.hazmat.primitives.asymmetric import rsa  # noqa: E402

import auth  # noqa: E402
from auth import verificar_token  # noqa: E402
from db import embedding_a_texto, similitud_coseno  # noqa: E402
import llm  # noqa: E402
import main  # noqa: E402
from nlp import extraer_perfil  # noqa: E402
from schemas import ConsultaChat, MensajeConversacion, PerfilDetectado  # noqa: E402


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


def test_jwt_valido(tmp_path: Path, monkeypatch):
    private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    public_key = private_key.public_key()
    public_key_path = tmp_path / "angel_public.pem"
    public_key_path.write_bytes(
        public_key.public_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PublicFormat.SubjectPublicKeyInfo,
        )
    )
    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption(),
    )
    token = jwt.encode(
        {"sub": "1", "exp": time.time() + 60},
        private_pem,
        algorithm="RS256",
    )
    monkeypatch.setattr(
        auth,
        "get_settings",
        lambda: SimpleNamespace(jwt_public_key_path=str(public_key_path)),
    )
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


def test_conversar_envia_mensaje_directo_a_qwen(monkeypatch):
    class Completions:
        async def create(self, **kwargs):
            self.request = kwargs
            return SimpleNamespace(
                choices=[
                    SimpleNamespace(
                        message=SimpleNamespace(content="Hola, ¿qué te gustaría saber?")
                    )
                ]
            )

    completions = Completions()
    cliente = SimpleNamespace(chat=SimpleNamespace(completions=completions))
    monkeypatch.setattr(llm, "_groq", cliente)

    respuesta = asyncio.run(
        llm.conversar(
            "Hola Ángel",
            PerfilDetectado(),
            [MensajeConversacion(role="user", content="Busco una crema")],
        )
    )

    assert respuesta == "Hola, ¿qué te gustaría saber?"
    assert completions.request["model"] == "qwen/qwen3.8-27b"
    assert completions.request["messages"][2] == {
        "role": "user",
        "content": "Busco una crema",
    }
    assert completions.request["messages"][3] == {
        "role": "user",
        "content": "Hola Ángel",
    }


def test_chat_usa_qwen_sin_catalogo(monkeypatch):
    async def responder(mensaje, perfil, historial):
        return f"Respuesta Qwen: {mensaje}"

    monkeypatch.setattr(main, "conversar", responder)
    resultado = asyncio.run(
        main.chat(ConsultaChat(mensaje="Hola Ángel"), _usuario={"sub": "test"})
    )

    assert resultado.respuesta == "Respuesta Qwen: Hola Ángel"
    assert resultado.productos == []
