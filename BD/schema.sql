-- Tabla auxiliar de Ángel, sobre la base LoveMakeup existente (la que contiene
-- producto, categoria y marca). No altera esas tablas.
-- Requiere MariaDB 11.7 o superior (tipo VECTOR); el hosting (11.8) lo soporta.
CREATE TABLE IF NOT EXISTS angel_producto_ai (
    id_producto INT NOT NULL PRIMARY KEY,
    tipo_piel VARCHAR(100) NULL,
    ingredientes_activos VARCHAR(255) NULL,
    embedding VECTOR(1024) NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_angel_producto_ai_producto
        FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- La dimensión 1024 corresponde a qwen/qwen3-embedding-0.6b (EMBEDDING_DIM en
-- .env). Cambiar de modelo de embeddings implica recrear la columna con la
-- dimensión nueva y volver a indexar (python seed.py reindex).

-- Índice vectorial OPCIONAL: acelera catálogos grandes. Mantener comentado
-- mientras haya filas con embedding NULL (seed inserta primero sin vector);
-- créalo solo cuando todo el catálogo esté indexado.
-- ALTER TABLE angel_producto_ai ADD VECTOR INDEX idx_embedding (embedding) DISTANCE=COSINE;

-- Migración desde el esquema anterior (embedding LONGTEXT con JSON).
-- La conversión directa LONGTEXT -> VECTOR no existe; ejecutar como usuario
-- administrador (requiere ALTER) y después volver a indexar:
--   1) ALTER TABLE angel_producto_ai DROP COLUMN embedding;
--   2) ALTER TABLE angel_producto_ai ADD COLUMN embedding VECTOR(1024) NULL;
--   3) python seed.py reindex

-- Usuario de BD dedicado: solo lectura del catálogo y escritura de su tabla AI.
-- Ajusta la base y host al entorno antes de ejecutar:
-- CREATE USER 'angel'@'localhost' IDENTIFIED BY 'una-clave-segura';
-- GRANT SELECT ON lovemakeupbd1.producto TO 'angel'@'localhost';
-- GRANT SELECT ON lovemakeupbd1.categoria TO 'angel'@'localhost';
-- GRANT SELECT ON lovemakeupbd1.marca TO 'angel'@'localhost';
-- GRANT SELECT, INSERT, UPDATE ON lovemakeupbd1.angel_producto_ai
--     TO 'angel'@'localhost';
