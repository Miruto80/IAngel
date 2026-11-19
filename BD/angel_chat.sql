-- Base de conocimiento + memoria de chat de Ángel, sobre la base LoveMakeup
-- existente (requiere MariaDB 11.7+ por el tipo VECTOR: en la PC es el
-- servicio MariaDB-Angel 11.8.4, puerto 23307; los XAMPP 10.x no sirven).
-- Ejecutar como administrador; no altera las tablas del sistema PHP.

-- 1) Fichas de conocimiento curadas: el equipo las escribe a mano en
--    phpMyAdmin y luego las vectoriza `python seed.py conocimiento`.
CREATE TABLE IF NOT EXISTS angel_conocimiento (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tema VARCHAR(80) NOT NULL COMMENT 'Título corto de la ficha',
    tipo VARCHAR(20) NOT NULL DEFAULT 'faq' COMMENT 'faq|envio|politica|uso|tip',
    contenido TEXT NOT NULL COMMENT 'Lo que Ángel puede consultar verificada',
    embedding VECTOR(1024) NULL COMMENT 'bge-m3; lo llena seed.py, no a mano',
    activo TINYINT(1) NOT NULL DEFAULT 1 COMMENT '0 = ficha desactivada sin borrarla',
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2) Memoria de conversaciones por usuario autenticado (sub = cédula del
--    token RS256). Los invitados (sub anon_*) NO se guardan.
--
--    NOTA DE DISEÑO — por qué `usuario` NO lleva FOREIGN KEY:
--    - `usuario` guarda el `sub` del JWT: la cédula del usuario de la tienda
--      o `anon_*` para invitados. La tabla de usuarios de la tienda NO vive
--      en esta base (está en la segunda base del sistema PHP), y MariaDB no
--      soporta claves foráneas entre bases distintas.
--    - Aunque viviera aquí, una FK acoplaría el ciclo de vida: eliminar un
--      usuario bloquearía (RESTRICT) o borraria (CASCADE) su historial de
--      chat, que debe sobrevivir de forma independiente.
--    - La relación funcional la garantiza el índice idx_usuario_recent y la
--      retención por HISTORIAL_GUARDAR (recorte, no borrado en cascada).
CREATE TABLE IF NOT EXISTS angel_chat_mensaje (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(30) NOT NULL,
    rol ENUM('usuario','asistente') NOT NULL,
    contenido VARCHAR(1000) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_usuario_recent (usuario, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Grants del usuario 'angel' (comodínes de host según el entorno):
-- GRANT SELECT, INSERT, UPDATE ON u417714339_Lovemakeupbd.angel_conocimiento TO 'angel'@'%';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON u417714339_Lovemakeupbd.angel_chat_mensaje TO 'angel'@'%';

-- PLANTILLAS de fichas: copiar, editar el texto y ejecutar. Una fila = un
-- conocimiento; teme cortos y contenido concreto (una o dos frases):
-- INSERT INTO angel_conocimiento (tema, tipo, contenido) VALUES
-- ('Envíos a Barquisimeto', 'envio', 'Hacemos envíos a todo el país; en Barquisimeto la entrega es en 24 horas y fuera de la ciudad en 48 a 72 horas.'),
-- ('Horario de atención', 'politica', 'Atendemos de lunes a sábado de 8:00 am a 6:00 pm por WhatsApp y por el chat de la web.'),
-- ('Garantía de productos', 'politica', 'Todos los productos son originales; si llega defectuoso se cambia en 5 días presentando foto y factura.');
