--use master
--drop DATABASE DBFORMA
create database DBFORMA
use DBFORMA

--=========================================ESTRUCTURA
begin
--a
create table tb_tipo_documento(
id	int identity(1,1) not null,
descripcion	varchar(50) not null
primary key (id)
)
create table tb_grados(
id	int identity(1,1) not null,
descripcion	varchar(100) not null,
sigla 	varchar(10) not null,
estado	tinyint default 1 not null,
primary key(id)
)
create table tb_secciones(
id	int identity (1,1) not null,
descripcion	varchar(50) not null,
estado	tinyint default  1 not null,
primary key(id)
)
create table tb_cursos(
id	int identity(1,1) not null,
descripcion	varchar(50) not null,
estado	tinyint default 1 not null
primary key(id)
)
create table tb_cliclo_academico(
id	int identity(1,1) not null,
nombre	varchar(50) not null,
fecha_ini	date not null,
fech_fin	date not null,
fech_reg	dateTime default SYSDATETIME(),
estado	tinyint default 1,
primary key(id)
)
create table tb_permisos(
id	int identity(1,1) not null,
titulo	varchar(20) not null,
descripcion	varchar(100) not null,
icono	varchar(50) not null,
controlador	varchar(50)not null,
primary key(id)
)
--b
create table tb_usuarios(
id	bigint identity(1,1) not null,
nombre	varchar(100) not null,
apellidos	varchar(100) not null,
usr	varchar(20) not null,
pas	varchar(10) not null,
tipo_doc	int not null,
num_doc	varchar(15) not null,
direccion	varchar(200) null,
email	varchar(100) null,
fecha_reg	dateTime default SYSDATETIME() not null,
estado tinyint default 1,
primary key(id),
foreign key(tipo_doc) references tb_tipo_documento(id)
)
create table tb_administrativos(
id_usuario	bigint not null,
fech_nac	date null,
puesto	varchar(100) null default 'SD',
telefono	varchar(12) null default 'SD',
foreign key(id_usuario) references tb_usuarios(id)
)
create table tb_docentes(
id_usuario	bigint not null,
fech_nac	date null,
telefono	varchar(12) null default 'SD',
foreign key (id_usuario) references tb_usuarios(id)
)
create table tb_alumnos(
id_usuario	bigint not null,
fech_nac	date null,
foreign key(id_usuario) references tb_usuarios(id)
)
create table tb_apoderado(
id_usuario	bigint not null,
trabajo	varchar(100) not null,
direccion	varchar(100) not null,
telefono	varchar(12) not null,
foreign key(id_usuario) references tb_usuarios(id)
)
create table tb_apoderado_alumno(
id_apoderado bigint,
id_alumno bigint,
foreign key (id_apoderado) references tb_usuarios(id),
foreign key (id_alumno) references tb_usuarios(id)
)
create table tb_permiso_usuario(
id_usuario	bigint,
id_permiso	int,
foreign key (id_usuario) references tb_usuarios(id),
foreign key (id_permiso) references tb_permisos(id)
)	
--c
create table tb_grupos(
id	bigint identity(1,1) not null,
descripcion	varchar(50) not null,
fech_reg	dateTime default SYSDATETIME() not null,
id_docente	bigint not null,
primary key(id),
foreign key (id_docente) references tb_usuarios(id)
)
create table tb_especificacion(
id	bigint identity(1,1) not null,
descripcion	varchar(50) not null,
id_docente	bigint not null,
id_grupo	bigint not null,
fech_reg	dateTime default SYSDATETIME() not null,
primary key(id),
foreign key (id_docente) references tb_usuarios(id),
foreign key (id_grupo) references tb_grupos(id) 
)
--d
create table tb_malla_curricular(
id_grado int not null,
id_curso int not null,
foreign key (id_grado) references tb_grados(id),
foreign key (id_curso) references tb_cursos(id)
)
create table tb_matricula(
id	bigint identity(1,1),
id_alumno	bigint not null,
id_grado	int not null,
id_seccion	int not null,
id_ciclo_acdemico	int not null,
fech_reg	dateTime default SYSDATETIME() not null,
primary key(id),
foreign key (id_alumno) references  tb_usuarios(id),
foreign key (id_grado) references  tb_grados(id),
foreign key (id_seccion) references  tb_secciones(id),
foreign key (id_ciclo_acdemico) references  tb_cliclo_academico(id)
)
create table tb_matricula_cursos(
id	bigint identity(1,1) not null,
id_matricula	bigint not null,
id_cursos	int not null,
nota_final	decimal null,
primary key (id),
foreign key (id_matricula) references tb_matricula(id),
foreign key (id_cursos) references tb_cursos(id),
)
create table tb_detalle_matricula_curso(
id_mat_cur	bigint not null,
nota	decimal not null,
porcentaje	int not null,
id_espec	bigint not null,
fech_reg	dateTime default SYSDATETIME() not null,
foreign key (id_mat_cur) references tb_matricula_cursos(id),
foreign key (id_espec) references tb_especificacion(id)
)
--e
create table tb_pantilla_cargo_rol(
id	int not null,
descripcion varchar(50) not null,
id_permiso	int not null
)
end
--=========================================DATA INIT
begin
	INSERT INTO tb_tipo_documento (descripcion) VALUES ('DNI')
	INSERT INTO tb_tipo_documento (descripcion) VALUES ('Pasaporte')
	INSERT INTO tb_tipo_documento (descripcion) VALUES ('Carnet de extrangeria')
	SELECT * FROM tb_tipo_documento

	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Administrativos','Gestión de administrativos','fas fa-users','Administrativo')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Inscripciones','Gestión de alumnos','fas fa-user-graduate','Alumno')
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Docentes','Gestión de docentes','fas fa-chalkboard-teacher','Docente')
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Apoderados','Gestión de apoderados','fab fa-black-tie','Apoderado')
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Permisos','Gestión de permisos del sistema','fas fa-lock','Permiso') --administra permisos de usuario
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cursos','Gestión de cursos','fas fa-book','Cursos')
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Malla Curricular','Gestión de mallas curriculares','fas fa-layer-group','MallaCurricular')
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grados','Gestión de grados y niveles','fas fa-ellipsis-v','Niveles')
	SELECT * FROM tb_permisos
	
	INSERT INTO tb_usuarios (nombre,apellidos,tipo_doc,num_doc,direccion,usr,pas) VALUES ('Eber David','Baldarrago',1,'43744482','Av. qwerty 123','root','123')
	SELECT * FROM tb_usuarios

	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (1,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (2,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (3,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (4,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (5,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (6,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (7,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (8,1)
	SELECT * FROM tb_permiso_usuario

end

	--data demo de asignacion
	INSERT INTO tb_pantilla_cargo_rol(id,descripcion,id_permiso) VALUES (1,'Administrativo',2)
	INSERT INTO tb_pantilla_cargo_rol(id,descripcion,id_permiso) VALUES (1,'Administrativo',3)


--=========================================PROCEDURES
create procedure SP_LOGIN(
@user varchar(20),
@pass varchar(10)
)
as
SELECT us.id,us.nombre,us.apellidos
FROM tb_usuarios us WHERE (us.usr=@user OR us.num_doc=@user) AND (us.pas=@pass) AND estado=1
go
drop procedure SP_LOGIN
exec SP_LOGIN 'root','123'
select * from tb_usuarios

create procedure SP_LISTA_PERMISOS_BY_USER(
@id bigint
)
as
SELECT pr.titulo,pr.descripcion,pr.icono,pr.controlador 
FROM tb_permiso_usuario prUs INNER JOIN tb_permisos pr ON pr.id=prUs.id_permiso 
WHERE prUs.id_usuario=@id
go

create procedure SP_LISTA_PERMISOS_BY_USER(
@id bigint
)
as
SELECT pr.titulo,pr.descripcion,pr.icono,pr.controlador FROM tb_permiso_usuario prU INNER JOIN tb_permisos pr ON pr.id=prU.id_permiso WHERE prU.id_usuario=@id
go
exec SP_LISTA_PERMISOS_BY_USER 1

create procedure SP_CONTROL_PERMISOS(
@id bigint,
@permiso int
)
as
SELECT count(*) FROM tb_permiso_usuario pr INNER JOIN tb_usuarios us ON us.id=pr.id_usuario  WHERE id_usuario=@id AND id_permiso=@permiso AND us.estado=1
go
exec SP_CONTROL_PERMISOS 1,1

create procedure SP_LISTAR_TIPO_DOCUMENTO
as
SELECT id,descripcion FROM tb_tipo_documento 
go
exec SP_LISTAR_TIPO_DOCUMENTO


--usuario
create procedure SP_AGREGA_USUARIO(
@nombre	varchar(100),
@apellidos	varchar(100),
@usr	varchar(20),
@tipo_doc	int,
@num_doc	varchar(15),
@direccion	varchar(200),
@email	varchar(100)
)
as
DECLARE
@fecha datetime = SYSDATETIME(),
@psw varchar(6) = SUBSTRING(CONVERT(varchar(255), NEWID()),1, 6)
INSERT INTO tb_usuarios (nombre,apellidos,usr,pas,tipo_doc,num_doc,direccion,email,fecha_reg)
VALUES (@nombre,@apellidos,@usr,@psw,@tipo_doc,@num_doc,@direccion,@email,@fecha)
SELECT id FROM tb_usuarios WHERE num_doc=@num_doc AND fecha_reg=@fecha
go
create procedure SP_ACTUALIZA_USUARIO(
@id bigint,
@nombre	varchar(100),
@apellidos	varchar(100),
@usr	varchar(20),
@pas varchar(20),
@tipo_doc	int,
@num_doc	varchar(15),
@direccion	varchar(200),
@email	varchar(100),
@estado tinyint
)
as
DECLARE
@mismoNombre int,
@nBusca varchar(20),
@coincidenciaUsrName int
SELECT @coincidenciaUsrName=count(*) FROM tb_usuarios
SELECT @nBusca=usr FROM tb_usuarios WHERE id=@id

if @nBusca=@usr AND @pas=''
	begin
	UPDATE tb_usuarios SET nombre=@nombre,apellidos=@apellidos,
	tipo_doc=@tipo_doc,num_doc=@num_doc,
	direccion=@direccion,email=@email,estado=@estado
	WHERE id=@id
	end
else if @nBusca=@usr AND @pas!=''
	begin
	UPDATE tb_usuarios SET nombre=@nombre,apellidos=@apellidos,pas=@pas,
	tipo_doc=@tipo_doc,num_doc=@num_doc,
	direccion=@direccion,email=@email,estado=@estado
	WHERE id=@id
	end
else if @nBusca!=@usr AND @pas=''
	begin
	if(@coincidenciaUsrName=0)
		begin
		UPDATE tb_usuarios SET nombre=@nombre,apellidos=@apellidos,
		usr=@usr,tipo_doc=@tipo_doc,num_doc=@num_doc,
		direccion=@direccion,email=@email,estado=@estado
		WHERE id=@id
		end
	end
else if @nBusca!=@usr AND @pas!=''
	begin
	if(@coincidenciaUsrName=0)
		begin
		UPDATE tb_usuarios SET nombre=@nombre,apellidos=@apellidos,pas=@pas,
		usr=@usr,tipo_doc=@tipo_doc,num_doc=@num_doc,
		direccion=@direccion,email=@email,estado=@estado
		WHERE id=@id
		end
	end
go
create procedure SP_LIST_OPTIONS_USUARIO
as
SELECT us.id,us.nombre,tpo.descripcion,us.num_doc 
FROM tb_usuarios us
INNER JOIN tb_tipo_documento tpo ON us.tipo_doc=tpo.id
WHERE us.estado = 1  
go
create procedure SP_BUSCA_USUARIO(
@id bigint
)
as
SELECT us.id,us.nombre,us.apellidos,tpoDc.descripcion,us.num_doc,us.email,us.direccion FROM tb_usuarios us 
INNER JOIN tb_tipo_documento tpoDc ON tpoDc.id=us.tipo_doc 
WHERE us.id=@id
go
--fin usuario


--administrativos (1)
create procedure SP_AGREGAR_DETALLE_ADMINISTRATIVO(
@id_usuario	bigint,
@fech_nac	date,
@puesto	varchar(100),
@telefono	varchar(12)
)
as
INSERT INTO tb_administrativos (id_usuario,fech_nac,puesto,telefono) 
VALUES (@id_usuario,@fech_nac,@puesto,@telefono)
go
create procedure SP_ACTUALIZA_DETALLE_ADMINISTRATIVO(
@id_usuario	bigint,
@fech_nac	date,
@puesto	varchar(100),
@telefono	varchar(12)
)
as
UPDATE tb_administrativos SET fech_nac=@fech_nac,puesto=@puesto,telefono=@telefono WHERE id_usuario=id_usuario
go
create procedure SP_AGREGA_PERMISOS_ADMINISTRATIVO(
@id bigint
)
as
INSERT INTO tb_permiso_usuario(id_usuario,id_permiso)
SELECT @id,id_permiso FROM tb_pantilla_cargo_rol where id=1
go
create procedure SP_LISTAR_ADMINISTRATIVOS
as
SELECT us.id,us.nombre,us.apellidos,us.email,
adm.puesto,adm.telefono,
case
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado',us.usr
FROM tb_administrativos adm INNER JOIN tb_usuarios us ON us.id=adm.id_usuario 
go
create procedure SP_BUSCA_ADMINISTRATIVO(
@id bigint
)
as
SELECT us.id,us.nombre,us.apellidos,us.tipo_doc,
tpoDoc.descripcion,us.num_doc,us.direccion,us.email,
CONVERT(varchar,adm.fech_nac,121),adm.puesto,adm.telefono,us.estado as 'idEstado',
case
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado',us.usr 
FROM tb_administrativos adm 
INNER JOIN tb_usuarios us ON us.id=adm.id_usuario
INNER JOIN tb_tipo_documento tpoDoc ON tpoDoc.id=us.tipo_doc 
WHERE adm.id_usuario=@id
go

--docentes (2)
create procedure SP_AGREGAR_DETALLE_DOCENTE(
@id_usuario	bigint,
@fech_nac	date,
@telefono	varchar(12)
)
as
INSERT INTO tb_docentes (id_usuario,fech_nac,telefono) VALUES (@id_usuario,@fech_nac,@telefono)
go
create procedure SP_LISTAR_DOCENTES
as
SELECT us.id,us.nombre,us.apellidos,us.email,
dc.telefono,CONVERT(varchar,dc.fech_nac,121),
case
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado',us.usr
FROM tb_docentes dc INNER JOIN tb_usuarios us ON us.id=dc.id_usuario
go
create procedure SP_BUSCAR_DOCENTE(
@id bigint
)
as
SELECT us.id,us.nombre,us.apellidos,us.tipo_doc,tpoDoc.descripcion,
us.num_doc,us.direccion,us.email,CONVERT(varchar,dc.fech_nac,121),dc.telefono,us.estado as 'idEdtado',
case
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado',us.usr 
FROM tb_docentes dc 
INNER JOIN tb_usuarios us ON us.id=dc.id_usuario
INNER JOIN tb_tipo_documento tpoDoc ON tpoDoc.id=us.tipo_doc 
WHERE dc.id_usuario=@id
go
create procedure SP_ACTUALIZA_DETALLE_DOCENTE(
@id_usuario	bigint,
@fech_nac	date,
@telefono	varchar(12)
)
as
UPDATE tb_docentes SET fech_nac=@fech_nac , telefono=@telefono WHERE id_usuario=@id_usuario
go
create procedure SP_AGREGAR_PERMISO_DOCENTE(
@id bigint
)
as
INSERT INTO tb_permiso_usuario(id_usuario,id_permiso)
SELECT @id,id_permiso FROM tb_pantilla_cargo_rol where id=2
go

--alumno (3)
create procedure SP_AGREGA_DETALLE_ALUMNO(
@id_usuario bigint,
@fech_nac date
)
as
INSERT INTO tb_alumnos (id_usuario,fech_nac) VALUES (@id_usuario,@fech_nac)
go
create procedure SP_LISTAR_ALUMNOS
as
SELECT us.id,us.nombre,us.apellidos,us.email,convert(varchar,alm.fech_nac,121),
case
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado'
FROM tb_alumnos alm 
INNER JOIN tb_usuarios us ON alm.id_usuario=us.id
go
create procedure SP_BUSCA_ALUMNO(
@id bigint
)
as
SELECT us.id,us.nombre,us.apellidos,us.email,us.direccion,us.tipo_doc,tpoDoc.descripcion,us.num_doc,us.estado as 'idEdtado',
CONVERT(varchar,al.fech_nac,121),
case 
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado',us.usr
FROM tb_alumnos al 
INNER JOIN tb_usuarios us ON al.id_usuario=us.id 
INNER JOIN tb_tipo_documento tpoDoc ON us.tipo_doc=tpoDoc.id
WHERE al.id_usuario=@id
go
create procedure SP_ACTUALIZA_DETALLE_ALUMNO(
@id_usuario bigint,
@fech_nac date
)
as
UPDATE tb_alumnos SET id_usuario=@id_usuario, fech_nac=@fech_nac WHERE id_usuario=@id_usuario
go
create procedure SP_AGREGAR_PERMISO_ALUMNO(
@id bigint
)
as
INSERT INTO tb_permiso_usuario(id_usuario,id_permiso)
SELECT @id,id_permiso FROM tb_pantilla_cargo_rol where id=3
go
create procedure SP_LIST_OPTIONS_ALUMNO
as
SELECT us.id,us.nombre,us.apellidos,tpo.descripcion,us.num_doc 
FROM tb_alumnos al 
INNER JOIN tb_usuarios us on us.id=al.id_usuario
INNER JOIN tb_tipo_documento tpo on tpo.id=us.tipo_doc 
WHERE us.estado!=0
go

--apoderado (4)
create procedure SP_AGREGAR_APDERADO(
@id_usuario bigint,
@trabajo varchar(100),
@direccion varchar(100),
@telefono varchar(12)
)
as
INSERT INTO tb_apoderado (id_usuario,trabajo,direccion,telefono) VALUES (@id_usuario,@trabajo,@direccion,@telefono) 
go
create procedure SP_LISTAR_APODERADO
as
SELECT
us.id,us.nombre,us.apellidos,us.email,apo.telefono,apo.trabajo,apo.direccion as 'dirTrabajo',
case
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado',us.usr 
FROM tb_apoderado apo INNER JOIN tb_usuarios us ON us.id=apo.id_usuario
go
create procedure SP_BUSCAR_APODERADO(
@id bigint
)
as
SELECT us.id,us.nombre,us.apellidos,us.email,us.direccion,us.tipo_doc,tpoDoc.descripcion as 'documentoDesc',us.num_doc,
apo.trabajo,apo.telefono,apo.direccion as 'dirTrabajo',us.estado as 'idEstado',
case
	when us.estado=1 then 'Activo'
	when us.estado=0 then 'Inactivo'
end as 'estado',us.usr 
FROM tb_apoderado apo 
INNER JOIN tb_usuarios us ON us.id=apo.id_usuario
INNER JOIN tb_tipo_documento tpoDoc ON tpoDoc.id=us.tipo_doc
WHERE apo.id_usuario=@id
go
create procedure SP_ACTUALIZAR_DETALLE_APODERADO(
@id_usuario bigint,
@trabajo varchar(100),
@direccion varchar(100),
@telefono varchar(12)
)
as
UPDATE tb_apoderado SET trabajo=@trabajo,direccion=@direccion,telefono=@telefono WHERE id_usuario=@id_usuario
go
create procedure SP_AGREGA_ALUMNO_APODERADO(
@id_apoderado bigint,
@id_alumno bigint
)
as
INSERT INTO tb_apoderado_alumno (id_apoderado,id_alumno) VALUES (@id_apoderado,@id_alumno)
go
create procedure SP_LISTA_ALUMNO_APODERADO(
@id bigint
)
as
SELECT us.id,us.nombre,us.apellidos 
FROM tb_apoderado_alumno apoAl 
INNER JOIN tb_usuarios us ON us.id=apoAl.id_alumno
WHERE apoAl.id_apoderado=@id
go
create procedure SP_ELIMINA_ALUMNO_APODERADO(
@id_apoderado bigint,
@id_alumno bigint
)
as
DELETE FROM tb_apoderado_alumno WHERE id_alumno=@id_alumno AND id_apoderado=@id_apoderado
go
create procedure SP_AGREGAR_PERMISO_APODERADO(
@id bigint
)
as
INSERT INTO tb_permiso_usuario(id_usuario,id_permiso)
SELECT @id,id_permiso FROM tb_pantilla_cargo_rol where id=4
go

--permisos
create procedure SP_LIST_OPTIONS_PERMISOS
as
SELECT id,descripcion FROM tb_permisos
go
create procedure SP_LISTAR_PERMISOS_USUARIO(
@id_usuario bigint
)
as
SELECT pr.id,pr.descripcion 
FROM tb_permiso_usuario prUs INNER JOIN tb_permisos pr ON pr.id=prUs.id_permiso 
WHERE prUs.id_usuario=@id_usuario 
go
create procedure SP_AGREGAR_PERMISO(
@id_usuario bigint,
@id_permiso bigint
)
as
INSERT INTO tb_permiso_usuario (id_usuario,id_permiso) VALUES (@id_usuario,@id_permiso)
go
create procedure SP_ELIMINA_PERMISO(
@id_usuario bigint,
@id_permiso bigint
)
as
DELETE FROM tb_permiso_usuario WHERE id_permiso=@id_permiso AND id_usuario=@id_usuario
go

--curso
create procedure SP_LISTAR_CURSOS
as
SELECT  cr.id,cr.descripcion,
case
	when cr.estado=1 then 'Activo'
	when cr.estado=0 then 'Inactivo'
end as 'estado'
FROM tb_cursos cr 
go
create procedure SP_AGEGAR_CURSO(
@descripcion varchar(50)
)
as
INSERT INTO tb_cursos (descripcion) VALUES (@descripcion)
go
create procedure SP_BUSCA_CURSO(
@id_curso int
)
as
SELECT id,descripcion,estado FROM tb_cursos WHERE id=@id_curso
go
create procedure SP_ACTUALIZA_CURSO(
@id_curso int ,
@descripcion varchar(50),
@estado tinyint
)
as
UPDATE tb_cursos SET descripcion=@descripcion,estado=@estado WHERE id=@id_curso
go


--niveles/grados
create procedure SP_LISTAR_GRADOS
as
SELECT id,descripcion,sigla,
case 
	when estado=1 then 'Activo'
	when estado=0 then 'Inactivo'
end as 'estado'
FROM tb_grados
go
create procedure SP_AGREGA_GRADOS(
@descripcion varchar(100),
@sigla varchar(10)
)
as
INSERT INTO tb_grados (descripcion,sigla) VALUES (@descripcion,@sigla)
go
create procedure SP_BUSCA_GRADO(
@id_grado int
)
as
SELECT id,descripcion,sigla,estado FROM tb_grados WHERE id=@id_grado
go
create procedure SP_ACTUALIZA_GRADO(
@id_grado int,
@descripcion varchar(100),
@sigla varchar(10),
@estado tinyint
)
as
UPDATE tb_grados SET descripcion=@descripcion,sigla=@sigla,estado=@estado WHERE id=@id_grado
go
create procedure SP_LIST_OPTIONS_NIVELES
as
SELECT id,descripcion,sigla FROM tb_grados where estado=1
go



--malla curri
create procedure SP_LISTA_MALLA_CURRICULAR(
@id_grado int
)
as
SELECT cr.id,cr.descripcion FROM tb_malla_curricular mll 
INNER JOIN tb_cursos cr ON cr.id=mll.id_curso 
WHERE mll.id_grado=@id_grado
go
create procedure SP_AGREGA_CURSO_MALLA(
@id_grado int,
@id_curso int
)
as
INSERT INTO tb_malla_curricular (id_grado,id_curso) VALUES (@id_grado,@id_curso)
go
create procedure SP_ELIMINA_CURSO_MALLA(
@id_grado int,
@id_curso int
)
as
DELETE FROM tb_malla_curricular WHERE id_curso=@id_curso AND id_grado=@id_grado
go

--secciones
create procedure SP_LISTAR_SECCIONES
as
SELECT id,descripcion,
case 
	when estado=1 then 'Activo'
	when estado=0 then 'Inactivo'
end as 'estado'
FROM tb_secciones
 
go
create procedure SP_AGREGA_SECCIONES(
@descripcion varchar(50)
)
as
INSERT INTO tb_secciones (descripcion) VALUES (@descripcion)
go
create procedure SP_BUSCA_SECCIONES(
@id int
)
as
SELECT sc.id,sc.descripcion,sc.estado as 'idEstado',
case
	when sc.estado=1 then 'Activo'
	when sc.estado=0 then 'Inactivo'
end as 'estado'
FROM tb_secciones sc WHERE sc.id=@id  
go
create procedure SP_ACTUALIZA_SECCIONES(
@id int,
@descripcion varchar(50),
@estado tinyint
)
as
UPDATE tb_secciones SET descripcion=@descripcion,estado=@estado WHERE id=@id 
go


select  * from tb_malla_curricular
select * from tb_permisos
