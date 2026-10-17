# Ángel – Asesor de belleza con IA (LoveMakeup C.A.)

Microservicio Python (FastAPI) que se conecta a tu tienda PHP/MariaDB.

```
Navegador (JS fetch) ──HTTPS+JWT──► FastAPI (Python)
                                     │ 1. PLN: perfil (tipo de piel, necesidad, precio)
                                     │ 2. Embedding de la consulta
                                     │ 3. SQL híbrido + VEC_DISTANCE_COSINE ──► MariaDB 11.8
                                     └ 4. Claude redacta la respuesta con datos reales
```

## Paso a paso

### 1. Preparar el entorno
```bash
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env              # completa tus claves
```
Necesitas dos claves: `OPENAI_API_KEY` (embeddings de 1536 dimensiones) y
`ANTHROPIC_API_KEY` (redacción de la respuesta). Sin la de Anthropic, Ángel igual
responde con una plantilla.

### 2. Preparar MariaDB 11.8
```bash
mariadb -u root -p < schema.sql
```
Verifica la versión: `SELECT VERSION();` (debe ser 11.7 o superior para `VECTOR`).
Si ya tienes la tabla `productos` en tu PHP, usa el bloque `ALTER TABLE` comentado en `schema.sql`.

### 3. Cargar embeddings
```bash
python seed.py demo       # productos de ejemplo
python seed.py reindex    # cuando ya tengas tu catálogo real: recalcula los embeddings
```
Cada vez que agregues o edites un producto, debes recalcular su embedding.

### 4. Levantar el microservicio
```bash
uvicorn main:app --reload --port 8000
```
Swagger: http://localhost:8000/docs

### 5. JWT desde PHP (RNF-03)
El PHP firma el token con el **mismo** `JWT_SECRET`. Con `composer require firebase/php-jwt`:
```php
use Firebase\JWT\JWT;
$token = JWT::encode(
    ['sub' => $_SESSION['user_id'] ?? 'invitado', 'exp' => time() + 3600],
    getenv('JWT_SECRET'), 'HS256'
);
echo "<script>window.ANGEL_TOKEN = " . json_encode($token) . ";</script>";
```
Incluye luego `chat_widget.js` en tu vista y crea `#chat-form`, `#chat-input`, `#chat-box`.

### 6. Probar
```bash
pytest -v                                   # pruebas unitarias (PLN y JWT)
python -c "import jwt,time;print(jwt.encode({'sub':'1','exp':time.time()+3600},'TU_JWT_SECRET',algorithm='HS256'))"
curl -X POST http://localhost:8000/api/chat \
  -H "Authorization: Bearer <TOKEN>" -H "Content-Type: application/json" \
  -d '{"mensaje":"Tengo piel grasa con acné, busco una base de menos de 15 dólares"}'
```

### 7. Cumplir RNF-01 (< 1.5 s)
- El PLN es por reglas (instantáneo); el LLM tiene `LLM_TIMEOUT_SECONDS` y cae a plantilla si tarda.
- Mide el tiempo en los logs (`chat atendido en ... ms`) y en las pruebas de integración.
- Despliega el microservicio cerca de la BD (misma red/servidor).

### 8. Producción
- HTTPS (nginx/Caddy como proxy), `uvicorn --workers 2` o gunicorn.
- Restringe `CORS_ORIGINS` a tu dominio y usa un `JWT_SECRET` largo.
- Usuario de BD con mínimo privilegio (solo SELECT en `productos`).

## Mapeo a tus requisitos
| Requisito | Dónde |
|---|---|
| RF-01 consultas en lenguaje natural | `nlp.py` |
| RF-02 recomendación por piel e ingredientes | `db.py` + `seed.py` (embeddings) |
| RF-03 filtros precio/piel/categoría/marca | `db.buscar_productos` |
| RNF-01 < 1.5 s | timeout + fallback en `llm.py`, FastAPI async |
| RNF-02 disponibilidad | `/health` para monitoreo |
| RNF-03 JWT | `auth.py` |
