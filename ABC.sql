-- Base de datos de Sistema de registro de entrada y salida de electrodomésticos “ABC”
-- Autor: grupo las chicas super poderosas
-- 21/02/2025

-- Desconectar usuarios y cambiar a master
use master;
go

-- Terminar conexiones activas y eliminar la base de datos si existe
if exists (select * from sys.databases where name = 'RegistroElectroDomesticos')
begin
    alter database RegistroElectroDomesticos set single_user with rollback immediate;
    drop database RegistroElectroDomesticos
end
go

-- Crear la base de datos
create database RegistroElectroDomesticos
go

use RegistroElectroDomesticos
go

-- Crear tabla de electrodomésticos
create table Electrodomestico (
    idElectrodomestico int primary key identity(1,1),
    nombre nvarchar(50) not null,
    descripcion nvarchar(50),
    marca nvarchar(50),
    preciocompra decimal(10,2) not null,
    precioventa decimal(10,2) not null,
)

-- Crear tabla de proveedores
create table proveedor 
(
    idProveedor int primary key identity(1,1),
    nombre nvarchar(50) not null,
    direccion nvarchar(50),
    telefono nvarchar(9),
)

-- Crear tabla de orden de compra
create table ordencompra 
(
    idOrdencompra int primary key identity(1,1),
    fecha date not null,
    hora time not null,
    montototal decimal(10,2) not null,
    idProveedor int not null,
    foreign key (idProveedor) references proveedor(idProveedor),
)

-- Crear tabla de detalle de entrada/salida
create table detalleentradasalida 
(
    idDetalle int primary key identity(1,1),
    idOrdencompra int not null,
    idElectrodomestico int not null,
    cantidad int not null,
    preciounitario decimal(10,2) not null,
    subtotal decimal(10,2) not null,
    tipomovimiento nvarchar(10) check (tipomovimiento in ('entrada', 'salida')),
    foreign key (idOrdencompra) references ordencompra(idOrdencompra),
    foreign key (idElectrodomestico) references electrodomestico(idElectrodomestico),
)

-- Crear tabla de clientes
create table cliente 
(
    idCliente int primary key identity(1,1),
    nombre nvarchar(50) not null,
    direccion nvarchar(50),
    telefono nvarchar(9),
)

-- Crear tabla de comprobantes
create table comprobante 
(
    idComprobante int primary key identity(1,1),
    fecha date not null,
    montototal decimal(10,2) not null,
    idCliente int not null,
    idDetalle int not null,
    foreign key (idCliente) references cliente(idCliente),
    foreign key (idDetalle) references detalleentradasalida(idDetalle),
)