-- Ejecutar sobre la base LoveMakeup existente (la que contiene producto,
-- categoria y marca). Compatible con MariaDB 10.4+; no altera esas tablas.
-- Los embeddings JSON evitan depender del tipo VECTOR, añadido en versiones
-- recientes de MariaDB.
CREATE TABLE IF NOT EXISTS angel_producto_ai (
    id_producto INT NOT NULL PRIMARY KEY,
    tipo_piel VARCHAR(100) NULL,
    ingredientes_activos VARCHAR(255) NULL,
    embedding LONGTEXT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_angel_producto_ai_producto
        FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Usuario de BD dedicado: solo lectura del catálogo y escritura de su tabla AI.
-- Ajusta la base y host al entorno antes de ejecutar:
-- CREATE USER 'angel'@'localhost' IDENTIFIED BY 'una-clave-segura';
-- GRANT SELECT ON lovemakeupbd1.producto TO 'angel'@'localhost';
-- GRANT SELECT ON lovemakeupbd1.categoria TO 'angel'@'localhost';
-- GRANT SELECT ON lovemakeupbd1.marca TO 'angel'@'localhost';
-- GRANT SELECT, INSERT, UPDATE ON lovemakeupbd1.angel_producto_ai
--     TO 'angel'@'localhost';
