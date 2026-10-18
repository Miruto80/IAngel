a# Ángel — microservicio de recomendaciones para LoveMakeup

Ángel es un servicio independiente en FastAPI. En el modo actual, conversa
directamente con Qwen a través de Groq. La conexión al catálogo, embeddings y
recomendaciones vectoriales queda reservada para una etapa posterior.


## Instalación y configuración

Se requiere Python 3.10 o posterior. Desde esta carpeta:

```powershell
python -m venv venv
venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
```

python -m uvicorn main:app --reload --host 127.0.0.1 --port 8000

Edita `.env` y configura la ruta a la clave pública RS256 y la clave de Groq:

```dotenv
JWT_PUBLIC_KEY_PATH=C:\ruta\segura\angel_jwt_public.pem
GROQ_API_KEY=...
LLM_MODEL=qwen/qwen3.8-27b
LLM_TIMEOUT_SECONDS=30
```

No copies credenciales de producción a este repositorio. MariaDB y OpenAI solo
serán necesarios al reactivar el indexado vectorial.

## Indexado vectorial (pausado)

La conversación actual no inicializa MariaDB ni solicita embeddings: no hace
falta preparar la base ni ejecutar `seed.py` para probar a Ángel. El código del
catálogo y el comando de indexado se conservan para reactivar las
recomendaciones con productos más adelante.

## Ejecutar y comprobar

```powershell
uvicorn main:app --reload --port 8000
```

- `GET http://127.0.0.1:8000/health`: comprueba que el servicio esté arriba.
- `POST http://127.0.0.1:8000/api/chat`: endpoint protegido por JWT.
- `http://127.0.0.1:8000/docs`: documentación OpenAPI.

El chat envía cada mensaje a Groq usando el modelo Qwen indicado en
`LLM_MODEL`. Necesita `GROQ_API_KEY`; si Qwen no está disponible, el endpoint
devuelve un error en vez de inventar una respuesta de respaldo.

En producción, usa HTTPS detrás de nginx/Caddy, limita `CORS_ORIGINS` al origen
de LoveMakeup y no expongas el puerto de MariaDB ni las claves privadas.

## Conexión desde LoveMakeup

El widget activo está en `Lovemakeup-3.0/vista/complementos/chat.php`. Firma un
JWT RS256 de una hora con la clave privada dedicada a Ángel y llama a
`/api/chat`. Configura `ANGEL_PRIVATE_KEY_PATH` en
`Lovemakeup-3.0/passconfig.env` con la ruta a esa clave. La clave pública
correspondiente se configura en `JWT_PUBLIC_KEY_PATH` del `.env` de IAngel.
No reutilices las llaves de la tienda ni guardes la privada en el repositorio.

```dotenv
ANGEL_API_URL=http://127.0.0.1:8000/api/chat
ANGEL_PRIVATE_KEY_PATH=C:\xampp\htdocs\Lovemakeup-3.0\config\ai_private.pem
```

En despliegues separados, configura `ANGEL_API_URL` con la URL HTTPS pública
del servicio y permite el origen de la tienda en `CORS_ORIGINS`.

Mientras el catálogo no esté conectado, Ángel ofrece orientación general y no
debe afirmar que conoce productos, precios o disponibilidad de la tienda.
