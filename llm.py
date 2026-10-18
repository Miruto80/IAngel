"""Integración con OpenAI para embeddings y Groq/Qwen para conversar."""
import asyncio
import logging

from groq import AsyncGroq
from openai import AsyncOpenAI

from config import get_settings
from schemas import MensajeConversacion, PerfilDetectado, Producto

_s = get_settings()
_openai = AsyncOpenAI(api_key=_s.openai_api_key) if _s.openai_api_key else None
_groq = AsyncGroq(api_key=_s.groq_api_key) if _s.groq_api_key else None
log = logging.getLogger(__name__)

SYSTEM_PROMPT = """Eres Ángel, asesor virtual de belleza de la tienda LoveMakeup (Barquisimeto, Venezuela).
Conversa en español con un tono cálido, natural y cercano. Ayuda con preguntas
generales sobre belleza, maquillaje y cuidado de la piel. No inventes productos,
precios, disponibilidad ni políticas de la tienda: todavía no tienes acceso al
catálogo. Si te preguntan por productos concretos, explica que aún no puedes
consultar el inventario y pregunta qué tipo de ayuda general necesita. Para
problemas persistentes o condiciones serias de la piel, recomienda consultar a
un dermatólogo. Mantén las respuestas concisas y útiles."""


async def generar_embedding(texto: str) -> list[float]:
    if _openai is None:
        raise RuntimeError("Falta OPENAI_API_KEY")
    r = await _openai.embeddings.create(model=_s.embedding_model, input=texto)
    return r.data[0].embedding


async def conversar(
    mensaje: str,
    perfil: PerfilDetectado,
    historial: list[MensajeConversacion] | None = None,
) -> str:
    """Responde directamente con el modelo Qwen configurado en Groq."""
    if _groq is None:
        raise RuntimeError("Falta GROQ_API_KEY")

    mensajes = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {
            "role": "system",
            "content": f"Perfil detectado a partir del mensaje actual: {perfil.model_dump_json()}",
        },
    ]
    mensajes.extend(item.model_dump() for item in historial or [])
    mensajes.append({"role": "user", "content": mensaje})

    async def completar() -> str:
        respuesta = await _groq.chat.completions.create(
            model=_s.llm_model,
            messages=mensajes,
            temperature=0.7,
            max_completion_tokens=512,
        )
        texto = respuesta.choices[0].message.content
        if not texto or not texto.strip():
            raise RuntimeError("Qwen devolvió una respuesta vacía")
        return texto.strip()

    return await asyncio.wait_for(completar(), timeout=_s.llm_timeout_seconds)


def _respuesta_plantilla(productos: list[Producto]) -> str:
    """Respaldo determinista si el LLM falla o tarda demasiado (RNF-01)."""
    if not productos:
        return (
            "No encontré productos disponibles con esas condiciones. "
            "¿Quieres que ajustemos el presupuesto, la categoría o el tipo de piel?"
        )
    lineas = [f"• {p.nombre} ({p.marca or 'LoveMakeup'}) - ${p.precio:.2f}" for p in productos[:3]]
    return "¡Hola! Esto es lo que te recomiendo según lo que me cuentas:\n" + "\n".join(lineas)


async def redactar_respuesta(
    mensaje: str, perfil: PerfilDetectado, productos: list[Producto]
) -> str:
    if _groq is None:
        return _respuesta_plantilla(productos)

    catalogo = "\n".join(
        f"- id={p.id} | {p.nombre} | {p.categoria} | {p.marca} | ${p.precio:.2f} | "
        f"piel: {p.tipo_piel} | activos: {p.ingredientes_activos}" """ sustituir estas columnas por vector dentro de descripcion  """
        for p in productos
    ) or "(sin resultados)" 

    contenido = (
        f"Mensaje del cliente: {mensaje}\n"
        f"Perfil detectado: {perfil.model_dump_json()}\n"
        f"Productos disponibles:\n{catalogo}"
    )

    async def completar() -> str:
        stream = await _groq.chat.completions.create(
            model=_s.llm_model,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": contenido},
            ],
            temperature=0.6,
            max_completion_tokens=2048,
            top_p=0.95,
            reasoning_effort="default",
            stream=True,
        )
        partes = []
        async for chunk in stream:
            texto = chunk.choices[0].delta.content
            if texto:
                partes.append(texto)
        return "".join(partes).strip()

    try:
        return await asyncio.wait_for(completar(), timeout=_s.llm_timeout_seconds)
    except Exception:
        log.exception("Error redactando respuesta con Groq; se usará la plantilla")
        return _respuesta_plantilla(productos)
