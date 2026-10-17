// Cliente del chat de "Ángel" (Fetch API). Úsalo desde tu vista PHP.
// El token JWT lo genera tu backend PHP al cargar la página (ver README).
const ANGEL_URL = "http://localhost:8000/api/chat"; // cambia en producción (HTTPS)

async function preguntarAngel(mensaje, token) {
  const r = await fetch(ANGEL_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({ mensaje }),
  });
  if (!r.ok) {
    if (r.status === 422) throw new Error("Escribe una consulta válida.");
    throw new Error("Ángel no está disponible en este momento.");
  }
  return r.json(); // { respuesta, perfil, productos[] }
}

// Ejemplo de uso con un formulario #chat-form, input #chat-input y contenedor #chat-box
document.getElementById("chat-form")?.addEventListener("submit", async (e) => {
  e.preventDefault();
  const input = document.getElementById("chat-input");
  const box = document.getElementById("chat-box");
  const texto = input.value.trim();
  if (!texto) return;

  box.insertAdjacentHTML("beforeend", `<div class="msg user"></div>`);
  box.lastElementChild.textContent = texto; // textContent evita XSS
  input.value = "";

  try {
    const data = await preguntarAngel(texto, window.ANGEL_TOKEN);
    box.insertAdjacentHTML("beforeend", `<div class="msg angel"></div>`);
    box.lastElementChild.textContent = data.respuesta;
  } catch (err) {
    box.insertAdjacentHTML("beforeend", `<div class="msg error"></div>`);
    box.lastElementChild.textContent = err.message;
  }
});
