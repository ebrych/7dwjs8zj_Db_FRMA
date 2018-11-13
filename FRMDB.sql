--use master
--drop DATABASE FRMDB
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
    estado	tinyint default 1,
    PRIMARY KEY (id),
    FOREIGN KEY (id_cargo) REFERENCES tb_cargo(id)
    )
    create table tb_usuario(
    id	bigint identity(1,1) not null,
    nombre	varchar(100) not null,
    apellidos	varchar(200)not null,
    tipo_doc	int not null,
    num_doc	varchar(25) not null,
    usuario	varchar(20) not null,
    pass	varchar(20) not null,
    token	varchar(10) null,
    fech_reg	dateTime default sysdatetime() not null,
    PRIMARY KEY(id),
    FOREIGN KEY (tipo_doc) REFERENCES tb_tipo_documento(id)
    )
    create table tb_cargo_usuario(
    id_usuario	bigint not null,
    id_cargo	int not null,
    FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
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

    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Personal','Registro de personal','fas fa-users','Personal')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Inscripciones','Registro de alumnos','fas fa-user-graduate','Alumnos')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Detalles de Usuarios','Gestión de datos de usuarios','fas fa-info-circle','Detalles') 
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Permisos','Gestión de permisos del sistema','fas fa-lock','Permisos')--asigna permisos/usuario
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cargos','Gestión de cargos','fas fa-id-card-alt','Cargos') --aqui se asigna plantilla permiso/cargo (cuando se ingrese el usuario se toma e inserta todos los permisos...despues puede añadir o quitar desde usuario_permiso)
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Malla Curricular','Gestión de mallas curriculares','fas fa-layer-group','MallaCurricular')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Matriculas','Gestión de matriculas','fas fa-tasks','Matriculas')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grados','Gestión de grados y niveles','fas fa-ellipsis-v','Niveles')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Secciones','Gestión de secciones','fas fa-grip-horizontal','Secciones')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Cursos','Gestión de cursos','fas fa-book','Cursos')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Especificaciones','Gestión de especificaciones de calificacion','fas fa-clipboard-check','Especificaciones')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Grupos','Agrupación de Especificaciones','far fa-object-group','Grupos')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Asignacion de cursos','Gestión de cursos a docentes','fas fa-chalkboard-teacher','AsignaCurso')
    INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Academico','Gestión de datos academicos','fas fa-highlighter','Academico') --ingreso de notas a tabla detalle_matricula_curso
	INSERT INTO tb_permisos (titulo,descripcion,icono,controlador) VALUES ('Apoderados','Gestión de Apoderados','fab fa-black-tie','Apoderados')
    SELECT * FROM tb_permisos


    INSERT INTO tb_usuario (nombre,apellidos,tipo_doc,num_doc,usuario,pass) VALUES ('Eber David','Baldarrago',1,'43744482','Root','123')
    SELECT * FROM tb_usuario

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

            
    --===========================DATOS DEMO
	INSERT INTO tb_cargo (descripcion) VALUES ('Ninguno')
    INSERT INTO tb_cargo (descripcion) VALUES ('Root')
    SELECT * FROM tb_cargo

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
exec SP_LOGIN 'Root','123'

create procedure SP_LOGOUT
    (
    @id bigint
    )
    as
    UPDATE tb_usuario set token=null WHERE id=@id
go
exec SP_LOGOUT 1

create procedure SP_MIS_PERMISOS
    (
    @id bigint
    )
    as
    SELECT 
    pr.titulo,pr.descripcion,pr.icono,pr.controlador 
    FROM tb_permiso_usuario prUs INNER JOIN tb_permisos pr on prUs.id_permiso=pr.id WHERE prUs.id_usuario=@id
go
exec SP_MIS_PERMISOS 1

create procedure SP_CONTROL_PERMISOS(
    @id bigint,
    @permiso int
    )
    as
    SELECT count(*) FROM tb_permiso_usuario WHERE id_usuario=@id AND id_permiso=@permiso
go
exec SP_CONTROL_PERMISOS 1,1
create procedure SP_CONTROL_TOKENS(
    @id bigint,
    @token varchar(10)
    )
    as
    SELECT count(*) FROM tb_usuario WHERE token=@token AND id=@token
go

--tipoDocumento
create procedure SP_LISTAR_TIPO_DOC
    as
    SELECT id,descripcion FROM tb_tipo_documento 
go

--cargos
create procedure SP_LISTAR_CARGOS
    as 
    SELECT cr.id,cr.descripcion,cr.estado,
    case
        when cr.estado=0 then 'Inactivo'
        when cr.estado=1 then 'Activo'
    end as 'estadoDesc'   
    FROM tb_cargo cr WHERE id != 2
go
create procedure SP_AGREGAR_CARGO(
    @descripcion varchar(100)
    )
    as
    INSERT INTO tb_cargo (descripcion) VALUES (@descripcion)
go
create procedure SP_ACTUALIZA_CARGO(
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
create procedure SP_LISTAR_CURSOS
    as
    SELECT cr.id,cr.descripcion,cr.estado,
    case
        when cr.estado=0 then 'Inactivo'
        when cr.estado=1 then 'Activo'
    end as 'estadoDesc'
    FROM tb_cursos cr  
go
create procedure SP_AGREGAR_CURSO(
    @descripcion varchar(50)
    )
    as
    INSERT INTO tb_cursos (descripcion) VALUES (@descripcion)
go
create procedure SP_ACTUALIZA_CURSO(
    @id int,
    @descripcion varchar(50)
    )
    as
    UPDATE tb_cursos SET descripcion=@descripcion WHERE id=@id
go
create procedure SP_ELIMINA_CURSO(
    @id int
    )
    as
    UPDATE tb_cursos SET estado=0 WHERE id=@id
go

--secciones
create procedure SP_LISTAR_SECCIONES
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
    @descriprion varchar(20)
    )
    as
    INSERT INTO tb_seccion (descripcion) VALUES (@descriprion)
go
create procedure SP_ACTUALIZA_SECCION(
    @id int,
    @descriprion varchar(20)
    )
    as
    UPDATE tb_seccion SET descripcion=@descriprion WHERE id=@id
go
create procedure SP_ELIMINA_SECCION(
    @id int
    )
    as
    UPDATE tb_seccion SET descripcion=0 WHERE id=@id
go

--grados
create procedure SP_LISTAR_GRADOS
    as
    SELECT gr.id,gr.descripcion,gr.estado,
    case
        when gr.estado=0 then 'Inactivo'
        when gr.estado=1 then 'Activo'
    end as 'estadoDesc' 
    FROM tb_grado gr
go
create procedure SP_AGREGAR_GRADO(
    @descriprion varchar(20),
    @sigla varchar(8)
    )
    as
    INSERT INTO tb_grado (descripcion,sigla) VALUES (@descriprion,@sigla)
go
create procedure SP_ACTUALIZA_GRADO(
    @id int,
    @descriprion varchar(20) 
    )
    as
    UPDATE tb_grado SET descripcion=@descriprion WHERE id=@id
go
create procedure SP_ELIMINA_GRADO(
    @id int 
    )
    as
    UPDATE tb_grado SET descripcion=0 WHERE id=@id
go

--ciclos academicos
create procedure SP_LISTAR_CLICLO_ACACEMICO
    as
    SELECT  
    cl.id,cl.nombre,CONVERT(VARCHAR,cl.fecha_ini,121),CONVERT(VARCHAR,cl.fech_fin,121),
    case
        when cl.estado=0 then 'Inactivo'
        when cl.estado=1 then 'Activo'
    end as 'estadoDesc'
    FROM tb_cliclo_academico cl
go
create procedure SP_AGREGAR_CLICLO_ACADEMICO(
    @nombre	varchar(50),
    @fecha_ini	varchar(10),
    @fech_fin	varchar(10)
    )
    as
    INSERT INTO tb_cliclo_academico (nombre,fecha_ini,fech_fin) VALUES (@nombre,@fecha_ini,@fech_fin)
go
create procedure SP_ACTUALIZA_CLICLO_ACADEMICO(
    @id int,
    @nombre	varchar(50),
    @fecha_ini	varchar(10),
    @fech_fin	varchar(10)
    )
    as
    UPDATE tb_cliclo_academico SET nombre=@nombre,fecha_ini=@fecha_ini,fech_fin=@fech_fin WHERE id=@id
go
create procedure SP_ELIMINA_CICLO_ACADEMICO(
        @id int
    )
    as
    UPDATE tb_cliclo_academico SET estado=0 WHERE id=@id
go

--plantillas permisos
create procedure SP_LISTAR_PLANTILLA_PERMISO(
    @cargo int
    )
    as
    SELECT plt.id_permiso,pr.descripcion FROM tb_pantilla_cargo_permiso plt INNER JOIN tb_permisos pr ON pr.id=plt.id_permiso WHERE plt.id_cargo=@cargo
go
create procedure SP_INSERTA_PERMISO_CARGO_PLANTILLA(
    @cargo int,
    @permiso int
    )
    as
    DECLARE
    @exist int
    SELECT @exist=count(*) FROM tb_pantilla_cargo_permiso WHERE id_cargo=@cargo AND id_permiso=@permiso
    IF @exist=0
    INSERT INTO tb_pantilla_cargo_permiso (id_cargo,id_permiso) VALUES (@cargo,@permiso)
go
create procedure SP_ELIMINA_PERMISO_CARGO_PLANTILLA(
    @cargo int,
    @permiso int
    )
    as
    DELETE FROM tb_pantilla_cargo_permiso WHERE id_cargo=@cargo AND id_permiso=@permiso
go

--detalles
create procedure SP_LISTAR_DETALLES
    as
    SELECT dtll.id,cr.descripcion as 'cargo',dtll.placeholder  FROM tb_detalles dtll INNER JOIN tb_cargo cr ON cr.id=dtll.id_cargo
go
create procedure SP_AGREGAR_DETALLE(
    @cargo int,
    @descripcion varchar(100),
    @placeholder varchar(100)
    )
    as
    INSERT INTO tb_detalles (descripcion,placeholder,id_cargo)VALUES(@descripcion,@placeholder,@cargo)
go
create procedure SP_LISTAR_DETALLE_USUARIO(
@id bigint
)
as
SELECT dt.id,dt.descripcion,dtlls.valor FROM tb_usuario_detalle dtlls INNER JOIN tb_detalles dt ON dt.id=dtlls.id_detalle WHERE dtlls.id_usuario=@id
go
create procedure SP_AGREGAR_DETALLE_USUARIO(
    @id bigint,
    @detalle int
    )
    as
    DECLARE
    @exist int
    SELECT @exist=count(*) FROM tb_usuario_detalle WHERE id_detalle=@detalle AND id_usuario=@id
    IF @exist=0
    INSERT INTO tb_usuario_detalle (id_detalle,id_usuario) VALUES (@detalle,@id)
go
create procedure SP_ACTUALIZA_CARGO_DETALLE(
    @id int,
    @cargo int,
    @descripcion varchar(100),
    @placeholder varchar(100)   
    )
    as
    UPDATE tb_detalles SET id_cargo=@cargo,descripcion=@descripcion,placeholder=@placeholder WHERE id=@id
go
create procedure SP_ELIMINA_DETALLE(
    @id int
    )
    as
    UPDATE tb_detalles set estado=0 WHERE id=@id
go

--usuarios
create procedure SP_AGREGAR_USUARIO(
    @nombre	varchar(100),
    @apellidos	varchar(200),
    @tipo_doc	int,
    @num_doc	varchar(25),
    @user	varchar(20),
    @pass	varchar(20)   
    )
    as
    INSERT INTO tb_usuario (nombre,apellidos,tipo_doc,num_doc,usuario,pass) VALUES (@nombre,@apellidos,@tipo_doc,@num_doc,@user,@pass)
go
create procedure SP_BUSCA_INTERNO_ID_USUARIO(
    @num_doc varchar(25)    
    )
    as
    SELECT top(1)id FROM tb_usuario WHERE num_doc=@num_doc
go
create procedure SP_AGREGA_CARGO_USUARIO(
    @id bigint,
    @cargo int 
    )
    as
    DECLARE
    @exist int
    SELECT @exist=count(*) FROM tb_cargo_usuario WHERE id_usuario=@id AND id_cargo=@cargo
    IF @exist=0
    INSERT INTO tb_cargo_usuario (id_usuario,id_cargo) VALUES (@id,@cargo)
go
create procedure SP_ELIMINA_CARGO_USUARIO(
    @id bigint,
    @cargo int
    )
    as
    DELETE FROM tb_cargo_usuario WHERE id_usuario=@id AND id_cargo=@cargo
go
create procedure SP_LISTAR_CARGO_USUARIO(
    @id bigint
    )
    as
    SELECT cr.id,cr.descripcion FROM tb_cargo_usuario crUs INNER JOIN tb_cargo cr ON cr.id=crUs.id_cargo WHERE crUs.id_usuario=@id 
go
create procedure SP_AUTO_AGREGA_PERMISO_USUARIO(
    @id bigint,
    @cargo int
    )
    as
    INSERT INTO tb_permiso_usuario
    SELECT @id as 'id_usuario',plt.id_permiso as 'id_permiso' FROM tb_pantilla_cargo_permiso plt WHERE plt.id_cargo=@cargo
go
create procedure SP_AUTO_ELMINA_PERMISO_USUARIO(
    @id bigint,
    @cargo int  
    )
    as
    DELETE FROM tb_permiso_usuario 
    WHERE id_permiso IN (SELECT * FROM tb_pantilla_cargo_permiso plt WHERE plt.id_cargo=@id)
    AND id_usuario=@id 
go
create procedure SP_LISTAR_USUARIOS(
    @usuario bigint,
    @cargo int
    )
    as
    SELECT us.id,us.nombre,us.apellidos,us.tipo_doc,tpoDoc.descripcion 
	FROM tb_cargo_usuario crUs 
	INNER JOIN tb_usuario us ON crUs.id_usuario=us.id 
	INNER JOIN tb_tipo_documento tpoDoc ON tpoDoc.id=us.tipo_doc WHERE crUs.id_cargo=@cargo 
go
create procedure SP_BUSCAR_USUARIO(
    @id bigint
    )
    as
    SELECT us.id,us.nombre,us.apellidos,us.tipo_doc as 'id_tipo_doc' ,tpoDoc.descripcion as 'documento',us.num_doc as 'numDoc' 
    FROM tb_usuario us INNER JOIN tb_tipo_documento tpoDoc ON tpoDoc.id=us.tipo_doc WHERE us.id=@id
go
create procedure SP_ELIMINA_DETALLE_USUARIO(
    @id bigint,
    @detalle int 
    )
    as
    DELETE FROM tb_usuario_detalle WHERE id_usuario=@id AND id_detalle=@detalle
go
create procedure SP_LISTA_PERMISOS_USUARIO(
    @id bigint
    )
    as
    SELECT pr.id,pr.descripcion,pr.icono FROM tb_permiso_usuario prUs INNER JOIN tb_permisos pr on prUs.id_permiso=pr.id WHERE prUs.id_usuario=@id
go
create procedure SP_AGREGA_PERMISO_USUARIO(
    @id bigint,
    @permiso int
    )
    as
    INSERT INTO tb_permiso_usuario (id_permiso,id_usuario)VALUES(@permiso,@id)
go
create procedure SP_ELIMINA_PERMISO_USUARIO(
    @id bigint,
    @permiso int   
    )
    as
    DELETE FROM tb_permiso_usuario WHERE id_usuario=@id AND id_permiso=@permiso
go

--apoderado-alumno
create procedure SP_LISTA_MIS_HIJOS(
    @id bigint
    )
    as
    SELECT us.id,us.nombre,us.apellidos FROM tb_apoderado_alumno alms INNER JOIN tb_usuario us ON alms.id_alumno=us.id WHERE id_apoderado=@id
go
create procedure SP_AGREGA_HIJO_APODERADO(
    @hijo bigint,
    @padre bigint
    )
    as
    INSERT INTO tb_apoderado_alumno (id_apoderado,id_alumno) VALUES (@padre,@hijo)
go
create procedure SP_ELIMINA_HIJO_APODERADO(
    @hijo bigint,
    @padre bigint
    )
    as
    DELETE FROM tb_apoderado_alumno WHERE id_alumno=@hijo AND id_apoderado=@padre
go
