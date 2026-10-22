# TODO — Ángel × LoveMakeup (estado del día: 2026-10-21)

> Congelación del estado al cerrar la sesión de integración en la VM (Ubuntu 26.04 en Termux proot).
> Este archivo va versionado (no está en `.gitignore`): continúa desde la PC con este checklist.
> **Actualización de la tarde (PC Windows)**: entorno local completo funcionando — ver "Hecho hoy".
> **22-10 (VM)**: fase de visión en marcha — fotos en `/api/chat` con `qwen/qwen3-vl-30b-a3b-instruct` (un solo modelo multimodal para texto y fotos; la descripción entra al embedding `bge-m3` y al prompt). Pendiente e2e con fotos en la PC.

## Mapa rápido

| Proyecto | Ruta | Estado global |
|---|---|---|
| **IAngel** (FastAPI, este repo) | VM `/root/IAngel` · PC `Desktop\IA-angel\IAngel` | Código y docs al día; **local Windows e2e completo**; falta despliegue |
| **Lovemakeup-3.0** (PHP tienda) | VM `/root/Lovemakeup-3.0` (rama `Local`) | `chat.php` y llave A en disco; falta commit de la pública + passconfig + despliegue (no hay clon en la PC) |

## ✅ Hecho hoy (no repetir)

- [x] **RS256 en IAngel**: `config.py` (`JWT_ALGORITHM=RS256` por defecto + `JWT_PUBLIC_KEY`; `jwt_secret` queda como modo legado HS256), `auth.py` (verifica la firma leyendo el PEM), `test_api.py` con par RSA efímero → `pytest` **7/7 verde** (válido/inválido/expirado/sin token + NLP + dimensiones)
- [x] **RS256 desde el lado PHP ya existía**: `login.php`, `issue_jwt.php` y ~8 APIs firman/verifican con `config/jwt_{private,public}.pem` (openssl_sign SHA256); no hay secreto compartido HS256 que sincronizar
- [x] **LLM de pago**: `qwen/qwen3-30b-a3b-instruct-2507` (instructivo, sin razonamiento) y `LLM_TIMEOUT_SECONDS=6.0`
- [x] **Embeddings**: `qwen/qwen3-embedding-0.6b` **ya no tiene endpoints en OpenRouter** (404 "No endpoints found"). Reemplazado por **`baai/bge-m3`**: 1024 dimensiones nativas (la columna `VECTOR(1024)` queda intacta), multilingüe, ~$0.01/M tokens. Cambio aplicado en `config.py`, `llm.py`, `.env`, `.env.example`, `README.md`, `AGENTS.md`
- [x] **Llaves RSA par A** (2048 bits, emparejadas y verificadas) copiadas en la VM a: `IAngel/ai_private.pem` + `ai_public.pem` y `Lovemakeup-3.0/config/jwt_{private,public}.pem` (600)
- [x] **`.env` de IAngel en la VM**: completo y validado (RS256, MariaDB, `OPENROUTER_API_KEY` con crédito $50/mes). ES SECRETO: no versionar
- [x] **`chat.php` en el clon** (rama `Local`, commit "Angel V1"): firma su propio JWT RS256 de 1 h (`sub=love_makeup_user`) con `ANGEL_PRIVATE_KEY_PATH` de `passconfig.env`, llama a `ANGEL_API_URL` con `Authorization: Bearer` y envía `historial` (IAngel lo ignora por ahora, base de la Fase 2)
- [x] Docs de IAngel actualizadas y sincronizadas con el código (README, AGENTS.md, .env.example)
- [x] **(Tarde, PC Windows) Entorno local completo y e2e verde**:
  - Deps del venv reinstaladas (faltaba `cryptography`) → `pytest` 7/7
  - `.env` local regenerado al estado actual (RS256 + `ai_public.pem` + `bge-m3` + LLM pago); la key OpenRouter vieja del PC estaba revocada (401 User not found) → reemplazada por la válida
  - Llaves `ai_private.pem`/`ai_public.pem` verificadas en disco (par emparejado, 2048, sin passphrase) — **es el par de PRUEBA local; no el par A del hosting**
  - **MariaDB 11.8.4 instalada nativa en Windows** (MSI `archive.mariadb.org`, servicio `MariaDB-Angel`, puerto **23307**, datadir `C:\MariaDB-Angel\data`). Docker descartado: `docker pull` muere en blobs grandes con `tls: bad record MAC` (Wi-Fi USB del PC; pulls chicos OK; sin proxy en el sistema)
  - Base `u417714339_lovemakeupbd` + import de `BD/bd.sql` (21 tablas, 58 productos) + `BD/schema.sql` + usuario `angel`@`%` con grants mínimos
  - `python seed.py reindex` → **57/57 productos activos indexados** (0 sin vector)
  - `GET /health` → `{"status":"ok"}`; e2e con JWT RS256 firmado por `prueba_e2e.py` (nuevo script, no lo recoje pytest): chat 200 con producto real (`Base Matte` $5.00 stock 39; labiales multi-producto con precios reales), **401 token basura y 422 mensaje corto verificados**
- [x] **Decisión de diseño — filtro `tipo_piel` opt-in**: el hosting no tiene columna de tipo de piel; esa semántica vive en la descripción (que ya entra en el vector). `db.buscar_productos` ahora filtra solo filas con `tipo_piel` curado (`ai.tipo_piel IS NULL` pasa el filtro y decide el coseno). No se fabrican datos; la columna queda lista para cocción manual futura desde phpMyAdmin. `pytest` sigue 7/7
- [x] **(22-10, VM) Fase de visión implementada**: `ConsultaChat.imagenes` (data URLs base64, máx. `MAX_IMAGENES=3`, ~3 MB c/u); `llm.describir_imagen` describe con el propio `LLM_MODEL` (`qwen/qwen3-vl-30b-a3b-instruct`: un solo modelo multimodal para texto y fotos) y la descripción entra al perfil, al embedding (`texto_para_embedding`) y al prompt de redacción. Si la visión falla o tarda (`VISION_TIMEOUT_SECONDS=15`), el flujo sigue con solo texto (nunca 502 por una foto). Manejo de rostro: solo rasgos de piel visibles, sin identificar personas ni diagnósticos. `pytest` 7/7; llamada de visión validada en vivo contra OpenRouter. El widget `chat.php` ahora SÍ envía las imágenes (canvas máx 1024px + JPEG 0.85, limpieza tras enviar, badge con el contador, texto por defecto si van solo fotos); `prueba_e2e.py` soporta `imagen ruta.jpg`. Pendiente: e2e completo con foto en la PC (ítem 5 del plan PC)

## 🔜 Pendiente priorizado — para hacer en la PC

- [ ] **1. Widget de punta a punta**: `git clone` de `Lovemakeup-3.0` en la PC + `passconfig.env` (`ANGEL_API_URL`, `ANGEL_PRIVATE_KEY_PATH=config/jwt_private.pem`) + par de llaves + tienda en XAMPP (Apache/PHP; la 10.x sirve: VECTOR solo lo necesita Ángel) → probar el chat real en el navegador, texto y con foto
- [ ] **2. Decisión de despliegue**: dónde correrá Ángel en producción (¿hosting con Passenger? ¿VPS?) — de esto salen `CORS_ORIGINS`, `ANGEL_API_URL` público y el hosting de las llaves
- [ ] **3. Uniformar llaves al desplegar**: en el hosting colocar `config/jwt_private.pem` **y** `config/jwt_public.pem` del mismo par **a la vez** (si no, los logins fallarían; tokens de 1 h → ventana sin impacto). El par del PC es de PRUEBA; el "par A real" está en la VM (`ai_*.pem` de Download)
- [ ] **4. (Opcional) MariaDB en la VM**: quedó rota (`mariadb-server` en estado `iHR`, datadir vacío); solo si se quiere dev desde el teléfono — la BD real de desarrollo vive en la PC (`MariaDB-Angel`, 11.8.4, puerto 23307)
- [ ] **5. e2e con fotos en la PC**: `python prueba_e2e.py imagen ruta.jpg` contra el servidor local, una vez integrada la fase de visión ítems de abajo
- [ ] **6. (Ya identificado) .env de la PC desactualizado**: el 22-10 la visión falló con `404 - No endpoints found that support image input` porque la PC dejaron `LLM_MODEL` en el modelo SOLO-TEXTO (`qwen3-30b-a3b-instruct-2507`); el fallback funcionó (200 en 3.4s). Corregir: `LLM_MODEL=qwen/qwen3-vl-30b-a3b-instruct` en `.env` **y reiniciar uvicorn**. No volver a este error: el código ahora soporta `VISION_MODEL` opcional para apuntar la visión a su propio modelo VL aunque el LLM sea de texto

## 🔜 Pendiente — IAngel / entornos

- [ ] **MariaDB en la VM**: quedó a mitad de instalación (`dpkg --configure -a`). En la PC ya existe el servicio `MariaDB-Angel` (11.8.4, puerto 23307) — traer el `.env` real de la VM a la VM-mismo para e2e allá, o replicar este proceso (import + seed)
- [ ] **Sincronizar llaves y `.env`**: el par de la PC es de PRUEBA local; cuando toque despliegue, usar el par A real (VM → PC/hosting) y la key OpenRouter vigente. Al editar `.env`: reiniciar el proceso (`get_settings` y el cliente de `llm.py` van cacheados)
- [ ] **Opcional — curación de `tipo_piel`**: si el negocio quiere el filtro determinista de tipo de piel, llenar `angel_producto_ai.tipo_piel` desde phpMyAdmin (el filtro opt-in lo activa por fila; luego `python seed.py reindex` porque el texto del embedding cambia)
- [ ] **(Opcional) smoke-test del widget**: `php-cli` renderizando `vista/complementos/chat.php` con un `passconfig.env` mínimo para comprobar que `openssl_sign` construye el token sin errores PHP

## 🔜 Pendiente — Lovemakeup-3.0 (PHP)

- [x] **1. Commitear la pública del par A — HECHO**: commit `1f55e7f` empujado a `origin/Local` desde la VM; HEAD y disco ya son par A (`ad7190…` = `IAngel/ai_public.pem`). En la PC basta `git pull`
- [ ] **2. `passconfig.env` LOCAL** (gitignored, no viene en el clon):
  ```dotenv
  ANGEL_API_URL=http://127.0.0.1:8000/api/chat
  ANGEL_PRIVATE_KEY_PATH=config/jwt_private.pem
  ```
  (la privada del par A ya está en esa ruta del disco, sin passphrase; el resto de variables `DB_*` irán cuando se sincronicen las del hosting)
- [ ] **3. Despliegue del par (cuando toque)**: en el hosting colocar `config/jwt_private.pem` = privada A **y** `config/jwt_public.pem` = pública A **ambos a la vez** (si no, los logins fallarían: quien firma y quien verifica quedarían con pares distintos). Tokens de 1 h → ventana sin impacto. Y push de la rama `Local`
- [ ] **4. Prueba post-despliegue**: login real de la tienda → token → `/api/chat` del servidor HTTPS público de Ángel; y ajustar `CORS_ORIGINS` con el dominio real de la tienda

## 🚧 Fase 2 (decisión del usuario: pospuesto)

- [ ] **Historial de conversación**: el widget ya envía `historial` (≤12) y `ConsultaChat` lo ignora; implementar implies añadir campo, prompt con últimos N mensajes y (opcional) contexto en `texto_para_embedding`
- [ ] Limpieza: borrar `package-lock.json` huérfano (85 bytes, sin `package.json`) y decidir sobre `chat_widget.js` de ejemplo
- [ ] `/health` riguroso: comprobar `VERSION()` de MariaDB ≥ 11.7 y disponibilidad del modelo de embeddings
- [ ] `seed.py` en lotes (entrada en arreglo) con límite de tasa para catálogos grandes

## Notas de entorno (VM)

- Los **pipes** largos (`cmd | tail`) pueden colgarse si hay I/O saturado; redirige a archivo y `tail` aparte
- `OPENROUTER_API_KEY` vive solo en `IAngel/.env` (nunca versionar; validar con `/api/v1/auth/key`)
- Módulos/config se leen al arrancar el proceso: tras editar `.env` hay que **reiniciar uvicorn**
- MariaDB: ver también `AGENTS.md` — reglas de BD (solo-lectura del catálogo; tabla propia `angel_producto_ai`)
