"""Acceso a MariaDB 11.8 con VECTOR(1536) y consulta híbrida (RF-02 / RF-03)."""
import aiomysql

from config import get_settings
from schemas import PerfilDetectado, Producto

_pool: aiomysql.Pool | None = None


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


async def close_pool() -> None:
    if _pool:
        _pool.close()
        await _pool.wait_closed()


def vector_a_texto(vec: list[float]) -> str:
    """MariaDB acepta VEC_FromText('[0.1,0.2,...]')."""
    return "[" + ",".join(f"{x:.8f}" for x in vec) + "]"


async def buscar_productos(
    vec: list[float], perfil: PerfilDetectado, limite: int = 5
) -> list[Producto]:
    """Consulta híbrida en una sola pasada SQL:
    1) filtros duros (stock, precio, categoría, marca, tipo de piel)
    2) orden por distancia de coseno entre la consulta y el embedding
    3) retorna atributos reales (sin alucinar precios ni stock)
    """
    assert _pool is not None, "El pool de BD no está inicializado"

    where = ["stock > 0"]
    params: list = []

    if perfil.precio_max is not None:
        where.append("precio <= %s")
        params.append(perfil.precio_max)
    if perfil.categoria:
        where.append("categoria = %s")
        params.append(perfil.categoria)
    if perfil.marca:
        where.append("LOWER(marca) = %s")
        params.append(perfil.marca)
    if perfil.tipo_piel:
        # 'todo_tipo' = producto apto para cualquier piel
        where.append("(FIND_IN_SET(%s, tipo_piel) > 0 OR FIND_IN_SET('todo_tipo', tipo_piel) > 0)")
        params.append(perfil.tipo_piel)

    sql = f"""
        SELECT id, nombre, categoria, marca, precio, stock, tipo_piel, ingredientes_activos
        FROM productos
        WHERE {' AND '.join(where)}
        ORDER BY VEC_DISTANCE_COSINE(embedding, VEC_FromText(%s))
        LIMIT %s
    """
    params.extend([vector_a_texto(vec), limite])

    async with _pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(sql, params)
            filas = await cur.fetchall()

    return [
        Producto(**{**f, "precio": float(f["precio"])})
        for f in filas
    ]
