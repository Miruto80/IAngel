a# Ángel — microservicio de recomendaciones para LoveMakeup

Ángel es un servicio independiente en FastAPI. Lee el catálogo existente de
LoveMakeup (`producto`, `categoria` y `marca`), aplica filtros por stock,
precio, categoría, marca y perfil de piel, y devuelve productos reales al chat.
No recrea ni modifica esas tablas del sistema PHP.


## Instalación y configuración

Se requiere Python 3.10 o posterior. Desde esta carpeta:

```powershell
python -m venv venv
venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
```

Edita `.env` y define la conexión a la base real, la ruta a la clave pública
RS256 de Ángel, la clave de OpenAI para embeddings y la clave de Groq para
redactar:

```dotenv
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=angel
DB_PASSWORD=una-clave-segura
DB_NAME=u417714339_Lovemakeupbd
JWT_PUBLIC_KEY_PATH=C:\ruta\segura\angel_jwt_public.pem
OPENAI_API_KEY=...
GROQ_API_KEY=...
```

Para desarrollo local con el dump antiguo, cambia `DB_NAME=lovemakeupbd1`. No
copies credenciales de producción a este repositorio.

## Preparar la base de datos

Importa primero el dump de LoveMakeup. Después, selecciona la base de datos
correcta y ejecuta:

```powershell
cmd /c "C:\xampp\mysql\bin\mysql.exe -u root -p u417714339_Lovemakeupbd < BD\schema.sql"
```

Para desarrollo local, reemplaza el nombre por `lovemakeupbd1`. La tabla
auxiliar contiene los atributos de piel/ingredientes que no existen en el
esquema de la tienda y los embeddings del catálogo. El usuario de ejecución necesita `SELECT`
en `producto`, `categoria` y `marca`, y `SELECT`, `INSERT` y `UPDATE` en
`angel_producto_ai`; los `GRANT` de ejemplo están comentados en `BD/schema.sql`.

Indexa los productos activos existentes:

```powershell
python seed.py reindex
```

El comando usa una llamada de embeddings de OpenAI por producto. Vuelve a
ejecutarlo al agregar productos o cambiar su descripción, categoría o marca.
Para completar las recomendaciones por tipo de piel e ingredientes, rellena
los campos auxiliares con información verificada, por ejemplo:

```sql
UPDATE angel_producto_ai
SET tipo_piel = 'grasa,mixta',
    ingredientes_activos = 'niacinamida'
WHERE id_producto = 12;
```

Después de editar esos atributos, vuelve a indexar.

## Ejecutar y comprobar

```powershell
uvicorn main:app --reload --port 8000
```

- `GET http://127.0.0.1:8000/health`: comprueba el acceso a MariaDB.
- `POST http://127.0.0.1:8000/api/chat`: endpoint protegido por JWT.
- `http://127.0.0.1:8000/docs`: documentación OpenAPI.

El chat necesita `OPENAI_API_KEY` para consultar embeddings. La redacción usa
Groq con el modelo `qwen/qwen3.8-27b`; si `GROQ_API_KEY` no está configurada o
la solicitud al modelo falla, se utiliza una respuesta de plantilla.

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
ANGEL_PRIVATE_KEY_PATH=C:\xampp\htdocs\Lovemakeup-3.0\config\angel_jwt_private.pem
```

En despliegues separados, configura `ANGEL_API_URL` con la URL HTTPS pública
del servicio y permite el origen de la tienda en `CORS_ORIGINS`.

## Alcance actual del catálogo

El servicio toma precio de `producto.precio_detal`, disponibilidad de
`producto.stock_disponible` y solo recomienda productos con `estatus = 1` y
stock positivo. Las categorías y marcas salen de las tablas relacionadas.
Los dumps tienen catálogos distintos: por ejemplo, el dump local más antiguo
solo incluye Polvo, Labial y Sombras; el dump más reciente tiene más categorías.
El servicio no puede recomendar productos que no existan o estén inactivos en
la base seleccionada.

Los datos originales no incluyen tipo de piel ni ingredientes activos. Esos
filtros solo se vuelven fiables al completar `angel_producto_ai`; mientras
estén vacíos, Ángel no debe atribuir esos atributos a un producto.
