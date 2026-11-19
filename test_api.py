"""Pruebas unitarias (XP): PLN y JWT RS256. Ejecutar: pytest -v"""
import asyncio
import os
import tempfile
import time
from pathlib import Path

from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

# Par RSA efímero para probar el flujo RS256 sin depender de las llaves reales
_privada = rsa.generate_private_key(public_exponent=65537, key_size=2048)
_privada_pem = _privada.private_bytes(
    serialization.Encoding.PEM,
    serialization.PrivateFormat.PKCS8,
    serialization.NoEncryption(),
).decode("ascii")
_ruta_publica = Path(tempfile.mkdtemp(prefix="angel_tests_")) / "publica_test.pem"
_ruta_publica.write_text(
    _privada.public_key()
    .public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo)
    .decode("ascii")
)
os.environ.setdefault("JWT_ALGORITHM", "RS256")
os.environ.setdefault("JWT_PUBLIC_KEY", str(_ruta_publica))

import jwt  # noqa: E402
import pytest  # noqa: E402
from fastapi import HTTPException  # noqa: E402
from fastapi.security import HTTPAuthorizationCredentials  # noqa: E402
from pydantic import ValidationError  # noqa: E402

from auth import verificar_token  # noqa: E402
from config import get_settings  # noqa: E402
from db import embedding_a_texto  # noqa: E402
from llm import _quitar_asteriscos_markdown, _quitar_saludo_repetido  # noqa: E402
import main  # noqa: E402
from nlp import extraer_perfil  # noqa: E402
import seed  # noqa: E402
from schemas import ConsultaChat, SolicitudReindexacion  # noqa: E402


def _cred(token: str):
    return HTTPAuthorizationCredentials(scheme="Bearer", credentials=token)


def test_detecta_piel_grasa_y_presupuesto():
    p = extraer_perfil("Tengo la piel grasa y con acné, busco una base de menos de $15")
    assert p.tipo_piel == "grasa"
    assert "acne" in p.necesidades
    assert p.categoria == "base"
    assert p.precio_max == 15.0


def test_detecta_piel_seca():
    p = extraer_perfil("mi piel está muy reseca, qué crema me recomiendas")
    assert p.tipo_piel == "seca"
    assert p.categoria == "skincare"


def test_jwt_valido():
    token = jwt.encode({"sub": "1", "exp": time.time() + 60}, _privada_pem, algorithm="RS256")
    assert verificar_token(_cred(token))["sub"] == "1"


def test_jwt_expirado():
    token = jwt.encode({"sub": "1", "exp": time.time() - 10}, _privada_pem, algorithm="RS256")
    with pytest.raises(HTTPException) as e:
        verificar_token(_cred(token))
    assert e.value.status_code == 401
    assert "expirado" in e.value.detail


def test_jwt_invalido():
    with pytest.raises(HTTPException) as e:
        verificar_token(_cred("basura"))
    assert e.value.status_code == 401


def test_falta_token():
    with pytest.raises(HTTPException) as e:
        verificar_token(None)
    assert e.value.status_code == 401


def test_solicitud_reindexacion_valida_id_y_filtros():
    solicitud = SolicitudReindexacion(
        tipo="conocimiento",
        ids=[2, 5],
        solo_pendientes=True,
    )
    assert solicitud.ids == [2, 5]
    with pytest.raises(ValidationError):
        SolicitudReindexacion(tipo="todo", id=3)
    with pytest.raises(ValidationError):
        SolicitudReindexacion(tipo="productos", solo_pendientes=True)


def test_reindexacion_exige_token_con_scope_especifico():
    solicitud = SolicitudReindexacion(tipo="productos", id=7)
    with pytest.raises(HTTPException) as e:
        asyncio.run(main.reindexar(solicitud, {"sub": "1"}))
    assert e.value.status_code == 403


def test_reindexacion_devuelve_cantidad_por_tipo(monkeypatch):
    async def reindexar_falso(tipo, **kwargs):
        assert tipo == "productos"
        assert kwargs["id"] == 7
        return {"productos": 1}

    monkeypatch.setattr(main.seed, "ejecutar_reindexacion", reindexar_falso)
    respuesta = asyncio.run(
        main.reindexar(
            SolicitudReindexacion(tipo="productos", id=7),
            {"sub": "admin", "scope": "angel:reindex"},
        )
    )
    assert respuesta["estado"] == "completado"
    assert respuesta["procesados"] == 1
    assert respuesta["detalle"] == {"productos": 1}


def test_reindexacion_informa_progreso_si_falla(monkeypatch):
    async def reindexar_falso(tipo, **kwargs):
        raise main.seed.ErrorReindexacion(
            "No se pudo indexar el producto ID 9",
            {"productos": 2},
        )

    monkeypatch.setattr(main.seed, "ejecutar_reindexacion", reindexar_falso)
    with pytest.raises(HTTPException) as e:
        asyncio.run(
            main.reindexar(
                SolicitudReindexacion(tipo="productos"),
                {"sub": "admin", "scope": "angel:reindex"},
            )
        )
    assert e.value.status_code == 502
    assert e.value.detail["procesados"] == 2
    assert e.value.detail["detalle"] == {"productos": 2}


def test_indexa_solo_ids_de_conocimiento_y_recalcula_vector(monkeypatch):
    class CursorFalso:
        def __init__(self):
            self.consultas = []

        async def __aenter__(self):
            return self

        async def __aexit__(self, *args):
            return None

        async def execute(self, consulta, parametros=None):
            self.consultas.append((consulta, parametros))

        async def fetchall(self):
            if self.consultas[-1][0].startswith("SELECT id FROM angel_conocimiento"):
                return [(12,)]
            return [(12, "Envíos", "faq", "Texto curado")]

    class ConexionFalsa:
        def __init__(self):
            self.cursor_falso = CursorFalso()

        def cursor(self):
            return self.cursor_falso

    async def embedding_falso(texto):
        return [0.0] * get_settings().embedding_dim

    conexion = ConexionFalsa()
    monkeypatch.setattr(seed, "embed", embedding_falso)
    cantidad = asyncio.run(seed.indexar_conocimiento(conexion, ids=[12]))

    consulta_select, parametros = conexion.cursor_falso.consultas[0]
    consulta_update, parametros_update = conexion.cursor_falso.consultas[2]
    assert "id IN (%s)" in consulta_select
    assert parametros == [12]
    assert consulta_update.startswith("UPDATE angel_conocimiento SET embedding")
    assert parametros_update[1] == 12
    assert cantidad == 1


def test_conocimiento_pendiente_filtra_fichas_sin_embedding():
    class CursorFalso:
        consulta = ""

        async def __aenter__(self):
            return self

        async def __aexit__(self, *args):
            return None

        async def execute(self, consulta, parametros=None):
            self.consulta = consulta

        async def fetchall(self):
            return []

    class ConexionFalsa:
        def __init__(self):
            self.cursor_falso = CursorFalso()

        def cursor(self):
            return self.cursor_falso

    conexion = ConexionFalsa()
    cantidad = asyncio.run(
        seed.indexar_conocimiento(conexion, solo_pendientes=True)
    )
    assert "embedding IS NULL" in conexion.cursor_falso.consulta
    assert cantidad == 0


def test_indexar_productos_filtra_por_id(monkeypatch):
    class CursorFalso:
        def __init__(self):
            self.consultas = []
            self.rowcount = 1

        async def __aenter__(self):
            return self

        async def __aexit__(self, *args):
            return None

        async def execute(self, consulta, parametros=None):
            self.consultas.append((consulta, parametros))

        async def fetchall(self):
            return [(9, "Crema", "Descripción", "Cuidado facial", "Marca", None, None)]

    class ConexionFalsa:
        def __init__(self):
            self.cursor_falso = CursorFalso()

        def cursor(self):
            return self.cursor_falso

    async def embedding_falso(texto):
        return [0.0] * get_settings().embedding_dim

    conexion = ConexionFalsa()
    monkeypatch.setattr(seed, "embed", embedding_falso)
    cantidad = asyncio.run(seed.indexar_productos(conexion, producto_id=9))

    insercion, parametros_insert = conexion.cursor_falso.consultas[0]
    consulta_select, parametros_select = conexion.cursor_falso.consultas[1]
    assert "id_producto = %s" in insercion
    assert parametros_insert == (9,)
    assert "AND p.id_producto = %s" in consulta_select
    assert parametros_select == [9]
    assert cantidad == 1


def test_embedding_a_texto_exige_la_dimension_configurada():
    dim = get_settings().embedding_dim
    with pytest.raises(ValueError, match=str(dim)):
        embedding_a_texto([0.1])


def test_historial_acepta_formato_del_widget():
    c = ConsultaChat(
        mensaje="buenas",
        historial=[
            {"role": "user", "content": "hola"},
            {"role": "assistant", "content": "¿qué buscas hoy?"},
        ],
    )
    assert c.historial[0].rol == "usuario"
    assert c.historial[1].rol == "asistente"


def test_historial_rechaza_demasiados_turnos():
    muchos = [{"role": "user", "content": f"m{i}"} for i in range(20)]
    with pytest.raises(ValidationError):
        ConsultaChat(mensaje="buenas", historial=muchos)


def test_quita_saludo_si_ya_hubo_respuesta_del_asistente():
    historial = ConsultaChat(
        mensaje="hola",
        historial=[{"role": "assistant", "content": "¡Hola! ¿En qué te ayudo?"}],
    ).historial
    assert _quitar_saludo_repetido("¡Hola! Claro, te ayudo 😊", historial) == "Claro, te ayudo 😊"


def test_conserva_saludo_si_no_hay_historial_del_asistente():
    historial = ConsultaChat(
        mensaje="hola",
        historial=[{"role": "user", "content": "hola"}],
    ).historial
    respuesta = "¡Hola! ¿En qué te ayudo?"
    assert _quitar_saludo_repetido(respuesta, historial) == respuesta


def test_quita_asteriscos_de_negritas_markdown():
    respuesta = (
        "Te recomiendo el **Polvo suelto premium de Salome** ($6.00). "
        "El **Polvo sencillo de Salome** también es una opción."
    )
    resultado = _quitar_asteriscos_markdown(respuesta)
    assert "*" not in resultado
    assert "Polvo suelto premium de Salome" in resultado
    assert "Polvo sencillo de Salome" in resultado
