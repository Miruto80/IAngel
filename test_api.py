"""Pruebas unitarias (XP): PLN y JWT. Ejecutar: pytest -v"""
import os
import time

os.environ.setdefault("JWT_SECRET", "secreto_de_pruebas")

import jwt  # noqa: E402
from fastapi import HTTPException  # noqa: E402
from fastapi.security import HTTPAuthorizationCredentials  # noqa: E402
import pytest  # noqa: E402

from auth import verificar_token  # noqa: E402
from nlp import extraer_perfil  # noqa: E402


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
