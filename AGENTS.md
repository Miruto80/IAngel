# AGENTS.md — Ángel (microservicio de recomendaciones LoveMakeup)

FastAPI + MariaDB 11.7+. Estructura plana de módulos: se ejecuta **desde esta carpeta** (no hay paquete ni `pyproject.toml`). Todo el repo está en **español** (comentarios, docstrings, errores de API, `SYSTEM_PROMPT`): mantén ese idioma en el código.

**IA vía OpenRouter** (una sola `OPENROUTER_API_KEY`, cliente del SDK `openai` con `base_url`): embeddings con `baai/bge-m3` (1024 dims, multilingüe; `qwen/qwen3-embedding-0.6b` ya no tiene endpoints en OpenRouter: no lo uses) y redacción con Qwen chat (`LLM_MODEL`). No hay SDK de OpenAI ni Anthropic propios; no los reintroduzcas.

## Comandos

```powershell
# Setup (PowerShell, Python 3.10+)
python -m venv venv; venv\Scripts\Activate.ps1; pip install -r requirements.txt
Copy-Item .env.example .env   # luego completar DB_* y OPENROUTER_API_KEY (el JWT ya usa RS256 por defecto)

uvicorn main:app --reload --port 8000        # servir; /health y /docs para verificar
pytest -v                                    # tests unitarios puros (sin BD ni red)
pytest test_api.py::test_jwt_valido          # test individual
python seed.py reindex                       # indexar embeddings (requiere BD MariaDB 11.7+ + OPENROUTER_API_KEY)
```

MySQL local de XAMPP: `C:\xampp\mysql\bin\mysql.exe` (XAMPP trae MariaDB 10.4, **sin tipo VECTOR**: no sirve para ejecutar el servicio, solo los dumps como referencia de catálogo).

## Reglas de la base de datos

- El servicio **solo lee** las tablas de la tienda PHP (`producto`, `categoria`, `marca`). **Nunca las modifiques ni las recrees.** La única tabla propia es `angel_producto_ai` (`BD/schema.sql`); aplicarla no altera el esquema de la tienda.
- Los embeddings se guardan como **`VECTOR(1024)`** (tipo nativo de MariaDB 11.7+) y la búsqueda es `ORDER BY VEC_DISTANCE_COSINE(ai.embedding, VEC_FromText(%s))` en SQL — no en Python. La dimensión viene de `EMBEDDING_DIM` en config: **cambiar de modelo de embeddings implica recrear la columna `VECTOR(N)` y reindexar todo**.
- La columna `embedding` es **NULL-able a propósito**: `seed.py` inserta primero las filas sin vector y las rellena después; con `NOT NULL` ese `INSERT` fallaría. Los productos sin indexar provocan `CatalogoSinIndexarError` (503).
- El índice `VECTOR INDEX` está comentado en `schema.sql`: crearlo solo con el catálogo completo indexado.
- Migración desde el esquema viejo (JSON/LONGTEXT): drop + add de la columna (comentada en `schema.sql`); la conversión directa no existe.
- Hay dos dumps con catálogos distintos: `BD/bd.sql` (hosting, MariaDB 11.8.9, base `u417714339_Lovemakeupbd` — valor por defecto de `DB_NAME`) y el dump local antiguo (base `lovemakeupbd1`). `DB_NAME` en `.env` debe coincidir con la base realmente importada; los ids del dump pueden no coincidir con el hosting.
- Tras editar productos de la tienda **o** los campos auxiliares `tipo_piel`/`ingredientes_activos`, re-ejecutar `python seed.py reindex` (una llamada a OpenRouter por producto).
- Solo se recomiendan productos con `estatus = 1` y `stock_disponible > 0`. No atribuir tipo de piel ni ingredientes que no estén en `angel_producto_ai`.

## Flujo de `/api/chat` (en este orden)

1. `nlp.extraer_perfil` — reglas deterministas, sin LLM (usa los diccionarios `TIPOS_PIEL`, `NECESIDADES`, `CATEGORIAS`, `MARCAS`; amplíalos ahí, no con LLM).
2. `llm.generar_embedding` — OpenRouter `EMBEDDING_MODEL` (por defecto `baai/bge-m3`), obligatorio para buscar.
3. `db.buscar_productos` — filtros en SQL + `VEC_DISTANCE_COSINE` en la misma consulta (una de conteo previa detecta catálogo sin indexar).
4. `llm.redactar_respuesta` — Qwen chat (`LLM_MODEL`) con timeout `LLM_TIMEOUT_SECONDS`; si falta la key o falla, cae a `_respuesta_plantilla` (comportamiento esperado, no un bug).

## Configuración y entornos

- `.env` se carga con pydantic-settings; con `JWT_ALGORITHM=RS256` (por defecto) la app no arranca sin `JWT_PUBLIC_KEY`; el modo legado HS256 exige `JWT_SECRET`. `config.get_settings` y el cliente de `llm.py` se crean a nivel de módulo / con `lru_cache`: **los cambios de `.env` requieren reiniciar el proceso**.
- El PHP ya firma **RS256** con `Lovemakeup-3.0/config/jwt_private.pem` y sus APIs verifican con `config/jwt_public.pem` (mismo par; `login.php`, `issue_jwt.php`, `producto.php`, etc.). Python solo verifica: `JWT_PUBLIC_KEY` debe apuntar al PEM público de ese mismo par (`ai_public.pem` es copia de `config/jwt_public.pem`, mantenlas idénticas). No hay secreto compartido con `passconfig.env`; `chat_widget.js` de aquí es solo ejemplo de cliente y el widget `chat.php` no está committeado en el repo PHP.
- OpenRouter es la única puerta de IA. Fase 2 pendiente (no implementada): visión con Qwen-VL (el cliente enviaría una foto en `/api/chat`); Qwen3-Embedding es solo texto.

## Verificación

No hay linter, formateador ni CI configurados. Para verificar un cambio: `pytest -v` + `GET /health` (confirma acceso a MariaDB) + una petición real a `/api/chat` con JWT firmado manualmente si se tocó el flujo completo.

- `todo.md` (versionado, en este repo y en `Lovemakeup-3.0`) concentra el estado y los pendientes de la integración IAngel ↔ Lovemakeup: mantenlo al día al cerrar tareas.
