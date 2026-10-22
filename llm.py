"""Embeddings y redacción de la respuesta de Ángel, todo vía OpenRouter.

Se usa la API compatible con OpenAI de OpenRouter (OPENROUTER_BASE_URL) con un
único cliente:
- Embeddings: baai/bge-m3, 1024 dimensiones (EMBEDDING_DIM).
- Redacción: un modelo de chat de Qwen (LLM_MODEL).
"""
import asyncio

from openai import AsyncOpenAI

from config import get_settings
from schemas import PerfilDetectado, Producto

_s = get_settings()
_client = (
    AsyncOpenAI(api_key=_s.openrouter_api_key, base_url=_s.openrouter_base_url)
    if _s.openrouter_api_key
    else None
)

SYSTEM_PROMPT = """Eres Ángel, asesor virtual de belleza de la tienda LoveMakeup (Barquisimeto, Venezuela).
Reglas estrictas:
- Responde en español, cálido y cercano, máximo 4 oraciones.
- Recomienda SOLO los productos de la lista que recibes. Nunca inventes productos, precios, marcas ni stock.
- Usa los precios exactos de la lista (en USD).
- Presenta las recomendaciones con saltos de línea y sin formato Markdown ni asteriscos.
- Explica brevemente por qué cada producto encaja con el tipo de piel o necesidad del cliente.
- Si la lista está vacía, dilo con amabilidad y sugiere ajustar presupuesto, categoría o tipo de piel.
- Si el cliente tiene condiciones de piel serias (dermatitis, alergias fuertes), sugiere consultar a un dermatólogo."""


async def generar_embedding(texto: str) -> list[float]:
    if _client is None:
        raise RuntimeError("Falta OPENROUTER_API_KEY")
    r = await _client.embeddings.create(model=_s.embedding_model, input=texto)
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
    if _client is None:
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
            _client.chat.completions.create(
                model=_s.llm_model,
                max_tokens=300,
                messages=[
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": contenido},
                ],
            ),
            timeout=_s.llm_timeout_seconds,
        )
        return r.choices[0].message.content.strip()
    except Exception:
        return _respuesta_plantilla(productos)
