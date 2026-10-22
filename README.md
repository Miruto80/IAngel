# Ángel — microservicio de recomendaciones para LoveMakeup

Ángel es un servicio independiente en FastAPI. Lee el catálogo existente de
LoveMakeup (`producto`, `categoria` y `marca`), aplica filtros por stock,
precio, categoría, marca y perfil de piel, y devuelve productos reales al chat.
No recrea ni modifica esas tablas del sistema PHP.

## Compatibilidad del catálogo

Los dumps disponibles no representan el mismo estado de la tienda ni el mismo
servidor:

- El dump del hosting, `BD/bd.sql`, declara MariaDB 11.8.9 y usa
  `u417714339_Lovemakeupbd`.
- `Lovemakeup-3.0/lovemakeupbd1.sql` es un dump local antiguo: declara MariaDB
  10.4 y usa la base `lovemakeupbd1`.
- Ambos esquemas contienen las tablas `producto`, `categoria` y `marca`, con
  las columnas relevantes `precio_detal`, `stock_disponible`, `estatus`,
  `id_categoria` e `id_marca`, aunque sus datos/categorías difieren.

El servicio requiere MariaDB 11.7 o superior: los embeddings se guardan como
`VECTOR(1024)` en la tabla auxiliar `angel_producto_ai` y la búsqueda por
similitud la ejecuta la propia base con `VEC_DISTANCE_COSINE`. El dump del
hosting declara MariaDB 11.8.9; los dumps locales antiguos (10.4) solo sirven
como referencia del catálogo, no para ejecutar el servicio. El valor por
defecto está alineado con el dump del hosting; `DB_NAME` en `.env` prevalece
sobre ese valor y debe coincidir con la base existente.

## Instalación y configuración

Se requiere Python 3.10 o posterior. Desde esta carpeta:

```powershell
python -m venv venv
venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
```

Edita `.env` y define la conexión a la base real, la llave pública del JWT y
la clave de OpenRouter:

```dotenv
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=angel
DB_PASSWORD=una-clave-segura
DB_NAME=u417714339_Lovemakeupbd
JWT_ALGORITHM=RS256
JWT_PUBLIC_KEY=ai_public.pem
OPENROUTER_API_KEY=...
```

El JWT lo firma el PHP con RS256 y aquí solo se verifica la firma con la
llave pública (`JWT_PUBLIC_KEY`). El repo incluye `ai_public.pem`, copia de
la misma llave que `Lovemakeup-3.0/config/jwt_public.pem`: ambos servicios
deben compartir el mismo par de llaves.

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
esquema de la tienda y los embeddings del catálogo. Si ya tenías la tabla con
el esquema anterior (embedding JSON en LONGTEXT), ejecuta la migración
comentada en `BD/schema.sql` (drop + add de la columna `VECTOR(1024)`) y vuelve
a indexar: la conversión directa no existe. El usuario de ejecución necesita `SELECT`
en `producto`, `categoria` y `marca`, y `SELECT`, `INSERT` y `UPDATE` en
`angel_producto_ai`; los `GRANT` de ejemplo están comentados en `BD/schema.sql`.

Indexa los productos activos existentes:

```powershell
python seed.py reindex
```

El comando usa una llamada de embeddings a OpenRouter (baai/bge-m3,
1024 dimensiones) por producto. Vuelve a ejecutarlo al agregar productos o
cambiar su descripción, categoría o marca.
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

Toda la IA pasa por OpenRouter con una única `OPENROUTER_API_KEY`: los
embeddings usan `EMBEDDING_MODEL` (por defecto `baai/bge-m3`, 1024 dimensiones)
y la redacción un modelo multimodal de Qwen (`LLM_MODEL`, por defecto
`qwen/qwen3-vl-30b-a3b-instruct`: texto y fotos). Con fotos en `/api/chat`,
`llm.describir_imagen` las interpreta primero (producto o rostro, máximo
`MAX_IMAGENES`, timeout `VISION_TIMEOUT_SECONDS`) y esa descripción entra al
perfil, al embedding y al prompt; si la visión falla, el chat continúa como
texto. Si la key no está configurada o el modelo tarda más de
`LLM_TIMEOUT_SECONDS`, se utiliza una respuesta de plantilla.

En producción, usa HTTPS detrás de nginx/Caddy, limita `CORS_ORIGINS` al origen
de LoveMakeup y no expongas el puerto de MariaDB ni el secreto JWT.

## Conexión desde LoveMakeup

El backend PHP ya firma JWT RS256 con `config/jwt_private.pem` (`login.php`,
`issue_jwt.php` y las demás APIs), así que Ángel no necesita secreto
compartido: valida la firma con `JWT_PUBLIC_KEY`, la llave pública del mismo
par (`ai_public.pem`, copia de `Lovemakeup-3.0/config/jwt_public.pem`).

El cliente reutiliza el token que `login.php` ya devuelve y lo envía en el
encabezado `Authorization: Bearer` a `/api/chat`, igual que hace con las demás
APIs. En despliegues separados, usa la URL HTTPS pública del servicio y permite
el origen de la tienda en `CORS_ORIGINS`.

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
