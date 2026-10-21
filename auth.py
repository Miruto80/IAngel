"""RNF-03: todas las peticiones deben venir autenticadas con JWT.

El backend PHP firma con RS256 (config/jwt_private.pem del repo
Lovemakeup-3.0) y aquí solo se verifica la firma con la llave pública.
"""
from functools import lru_cache
from pathlib import Path

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from config import get_settings

bearer = HTTPBearer(auto_error=False)


@lru_cache
def _clave_verificacion() -> str:
    """Clave según el algoritmo: PEM público (RS256) o secreto (HS256 legado)."""
    s = get_settings()
    if s.jwt_algorithm == "RS256":
        if not s.jwt_public_key:
            raise RuntimeError("Falta JWT_PUBLIC_KEY en la configuración")
        ruta = Path(s.jwt_public_key)
        if not ruta.is_absolute():
            ruta = Path(__file__).resolve().parent / ruta
        try:
            return ruta.read_text(encoding="utf-8")
        except OSError as e:
            raise RuntimeError(f"No se pudo leer la llave pública {ruta}") from e
    if not s.jwt_secret:
        raise RuntimeError("JWT_ALGORITHM=HS256 exige JWT_SECRET")
    return s.jwt_secret


def verificar_token(
    cred: HTTPAuthorizationCredentials | None = Depends(bearer),
) -> dict:
    if cred is None:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Falta el token")
    s = get_settings()
    try:
        return jwt.decode(
            cred.credentials,
            _clave_verificacion(),
            algorithms=[s.jwt_algorithm],
        )
    except jwt.ExpiredSignatureError:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Token expirado")
    except jwt.PyJWTError:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Token inválido")
