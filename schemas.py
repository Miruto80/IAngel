from typing import Literal

from pydantic import BaseModel, Field


class ConsultaChat(BaseModel):
    # Valida "datos vacíos o incorrectos" (diagrama de actividades)
    mensaje: str = Field(..., min_length=2, max_length=500)
    historial: list["MensajeConversacion"] = Field(default_factory=list, max_length=12)


class MensajeConversacion(BaseModel):
    role: Literal["user", "assistant"]
    content: str = Field(..., min_length=1, max_length=1000)


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
