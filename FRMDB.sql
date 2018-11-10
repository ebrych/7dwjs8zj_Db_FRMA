use master
create database FRMDB
use FRMDB
--===========================ESTRUCTURA
begin
--maestros
create table tb_tipo_documento(
id	int identity(1,1) not null,
descripcion	varchar(50) not null,
PRIMARY KEY(id)
)
create table tb_cargo(
id	int identity(1,1) not null,
descripcion	varchar(100) not null,
estado	tinyint default 1 not null,
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
create table tb_detalles(
id	int identity(1,1) not null,
descripcion	varchar(100) not null,
placeholder	varchar(200),
id_cargo int ,
PRIMARY KEY (id),
FOREIGN KEY (id_cargo) REFERENCES tb_cargo(id)
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
valor varchar(200),
FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
FOREIGN KEY (id_detalle) REFERENCES tb_detalles(id)
)
create table tb_grado(
id int not null identity(1,1),
descripcion varchar(20) not null,
sigla varchar(8) not null,
estado	tinyint default 1 not null,
PRIMARY KEY (id)
)
create table tb_seccion	(
id int not null identity(1,1),
descripcion varchar(20) not null,
estado	tinyint default 1 not null,
PRIMARY KEY (id)
)
create table tb_cursos(
id int not null identity(1,1),
descripcion varchar(50) not null,
estado	tinyint default 1 not null,
PRIMARY KEY (id)
)
create table tb_permiso_usuario(
id_usuario	bigint not null,
id_permiso	int not null,
FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
FOREIGN KEY (id_permiso) REFERENCES tb_permisos(id)
)	
create table tb_apoderado_alumno(
id_alumno bigint not null,
id_apoderado bigint not null,
FOREIGN KEY (id_alumno) REFERENCES tb_usuario(id),
FOREIGN KEY (id_apoderado) REFERENCES tb_usuario(id),
)

--plantillas
create table tb_pantilla_cargo_permiso(
id_cargo	int not null,
id_permiso	int not null,
FOREIGN KEY (id_cargo) REFERENCES tb_cargo (id),
FOREIGN KEY (id_permiso) REFERENCES tb_permisos(id)
)
create table tb_malla_curricular(
id_curso int not null,
id_grado int not null,
FOREIGN KEY (id_curso) REFERENCES tb_cursos(id),
FOREIGN KEY (id_grado) REFERENCES tb_grado(id)
)
--curricula
create table tb_cliclo_academico(
id	int IDENTITY(1,1) not null,
nombre varchar(50) not null,
fecha_ini date not null,
fech_fin date not null,
fech_reg dateTime default sysdatetime() not null,
estado  tinyint default 1 not null, 
PRIMARY KEY (id)
)
create table tb_grupos(
id	bigint not null IDENTITY(1,1),
descripcion	varchar(50),
id_profesor	bigint,
fech_reg dateTime default sysdatetime() not null,
PRIMARY KEY (id),
FOREIGN KEY (id_profesor) REFERENCES tb_usuario (id)
)
create table tb_especificaciones(
id	bigint not null identity(1,1),
descripcion	varchar(50) not null,
id_profesor	bigint not null,
id_grupo	bigint not null,
PRIMARY KEY (id),
FOREIGN KEY (id_profesor) REFERENCES tb_usuario(id),
FOREIGN KEY (id_grupo) REFERENCES tb_grupos(id)
)
create table tb_especificacion_curso(
id_curso	int not null,
id_espec	bigint not null
FOREIGN KEY (id_curso) REFERENCES tb_cursos(id),
FOREIGN KEY (id_espec) REFERENCES tb_especificaciones(id)
)
create table tb_curso_profesor(
idCurso	bigint not null,
idProfesor	int not null
)
--matricula
create table tb_matricula(
id	bigint not null,
id_alumno	bigint not null,
id_grado	int not null,
id_seccion	int not null,
id_ciclo_acdemico int not null,
fech_reg	dateTime DEFAULT SYSDATETIME() not null,
PRIMARY KEY (id),
FOREIGN KEY (id_alumno) REFERENCES tb_usuario(id),
FOREIGN KEY (id_grado) REFERENCES tb_grado(id),
FOREIGN KEY (id_seccion) REFERENCES tb_seccion(id),
FOREIGN KEY (id_ciclo_acdemico) REFERENCES tb_cliclo_academico(id)
)
create table tb_matricula_cursos(
id	bigint not null,
id_matricula bigint not null,
id_curso	int not null,
nota_final	decimal(4,2),
fech_reg dateTime DEFAULT SYSDATETIME(),
PRIMARY KEY (id),
FOREIGN KEY (id_matricula) REFERENCES tb_matricula(id),
FOREIGN KEY (id_curso) REFERENCES tb_cursos(id)
)
create table tb_detalle_matricula_curso(
id_mat_cur	bigint not null,
nota	decimal not null default 0.00,
porcentaje	int not null default 0,
id_espec	bigint not null,
FOREIGN KEY (id_mat_cur) REFERENCES tb_matricula_cursos(id),
FOREIGN KEY (id_espec) REFERENCES tb_especificaciones(id)
)
end

--===========================DATOS MAESTROS
begin

INSERT INTO tb_tipo_documento (descripcion) VALUES ('DNI')
INSERT INTO tb_tipo_documento (descripcion) VALUES ('Pasaporte')
INSERT INTO tb_tipo_documento (descripcion) VALUES ('Carnet de extrangeria')
SELECT * FROM tb_tipo_documento

INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Personal','Registro de personal','ccc','Registro-personal')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Inscripciones','Registro de alumnos','ccc','Registro-alumnos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Inscripciones','Registro de alumnos','ccc','Registro-alumnos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Permisos','Gestión de permisos del sistema','ccc','Permisos')--asigna permisos/usuario
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cargos','Gestión de cargos','ccc','Cargos') --aqui se asigna plantilla permiso/cargo (cuando se ingrese el usuario se toma e inserta todos los permisos...despues puede añadir o quitar desde usuario_permiso)
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Permisos','Gestión de permisos del sistema','ccc','Permisos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Malla Curricular','Gestión de mallas curriculares','ccc','Malla-curricular')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Matriculas','Gestión de matriculas','ccc','Matriculas')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grados','Gestión de grados y niveles','ccc','Niveles')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Secciones','Gestión de secciones','ccc','Secciones')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cursos','Gestión de cursos','ccc','Cursos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Especificaciones','Gestión de especificaciones de calificacion','ccc','Especificaciones')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grupos','Agrupación de Especificaciones','ccc','Grupos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Asignacion de cursos','Gestión de cursos a docentes','ccc','Asigna-Curso')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Academico','Gestión de datos academicos','ccc','Academico') --ingreso de notas a tabla detalle_matricula_curso
SELECT * FROM tb_permisos

INSERT INTO tb_cargo (descripcion) VALUES ('Ninguno')
INSERT INTO tb_cargo (descripcion) VALUES ('Root')
SELECT * FROM tb_cargo

INSERT INTO tb_usuario (nombre,apellidos,tipo_doc,num_doc,id_cargo,usuario,pass) VALUES ('Eber David','Baldarrago',1,'43744482',2,'Root','123')

INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (1,1)
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (2,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (3,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (4,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (5,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (6,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (7,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (8,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (9,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (10,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (11,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (12,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (13,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (14,1)	
INSERT INTO tb_permiso_usuario (id_permiso,id_usuario) VALUES (15,1)

		
--===========================DATOS DEMO
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Inicial','INI')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Primero de primaria','1º PRIM')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Segundo de primaria','2º PRIM')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Tercero de primaria','3º PRIM')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Cuarto de primaria','4º PRIM')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Quinto de primaria','5º PRIM')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Sexto de primaria','6º PRIM')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Primero de secundaria','1º SEC')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Segundo de secundaria','2º SEC')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Tercero de secundaria','3º SEC')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Cuarto de secundaria','4º SEC')
INSERT INTO tb_grado (descripcion,sigla) VALUES ('Quinto de secundaria','5º SEC')
SELECT * FROM tb_grado

INSERT INTO  tb_seccion	(descripcion) VALUES ('A')
INSERT INTO  tb_seccion	(descripcion) VALUES ('B')
INSERT INTO  tb_seccion	(descripcion) VALUES ('C')
SELECT * FROM tb_seccion

INSERT INTO tb_cursos (descripcion) VALUES ('Matemática')
INSERT INTO tb_cursos (descripcion) VALUES ('Comunicación')
INSERT INTO tb_cursos (descripcion) VALUES ('Quimica')
INSERT INTO tb_cursos (descripcion) VALUES ('Fisica')
INSERT INTO tb_cursos (descripcion) VALUES ('Biología')
INSERT INTO tb_cursos (descripcion) VALUES ('Trigonometría')
INSERT INTO tb_cursos (descripcion) VALUES ('Personal Social')
SELECT * FROM tb_cursos
end
end

--===========================PROCEDIMIENTOS

--sesiones
create procedure SP_LOGIN
(
@user varchar(20),
@pass varchar(20)
)
as
DECLARE
@token varchar(10)
SET @token= SUBSTRING(CONVERT(varchar(255), NEWID()),3, 10)
UPDATE tb_usuario set token=@token WHERE usuario=@user AND pass=@pass
SELECT TOP(1) us.id,us.nombre,us.apellidos,@token FROM tb_usuario us WHERE us.usuario=@user AND us.pass=@pass
go

create procedure SP_LOGOUT
(
@id bigint
)
as
UPDATE tb_usuario set token=null WHERE id=@id

go

create procedure SP_MIS_PERMISOS
(
@id bigint
)
as
SELECT 
pr.titulo,pr.descripcion,pr.icono,pr.controlador 
FROM tb_permiso_usuario prUs INNER JOIN tb_permisos pr on prUs.id_permiso=pr.id WHERE prUs.id_usuario=@id
go

create procedure SP_CONTROL_PERMISOS(
@id bigint,
@permiso int
)
as
SELECT count(*) FROM tb_permiso_usuario WHERE id_usuario=@id AND id_permiso=@permiso
go

create procedure SP_CONTROL_TOKENS(
@id bigint,
@token varchar(10)
)
as
SELECT count(*) FROM tb_usuario WHERE token=@token AND id=@token
go

--tipoDocumento
create procedure SP_LISTAR_TIPO_DOC(
@usuario bigint
)
as
SELECT id,descripcion FROM tb_tipo_documento 
go

--cargos
create procedure SP_LISTAR_CARGOS(
@usuario bigint
)
as 
SELECT cr.id,cr.descripcion,cr.estado,
case
	when cr.estado=0 then 'Inactivo'
	when cr.estado=1 then 'Activo'
end as 'estadoDesc'   
FROM tb_cargo cr WHERE id != 2
go
create procedure SP_AGREGAR_CARGO(
@usuario bigint,
@descripcion varchar(100)
)
as
INSERT INTO tb_cargo (descripcion) VALUES (@descripcion)
go
create procedure SP_ACTUALIZA_CARGO(
@usuario bigint,
@id int,
@descripcion varchar(100)
)
as
UPDATE tb_cargo SET descripcion=@descripcion WHERE id=@id
go
create procedure SP_ELIMINA_CARGO(
@usuario bigint,
@id int
)
as
UPDATE tb_cargo SET estado=0 WHERE id=@id
go


--cursos
create procedure SP_LISTAR_CURSOS(
@usuario bigint
)
as
SELECT cr.id,cr.descripcion,cr.estado,
case
	when cr.estado=0 then 'Inactivo'
	when cr.estado=1 then 'Activo'
end as 'estadoDesc'
FROM tb_cursos cr  
go
create procedure SP_AGREGAR_CURSO(
@usuario bigint,
@descripcion varchar(50)
)
as
INSERT INTO tb_cursos (descripcion) VALUES (@descripcion)
go
create procedure SP_ACTUALIZA_CURSO(
@usuario bigint,
@id int,
@descripcion varchar(50)
)
as
UPDATE tb_cursos SET descripcion=@descripcion WHERE id=@id
go
create procedure SP_ELIMINA_CURSO(
@usuario bigint,
@id int
)
as
UPDATE tb_cursos SET estado=0 WHERE id=@id
go

--secciones
create procedure SP_LISTAR_SECCIONES(
@usuario bigint
)
as
SELECT 
sc.id,sc.descripcion,sc.estado,
case
	when sc.estado=0 then 'Inactivo'
	when sc.estado=1 then 'Activo'
end as 'estadoDesc' 
FROM tb_seccion sc
go
create procedure SP_AGREGAR_SECCION(
@usuario bigint,
@descriprion varchar(20)
)
as
INSERT INTO tb_seccion (descripcion) VALUES (@descriprion)
go
create procedure SP_ACTUALIZA_SECCION(
@usuario bigint,
@id int,
@descriprion varchar(20)
)
as
UPDATE tb_seccion SET descripcion=@descriprion WHERE id=@id
go
create procedure SP_ELIMINA_SECCION(
@usuario bigint,
@id int
)
as
UPDATE tb_seccion SET descripcion=0 WHERE id=@id
go

--grados
create procedure SP_LISTAR_GRADOS(
@usuario bigint
)
as
SELECT gr.id,gr.descripcion,gr.estado,
case
	when gr.estado=0 then 'Inactivo'
	when gr.estado=1 then 'Activo'
end as 'estadoDesc' 
FROM tb_grado gr
go
create procedure SP_AGREGAR_GRADO(
@usuario bigint,
@descriprion varchar(20),
@sigla varchar(8)
)
as
INSERT INTO tb_grado (descripcion,sigla) VALUES (@descriprion,@sigla)
go
create procedure SP_ACTUALIZA_GRADO(
@usuario bigint,
@id int 
)
as
UPDATE tb_grado SET descripcion=0 WHERE id=@id
go
