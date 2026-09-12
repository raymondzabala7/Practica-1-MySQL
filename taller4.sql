-- ============================================================
-- TALLER PRACTICO: Claves, Restricciones y Modelo E-R
-- Caso: tienda de ropa (productos, categorias, clientes, ventas)
-- ============================================================


-- ============================================================
-- RETO 1 - Identificar entidades y atributos
-- ============================================================
--
-- Categoria   -> id, nombre, descripcion
-- Producto    -> id, nombre, precio, existencia, categoria_id
-- Cliente     -> id, nombre, correo
-- Venta       -> id, fecha, cliente_id
--
-- (Producto y Venta se relacionan N:M: una venta puede incluir
--  varios productos, y un producto puede estar en varias ventas.
--  Esa relacion N:M se resuelve en el RETO 2 con una tabla
--  intermedia: detalle_venta)


-- ============================================================
-- RETO 2 - Definir claves primarias y foraneas
-- ============================================================
--
-- Categoria:      PK = id
-- Producto:       PK = id | FK = categoria_id -> Categoria(id)
-- Cliente:        PK = id
-- Venta:          PK = id | FK = cliente_id -> Cliente(id)
-- detalle_venta:  PK = (venta_id, producto_id) [clave compuesta]
--                 FK = venta_id -> Venta(id)
--                 FK = producto_id -> Producto(id)
--                 (esta tabla resuelve la relacion N:M entre
--                  Producto y Venta)

CREATE DATABASE IF NOT EXISTS tienda_ropa;
USE tienda_ropa;

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150)
);

CREATE TABLE producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    existencia INT NOT NULL DEFAULT 0 CHECK (existencia >= 0),
    categoria_id INT NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT (CURRENT_DATE),
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

-- Tabla intermedia que resuelve la relacion N:M Producto <-> Venta
CREATE TABLE detalle_venta (
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (venta_id, producto_id),
    FOREIGN KEY (venta_id) REFERENCES venta(id),
    FOREIGN KEY (producto_id) REFERENCES producto(id)
);


-- ============================================================
-- RETO 3 - CREATE TABLE con una restriccion (CHECK / NOT NULL)
-- ============================================================
--
-- Ya aplicado arriba en la tabla producto:
--   - nombre VARCHAR(100) NOT NULL          -> el nombre es obligatorio
--   - precio DECIMAL(10,2) CHECK (precio >= 0) -> el precio no puede ser negativo
--
-- Version aislada, tal como la pide el reto (una sola entidad):

CREATE TABLE producto_reto3 (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) CHECK (precio >= 0)
);
