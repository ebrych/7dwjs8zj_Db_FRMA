use master
create database FRMDB

--===========================ESTRUCTURA
--maestros
create table tb_tipo_documento(
id	int identity(1,1) not null,
descripcion	varchar(50) not null,
PRIMARY KEY(id)
)
create table tb_cargo(
id	int identity(1,1) not null,
descripcion	varchar(100) not null
PRIMARY KEY (id)
)
create table tb_detalles(
id	int identity(1,1) not null,
descripcion	varchar(50) not null,
PRIMARY KEY (id)
)
create table tb_permisos(
id	int identity(1,1) not null, 
titulo	varchar(20) not null,
descripcion	varchar(100) not null,
icono	varchar(50) not null,
controlador	varchar(50) not null,
PRIMARY KEY(id)
)
create table tb_usuario(
id	bigint identity(1,1) not null,
nombre	varchar(100) not null,
apellidos	varchar(200)not null,
tipo_doc	int not null,
num_doc	varchar(25) not null,
id_cargo	int not null,
usuario	varchar(20) not null,
pass	varchar(20) not null,
token	varchar(10) null,
fech_reg	dateTime default sysdatetime() not null,
PRIMARY KEY(id),
FOREIGN KEY (tipo_doc) REFERENCES tb_tipo_documento(id),
FOREIGN KEY (id_cargo) REFERENCES tb_cargo(id)
)
create table tb_usuario_detalle(
id_usuario	bigint not null,
id_detalle	int,
FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
FOREIGN KEY (id_detalle) REFERENCES tb_detalles(id)
)
--curricula
create table tb_cliclo_academico(
id	int IDENTITY(1,1) not null,
nombre varchar(50) not null,
fecha_ini date not null,
fech_fin date not null,
PRIMARY KEY (id)
)
