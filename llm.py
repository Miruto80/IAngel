"""Embeddings (OpenAI, 1536 dims) y redacción de la respuesta de Ángel (Claude).

Anthropic no ofrece modelo de embeddings, por eso se usa OpenAI
text-embedding-3-small, que produce exactamente 1536 dimensiones.
"""
import asyncio

from anthropic import AsyncAnthropic
from openai import AsyncOpenAI

from config import get_settings
from schemas import PerfilDetectado, Producto

_s = get_settings()
_openai = AsyncOpenAI(api_key=_s.openai_api_key) if _s.openai_api_key else None
_claude = AsyncAnthropic(api_key=_s.anthropic_api_key) if _s.anthropic_api_key else None

SYSTEM_PROMPT = """Eres Ángel, asesor virtual de belleza de la tienda LoveMakeup (Barquisimeto, Venezuela).
Reglas estrictas:
- Responde en español, cálido y cercano, máximo 4 oraciones.
- Recomienda SOLO los productos de la lista que recibes. Nunca inventes productos, precios, marcas ni stock.
- Usa los precios exactos de la lista (en USD).
- Explica brevemente por qué cada producto encaja con el tipo de piel o necesidad del cliente.
- Si la lista está vacía, dilo con amabilidad y sugiere ajustar presupuesto, categoría o tipo de piel.
- Si el cliente tiene condiciones de piel serias (dermatitis, alergias fuertes), sugiere consultar a un dermatólogo."""


async def generar_embedding(texto: str) -> list[float]:
    if _openai is None:
        raise RuntimeError("Falta OPENAI_API_KEY")
    r = await _openai.embeddings.create(model=_s.embedding_model, input=texto)
    return r.data[0].embedding


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
    if _claude is None:
        return _respuesta_plantilla(productos)

    catalogo = "\n".join(
        f"- id={p.id} | {p.nombre} | {p.categoria} | {p.marca} | ${p.precio:.2f} | "
        f"piel: {p.tipo_piel} | activos: {p.ingredientes_activos}"
        for p in productos
    ) or "(sin resultados)"

    contenido = (
        f"Mensaje del cliente: {mensaje}\n"
        f"Perfil detectado: {perfil.model_dump_json()}\n"
        f"Productos disponibles:\n{catalogo}"
    )
    try:
        r = await asyncio.wait_for(
            _claude.messages.create(
                model=_s.llm_model,
                max_tokens=300,
                system=SYSTEM_PROMPT,
                messages=[{"role": "user", "content": contenido}],
            ),
            timeout=_s.llm_timeout_seconds,
        )
        return r.content[0].text.strip()
    except Exception:
        return _respuesta_plantilla(productos)
