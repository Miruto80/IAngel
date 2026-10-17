"""Genera los embeddings de los productos y los guarda en MariaDB.

Uso:
    python seed.py demo      -> inserta productos de ejemplo + embeddings
    python seed.py reindex   -> recalcula embeddings de TODOS los productos existentes
"""
import asyncio
import sys

import aiomysql
from openai import AsyncOpenAI

from config import get_settings
from db import vector_a_texto

s = get_settings()
openai = AsyncOpenAI(api_key=s.openai_api_key)

DEMO = [
    # nombre, categoria, marca, precio, stock, tipo_piel, activos, descripcion
    ("Base Matte Control Oil-Free", "base", "Maybelline", 12.50, 20, "grasa,mixta",
     "ácido salicílico, arcilla",
     "Base de acabado mate que controla el brillo todo el día, ideal para piel grasa y con tendencia al acné."),
    ("Base Hidratante Glow", "base", "Revlon", 14.00, 15, "seca,normal",
     "ácido hialurónico, glicerina",
     "Base luminosa con ácido hialurónico para piel seca o con resequedad, acabado natural."),
    ("Corrector Líquido Alta Cobertura", "corrector", "NYX", 8.00, 30, "todo_tipo",
     "vitamina E",
     "Corrector de alta cobertura para ojeras e imperfecciones, larga duración."),
    ("Labial Cremoso Rojo Pasión", "labial", "Ruby Rose", 5.50, 40, "todo_tipo",
     "manteca de karité",
     "Labial cremoso hidratante de larga duración en tono rojo intenso."),
    ("Serum Niacinamida 10%", "skincare", "CeraVe", 13.00, 12, "grasa,mixta,sensible",
     "niacinamida, zinc",
     "Serum que reduce poros, controla grasa y ayuda con granos y marcas del acné."),
    ("Crema Hidratante Ceramidas", "skincare", "CeraVe", 11.00, 25, "seca,sensible,normal",
     "ceramidas, ácido hialurónico",
     "Crema para piel seca y sensible, repara la barrera cutánea y combate la resequedad."),
    ("Polvo Compacto Translúcido", "polvo", "Catrice", 6.50, 18, "grasa,mixta,normal",
     "sílice",
     "Polvo compacto translúcido que sella el maquillaje y reduce el brillo."),
    ("Rubor en Crema Durazno", "rubor", "Essence", 4.50, 22, "seca,normal",
     "aceite de jojoba",
     "Rubor cremoso de acabado jugoso, perfecto para piel seca."),
]


def texto_producto(p: tuple) -> str:
    nombre, cat, marca, _, _, piel, activos, desc = p
    return f"{nombre}. Categoría: {cat}. Marca: {marca}. Piel: {piel}. Activos: {activos}. {desc}"


async def embed(texto: str) -> list[float]:
    r = await openai.embeddings.create(model=s.embedding_model, input=texto)
    return r.data[0].embedding


async def main(modo: str) -> None:
    conn = await aiomysql.connect(
        host=s.db_host, port=s.db_port, user=s.db_user, password=s.db_password,
        db=s.db_name, autocommit=True, charset="utf8mb4",
    )
    async with conn.cursor() as cur:
        if modo == "demo":
            for p in DEMO:
                vec = await embed(texto_producto(p))
                await cur.execute(
                    """INSERT INTO productos
                       (nombre, categoria, marca, precio, stock, tipo_piel,
                        ingredientes_activos, descripcion, embedding)
                       VALUES (%s,%s,%s,%s,%s,%s,%s,%s, VEC_FromText(%s))""",
                    (*p, vector_a_texto(vec)),
                )
                print("OK:", p[0])
        elif modo == "reindex":
            await cur.execute(
                "SELECT id, nombre, categoria, marca, tipo_piel, ingredientes_activos, descripcion FROM productos"
            )
            for (pid, nombre, cat, marca, piel, activos, desc) in await cur.fetchall():
                t = f"{nombre}. Categoría: {cat}. Marca: {marca}. Piel: {piel}. Activos: {activos}. {desc}"
                vec = await embed(t)
                await cur.execute(
                    "UPDATE productos SET embedding = VEC_FromText(%s) WHERE id = %s",
                    (vector_a_texto(vec), pid),
                )
                print("Reindexado:", nombre)
        else:
            print(__doc__)
    conn.close()


if __name__ == "__main__":
    asyncio.run(main(sys.argv[1] if len(sys.argv) > 1 else ""))
