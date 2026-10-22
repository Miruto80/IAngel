"""Esquemas de la API de Ángel: validación de entrada y salida (RF-01/RF-03)."""
from pydantic import BaseModel, Field, field_validator

MAX_IMAGENES = 3
IMAGEN_MAX_CARACTERES = 4_000_000  # ~3 MB por imagen en base64


class ConsultaChat(BaseModel):
    # Valida "datos vacíos o incorrectos" (diagrama de actividades)
    mensaje: str = Field(..., min_length=2, max_length=500)
    # Fase de visión: data URLs base64 de fotos del cliente (opcional)
    imagenes: list[str] | None = None

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
