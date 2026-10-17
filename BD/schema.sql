-- MariaDB 11.8 LTS (soporte nativo de VECTOR)
CREATE DATABASE IF NOT EXISTS lovemakeup CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lovemakeup;

-- Usuario dedicado para el microservicio (mínimo privilegio)
-- CREATE USER 'angel'@'%' IDENTIFIED BY 'cambia_esto';
-- GRANT SELECT, INSERT, UPDATE ON lovemakeup.productos TO 'angel'@'%';

-- Si ya tienes la tabla de productos en tu sistema PHP, NO la recrees:
-- solo agrega las columnas que faltan con ALTER TABLE (ver abajo).
CREATE TABLE IF NOT EXISTS productos (
    id                   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre               VARCHAR(150)  NOT NULL,
    categoria            VARCHAR(50)   NOT NULL,   -- base, labial, corrector, skincare...
    marca                VARCHAR(80)   NULL,
    precio               DECIMAL(10,2) NOT NULL,
    stock                INT           NOT NULL DEFAULT 0,
    tipo_piel            VARCHAR(100)  NULL,       -- 'grasa,mixta' | 'seca' | 'todo_tipo'
    ingredientes_activos VARCHAR(255)  NULL,
    descripcion          TEXT          NULL,
    embedding            VECTOR(1536)  NOT NULL,
    INDEX idx_categoria (categoria),
    INDEX idx_precio (precio),
    VECTOR INDEX idx_embedding (embedding) DISTANCE=cosine
) ENGINE=InnoDB;

/* Si tu tabla ya existe:
ALTER TABLE productos
    ADD COLUMN tipo_piel VARCHAR(100) NULL,
    ADD COLUMN ingredientes_activos VARCHAR(255) NULL,
    ADD COLUMN embedding VECTOR(1536) NOT NULL,   -- (rellena antes de añadir el índice si hay datos)
    ADD VECTOR INDEX idx_embedding (embedding) DISTANCE=cosine;
*/

-- Consulta híbrida de ejemplo (la misma que usa db.py):
-- SELECT id, nombre, precio
-- FROM productos
-- WHERE stock > 0 AND precio <= 15.00
--   AND (FIND_IN_SET('grasa', tipo_piel) > 0 OR FIND_IN_SET('todo_tipo', tipo_piel) > 0)
-- ORDER BY VEC_DISTANCE_COSINE(embedding, VEC_FromText('[...1536 valores...]'))
-- LIMIT 5;
