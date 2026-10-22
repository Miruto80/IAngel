"""Prueba e2e local contra el servidor de Ángel (texto y fotos).

Uso (PowerShell, desde la carpeta del repo con el venv activo):

    venv\\Scripts\\python.exe prueba_e2e.py                     # mensaje típico de prueba
    venv\\Scripts\\python.exe prueba_e2e.py 401                 # token basura -> 401
    venv\\Scripts\\python.exe prueba_e2e.py 422                 # mensaje vacío -> 422
    venv\\Scripts\\python.exe prueba_e2e.py "otro mensaje"
    venv\\Scripts\\python.exe prueba_e2e.py imagen foto.jpg     # fase de visión (foto)

Firma el token igual que issue_jwt.php/chat.php: RS256 con la privada del par,
payload {sub, iat, exp} de 1 h de vida.
"""
import base64
import json
import sys
import time

import httpx
import jwt

# La consola de Windows usa cp1252 y no sabe imprimir emojis ni acentos;
# forzamos UTF-8 con reemplazo para poder mostrar la respuesta del LLM.
sys.stdout.reconfigure(encoding="utf-8", errors="replace")

PRIVADA = "ai_private.pem"
URL = "http://127.0.0.1:8000/api/chat"
SUB = "love_makeup_user"


def firmar_token() -> str:
    ahora = int(time.time())
    payload = {"sub": SUB, "iat": ahora, "exp": ahora + 3600}
    with open(PRIVADA, "rb") as f:
        return jwt.encode(payload, f.read(), algorithm="RS256")


def mostrar(r: httpx.Response) -> None:
    print(f"HTTP {r.status_code}")
    try:
        print(json.dumps(r.json(), ensure_ascii=False, indent=2)[:3000])
    except Exception:
        print(r.text[:1000])


def main() -> None:
    caso = sys.argv[1] if len(sys.argv) > 1 else "chat"
    cabeceras = {"Authorization": f"Bearer {firmar_token()}"}

    if caso == "401":
        r = httpx.post(URL, json={"mensaje": "hola"}, headers={"Authorization": "Bearer basura"}, timeout=30)
        mostrar(r)
        return

    if caso == "422":
        r = httpx.post(URL, json={"mensaje": ""}, headers=cabeceras, timeout=30)
        mostrar(r)
        return

    if caso == "imagen":
        if len(sys.argv) < 3:
            print("Uso: python prueba_e2e.py imagen ruta.jpg")
            return
        with open(sys.argv[2], "rb") as f:
            data = "data:image/jpeg;base64," + base64.b64encode(f.read()).decode()
        r = httpx.post(
            URL,
            json={"mensaje": "Según lo que ves, ¿qué me recomiendas?", "imagenes": [data]},
            headers=cabeceras,
            timeout=120,
        )
        mostrar(r)
        return

    mensaje = caso if caso != "chat" else "tengo la piel grasa y acné, busco una base de menos de $15"
    r = httpx.post(URL, json={"mensaje": mensaje}, headers=cabeceras, timeout=60)
    mostrar(r)


if __name__ == "__main__":
    main()
