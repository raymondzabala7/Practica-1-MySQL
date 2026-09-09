-- ============================================================
-- TALLER PRACTICO DE SQL - TechStore
-- DDL, DML, DQL, operadores, agregacion y agrupacion
-- ============================================================


-- ============================================================
-- EJ. 01 - Construir la base
-- Consigna: crear la base de datos y las 3 tablas relacionadas.
-- ============================================================

CREATE DATABASE IF NOT EXISTS techstore;
USE techstore;

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    ciudad VARCHAR(50) NOT NULL
);

-- ventas referencia tanto a clientes como a productos (relacion N:1 con cada una)
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


-- ============================================================
-- EJ. 02 - Modificar una estructura
-- Consigna: agregar telefono a clientes y ampliar el tamaño
-- permitido para nombres de producto.
-- ============================================================

-- Agregar columna nueva (no existía en clientes)
ALTER TABLE clientes ADD COLUMN telefono VARCHAR(20);

-- Cambiar la definicion de una columna existente (no crear una nueva)
ALTER TABLE productos MODIFY COLUMN nombre VARCHAR(150) NOT NULL;


-- ============================================================
-- EJ. 03 - Cargar productos y clientes
-- Consigna: al menos 8 productos y 6 clientes, repitiendo
-- categorias, ciudades y rangos de precio.
-- ============================================================

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Mouse inalambrico', 'Perifericos', 45000.00, 30),
('Teclado mecanico', 'Perifericos', 180000.00, 15),
('Monitor 24 pulgadas', 'Monitores', 650000.00, 10),
('Monitor 27 pulgadas curvo', 'Monitores', 950000.00, 8),
('Portatil i5 8GB', 'Computadores', 2800000.00, 5),
('Portatil i7 16GB', 'Computadores', 4200000.00, 4),
('Disco SSD 1TB', 'Almacenamiento', 320000.00, 20),
('Memoria RAM 16GB', 'Componentes', 210000.00, 25),
('Audifonos bluetooth', 'Audio', 95000.00, 18),
('Mouse pad grande', 'Accesorios', 25000.00, 40);

INSERT INTO clientes (nombre, email, ciudad, telefono) VALUES
('Ana Torres', 'ana.torres@mail.com', 'Bogota', '3001234567'),
('Carlos Ruiz', 'carlos.ruiz@mail.com', 'Cucuta', '3007654321'),
('Laura Gomez', 'laura.gomez@mail.com', 'Bogota', '3009876543'),
('Diego Perez', 'diego.perez@mail.com', 'Medellin', '3005551234'),
('Marta Silva', 'marta.silva@mail.com', 'Cali', '3002223344'),
('Juan Vargas', 'juan.vargas@mail.com', 'Bucaramanga', '3004445566'),
('Sofia Leon', 'sofia.leon@mail.com', 'Cucuta', '3006667788');


-- ============================================================
-- EJ. 04 - Registrar ventas con sentido
-- Consigna: al menos 12 ventas usando ids ya existentes,
-- con clientes y productos repetidos, cantidades y fechas
-- distintas.
-- ============================================================

INSERT INTO ventas (id_cliente, id_producto, cantidad, fecha_venta) VALUES
(1, 1, 2, '2026-07-01'),
(1, 3, 1, '2026-07-15'),
(2, 2, 1, '2026-07-03'),
(2, 7, 3, '2026-08-10'),
(3, 5, 1, '2026-07-20'),
(3, 9, 2, '2026-08-05'),
(4, 6, 1, '2026-08-01'),
(4, 4, 1, '2026-08-22'),
(5, 8, 4, '2026-07-11'),
(5, 1, 1, '2026-08-30'),
(6, 10, 5, '2026-07-28'),
(7, 2, 2, '2026-08-14'),
(1, 7, 1, '2026-09-01'),
(3, 3, 1, '2026-09-02');


-- ============================================================
-- EJ. 05 - Corregir y eliminar con seguridad
-- Consigna: corregir el precio de un producto concreto,
-- ajustar el stock de otro tras una venta, y eliminar un
-- registro creado por error.
-- Buena practica: primero se verifica el filtro con SELECT,
-- despues se ejecuta el UPDATE/DELETE.
-- ============================================================

-- 1) Verificar antes de corregir el precio del Mouse inalambrico
SELECT id_producto, nombre, precio FROM productos WHERE nombre = 'Mouse inalambrico';
UPDATE productos SET precio = 48000.00 WHERE nombre = 'Mouse inalambrico';

-- 2) Verificar antes de ajustar el stock del Disco SSD (se vendieron 3 unidades)
SELECT id_producto, nombre, stock FROM productos WHERE id_producto = 7;
UPDATE productos SET stock = stock - 3 WHERE id_producto = 7;

-- 3) Eliminar un registro creado por error (ejemplo: un producto de prueba)
--    Se verifica primero que el filtro afecte solo esa fila antes de borrar.
SELECT * FROM productos WHERE nombre = 'Mouse pad grande';
DELETE FROM productos WHERE nombre = 'Mouse pad grande';


-- ============================================================
-- EJ. 06 - Primera exploracion
-- Consigna: ver todos los productos; mostrar solo nombre y
-- precio; presentar el precio con un nombre de columna mas
-- comprensible.
-- ============================================================

SELECT * FROM productos;

SELECT nombre, precio FROM productos;

SELECT nombre, precio AS precio_unitario FROM productos;


-- ============================================================
-- EJ. 07 - Filtrar por una condicion
-- Consigna: productos con precio superior a un umbral,
-- clientes de una ciudad concreta, productos de una categoria.
-- ============================================================

SELECT nombre, precio FROM productos WHERE precio > 500000;

SELECT nombre, ciudad FROM clientes WHERE ciudad = 'Bogota';

SELECT nombre, categoria FROM productos WHERE categoria = 'Perifericos';


-- ============================================================
-- EJ. 08 - Combinar condiciones
-- Consigna: productos de una categoria y por debajo de cierto
-- precio (ambas condiciones a la vez); clientes de dos
-- ciudades posibles (basta con que se cumpla una).
-- ============================================================

SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'Componentes' AND precio < 250000;

SELECT nombre, ciudad
FROM clientes
WHERE ciudad = 'Bogota' OR ciudad = 'Cucuta';


-- ============================================================
-- EJ. 09 - Buscar por rangos y texto
-- Consigna: productos dentro de un rango de precios;
-- productos de un conjunto de categorias; productos cuyo
-- nombre contenga una palabra indicada.
-- ============================================================

SELECT nombre, precio
FROM productos
WHERE precio BETWEEN 100000 AND 1000000;

SELECT nombre, categoria
FROM productos
WHERE categoria IN ('Monitores', 'Computadores');

SELECT nombre
FROM productos
WHERE nombre LIKE '%Portatil%';


-- ============================================================
-- EJ. 10 - Ordenar resultados
-- Consigna: productos del mas barato al mas caro, y del
-- mayor stock al menor. Combina un filtro con un ordenamiento.
-- ============================================================

SELECT nombre, precio
FROM productos
ORDER BY precio ASC;

SELECT nombre, stock
FROM productos
ORDER BY stock DESC;

-- Filtro + ordenamiento combinados
SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'Computadores'
ORDER BY precio ASC;
