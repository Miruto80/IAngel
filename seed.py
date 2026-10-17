"""Indexa el catálogo real de LoveMakeup para las recomendaciones de Ángel.

Uso:
    python seed.py reindex   -> recalcula los embeddings de productos activos
"""
import asyncio
import sys

import aiomysql
from openai import AsyncOpenAI

from config import get_settings
from db import embedding_a_texto

s = get_settings()
openai = AsyncOpenAI(api_key=s.openai_api_key) if s.openai_api_key else None


async def embed(texto: str) -> list[float]:
    if openai is None:
        raise RuntimeError("Falta OPENAI_API_KEY en la configuración")
    r = await openai.embeddings.create(model=s.embedding_model, input=texto)
    vector = r.data[0].embedding
    if len(vector) != 1536:
        raise ValueError(f"El modelo devolvió {len(vector)} dimensiones; se esperaban 1536")
    return vector


async def main(modo: str) -> None:
    if modo != "reindex":
        raise ValueError("Modo no válido. Use: python seed.py reindex")
    if openai is None:
        raise RuntimeError("Falta OPENAI_API_KEY en la configuración")

    conn = await aiomysql.connect(
        host=s.db_host,
        port=s.db_port,
        user=s.db_user,
        password=s.db_password,
        db=s.db_name,
        autocommit=True,
        charset="utf8mb4",
    )
    try:
        async with conn.cursor() as cur:
            await cur.execute(
                """INSERT INTO angel_producto_ai (id_producto)
                   SELECT id_producto FROM producto WHERE estatus = 1
                   ON DUPLICATE KEY UPDATE id_producto = VALUES(id_producto)"""
            )
            await cur.execute(
                """SELECT p.id_producto, p.nombre, p.descripcion,
                          c.nombre, m.nombre, ai.tipo_piel, ai.ingredientes_activos
                   FROM producto p
                   LEFT JOIN categoria c ON c.id_categoria = p.id_categoria
                   LEFT JOIN marca m ON m.id_marca = p.id_marca
                   JOIN angel_producto_ai ai ON ai.id_producto = p.id_producto
                   WHERE p.estatus = 1"""
            )
            productos = await cur.fetchall()

            for pid, nombre, descripcion, categoria, marca, piel, activos in productos:
                texto = (
                    f"{nombre or ''}. Categoría: {categoria or ''}. "
                    f"Marca: {marca or ''}. Tipo de piel: {piel or ''}. "
                    f"Ingredientes activos: {activos or ''}. "
                    f"{descripcion or ''}"
                )
                vector = await embed(texto)
                await cur.execute(
                    "UPDATE angel_producto_ai SET embedding = %s WHERE id_producto = %s",
                    (embedding_a_texto(vector), pid),
                )
                print(f"Reindexado: {nombre or pid}")
    finally:
        conn.close()


if __name__ == "__main__":
    try:
        asyncio.run(main(sys.argv[1] if len(sys.argv) > 1 else ""))
    except (RuntimeError, ValueError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
