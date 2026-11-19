"""Indexa el catálogo y la base de conocimiento de Ángel.

Uso:
    python seed.py reindex                  -> productos activos
    python seed.py reindex 123              -> un producto
    python seed.py conocimiento             -> todas las fichas activas
    python seed.py conocimiento 12           -> una ficha
    python seed.py conocimiento --pendientes -> fichas activas sin vector
    python seed.py todo                      -> productos y conocimiento
"""
import asyncio
import sys

import aiomysql
from openai import AsyncOpenAI

from config import get_settings
from db import embedding_a_texto

s = get_settings()
client = (
    AsyncOpenAI(api_key=s.openrouter_api_key, base_url=s.openrouter_base_url)
    if s.openrouter_api_key
    else None
)


class ErrorReindexacion(RuntimeError):
    def __init__(self, mensaje: str, procesados: dict[str, int]):
        super().__init__(mensaje)
        self.procesados = procesados


async def embed(texto: str) -> list[float]:
    if client is None:
        raise RuntimeError("Falta OPENROUTER_API_KEY en la configuración")
    r = await client.embeddings.create(model=s.embedding_model, input=texto)
    vector = r.data[0].embedding
    if len(vector) != s.embedding_dim:
        raise ValueError(
            f"El modelo devolvió {len(vector)} dimensiones; se esperaban {s.embedding_dim}"
        )
    return vector


async def conectar_bd():
    """Abre una conexión dedicada para el trabajo de indexación."""
    return await aiomysql.connect(
        host=s.db_host,
        port=s.db_port,
        user=s.db_user,
        password=s.db_password,
        db=s.db_name,
        autocommit=True,
        charset="utf8mb4",
    )


async def cerrar_cliente() -> None:
    if client is not None:
        await client.close()


async def indexar_conocimiento(
    conn,
    ids: list[int] | None = None,
    solo_pendientes: bool = False,
) -> int:
    """Vectoriza fichas activas; los IDs explícitos permiten reindexar cambios."""
    if ids is not None and not ids:
        raise ValueError("La lista de IDs de conocimiento no puede estar vacía")

    condiciones = ["activo = 1"]
    parametros: list[int] = []
    if ids is not None:
        condiciones.append(f"id IN ({', '.join(['%s'] * len(ids))})")
        parametros.extend(ids)
    if solo_pendientes:
        condiciones.append("embedding IS NULL")

    async with conn.cursor() as cur:
        if ids is not None:
            await cur.execute(
                f"SELECT id FROM angel_conocimiento WHERE activo = 1 "
                f"AND id IN ({', '.join(['%s'] * len(ids))})",
                ids,
            )
            ids_encontrados = {fila[0] for fila in await cur.fetchall()}
            ids_no_disponibles = sorted(set(ids) - ids_encontrados)
            if ids_no_disponibles:
                raise LookupError(
                    "No existen fichas activas de conocimiento con ID: "
                    + ", ".join(map(str, ids_no_disponibles))
                )

        await cur.execute(
            "SELECT id, tema, tipo, contenido FROM angel_conocimiento WHERE "
            + " AND ".join(condiciones),
            parametros,
        )
        fichas = await cur.fetchall()

        procesados = 0
        for fid, tema, tipo, contenido in fichas:
            try:
                texto = f"{tema}. {tipo}: {contenido}"
                vector = await embed(texto)
                await cur.execute(
                    "UPDATE angel_conocimiento SET embedding = VEC_FromText(%s) WHERE id = %s",
                    (embedding_a_texto(vector), fid),
                )
            except Exception as error:
                raise ErrorReindexacion(
                    f"No se pudo indexar la ficha de conocimiento ID {fid}",
                    {"conocimiento": procesados},
                ) from error
            procesados += 1
            print(f"Indexado conocimiento: {tema} (ID {fid})")

    return procesados


async def indexar_productos(conn, producto_id: int | None = None) -> int:
    """Vectoriza productos activos, opcionalmente limitados a un ID."""
    async with conn.cursor() as cur:
        if producto_id is None:
            await cur.execute(
                """INSERT INTO angel_producto_ai (id_producto)
                   SELECT id_producto FROM producto WHERE estatus = 1
                   ON DUPLICATE KEY UPDATE id_producto = VALUES(id_producto)"""
            )
        else:
            await cur.execute(
                """INSERT INTO angel_producto_ai (id_producto)
                   SELECT id_producto FROM producto
                   WHERE estatus = 1 AND id_producto = %s
                   ON DUPLICATE KEY UPDATE id_producto = VALUES(id_producto)""",
                (producto_id,),
            )
            if cur.rowcount == 0:
                await cur.execute(
                    "SELECT 1 FROM producto WHERE estatus = 1 AND id_producto = %s",
                    (producto_id,),
                )
                if await cur.fetchone() is None:
                    raise LookupError(
                        f"No existe un producto activo con ID {producto_id}"
                    )

        consulta = """SELECT p.id_producto, p.nombre, p.descripcion,
                             c.nombre, m.nombre, ai.tipo_piel, ai.ingredientes_activos
                      FROM producto p
                      LEFT JOIN categoria c ON c.id_categoria = p.id_categoria
                      LEFT JOIN marca m ON m.id_marca = p.id_marca
                      JOIN angel_producto_ai ai ON ai.id_producto = p.id_producto
                      WHERE p.estatus = 1"""
        parametros = []
        if producto_id is not None:
            consulta += " AND p.id_producto = %s"
            parametros.append(producto_id)
        await cur.execute(consulta, parametros)
        productos = await cur.fetchall()

        procesados = 0
        for pid, nombre, descripcion, categoria, marca, piel, activos in productos:
            try:
                texto = (
                    f"{nombre or ''}. Categoría: {categoria or ''}. "
                    f"Marca: {marca or ''}. Tipo de piel: {piel or ''}. "
                    f"Ingredientes activos: {activos or ''}. "
                    f"{descripcion or ''}"
                )
                vector = await embed(texto)
                await cur.execute(
                    "UPDATE angel_producto_ai SET embedding = VEC_FromText(%s) WHERE id_producto = %s",
                    (embedding_a_texto(vector), pid),
                )
            except Exception as error:
                raise ErrorReindexacion(
                    f"No se pudo indexar el producto ID {pid}",
                    {"productos": procesados},
                ) from error
            procesados += 1
            print(f"Reindexado producto: {nombre or pid} (ID {pid})")

    return procesados


async def ejecutar_reindexacion(
    tipo: str,
    id: int | None = None,
    ids: list[int] | None = None,
    solo_pendientes: bool = False,
) -> dict[str, int]:
    """Ejecuta el indexado desde la API o desde la CLI y devuelve cantidades."""
    if tipo not in ("conocimiento", "productos", "todo"):
        raise ValueError("Tipo no válido: use conocimiento, productos o todo")
    if id is not None and ids is not None:
        raise ValueError("Use id o ids, no ambos")
    if tipo == "productos" and (ids is not None or solo_pendientes):
        raise ValueError("Para productos solo se admite id o reindexación completa")
    if tipo == "todo" and (id is not None or ids is not None or solo_pendientes):
        raise ValueError("La reindexación todo no admite filtros")

    if client is None:
        raise RuntimeError("Falta OPENROUTER_API_KEY en la configuración")

    conexion = await conectar_bd()
    try:
        resultados: dict[str, int] = {}
        try:
            if tipo in ("conocimiento", "todo"):
                ids_fichas = ids if ids is not None else ([id] if id is not None else None)
                resultados["conocimiento"] = await indexar_conocimiento(
                    conexion, ids_fichas, solo_pendientes
                )
            if tipo in ("productos", "todo"):
                resultados["productos"] = await indexar_productos(
                    conexion, id if tipo == "productos" else None
                )
            return resultados
        except ErrorReindexacion as error:
            error.procesados = {**resultados, **error.procesados}
            raise
    finally:
        conexion.close()


async def main(modo: str, registro_id: int | None = None, solo_pendientes: bool = False) -> None:
    tipo = "productos" if modo == "reindex" else modo
    resultado = await ejecutar_reindexacion(
        tipo,
        id=registro_id,
        solo_pendientes=solo_pendientes,
    )
    for tabla, cantidad in resultado.items():
        print(f"Total de {tabla} procesados: {cantidad}")


def _argumentos_cli() -> tuple[str, int | None, bool]:
    argumentos = sys.argv[1:]
    if not argumentos:
        raise ValueError(
            "Uso: python seed.py reindex [producto_id] | conocimiento [id|--pendientes] | todo"
        )
    modo = argumentos[0]
    registro_id = None
    solo_pendientes = False
    for argumento in argumentos[1:]:
        if argumento == "--pendientes" and modo == "conocimiento":
            solo_pendientes = True
        elif registro_id is None:
            try:
                registro_id = int(argumento)
            except ValueError as error:
                raise ValueError(f"Argumento no válido: {argumento}") from error
            if registro_id < 1:
                raise ValueError("El ID debe ser un entero positivo")
        else:
            raise ValueError(f"Argumento no válido: {argumento}")
    return modo, registro_id, solo_pendientes


if __name__ == "__main__":
    try:
        asyncio.run(main(*_argumentos_cli()))
    except (RuntimeError, ValueError, LookupError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
