"""RNF-03: todas las peticiones deben venir autenticadas con JWT."""
import logging
from pathlib import Path

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from config import get_settings

bearer = HTTPBearer(auto_error=False)
log = logging.getLogger(__name__)


def verificar_token(
    cred: HTTPAuthorizationCredentials | None = Depends(bearer),
) -> dict:
    if cred is None:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Falta el token")
    s = get_settings()

    try:
        public_key = Path(s.jwt_public_key_path).read_text(encoding="utf-8")
    except OSError as e:
        log.exception("No se pudo leer la clave pública JWT de Ángel")
        raise HTTPException(
            status.HTTP_503_SERVICE_UNAVAILABLE,
            "Autenticación de Ángel no configurada",
        ) from e

    try:
        return jwt.decode(cred.credentials, public_key, algorithms=["RS256"])
    except jwt.ExpiredSignatureError:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Token expirado")
    except jwt.InvalidTokenError:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Token inválido")
