create database TUTORIALSDB
use TUTORIALSDB

/*ESTRUCTURA*/
create table tb_usuarios (
id bigint not null AUTO_INCREMENT,
nombres	varchar(200) not null,
mail	varchar(200) not null,
contrasena	varchar(50) not null,
tokenGoogle	varchar(200) not null,
tokenFacebook	varchar(200)not null,
tokenDinamico	varchar(200) null,
fechaRegistro	dateTime not null DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(id)
)

create table tb_sliders(
id	bigint not null AUTO_INCREMENT,
titulo	varchar(50) not null,
descripcion	varchar(200)not null,
imagen	varchar(200) not null,
estado tinyint not null DEFAULT 1,
PRIMARY KEY(id) 
)

create table tb_areas(
id	int not null AUTO_INCREMENT,
descripcion varchar(50) not null,
PRIMARY KEY (id)
)

create table tb_cursos (
id	bigint not null AUTO_INCREMENT,
idUsuario	bigint not null,
idArea int not null, 
nombre	varchar(50) not null,
imagen	varchar(100) not null,
descripcion	varchar(150) not null,
fechaRegistro	dateTime not null DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id),
FOREIGN KEY (idUsuario) REFERENCES tb_usuarios(id),
FOREIGN KEY (idArea) REFERENCES tb_areas(id)
)

create table tb_temas(
id	bigint not null AUTO_INCREMENT,
idCurso	bigint not null,
nombre	varchar(50) not null,
descripcion	varchar(150)not null,
PRIMARY KEY (id),
FOREIGN KEY (idCurso) REFERENCES tb_cursos(id) 
)

create table tb_mis_cursos(
idCurso	bigint not null,
idUsuario	bigint not null,
fechaRegistro dateTime DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (idCurso) REFERENCES tb_cursos(id),
FOREIGN KEY (idUsuario) REFERENCES tb_usuarios(id)
)

create table tb_suscripciones(
idCurso	bigint not null,
idUsuario	bigint not null,
fechaRegistro dateTime DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (idCurso) REFERENCES tb_cursos(id),
FOREIGN KEY (idUsuario) REFERENCES tb_usuarios(id)
)

create table tb_likes(
idCurso	bigint not null,
idusiario	bigint not null,
FOREIGN KEY (idCurso) REFERENCES tb_cursos(id),
FOREIGN KEY (idUsuario) REFERENCES tb_usuarios(id)
)

create table tb_dislikes(
idCurso	bigint not null,
idusiario	bigint not null,
FOREIGN KEY (idCurso) REFERENCES tb_cursos(id),
FOREIGN KEY (idUsuario) REFERENCES tb_usuarios(id)
)

create table tb_entradas(
id	bigint not null AUTO_INCREMENT,
idTema bigint not null,
numPaso	int not null,
titulo	varchar(50) not null,
descripcion	varchar(150) not null,
PRIMARY KEY (id),
FOREIGN KEY (idTema) REFERENCES tb_temas(id)
)

create table tb_detalle_entrada(
idEntrada	bigint not null,
descripcion	text no null,
FOREIGN KEY (idEntrada) REFERENCES tb_entradas(id)
)

create table tb_comentarios(
idEntrada	bigint not null,
nombre	varchar(200) not null,
comentario	varchar(250) not null,
respuesta	varchar(250) null,
FOREIGN KEY (idEntrada) REFERENCES tb_entradas(id)
)

create table tb_imagenes(
idEntrada	bigint not null,
ruta varchar(100) not null,
FOREIGN KEY (idEntrada) REFERENCES tb_entradas(id)
)

create table tb_videos(
idEntrada bigint not null,
ruta varchar(100) not null,
FOREIGN KEY (idEntrada) REFERENCES tb_entradas(id)
)
 
 
/*PROCEDURES*/
create procedure SP_LOGIN_LOCAL (email varchar(200),pws varchar(50))
SELECT id,nombres,tokenDinamico as 'token' FROM tb_usuarios WHERE mail=email AND contrasena=pws LIMIT 1
end

create procedure SP_LOGIN_FB (token_fb varchar(200))
SELECT id,nombres,tokenDinamico as 'token' FROM tb_usuarios WHERE tokenFacebook=token_fb
end

create procedure SP_LOGIN_GL (token_gl varchar(200))
SELECT id,nombres,tokenDinamico as 'token' FROM tb_usuarios WHERE tokenGoogle=token_gl
end

create procedure SP_NUEVO_TOKEN_SESION (id_usuario bigint,token varchar(200))
UPDATE tb_usuarios SET tokenDinamico=token WHERE id=id_usuario
end

create procedure SP_LOGOUT(id_usuario bigint)
UPDATE tb_usuarios SET tokenDinamico=null WHERE id=id_usuario
end

create procedure SP_LISTAR_NOTICIAS()
SELECT id,titulo,descripcion,imagen FROM tb_sliders WHERE estado=1
end

create procedure SP_LISTA_CURSOS_SUBCRITOS(uduario_id bigint)
SELECT crs.id,crs.nombre,crs.descripcion,crs.imagen, 
(SELECT COUNT(*) FROM tb_likes lks WHERE lks.idCurso=crs.id ) as likes,
(SELECT COUNT(*) FROM tb_dislikes dlks WHERE dlks.idCurso=crs.id) as disklikes
FROM tb_suscripciones scrp INNER JOIN tb_cursos crs ON scrp.idCurso=crs.id WHERE scrp.idUsuario=uduario_id
end

create procedure SP_LISTAR_MIS_CURSOS(uduario_id bigint)
SELECT crs.id,crs.nombre,crs.descripcion,crs.imagen,
(SELECT COUNT(*) FROM tb_likes lks WHERE lks.idCurso=crs.id ) as likes,
(SELECT COUNT(*) FROM tb_dislikes dlks WHERE dlks.idCurso=crs.id) as disklikes
FROM tb_mis_cursos mscr INNER JOIN tb_cursos crs ON mscr.idCurso=crs.id WHERE mscr.idUsuario=uduario_id
end

create procedure SP_BUSCAR_CURSOS(curso_nombre varchar(100))
SELECT crs.id,crs.nombre,crs.descripcion,crs.imagen, 
(SELECT COUNT(*) FROM tb_likes lks WHERE lks.idCurso=crs.id ) as likes,
(SELECT COUNT(*) FROM tb_dislikes dlks WHERE dlks.idCurso=crs.id) as disklikes
FROM tb_cursos crs WHERE crs.nombre like '%'+curso_nombre+'%'
end

create procedure SP_DETALLE_CURSO(curso_id bigint)
SELECT id,nombre,descripcion,imagen,fechaRegistro,
(SELECT usr.nombres FROM tb_mis_cursos mscr INNER JOIN tb_usuarios usr.id=mscr.idUsuario WHERE mscr.idCurso=curso_id) as 'autor' 
FROM tb_cursos INNER JOIN  WHERE id=curso_id
end

create procedure SP_TEMAS_CURSO(curso_id bigint)
SELECT id,nombre,descripcion FROM tb_temas WHERE idCurso=curso_id
end





