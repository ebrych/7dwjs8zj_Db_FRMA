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
create table tb_docente_curso(
id_docente bigint,
id_curso int,
FOREIGN KEY(id_docente) REFERENCES tb_usuarios(id),
FOREIGN KEY(id_curso) REFERENCES tb_cursos(id)
)
create table tb_grupos(
id	bigint identity(1,1) not null,
descripcion	varchar(50) not null,
fech_reg	dateTime default SYSDATETIME() not null,
id_docente	bigint not null,
estado tinyint default 1 not null,
primary key(id),
foreign key (id_docente) references tb_usuarios(id)
)
create table tb_especificacion(
id	bigint identity(1,1) not null,
descripcion	varchar(50) not null,
id_docente	bigint not null,
id_grupo	bigint not null,
fech_reg	dateTime default SYSDATETIME() not null,
estado tinyint default 1 not null,
primary key(id),
foreign key (id_docente) references tb_usuarios(id),
foreign key (id_grupo) references tb_grupos(id) 
)
create table tb_especificacion_curso(
id_curso int,
id_especificacion bigint,
id_docente bigint,
FOREIGN KEY (id_curso) REFERENCES tb_cursos,
FOREIGN KEY (id_especificacion) REFERENCES tb_especificacion,
FOREIGN KEY (id_docente) REFERENCES tb_usuarios
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
estado tinyint default 1 not null,
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
nota_final	decimal(4,2) null,
id_docente bigint null
primary key (id),
foreign key (id_matricula) references tb_matricula(id),
foreign key (id_cursos) references tb_cursos(id),
)
create table tb_detalle_matricula_curso(
id bigint identity(1,1) not null,
id_mat_cur	bigint not null,
nota	decimal(4,2) not null,
porcentaje	int not null,
id_espec	bigint not null,
fech_reg	dateTime default SYSDATETIME() not null,
primary key(id),
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


	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Administrativos','Gestión de administrativos','fas fa-users','Administrativo')--exclusivo administrativos
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Inscripciones','Gestión de alumnos','fas fa-user-graduate','Alumno') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Docentes','Gestión de docentes','fas fa-chalkboard-teacher','Docente') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Apoderados','Gestión de apoderados','fab fa-black-tie','Apoderado') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Permisos','Gestión de permisos del sistema','fas fa-lock','Permiso') --administra permisos de usuario
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cursos','Gestión de cursos','fas fa-book','Cursos') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Malla Curricular','Gestión de mallas curriculares','fas fa-layer-group','MallaCurricular') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grados','Gestión de grados y niveles','fas fa-ellipsis-v','Niveles') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Ciclos Academicos','Gestión de ciclos Academicos','fas fa-pencil-ruler','Ciclos') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Matriculas','Gestión de matriculas','fas fa-tasks','Matriculas') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Secciones','Gestión de secciones','fas fa-grip-horizontal','Secciones') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Docente - Curso','Asignacion docentes a cursos','fas fa-user-tag','DocenteCurso') --exclusivo administrativos
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grupos','Gestión de Grupos de Evaluacion','fas fa-object-group','Grupos') --exclusivo docentes
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Especificaciones','Gestión de Especificaciones de Evaluacion','fas fa-highlighter','Especificaciones') --exclusivo docentes
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cursos del docente','Gestión de sus cursos del docente','fas fa-chalkboard','CursosDeDocente') --exclusivo docentes
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Calificaciones','Gestión de calificaciones','fas fa-pen-alt','GestionCalificaciones') --exclusivo docentes
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
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (9,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (10,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (11,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (12,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (13,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (14,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (15,1)
	INSERT INTO tb_permiso_usuario(id_permiso,id_usuario) values (16,1)
	SELECT * FROM tb_permiso_usuario

	INSERT INTO tb_grupos(descripcion,fech_reg,id_docente) VALUES ('Ninguno',SYSDATETIME(),1)
	select * from tb_grupos
end

	--data demo de asignacion
	INSERT INTO tb_pantilla_cargo_rol(id,descripcion,id_permiso) VALUES (1,'Administrativo',2)
	INSERT INTO tb_pantilla_cargo_rol(id,descripcion,id_permiso) VALUES (1,'Administrativo',3)
	INSERT INTO tb_docente_curso(id_curso,id_docente) VALUES (1,1)


--=========================================PROCEDURES
create procedure SP_LOGIN(
@user varchar(20),
@pass varchar(10)
)
as
SELECT us.id,us.nombre,us.apellidos
FROM tb_usuarios us WHERE (us.usr=@user OR us.num_doc=@user) AND (us.pas=@pass) AND estado=1
go
exec SP_LOGIN 'root','123'


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

create procedure SP_CONTROL_PERMISOS(
@id bigint,
@permiso int
)
as
SELECT count(*) FROM tb_permiso_usuario pr INNER JOIN tb_usuarios us ON us.id=pr.id_usuario  WHERE id_usuario=@id AND id_permiso=@permiso AND us.estado=1
go

create procedure SP_LISTAR_TIPO_DOCUMENTO
as
SELECT id,descripcion FROM tb_tipo_documento 
go



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
create procedure SP_LISTA_CURSOS_DOCENTE(
@id bigint
)
as
SELECT cr.id,cr.descripcion,
case
	when cr.estado=1 then 'Activo'
	when cr.estado=0 then 'Inactivo'
end as 'estado' 
FROM tb_docente_curso dccr
INNER JOIN tb_cursos cr ON cr.id=dccr.id_curso
WHERE dccr.id_docente=@id
go

create procedure SP_AGREGA_CURSO_DOCENTE(
@docente bigint,
@curso bigint
)
as
INSERT INTO tb_docente_curso (id_docente,id_curso) VALUES (@docente,@curso)
go
create procedure SP_ELIMINA_CURSO_DOCENTE(
@docente bigint,
@curso bigint
)
as
DELETE FROM tb_docente_curso WHERE id_docente=@docente AND id_curso=@curso
go
create procedure SP_LISTA_DOCENTE_BY_CURSO(
@id_curso int
)
as
SELECT us.id,us.nombre,us.apellidos
FROM tb_docente_curso dccr
INNER JOIN tb_usuarios us ON us.id=dccr.id_docente
WHERE dccr.id_curso=@id_curso
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
create procedure SP_BUSCA_ALUMNO_BY_DOC(
@numero varchar(12)
)
as
SELECT us.id,us.nombre,us.apellidos,tpo.descripcion,us.num_doc
FROM tb_alumnos al 
INNER JOIN tb_usuarios us ON us.id=al.id_usuario
INNER JOIN tb_tipo_documento tpo ON tpo.id=us.tipo_doc 
WHERE us.num_doc=@numero 
go
create procedure SP_BUSCA_ALUMNO_BY_CURSO_MATRICULA(
@curso_matricula bigint
)
as
DECLARE 
@mt bigint
select @mt=id_matricula from tb_matricula_cursos where id=@curso_matricula
select us.id,us.nombre,us.apellidos from tb_matricula mt 
inner join tb_usuarios us on us.id=mt.id_alumno
where mt.id=@mt
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
create procedure SP_LIST_OPTIONS_CURSOS
as
SELECT id,descripcion FROM tb_cursos WHERE estado=1
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
create procedure SP_LIST_OPTIONS_SECCIONES
as
SELECT id,descripcion FROM tb_secciones WHERE estado=1
go

--ciclos
create procedure SP_LISTAR_CICLOS_ACADEMICOS
as
SELECT cl.id,cl.nombre,CONVERT(varchar,cl.fecha_ini,121) as 'inicio',CONVERT(varchar,cl.fech_fin,121) as 'fin',
case
	when cl.estado=1 then 'Activo'
	when cl.estado=0 then 'Terminado'
end as 'estado'
FROM tb_cliclo_academico cl
go
create procedure SP_AGREGA_CLICLO_ACADEMICO(
@nombre varchar(50),
@inicio date,
@fin date
)
as
INSERT INTO tb_cliclo_academico (nombre,fecha_ini,fech_fin) VALUES (@nombre,@inicio,@fin)
go
create procedure SP_BUSCA_CICLO_ACADEMICO(
@id int 
)
as
SELECT cl.id,cl.nombre,CONVERT(varchar,fecha_ini,121) as 'inicio',CONVERT(varchar,fech_fin,121) as 'fin',
cl.estado 
FROM tb_cliclo_academico cl WHERE cl.id=@id
go
create procedure SP_ACTUALIZA_CICLO_ACADEMICO(
@id int,
@nombre varchar(50),
@inicio date,
@fin date,
@estado tinyint
)
as
UPDATE tb_cliclo_academico SET nombre=@nombre,fecha_ini=@inicio,fech_fin=@fin,estado=@estado 
WHERE id=@id
go
create procedure SP_LIST_OPTIONS_CICLOS_ACADEMICOS
as
SELECT id,nombre FROM tb_cliclo_academico WHERE estado=1
go

--matriculas
create procedure SP_LISTAR_MATRICULA_BY_USUARIO(
@id bigint
)
as
SELECT 
mtr.id as 'id_matricula',us.nombre,us.apellidos,gr.descripcion,gr.sigla,sc.descripcion,cl.nombre,
case
	when cl.estado = 1 then 'Activo'
	when cl.estado= 0 then 'Finalizado'
end as 'estado_academico',
case
	when mtr.estado=1 then 'Normal'
	when mtr.estado=0 then 'Anulada'
end as 'estado_matricula' 
FROM tb_matricula mtr
INNER JOIN tb_usuarios us ON us.id=mtr.id_alumno
INNER JOIN tb_grados gr ON mtr.id_grado=gr.id
INNER JOIN tb_secciones sc ON mtr.id_seccion=sc.id
INNER  JOIN tb_cliclo_academico cl ON mtr.id_ciclo_acdemico=cl.id
WHERE us.id=@id 
go
create procedure SP_AGREGAR_MATRICULA(
@id_alumno bigint,
@id_grado int,
@id_seccion int,
@id_ciclo_academic int
)
as
DECLARE
@fecha date = SYSDATETIME(),
@idMat bigint
--inserta
INSERT INTO tb_matricula (id_alumno,id_grado,id_seccion,id_ciclo_acdemico,fech_reg) 
VALUES (@id_alumno,@id_grado,@id_seccion,@id_ciclo_academic,@fecha)
--buscaId
SELECT @idMat=id  
FROM tb_matricula 
WHERE id_alumno=@id_alumno AND id_grado=@id_grado AND id_seccion=@id_seccion AND id_ciclo_acdemico=@id_ciclo_academic
--agrega curso de curricula
INSERT INTO tb_matricula_cursos (id_matricula,id_cursos)
SELECT @idMat,id_curso FROM tb_malla_curricular WHERE id_grado=@id_grado
go
create procedure SP_BUSCA_MATRICULA(
@id_matricula bigint
)
as
SELECT mt.id,us.nombre,us.apellidos,tpo.descripcion as 'tipoDoc',us.num_doc,mt.id_grado as 'idGrado',gr.descripcion as 'grado',
mt.id_seccion,sc.descripcion as 'seccion',
mt.id_ciclo_acdemico,cl.nombre,CONVERT(varchar,cl.fecha_ini,121) as 'inicio', CONVERT(varchar,cl.fech_fin,121) as 'fin' 
FROM tb_matricula mt
INNER JOIN tb_usuarios us ON mt.id_alumno=us.id
INNER JOIN tb_grados gr ON mt.id_grado=gr.id
INNER JOIN tb_secciones sc ON mt.id_seccion=sc.id
INNER JOIN tb_cliclo_academico cl ON cl.id=mt.id_ciclo_acdemico
INNER JOIN tb_tipo_documento tpo ON us.tipo_doc=tpo.id
WHERE mt.id=@id_matricula
go
--create procedure SP_ACTUALIZA_MATRICULA(
--@id bigint,
--@id_alumno bigint,
--@id_grado int,
--@id_seccion int,
--@id_ciclo_academic int,
--@estado tinyint
--)
--as
--variables
--DECLARE
--@i int=1,
--@total_cursos int =0,
--@idCrMt bigint = 0,
--@total_notas int = 0,
--@nota int = 0,
--@grado int
--listaDeCursos
--create table #MatCur(
--id int identity(1,1),
--idMatCur bigint
--)
--insert into #MatCur (idMatCur)
--select id from tb_matricula_cursos where id_matricula=@id;
--numero de regisitros para while
--select @total_cursos=count(*) from #MatCur
--ciclo
--while @i<@total_cursos
--begin
--	select @idCrMt=idMatCur from #MatCur where id=@i
--	select @nota=count(*) from tb_detalle_matricula_curso where id_mat_cur=@idCrMt
--	set @total_notas=@total_notas+@nota
--	set @i=@i+1
--end
--acciones
--if @total_notas=0
--begin
--	SELECT @grado=id_grado FROM tb_matricula WHERE id=@id
--	IF @grado=@id_grado
--	BEGIN
--		UPDATE tb_matricula SET id_alumno=@id_alumno,id_seccion=@id_seccion,id_ciclo_acdemico=@id_ciclo_academic
--		WHERE id=@id
--	END
--	ELSE
--	BEGIN
--		UPDATE tb_matricula SET id_alumno=@id_alumno,id_grado=@id_grado,id_seccion=@id_seccion,id_ciclo_acdemico=@id_ciclo_academic
--		WHERE id=@id
--		DELETE FROM tb_matricula_cursos where id_matricula=@id
--		INSERT INTO tb_matricula_cursos (id_cursos,id_matricula)
--		SELECT id_curso,@id FROM tb_malla_curricular WHERE id_grado=@id_grado
--	END
--end
--estado
--UPDATE tb_matricula SET estado=@estado WHERE id=@id
--go
create procedure SP_ELIMINA_MATRICULA(
@id bigint
)
as
--variables
DECLARE
@i int=1,
@total_cursos int =0,
@idCrMt bigint = 0,
@total_notas int = 0,
@nota int = 0
--listaDeCursos
create table #MatCur(
id int identity(1,1),
idMatCur bigint
)
insert into #MatCur (idMatCur)
select id from tb_matricula_cursos where id_matricula=@id;
--numero de regisitros para while
select @total_cursos=count(*) from #MatCur
--ciclo
while @i<@total_cursos
begin
	select @idCrMt=idMatCur from #MatCur where id=@i
	select @nota=count(*) from tb_detalle_matricula_curso where id_mat_cur=@idCrMt
	set @total_notas=@total_notas+@nota
	set @i=@i+1
end
if @total_notas=0
begin
DELETE FROM tb_matricula_cursos WHERE id_matricula=@id
DELETE FROM tb_matricula WHERE id=@id
end
go
create procedure SP_LISTAR_CURSO_MATRICULA(
@id_matricula bigint
)
as
SELECT cr.id,cr.descripcion 
FROM tb_matricula_cursos mtcr 
INNER JOIN tb_cursos cr ON mtcr.id_cursos=cr.id
WHERE mtcr.id_matricula=@id_matricula
go
create procedure SP_AGREGA_CURSO_MATRICULA(
@id_curso int,
@matricula bigint
)
as
INSERT INTO tb_matricula_cursos (id_matricula,id_cursos)VALUES (@matricula,@id_curso)
go
create procedure SP_ELIMINA_CURSO_MATRICULA(
@id_curso int,
@matricula bigint
)
as
DECLARE
@notas int=0,
@Matcurso int =0
SELECT @Matcurso=id FROM tb_matricula_cursos WHERE id_matricula=@matricula AND id_cursos=@id_curso
SELECT @notas=count(*) FROM tb_detalle_matricula_curso WHERE id_mat_cur=@Matcurso
if @notas=0
begin
	DELETE FROM tb_matricula_cursos WHERE id_cursos=@id_curso AND id_matricula=@matricula
end
go

--Docente - Curso
create procedure SP_LISTA_GRADO_BY_MATRICULAS
as
DECLARE
@i int = 1,
@total int =0,
@sc int,
@cl int,
@gr int,
@totalEstado int,
@totalCurso int
create table #tbl(
id int identity(1,1),
seccion int,
seccion_des varchar(50),
nivel int,
nivel_des varchar(50),
ciclo int,
ciclo_nom varchar(50),
alumnos int,
estado_asigna_doc varchar(20)
)
insert into #tbl (seccion,seccion_des,nivel,nivel_des,ciclo,ciclo_nom,alumnos)
select DISTINCT sc.id as 'id_seccion' ,sc.descripcion as 'seccion',gr.id as 'id_nivel',gr.descripcion,cl.id as 'id_ciclo',cl.nombre as 'ciclo'
,(select count(*) from tb_matricula where id_grado=mt.id_grado and id_seccion=mt.id_seccion) as 'cantidad_alumnos'
from tb_matricula mt
inner join  tb_grados gr on mt.id_grado=gr.id
inner join tb_secciones sc on mt.id_seccion=sc.id
inner join tb_cliclo_academico cl on mt.id_ciclo_acdemico=cl.id
where mt.estado=1
select @total=count(*) from #tbl
WHILE @i <= @total
begin
	select @sc=seccion,@cl=ciclo,@gr=nivel from #tbl where id=@i
	--cantidad docente
	select @totalEstado=count(*) 
	from tb_matricula_cursos mtcr
	inner join tb_matricula mt on mt.id=mtcr.id_matricula
	where mt.id_ciclo_acdemico=@cl and id_grado=@gr and id_seccion=@sc and id_docente is null
	--cantidad cursos
	select @totalCurso=count(*)
	from tb_matricula_cursos mtcr
	inner join tb_matricula mt on mtcr.id_matricula=mt.id
	inner join tb_cursos cr on cr.id=mtcr.id_cursos
	where mt.id_ciclo_acdemico=@cl and mt.id_seccion=@sc and mt.id_grado=@gr
	--logica update
	if @totalEstado>0
	begin
		update #tbl set estado_asigna_doc='Incompleto' where id=@i
	end
	else
	begin
		if @totalCurso>0
		begin
			update #tbl set estado_asigna_doc='Completo' where id=@i
		end
		else
		begin
			update #tbl set estado_asigna_doc='Sin Cursos' where id=@i
		end
	end
	set @i=@i+1
end
select seccion,seccion_des,nivel,nivel_des,ciclo,ciclo_nom,alumnos,estado_asigna_doc  from #tbl
drop table #tbl
go
create procedure SP_LISTA_CURSO_BY_MATRICULAS(
@id_ciclo int,
@id_seccion int,
@id_grado int
)
as
select DISTINCT cr.id as 'id_curso' ,cr.descripcion,@id_ciclo as 'ciclo',@id_seccion as 'seccion',@id_grado as 'nivel' --,mtcr.id as 'id_matricula_curso' 
from tb_matricula_cursos mtcr
inner join tb_matricula mt on mtcr.id_matricula=mt.id
inner join tb_cursos cr on cr.id=mtcr.id_cursos
where mt.id_ciclo_acdemico=@id_ciclo and mt.id_seccion=@id_seccion and mt.id_grado=@id_grado
go
create procedure SP_BUSCA_DATO_CURSO_MATRICULA(
@id_curso int,
@id_ciclo int,
@id_seccion int,
@id_nivel int
)
as
select DISTINCT cr.id as 'id_curso' ,cr.descripcion,
@id_ciclo as 'ciclo',
(select nombre from tb_cliclo_academico where id=@id_ciclo) as 'cilo_desc',
@id_seccion as 'seccion',
(select descripcion from tb_secciones where id=@id_seccion) as 'seccion_desc',
@id_nivel as 'nivel',
(select descripcion from tb_grados where id=@id_nivel) as 'nivel_desc',
case
	when mtcr.id_docente is null then '0'
	when mtcr.id_docente is not null then mtcr.id_docente
end as 'usuario'
--case
--	when mtcr.id_docente is null then 'Sin Asignar'
--	when mtcr.id_docente is not null then (select CONCAT(nombre,' ',apellidos) from tb_usuarios where id=mtcr.id_docente)
--end as 'usuario'
from tb_matricula_cursos mtcr
inner join tb_matricula mt on mtcr.id_matricula=mt.id
inner join tb_cursos cr on cr.id=mtcr.id_cursos
where mt.id_ciclo_acdemico=@id_ciclo and mt.id_seccion=@id_seccion and mt.id_grado=@id_nivel and id_cursos=@id_curso
go
create procedure SP_AGREGA_DOCENTE_TO_MATRICULA(
@id_docente bigint,
@id_ciclo int,
@id_seccion int,
@id_grado int,
@id_curso int
)
as
DECLARE
@i int = 1,
@total int=0,
@idMatCur bigint
create table #tbList(
idt int identity(1,1) not null,
idMat bigint
)
insert into #tbList (idMat)
select mtcr.id 
from tb_matricula_cursos mtcr 
inner join tb_matricula mt on mtcr.id_matricula=mt.id
where id_cursos=@id_curso and mt.id_ciclo_acdemico=@id_ciclo and mt.id_seccion=@id_seccion and mt.id_grado=@id_grado
--asigna 
select @total=count(*) from #tbList
print(@total)
while @i<=@total
begin
	select @idMatCur=idMat from #tbList where idt=@i
	print(@idMatCur)
	update tb_matricula_cursos set id_docente=@id_docente WHERE id=@idMatCur
	set @i=@i+1 
end
drop table #tbList
go

--Grupos
create procedure SP_LISTAR_GRUPOS_BY_USUARIO(
@id_docente bigint
)
as
select id,descripcion,convert(varchar,fech_reg,10),
case
	when estado=1 then 'Activo'
	when estado=0 then 'Inactivo'
end as 'estado' 
from tb_grupos where id_docente=@id_docente
go
create procedure SP_AGREGAR_GRUPO(
@id_usuario bigint,
@descripcion varchar(50)
)
as
INSERT INTO tb_grupos (descripcion,fech_reg,id_docente) VALUES (@descripcion,SYSDATETIME(),@id_usuario)
go
create procedure SP_BUSCA_GRUPO(
@id bigint,
@id_docente bigint
)
as
SELECT id,descripcion,CONVERT(varchar,fech_reg,10),estado FROM tb_grupos where id=@id and id_docente=@id_docente
go
create procedure SP_ACTUALIZA_GRUPO(
@id_grupo bigint,
@descripcion varchar(50),
@estado tinyint
)
as
UPDATE tb_grupos SET descripcion=@descripcion,fech_reg=SYSDATETIME(),estado=@estado WHERE id=@id_grupo
go
create procedure SP_LIST_OPTIONS_GRUPOS(
@id_usuario bigint
)
as
SELECT id,descripcion FROM tb_grupos WHERE id_docente=@id_usuario OR id=1 AND estado=1
go
--Especificaciones
create procedure SP_LISTAR_ESPECIFICACION_BY_USUARIO(
@id bigint
)
as
select es.id,es.descripcion,es.id_grupo,gr.descripcion,
case 
	when es.estado=0 then 'Inactivo'
	when es.estado=1 then 'Activo'
end as 'estado' 
from tb_especificacion  es
inner join tb_grupos gr on es.id_grupo=gr.id
where es.id_docente=@id
go
create procedure SP_AGREGAR_ESPECIFICACION(
@descripcion varchar(50),
@docente bigint,
@grupo bigint
)
as
insert into tb_especificacion (descripcion,id_docente,id_grupo,fech_reg) values (@descripcion,@docente,@grupo,SYSDATETIME())
go
create procedure SP_BUSCA_ESPECIFICACION(
@especificacion bigint
)
as
select 
id,descripcion,id_grupo,estado
from tb_especificacion where id=@especificacion
go
create procedure SP_ACTUALIZAR_ESPECIFICACION(
@id bigint,
@descripcion varchar(50),
@docente bigint,
@grupo bigint,
@estado tinyint
)
as
update tb_especificacion 
set descripcion=@descripcion,id_docente=@docente,id_grupo=@grupo,fech_reg=SYSDATETIME(),estado=@estado 
WHERE id=@id
go
create procedure SP_LIST_OPTIONS_ESPECIFICACIONES(
@docente bigint,
@curso int
)
as
select es.id, es.descripcion
from tb_especificacion_curso esCr
inner join tb_especificacion es on esCr.id_especificacion=es.id 
where esCr.id_curso=@curso and esCr.id_docente=@docente and es.estado=1
go


--CursosDelDocente
create procedure SP_LISTA_ESPECIFICACIONES_BY_CURSO(
@docente bigint,
@curso int
)
as
select esCr.id_especificacion,es.descripcion as 'especificacion' 
from tb_especificacion_curso esCr
inner join tb_especificacion es on es.id=esCr.id_especificacion
where esCr.id_docente=@docente and esCr.id_curso=@curso
go
create procedure SP_AGREGAR_ESPEFICICACION_TO_CURSO(
@id_curso int,
@especificacion bigint,
@docente bigint
)
as
INSERT INTO tb_especificacion_curso (id_curso,id_especificacion,id_docente) VALUES (@id_curso,@especificacion,@docente)
go
create procedure SP_ELIMINA_ESPECIFICACION_TO_CURSO(
@id_curso int,
@especificacion bigint,
@docente bigint
)
as
DELETE FROM tb_especificacion_curso WHERE id_curso=@id_curso AND id_especificacion=@especificacion AND id_docente=@docente
go

--Calificacion
create procedure SP_LISTA_CURSOS_MATRICULA_BY_DOCENTE(
@docente bigint
)
as
select DISTINCT mtCr.id_cursos,cr.descripcion,
mt.id_ciclo_acdemico,
(select nombre from tb_cliclo_academico where id=mt.id_ciclo_acdemico) as 'ciclo_aademico',
mt.id_grado,
(select descripcion from tb_grados where id=mt.id_grado) as 'grados',
mt.id_seccion,
(select descripcion from tb_secciones where id=mt.id_seccion) as 'seccion'
from tb_matricula_cursos mtCr
inner join tb_matricula mt on mt.id=mtCr.id_matricula
inner join tb_cursos cr on cr.id=mtCr.id_cursos
where mtCr.id_docente=@docente
go
--exec SP_LISTA_CURSOS_MATRICULA_BY_DOCENTE 4
create procedure SP_LISTAR_ALUMNOS_CURSO_DOCENTE(
@curso int,
@docente bigint
)
as
select mtCr.id as 'matriculaCurs_id',al.id,al.nombre,al.apellidos
from tb_matricula_cursos mtCr
inner join tb_matricula mt on mtCr.id=mt.id
inner join tb_usuarios al on al.id=mt.id_alumno 
where id_cursos=@curso and id_docente=@docente
go
create procedure SP_LISTA_DETALLE_MATRICULA_CURSO_ALMUNO(
@matricula bigint,
@curso int,
@docente bigint
)
as
DECLARE
@idMatCur bigint
select @idMatCur=id from tb_matricula_cursos 
where id_matricula=@matricula and id_cursos=@curso and id_docente=@docente
select dtll.id,dtll.nota,dtll.porcentaje,dtll.id_espec,es.descripcion 
from tb_detalle_matricula_curso dtll
inner join tb_especificacion es on dtll.id_espec=es.id
where id_mat_cur=@matricula
go

create procedure SP_TOTAL_DETALLE_MATRICULA_CURSO_ALUMNO(
@matricula bigint,
@curso int
)
as
create table #notas(
id int identity(1,1) not null, 
nota decimal(4,2) not null,
porcentaje int not null
)
DECLARE
@idMatCur bigint,
@total int=0,
@i int = 1,
@notaTotal decimal(4,2)=0,
@porTotal int =0
select @idMatCur=id from tb_matricula_cursos 
where id_matricula=@matricula and id_cursos=@curso
insert into #notas (nota,porcentaje)
select dtll.nota,dtll.porcentaje
from tb_detalle_matricula_curso dtll
inner join tb_especificacion es on dtll.id_espec=es.id
where id_mat_cur=@matricula
select @total=count(*) from #notas
while @i<@total
begin
	
	set @i=@i+1
end
go

create procedure SP_AGREGAR_DETALLE_TO_DETALLEMATRICULACURSO(
@matriculaCurso bigint,
@nota decimal,
@porcentaje int,
@especificacion bigint
)
as
DECLARE
@percent int = 0
select 
 @percent=(case
 when SUM(porcentaje)is null then 0
 when SUM(porcentaje)is not null then SUM(porcentaje)
 end) 
from tb_detalle_matricula_curso
set @percent=@percent+@porcentaje
	if @percent < 100
	begin
	INSERT INTO tb_detalle_matricula_curso (id_mat_cur,nota,porcentaje,id_espec) VALUES (@matriculaCurso,@nota,@porcentaje,@especificacion) 
	end
go
create procedure SP_ELIMINA_DETALLE_TO_DETALLEMATRICULACURSO(
@detalle bigint
)
as
DELETE FROM tb_detalle_matricula_curso where id=@detalle
go
