drop table if exists detalle_venta;
drop table if exists cabecera_venta;
drop table if exists historial_stock;	   
drop table if exists detalle_pedido;
drop table if exists cabecera_pedido;
drop table if exists estado_pedido;
drop table if exists proveedores;
drop table if exists tipo_documento;
drop table if exists productos;
drop table if exists unidad_medida;
drop table if exists categoria_unidad_medida;
drop table if exists categorias;

create table categorias(
	codigo_cat serial not null,
	nombre varchar(100) not null,
	categoria_padre int,
	constraint categorias_pk primary key (codigo_cat),
	constraint categorias_fk foreign key (categoria_padre) references categorias(codigo_cat)
);

insert into categorias(nombre, categoria_padre)
values ('Materia Prima', null),
	   ('Proteína', 1),
	   ('Salsas', 1),
	   ('Punto de Venta', null),
	   ('Bebidas', 4),
	   ('Con alcohol', 5),
	   ('Sin Alcohol', 5);
	   
create table categoria_unidad_medida(
	codigo_udm char(1) not null,
	nombre varchar(100) not null,
	constraint categoria_udm_pk primary key (codigo_udm)
);

insert into categoria_unidad_medida(codigo_udm, nombre)
values ('U', 'Unidad'),
       ('V', 'Volumnen'),
	   ('P', 'Peso');

create table unidad_medida(
	codigo_udm serial not null,
	nombre varchar(3) not null,
	descripcion varchar(1000) not null,
	categoria_udm char(1) not null,
	constraint unidad_medida_pk primary key (codigo_udm),
	constraint unidad_medida_cat_fk foreign key (categoria_udm) references categoria_unidad_medida(codigo_udm)
);

insert into unidad_medida(nombre, descripcion, categoria_udm)
values ('ml', 'milimetros', 'V'),
	   ('l', 'litros', 'V'),
	   ('u', 'unidad', 'U'),
	   ('d', 'decena', 'U'),
	   ('g', 'gramos', 'P'),
	   ('kg', 'kilogramos', 'P'),
	   ('lb', 'libras', 'P');
	   
create table productos(
	codigo_prod serial not null,
	nombre varchar(100) not null,
	udm_cod int not null,
	precio_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	categoria_cod int not null,
	stock int not null,
	constraint productos_pk primary key (codigo_prod),
	constraint productos_udm_fk foreign key (udm_cod) references unidad_medida(codigo_udm),
	constraint productos_cat_fk foreign key (categoria_cod) references categorias(codigo_cat)
);

insert into productos(nombre, udm_cod, precio_venta, tiene_iva, coste, categoria_cod, stock)
values ('Coca Cola pequeña', 3, 0.5804, 'true', 0.3729, 7, 105),
	   ('Salsa Tomate', 6, 0.95, 'true', 0.8736, 3, 0),
	   ('Mostaza', 6, 0.95, 'true', 0.89, 3, 0),
	   ('Fuze Tea', 3, 0.80, 'true', 0.70, 7, 49);
	   
create table tipo_documento(
	codigo_tp char(1) not null,
	descripcion varchar(10) not null,
	constraint tipo_documento_pk primary key (codigo_tp)
);

insert into tipo_documento(codigo_tp, descripcion)
values ('C', 'CEDULA'),
	   ('R', 'RUC');
	   
create table proveedores(
	identificador varchar(13) not null,
	tipo_documento_cod char(1) not null,
	nombre varchar(50) not null,
	telefono char(10) not null,
	correo varchar(50) not null,
	direccion varchar(100) not null,
	constraint proveedores_pk primary key (identificador),
	constraint proveedores_td_fk foreign key (tipo_documento_cod) references tipo_documento(codigo_tp)
);

insert into proveedores(identificador, tipo_documento_cod, nombre, telefono, correo, direccion)
values ('1792285747', 'C', 'SANTIAGO MOSQUERA', '0992920306', 'zantycb89@gmail.com', 'Cumbayork'),
	   ('1792285747001', 'R', 'SNACKS SA', '0992920398', 'snacks@gmail.com', 'La Tola');

create table estado_pedido(
	codigo_ep char(1) not null,
	descripcion varchar(15) not null,
	constraint estado_pedido_pk primary key (codigo_ep)
);

insert into estado_pedido(codigo_ep, descripcion)
values ('S', 'SOLICITADO'),
	   ('R', 'RECIBIDO');

create table cabecera_pedido(
	codigo_cp serial not null,
	proveedor_cod varchar(13) not null,
	fecha date not null,
	estado_cod char(1) not null,
	constraint cabecera_pedido_pk primary key (codigo_cp),
	constraint cabecera_pedido_pr_fk foreign key (proveedor_cod) references proveedores(identificador),
	constraint cabecera_pedido_ep_fk foreign key (estado_cod) references estado_pedido(codigo_ep)
);

insert into cabecera_pedido(proveedor_cod, fecha, estado_cod)
values ('1792285747', '20-11-2023', 'R'),
	   ('1792285747', '20-11-2023', 'R');

create table detalle_pedido(
	codigo_dp serial not null,
	cabecera_pedido_cod int not null,
	producto_cod int not null,
	cantidad_solicitada int not null,
	subtotal money not null,
	cantidad_recibida int not null,
	constraint detalle_pedido_pk primary key (codigo_dp),
	constraint detalle_pedido_cab_fk foreign key (cabecera_pedido_cod) references cabecera_pedido(codigo_cp),
	constraint detalle_pedido_prod_fk foreign key (producto_cod) references productos(codigo_prod)
);

insert into detalle_pedido(cabecera_pedido_cod, producto_cod, cantidad_solicitada, subtotal, cantidad_recibida)
values (1, 1, 100, 37.29, 100),
	   (1, 4, 50, 11.80, 50),
	   (2, 1, 10, 3.73, 10);

create table cabecera_venta(
	codigo_cv serial not null,
	fecha timestamp without time zone not null,
	total_sin_iva money not null,
	iva money not null,
	total money not null,
	constraint cabecera_venta_pk primary key (codigo_cv)
);

insert into cabecera_venta(fecha, total_sin_iva, iva, total)
values ('20-11-2023 20:00', 3.26, 0.39, 3.65);

create table detalle_venta(
	codigo_dv serial not null,
	cabecera_venta_cod int not null,
	producto_cod int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	subtotal_iva money not null,
	constraint detalle_venta_pk primary key (codigo_dv),
	constraint detalle_venta_cab_fk foreign key (cabecera_venta_cod) references cabecera_venta(codigo_cv),
	constraint detalle_venta_prod_fk foreign key (producto_cod) references productos(codigo_prod)
);

insert into detalle_venta(cabecera_venta_cod, producto_cod, cantidad, precio_venta, subtotal, subtotal_iva)
values (1, 1, 5, 0.58, 2.90, 3.25),
	   (1, 4, 1, 0.36, 0.36, 0.40);
	   
create table historial_stock(
	codigo_his serial not null,
	fecha timestamp without time zone not null,
	referencia varchar(20) not null,
	producto_cod int not null,
	cantidad int not null,
	constraint historial_stock_pk primary key (codigo_his),
	constraint historial_stock_prod_fk foreign key (producto_cod) references productos(codigo_prod)
);

insert into historial_stock(fecha, referencia, producto_cod, cantidad)
values ('20-11-2023 19:59', 'PEDIDO 1', 1, 100),
	   ('20-11-2023 19:59', 'PEDIDO 1', 4, 50),
	   ('20-11-2023 20:00', 'PEDIDO 2', 1, 10),
	   ('20-11-2023 20:00', 'VENTA 1', 1, -5),
	   ('20-11-2023 20:00', 'VENTA 1', 4, -1);

select * from cabecera_pedido;
select * from cabecera_venta;
select * from categoria_unidad_medida;
select * from categorias;
select * from detalle_pedido;
select * from detalle_venta;
select * from estado_pedido;
select * from historial_stock;
select * from productos;
select * from proveedores;
select * from tipo_documento;
select * from unidad_medida;
