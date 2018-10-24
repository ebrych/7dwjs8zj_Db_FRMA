create database FRMADB
use FRMADB

--====================================================ESTRUCTURA
--maestros
create table tb_tipo_documento(
id int not null identity(1,1),
descripcion varchar(20) not null,
PRIMARY KEY (id)
)
create table tb_cargos(
id int not null identity(1,1),
descripcion varchar(20) not null,
PRIMARY KEY (id)
)
create table tb_grado(
id int not null identity(1,1),
descripcion varchar(20) not null,
sigla varchar(8) not null,
PRIMARY KEY (id)
)
create table tb_seccion	(
id int not null identity(1,1),
descripcion varchar(20) not null,
PRIMARY KEY (id)
)
create table tb_cursos(
id int not null identity(1,1),
descripcion varchar(20) not null,
PRIMARY KEY (id)
)
create table tb_permisos(
id int not null identity(1,1),
titulo varchar(20) not null,
descripcion varchar(100) not null,
icono varchar(20) not null,
controlador varchar(20) not null
PRIMARY KEY (id)
)


--permisos
create table tb_permisos_cargos	(
id_cargo int not null,
id_permiso int not  null,
FOREIGN KEY (id_cargo) REFERENCES tb_cargos(id),
FOREIGN KEY (id_permiso) REFERENCES tb_permisos(id)
)
create table tb_usuario(
id bigint not null identity(1,1),
nombres varchar(100) not null,
apellidos varchar(200) not null,
tipo_doc int not null,
num_doc varchar(20),
usuario varchar(20),
pass varchar(20),
tkn_dinamico varchar(10),
tkn_fijo varchar(20),
fecha_reg datetime,
PRIMARY KEY(id),
FOREIGN KEY(tipo_doc) REFERENCES tb_tipo_documento(id)
)
create table tb_detalle_alumno(
id_usuario bigint not null,
fech_nac date not null,
fech_ingreso date null,
FOREIGN KEY (id_usuario) REFERENCES tb_usuario (id)
)
create table tb_detalle_apoderado(
id_usuario bigint not null,
oficio varchar(100) not null,
telefono varchar(12) not null,
email varchar(100) not null,
FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id)
)
create table tb_detalle_profesor(
id_usuario bigint not null,
area varchar(50) null,
titulo varchar(50) null,
fech_nac date not null,
FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id)
)
create table tb_detalle_administrativo(
id_usuario bigint not null,
id_cargo int not null,
fech_nac date not null,
titulo varchar(50) null,
FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
FOREIGN KEY (id_cargo) REFERENCES tb_cargos(id)
)

--cursos
create table tb_grupo_espeficicacion(
id	bigint not null identity(1,1),
descripcion	varchar(50) not null,
id_profesor	bigint not null,
PRIMARY KEY (id),
FOREIGN KEY (id_profesor) REFERENCES tb_usuario(id)
)
create table tb_especificacion(
id	bigint not null identity(1,1),
descripcion	varchar(50) not null,
id_profesor	bigint not null,
id_grupo	bigint not null,
PRIMARY KEY (id),
FOREIGN KEY (id_profesor) REFERENCES tb_usuario(id),
FOREIGN KEY (id_grupo) REFERENCES tb_grupo_espeficicacion(id)
)
create table tb_especificacion_curso(
id_curso	int not null,
id_espec	bigint not null
FOREIGN KEY (id_curso) REFERENCES tb_cursos(id),
FOREIGN KEY (id_espec) REFERENCES tb_especificacion(id)
)
create table tb_curso_profesor(
idCurso	bigint not null,
idProfesor	int not null
)
create table tb_malla_curricular(
id_curso int not null,
id_grado int not null,
FOREIGN KEY (id_curso) REFERENCES tb_cursos(id),
FOREIGN KEY (id_grado) REFERENCES tb_grado(id)
)

--matricula
create table tb_matricula(
id	bigint not null,
id_alumno	bigint not null,
id_grado	int not null,
id_seccion	int not null,
fech_reg	dateTime not null,
fech_fin	date null,
PRIMARY KEY (id),
FOREIGN KEY (id_alumno) REFERENCES tb_usuario(id),
FOREIGN KEY (id_grado) REFERENCES tb_grado(id),
FOREIGN KEY (id_seccion) REFERENCES tb_seccion(id)
)
create table tb_matricula_cursos(
id	bigint not null,
id_matricula	bigint not null,
id_cursos	bigint not null,
nota_final	decimal(4,2)
)
create table tb_detalle_matricula_curso(
id_mat_cur	bigint not null,
nota	decimal not null default 0.00,
porcentaje	int not null default 0,
id_espec	bigint not null,
FOREIGN KEY (id_mat_cur) REFERENCES tb_matricula_cursos(id),
FOREIGN KEY (id_espec) REFERENCES tb_especificacion(id)
)

--====================================================DATA

--maestros
INSERT INTO tb_tipo_documento (descripcion) VALUES ('DNI')
INSERT INTO tb_tipo_documento (descripcion) VALUES ('Pasaporte')
INSERT INTO tb_tipo_documento (descripcion) VALUES ('Carnet de extrangeria')

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

INSERT INTO  tb_seccion	(descripcion) VALUES ('A')
INSERT INTO  tb_seccion	(descripcion) VALUES ('B')
INSERT INTO  tb_seccion	(descripcion) VALUES ('C')

INSERT INTO tb_cursos (descripcion) VALUES ('Matemática')
INSERT INTO tb_cursos (descripcion) VALUES ('Comunicación')
INSERT INTO tb_cursos (descripcion) VALUES ('Quimica')
INSERT INTO tb_cursos (descripcion) VALUES ('Fisica')

INSERT INTO tb_cargos (descripcion) VALUES ('root')
INSERT INTO tb_cargos (descripcion) VALUES ('Administrador')
INSERT INTO tb_cargos (descripcion) VALUES ('Secretaria')
INSERT INTO tb_cargos (descripcion) VALUES ('Cordinador')
INSERT INTO tb_cargos (descripcion) VALUES ('Asistente')

INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Inscripciones','Registro de usuarios','ccc','Registro-usuarios')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Accesos','Administra permisos y accesos','ccc','Permisos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grados','Administra Grados y niveles','ccc','Grados')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Secciones','Administra Nombres de secciones','ccc','Secciones')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Matriculas','Registra nuevas Matriculas','ccc','Matriculas')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cursos','Creación de cursos','ccc','Cursos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Malla Curricular','Gestión cursos por grado','ccc','Cursos')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Gestión de docentes','administra el registro y datos de docentes','ccc','Docentes')
INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Gestión de administrativos','administra el registro y datos de personal administrativo','ccc','Administrativo')
