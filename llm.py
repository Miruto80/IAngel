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
- Si incluyo una conversación reciente, continúa el hilo con naturalidad: no repitas saludos ni respuestas anteriores.
- Si te doy fichas internas de la tienda, úsalas solo si encajan con la pregunta: no las cites literalmente y no inventes otras.
- Si la lista está vacía, dilo con amabilidad y sugiere ajustar presupuesto, categoría o tipo de piel.
- Si el cliente tiene condiciones de piel serias (dermatitis, alergias fuertes), sugiere consultar a un dermatólogo."""


async def generar_embedding(texto: str) -> list[float]:
    if _client is None:
        raise RuntimeError("Falta OPENROUTER_API_KEY")
    r = await _client.embeddings.create(model=_s.embedding_model, input=texto)
    return r.data[0].embedding


PROMPT_VISION = """Mira la imagen que envió el cliente de la tienda de cosméticos LoveMakeup.
- Si es un producto de belleza: describe en máximo 60 palabras el tipo, el color o acabado y a qué tipo de piel le conviene.
- Si es un rostro: describe solo rasgos visibles de la piel (brillo, acné, rojeces, textura, zonas afectadas) y el tipo de piel aparente. No identifiques a la persona ni des diagnósticos clínicos.
- Si es otra cosa: describe brevemente lo que ayude a recomendar productos de belleza.
Responde solo con la descripción, en español, sin Markdown ni listas."""


async def describir_imagen(imagenes: list[str], mensaje: str) -> str:
    """Fase de visión: describe la(s) foto(s) del cliente con el modelo multimodal.

    La descripción enriquece el embedding (los vectores guardados son de TEXTO,
    no se pueden comparar contra una imagen cruda) y el prompt de redacción.
    Si el modelo falla o tarda, devuelve cadena vacía y el flujo continúa como
    si solo hubiera texto: la foto es un extra, no un requisito.
    """
    if _client is None:
        raise RuntimeError("Falta OPENROUTER_API_KEY")
    contenido: list[dict] = [
        {"type": "text", "text": f"Mensaje del cliente: {mensaje}\n{PROMPT_VISION}"}
    ]
    for data_url in imagenes[: _s.max_imagenes]:
        contenido.append({"type": "image_url", "image_url": {"url": data_url}})
    r = await asyncio.wait_for(
        _client.chat.completions.create(
            model=_s.vision_model or _s.llm_model,
            max_tokens=160,
            messages=[{"role": "user", "content": contenido}],
        ),
        timeout=_s.vision_timeout_seconds,
    )
    return (r.choices[0].message.content or "").strip()


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
    mensaje: str,
    perfil: PerfilDetectado,
    productos: list[Producto],
    descripcion_foto: str = "",
    historial: list | None = None,
    fichas: list[tuple[str, str, str]] | None = None,
) -> str:
    if _client is None:
        return _respuesta_plantilla(productos)

    catalogo = "\n".join(
        f"- id={p.id} | {p.nombre} | {p.categoria} | {p.marca} | ${p.precio:.2f} | "
        f"piel: {p.tipo_piel} | activos: {p.ingredientes_activos}"
        for p in productos
    ) or "(sin resultados)"

    secciones = [
        f"Mensaje del cliente: {mensaje}",
        f"Perfil detectado: {perfil.model_dump_json()}",
    ]
    if descripcion_foto:
        secciones.append(f"Descripción de la foto enviada por el cliente: {descripcion_foto}")
    if historial:
        hilos = "\n".join(f"- {h.rol}: {h.contenido}" for h in historial)
        secciones.append(f"Conversación reciente con el cliente:\n{hilos}")
    if fichas:
        datos = "\n".join(f"- {tema} ({tipo}): {contenido}" for tema, tipo, contenido in fichas)
        secciones.append(f"Fichas internas de la tienda:\n{datos}")
    secciones.append(f"Productos disponibles:\n{catalogo}")
    contenido = "\n".join(secciones)
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
