-- ============================================================
-- TALLER PRACTICO INTEGRADOR - Base de datos de una tienda
-- ============================================================

CREATE DATABASE IF NOT EXISTS tienda_taller2;
USE tienda_taller2;


-- ============================================================
-- 1. Crear la tabla Producto (id, nombre, precio, categoria)
--    y la tabla Venta (id, id_producto, cantidad, fecha)
-- ============================================================

CREATE TABLE Producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50) NOT NULL
);

-- ============================================================
-- 2. Relacionar Venta con Producto mediante una llave foranea
--    (id_producto -> Producto.id)
-- ============================================================

CREATE TABLE Venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES Producto(id)
);

-- Datos de prueba para poder ejecutar el resto de los ejercicios

INSERT INTO Producto (nombre, precio, categoria) VALUES
('licuadora basica', 85000.00, 'Electrodomesticos'),
('television 50 pulgadas', 1800000.00, 'Tecnologia'),
('parlante bluetooth', 120000.00, 'Tecnologia'),
('microondas', 320000.00, 'Electrodomesticos'),
('mouse inalambrico', 45000.00, 'Perifericos'),
('portatil gamer', 4200000.00, 'Tecnologia'),
('ventilador de pie', 150000.00, 'Electrodomesticos'),
('audifonos in-ear', 60000.00, 'Perifericos');

INSERT INTO Venta (id_producto, cantidad, fecha) VALUES
(1, 2, '2026-07-01'),
(2, 1, '2026-07-05'),
(3, 3, '2026-07-10'),
(4, 1, '2026-07-15'),
(5, 5, '2026-08-01'),
(6, 1, '2026-08-05'),
(2, 1, '2026-08-10'),
(7, 2, '2026-08-15'),
(8, 4, '2026-08-20'),
(1, 1, '2026-09-01');


-- ============================================================
-- 3. Crear la tabla productos_caros usando CREATE TABLE AS SELECT,
--    con los productos de precio mayor a 100000
-- ============================================================

CREATE TABLE productos_caros AS
SELECT id, nombre, precio, categoria
FROM Producto
WHERE precio > 100000;


-- ============================================================
-- 4. Revisar la estructura de productos_caros usando DESCRIBE
-- ============================================================

DESCRIBE productos_caros;


-- ============================================================
-- 5. Consulta que use alias de tabla para combinar
--    Producto y Venta
-- ============================================================

SELECT p.nombre, p.categoria, v.cantidad, v.fecha
FROM Producto p
JOIN Venta v ON p.id = v.id_producto;


-- ============================================================
-- 6. Usar al menos 3 funciones sobre campos
--    (UPPER, ROUND, CONCAT) en una consulta
-- ============================================================

SELECT
    UPPER(nombre) AS nombre_mayusculas,
    ROUND(precio, 0) AS precio_redondeado,
    CONCAT(nombre, ' - ', categoria) AS producto_categoria
FROM Producto;


-- ============================================================
-- 7. Usar IF para clasificar los productos como 'Premium'
--    o 'Estandar' segun su precio
-- ============================================================

SELECT
    nombre,
    precio,
    IF(precio > 300000, 'Premium', 'Estandar') AS clasificacion
FROM Producto;


-- ============================================================
-- 8. Consulta final que combine alias, JOIN, alguna funcion
--    e IF al mismo tiempo
-- ============================================================

SELECT
    p.nombre AS producto,
    UPPER(p.categoria) AS categoria,
    v.cantidad,
    ROUND(p.precio * v.cantidad, 0) AS total_venta,
    IF(p.precio > 300000, 'Premium', 'Estandar') AS clasificacion
FROM Producto p
JOIN Venta v ON p.id = v.id_producto
ORDER BY total_venta DESC;
