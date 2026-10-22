"""Esquemas de la API de Ángel: validación de entrada y salida (RF-01/RF-03)."""
from typing import Literal

from pydantic import BaseModel, Field, field_validator

MAX_IMAGENES = 3
IMAGEN_MAX_CARACTERES = 4_000_000  # ~3 MB por imagen en base64

MAX_HISTORIAL_TURNOS = 16  # 8 ida y vuelta; demás lo recorta el widget
MENSAJE_HISTORIAL_MAX = 1000

_ROLES = {"user": "usuario", "assistant": "asistente",
          "usuario": "usuario", "asistente": "asistente"}


class MensajeHistorial(BaseModel):
    """Un turno de conversación guardado en la memoria del usuario."""
    rol: Literal["usuario", "asistente"]
    contenido: str = Field(..., min_length=1, max_length=MENSAJE_HISTORIAL_MAX)


class ConsultaChat(BaseModel):
    mensaje: str = Field(..., min_length=2, max_length=500)
    # Visión: data URLs base64 (opcional)
    imagenes: list[str] | None = None
    # Memoria: turnos previos (opcional). El widget envía {role, content};
    # se normaliza a {rol, contenido} para hablar el idioma de la BD.
    historial: list[MensajeHistorial] | None = None

    @field_validator("imagenes")
    @classmethod
    def _validar_imagenes(cls, valor: list[str] | None) -> list[str] | None:
        if not valor:
            return None
        if len(valor) > MAX_IMAGENES:
            raise ValueError(f"Máximo {MAX_IMAGENES} imágenes por mensaje")
        for imagen in valor:
            if not imagen.startswith("data:image/"):
                raise ValueError("Las imágenes deben ser data URLs (data:image/...;base64,)")
            if len(imagen) > IMAGEN_MAX_CARACTERES:
                raise ValueError("Una imagen excede el tamaño máximo (3 MB)")
        return valor

    @field_validator("historial", mode="before")
    @classmethod
    def _normalizar_historial(cls, valor):
        # Acepta {role, content} (widget), {rol, contenido} (BD) y objetos ya
        # validados; degrada a None si viene vacío.
        if not valor:
            return None
        normalizado = []
        for item in valor:
            if isinstance(item, dict):
                rol = _ROLES.get(item.get("rol") or item.get("role") or "")
                normalizado.append({
                    "rol": rol,
                    "contenido": item.get("contenido") or item.get("content"),
                })
            else:
                normalizado.append(item)
        if len(normalizado) > MAX_HISTORIAL_TURNOS:
            raise ValueError(f"El historial admite como máximo {MAX_HISTORIAL_TURNOS} turnos")
        return normalizado


class Producto(BaseModel):
    id: int
    nombre: str
    categoria: str
    marca: str | None = None
    precio: float
    stock: int
    tipo_piel: str | None = None
    ingredientes_activos: str | None = None


class PerfilDetectado(BaseModel):
    tipo_piel: str | None = None
    necesidades: list[str] = Field(default_factory=list)
    precio_max: float | None = None
    categoria: str | None = None
    marca: str | None = None


class RespuestaChat(BaseModel):
    respuesta: str
    perfil: PerfilDetectado
    productos: list[Producto]
