"""Acceso al catálogo MariaDB de LoveMakeup (RF-02 / RF-03)."""
import json
import math

import aiomysql

from config import get_settings
from schemas import PerfilDetectado, Producto

_pool: aiomysql.Pool | None = None


class CatalogoSinIndexarError(RuntimeError):
    """El catálogo tiene productos activos sin embedding."""


async def init_pool() -> None:
    global _pool
    s = get_settings()
    _pool = await aiomysql.create_pool(
        host=s.db_host,
        port=s.db_port,
        user=s.db_user,
        password=s.db_password,
        db=s.db_name,
        minsize=1,
        maxsize=10,
        autocommit=True,
        charset="utf8mb4",
    )


async def healthcheck() -> None:
    if _pool is None:
        raise RuntimeError("El pool de base de datos no está inicializado")

    async with _pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("SELECT 1")
            await cur.fetchone()


async def close_pool() -> None:
    if _pool:
        _pool.close()
        await _pool.wait_closed()


def embedding_a_texto(vec: list[float]) -> str:
    if len(vec) != 1536:
        raise ValueError(f"Se esperaba un embedding de 1536 dimensiones; recibido: {len(vec)}")
    return json.dumps(vec, separators=(",", ":"))


def similitud_coseno(a: list[float], b: list[float]) -> float:
    if len(a) != len(b):
        raise ValueError("Los embeddings deben tener la misma cantidad de dimensiones")

    norma_a = math.sqrt(sum(x * x for x in a))
    norma_b = math.sqrt(sum(x * x for x in b))
    if not norma_a or not norma_b:
        return 0.0
    return sum(x * y for x, y in zip(a, b)) / (norma_a * norma_b)


async def buscar_productos(
    vec: list[float], perfil: PerfilDetectado, limite: int = 5
) -> list[Producto]:
    """Filtra el catálogo en SQL y ordena los resultados por coseno en Python.

    Retorna atributos reales, sin inventar precios ni disponibilidad.
    """
    if _pool is None:
        raise RuntimeError("El pool de base de datos no está inicializado")
    if len(vec) != 1536:
        raise ValueError(f"Se esperaba un embedding de 1536 dimensiones; recibido: {len(vec)}")

    where = [
        "p.estatus = 1",
        "p.nombre IS NOT NULL",
        "p.precio_detal IS NOT NULL",
        "COALESCE(p.stock_disponible, 0) > 0",
    ]
    params: list = []

    if perfil.precio_max is not None:
        where.append("p.precio_detal <= %s")
        params.append(perfil.precio_max)
    if perfil.categoria:
        where.append("LOWER(c.nombre) LIKE %s")
        params.append(f"%{perfil.categoria.rstrip('s')}%")
    if perfil.marca:
        where.append("LOWER(m.nombre) LIKE %s")
        params.append(f"%{perfil.marca}%")
    if perfil.tipo_piel:
        where.append(
            "(FIND_IN_SET(%s, ai.tipo_piel) > 0 "
            "OR FIND_IN_SET('todo_tipo', ai.tipo_piel) > 0)"
        )
        params.append(perfil.tipo_piel)

    sql = f"""
        SELECT p.id_producto AS id,
               p.nombre,
               COALESCE(c.nombre, 'Sin categoría') AS categoria,
               NULLIF(m.nombre, 'Sin Marca') AS marca,
               p.precio_detal AS precio,
               p.stock_disponible AS stock,
               ai.tipo_piel,
               ai.ingredientes_activos,
               ai.embedding
        FROM producto p
        LEFT JOIN categoria c ON c.id_categoria = p.id_categoria
        LEFT JOIN marca m ON m.id_marca = p.id_marca
        LEFT JOIN angel_producto_ai ai ON ai.id_producto = p.id_producto
        WHERE {' AND '.join(where)}
    """

    async with _pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(sql, params)
            filas = await cur.fetchall()

    if any(not fila["embedding"] for fila in filas):
        raise CatalogoSinIndexarError(
            "Hay productos activos sin embedding; ejecute `python seed.py reindex`"
        )

    puntuados = []
    for fila in filas:
        embedding = json.loads(fila["embedding"])
        if len(embedding) != len(vec):
            raise ValueError(
                f"Embedding inválido para el producto {fila['id']}: "
                f"se esperaban {len(vec)} dimensiones y hay {len(embedding)}"
            )
        puntuados.append((similitud_coseno(vec, embedding), fila))

    puntuados.sort(key=lambda item: item[0], reverse=True)
    return [
        Producto(
            id=f["id"],
            nombre=f["nombre"] or "",
            categoria=f["categoria"],
            marca=f["marca"],
            precio=float(f["precio"]),
            stock=int(f["stock"]),
            tipo_piel=f["tipo_piel"],
            ingredientes_activos=f["ingredientes_activos"],
        )
        for _, f in puntuados[:limite]
    ]
