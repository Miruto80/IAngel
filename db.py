"""Acceso al catálogo MariaDB de LoveMakeup (RF-02 / RF-03).

La búsqueda semántica es nativa de la base (tipo VECTOR + VEC_DISTANCE_COSINE):
requiere MariaDB 11.7+.
"""
import json

import aiomysql

from config import get_settings
from schemas import MensajeHistorial, PerfilDetectado, Producto

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
    """Serializa el vector como texto `[...]`, formato que acepta VEC_FromText."""
    esperado = get_settings().embedding_dim
    if len(vec) != esperado:
        raise ValueError(f"Se esperaba un embedding de {esperado} dimensiones; recibido: {len(vec)}")
    return json.dumps(vec, separators=(",", ":"))


async def buscar_productos(
    vec: list[float], perfil: PerfilDetectado, limite: int = 5
) -> list[Producto]:
    """Filtra el catálogo en SQL y ordena por distancia coseno en MariaDB.

    La similitud la calcula la propia base comparando `ai.embedding` con el
    vector de la consulta; retorna atributos reales, sin inventar precios ni
    disponibilidad.
    """
    if _pool is None:
        raise RuntimeError("El pool de base de datos no está inicializado")
    s = get_settings()
    if len(vec) != s.embedding_dim:
        raise ValueError(
            f"Se esperaba un embedding de {s.embedding_dim} dimensiones; recibido: {len(vec)}"
        )

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
        # Filtro opt-in: solo restringe filas con tipo_piel curado en la tabla;
        # con la columna NULL decide la similitud del vector, no el SQL.
        where.append(
            "(ai.tipo_piel IS NULL "
            "OR FIND_IN_SET(%s, ai.tipo_piel) > 0 "
            "OR FIND_IN_SET('todo_tipo', ai.tipo_piel) > 0)"
        )
        params.append(perfil.tipo_piel)

    joins = """
        FROM producto p
        LEFT JOIN categoria c ON c.id_categoria = p.id_categoria
        LEFT JOIN marca m ON m.id_marca = p.id_marca
        LEFT JOIN angel_producto_ai ai ON ai.id_producto = p.id_producto
    """
    condiciones = " AND ".join(where)

    async with _pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                f"""SELECT COUNT(*)
                    {joins}
                    WHERE {condiciones}
                      AND (ai.id_producto IS NULL OR ai.embedding IS NULL)""",
                params,
            )
            (sin_indexar,) = await cur.fetchone()
        if sin_indexar:
            raise CatalogoSinIndexarError(
                "Hay productos activos sin embedding; ejecute `python seed.py reindex`"
            )

        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                f"""SELECT p.id_producto AS id,
                           p.nombre,
                           COALESCE(c.nombre, 'Sin categoría') AS categoria,
                           NULLIF(m.nombre, 'Sin Marca') AS marca,
                           p.precio_detal AS precio,
                           p.stock_disponible AS stock,
                           ai.tipo_piel,
                           ai.ingredientes_activos
                    {joins}
                    WHERE {condiciones} AND ai.embedding IS NOT NULL
                    ORDER BY VEC_DISTANCE_COSINE(ai.embedding, VEC_FromText(%s)) ASC
                    LIMIT %s""",
                [*params, embedding_a_texto(vec), limite],
            )
            filas = await cur.fetchall()

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
        for f in filas
    ]


async def leer_conversacion(usuario: str, limite: int = 8) -> list[MensajeHistorial]:
    """Memoria: últimos `limite` turnos (ida+vuelta) en orden cronológico."""
    if _pool is None:
        raise RuntimeError("El pool de base de datos no está inicializado")
    async with _pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """SELECT rol, contenido FROM angel_chat_mensaje
                   WHERE usuario = %s
                   ORDER BY id DESC LIMIT %s""",
                (usuario, limite * 2),
            )
            filas = list(reversed(await cur.fetchall()))
    return [MensajeHistorial(rol=f["rol"], contenido=f["contenido"]) for f in filas]


async def guardar_conversacion(usuario: str, turnos: list[tuple[str, str]]) -> None:
    """Persiste los turnos nuevos y recorta el histórico hasta HISTORIAL_GUARDAR.

    autocommit=True en el pool: sin transacciones explícitas. La eliminación
    conserva los `historial_guardar` mensajes más recientes del usuario.
    """
    if _pool is None or not turnos:
        return
    async with _pool.acquire() as conn:
        async with conn.cursor() as cur:
            for rol, contenido in turnos:
                await cur.execute(
                    "INSERT INTO angel_chat_mensaje (usuario, rol, contenido) VALUES (%s, %s, %s)",
                    (usuario, rol, contenido[:1000]),
                )
            await cur.execute(
                """DELETE m FROM angel_chat_mensaje m
                   LEFT JOIN (SELECT id FROM angel_chat_mensaje
                              WHERE usuario = %s ORDER BY id DESC LIMIT %s) keep
                     ON m.id = keep.id
                   WHERE m.usuario = %s AND keep.id IS NULL""",
                (usuario, get_settings().historial_guardar, usuario),
            )


async def buscar_conocimiento(
    vec: list[float], limite: int | None = None, distancia_max: float | None = None
) -> list[tuple[str, str, str]]:
    """Base de conocimiento: fichas internas más similares (coseno).

    Solo filas activas con embedding (lo llena seed.py). `limite` y umbral de
    distancia vienen de config (CONOCIMIENTO_TOP / CONOCIMIENTO_DISTANCIA_MAX);
    si una ficha queda lejos, se descarta y no contamina el prompt.
    """
    if _pool is None:
        raise RuntimeError("El pool de base de datos no está inicializado")
    s = get_settings()
    if len(vec) != s.embedding_dim:
        raise ValueError(
            f"Se esperaba un embedding de {s.embedding_dim} dimensiones; recibido: {len(vec)}"
        )
    limite = limite if limite is not None else s.conocimiento_top
    distancia_max = distancia_max if distancia_max is not None else s.conocimiento_distancia_max

    async with _pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """SELECT tema, tipo, contenido,
                          VEC_DISTANCE_COSINE(embedding, VEC_FromText(%s)) AS distancia
                   FROM angel_conocimiento
                   WHERE activo = 1 AND embedding IS NOT NULL
                   ORDER BY distancia ASC
                   LIMIT %s""",
                (embedding_a_texto(vec), limite),
            )
            filas = await cur.fetchall()
    return [
        (f["tema"], f["tipo"], f["contenido"])
        for f in filas
        if float(f["distancia"]) <= distancia_max
    ]
