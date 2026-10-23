"""Pruebas unitarias (XP): PLN y JWT RS256. Ejecutar: pytest -v"""
import os
import tempfile
import time
from pathlib import Path

from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

# Par RSA efímero para probar el flujo RS256 sin depender de las llaves reales
_privada = rsa.generate_private_key(public_exponent=65537, key_size=2048)
_privada_pem = _privada.private_bytes(
    serialization.Encoding.PEM,
    serialization.PrivateFormat.PKCS8,
    serialization.NoEncryption(),
).decode("ascii")
_ruta_publica = Path(tempfile.mkdtemp(prefix="angel_tests_")) / "publica_test.pem"
_ruta_publica.write_text(
    _privada.public_key()
    .public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo)
    .decode("ascii")
)
os.environ.setdefault("JWT_ALGORITHM", "RS256")
os.environ.setdefault("JWT_PUBLIC_KEY", str(_ruta_publica))

import jwt  # noqa: E402
import pytest  # noqa: E402
from fastapi import HTTPException  # noqa: E402
from fastapi.security import HTTPAuthorizationCredentials  # noqa: E402
from pydantic import ValidationError  # noqa: E402

from auth import verificar_token  # noqa: E402
from config import get_settings  # noqa: E402
from db import embedding_a_texto  # noqa: E402
from llm import _quitar_saludo_repetido  # noqa: E402
from nlp import extraer_perfil  # noqa: E402
from schemas import ConsultaChat  # noqa: E402


def _cred(token: str):
    return HTTPAuthorizationCredentials(scheme="Bearer", credentials=token)


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
    token = jwt.encode({"sub": "1", "exp": time.time() + 60}, _privada_pem, algorithm="RS256")
    assert verificar_token(_cred(token))["sub"] == "1"


def test_jwt_expirado():
    token = jwt.encode({"sub": "1", "exp": time.time() - 10}, _privada_pem, algorithm="RS256")
    with pytest.raises(HTTPException) as e:
        verificar_token(_cred(token))
    assert e.value.status_code == 401
    assert "expirado" in e.value.detail


def test_jwt_invalido():
    with pytest.raises(HTTPException) as e:
        verificar_token(_cred("basura"))
    assert e.value.status_code == 401


def test_falta_token():
    with pytest.raises(HTTPException) as e:
        verificar_token(None)
    assert e.value.status_code == 401


def test_embedding_a_texto_exige_la_dimension_configurada():
    dim = get_settings().embedding_dim
    with pytest.raises(ValueError, match=str(dim)):
        embedding_a_texto([0.1])


def test_historial_acepta_formato_del_widget():
    c = ConsultaChat(
        mensaje="buenas",
        historial=[
            {"role": "user", "content": "hola"},
            {"role": "assistant", "content": "¿qué buscas hoy?"},
        ],
    )
    assert c.historial[0].rol == "usuario"
    assert c.historial[1].rol == "asistente"


def test_historial_rechaza_demasiados_turnos():
    muchos = [{"role": "user", "content": f"m{i}"} for i in range(20)]
    with pytest.raises(ValidationError):
        ConsultaChat(mensaje="buenas", historial=muchos)


def test_quita_saludo_si_ya_hubo_respuesta_del_asistente():
    historial = ConsultaChat(
        mensaje="hola",
        historial=[{"role": "assistant", "content": "¡Hola! ¿En qué te ayudo?"}],
    ).historial
    assert _quitar_saludo_repetido("¡Hola! Claro, te ayudo 😊", historial) == "Claro, te ayudo 😊"


def test_conserva_saludo_si_no_hay_historial_del_asistente():
    historial = ConsultaChat(
        mensaje="hola",
        historial=[{"role": "user", "content": "hola"}],
    ).historial
    respuesta = "¡Hola! ¿En qué te ayudo?"
    assert _quitar_saludo_repetido(respuesta, historial) == respuesta
