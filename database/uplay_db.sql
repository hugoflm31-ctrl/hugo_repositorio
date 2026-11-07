-- ==========================================
-- PROYECTO: UPLAY
-- BASE DE DATOS PARA RED SOCIAL DE VIDEOJUEGOS
-- ==========================================

CREATE DATABASE IF NOT EXISTS uplay_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE uplay_db;


-- ==========================================
-- 1. TABLA USUARIO
-- ==========================================

CREATE TABLE USUARIO (
    ID_USUARIO INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT,
    correo_electronico VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    ROL VARCHAR(50) NOT NULL DEFAULT 'USUARIO_APP',
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,

    CHECK (edad IS NULL OR edad >= 0),
    CHECK (ROL IN ('USUARIO_APP', 'MODERADOR', 'ADMIN')),
    CHECK (estado IN ('ACTIVO', 'SUSPENDIDO', 'INACTIVO'))
) ENGINE=InnoDB;


-- ==========================================
-- 2. TABLA CUENTAVIDEOJUEGO
-- Guarda las cuentas de videojuegos del usuario
-- ==========================================

CREATE TABLE CUENTAVIDEOJUEGO (
    ID_CUENTA INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    plataforma VARCHAR(50) NOT NULL,
    gamertag VARCHAR(100) NOT NULL,

    CONSTRAINT fk_cuenta_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    UNIQUE (ID_USUARIO, plataforma, gamertag)
) ENGINE=InnoDB;


-- ==========================================
-- 3. TABLA VIDEOJUEGO
-- Catálogo de videojuegos disponibles en UPlay
-- ==========================================

CREATE TABLE VIDEOJUEGO (
    ID_VIDEOJUEGO INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    genero VARCHAR(80),
    plataforma VARCHAR(50),
    descripcion TEXT
) ENGINE=InnoDB;


-- ==========================================
-- 4. TABLA USUARIO_VIDEOJUEGO
-- Relaciona usuarios con sus videojuegos favoritos
-- ==========================================

CREATE TABLE USUARIO_VIDEOJUEGO (
    ID_USUARIO_VIDEOJUEGO INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    ID_VIDEOJUEGO INT NOT NULL,

    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_uv_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    CONSTRAINT fk_uv_videojuego
    FOREIGN KEY (ID_VIDEOJUEGO)
    REFERENCES VIDEOJUEGO(ID_VIDEOJUEGO)
    ON DELETE CASCADE,

    UNIQUE (ID_USUARIO, ID_VIDEOJUEGO)
) ENGINE=InnoDB;


-- ==========================================
-- 5. TABLA CLIP
-- Guarda los videos publicados por los usuarios
-- ==========================================

CREATE TABLE CLIP (
    ID_CLIP INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    clip_url VARCHAR(500) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_clip_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 6. TABLA EVENTOS
-- Guarda torneos y actividades
-- ==========================================

CREATE TABLE EVENTOS (
    ID_EVENTOS INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATETIME NOT NULL,
    fecha_final DATETIME NOT NULL,
    tipo_evento VARCHAR(50),

    CHECK (fecha_final > fecha_inicio)
) ENGINE=InnoDB;


-- ==========================================
-- 7. TABLA EVENTO_USUARIO
-- Registra los participantes de cada evento
-- ==========================================

CREATE TABLE EVENTO_USUARIO (
    ID_EVENTO_USUARIO INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    ID_EVENTOS INT NOT NULL,
    fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30) DEFAULT 'INSCRITO',

    CONSTRAINT fk_eu_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    CONSTRAINT fk_eu_evento
    FOREIGN KEY (ID_EVENTOS)
    REFERENCES EVENTOS(ID_EVENTOS)
    ON DELETE CASCADE,

    UNIQUE (ID_USUARIO, ID_EVENTOS),

    CHECK (estado IN ('INSCRITO', 'CANCELADO', 'PARTICIPO'))
) ENGINE=InnoDB;


-- ==========================================
-- 8. TABLA GRUPO
-- Guarda los grupos creados por los usuarios
-- ==========================================

CREATE TABLE GRUPO (
    ID_GRUPO INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    nombre_grupo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_grupo_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- ==========================================
-- 9. TABLA MIEMBRO_GRUPO
-- Registra los integrantes de cada grupo
-- ==========================================

CREATE TABLE MIEMBRO_GRUPO (
    ID_MIEMBRO_GRUPO INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    ID_GRUPO INT NOT NULL,
    ROL VARCHAR(50) DEFAULT 'MIEMBRO',
    fecha_union DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_miembro_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    CONSTRAINT fk_miembro_grupo
    FOREIGN KEY (ID_GRUPO)
    REFERENCES GRUPO(ID_GRUPO)
    ON DELETE CASCADE,

    UNIQUE (ID_USUARIO, ID_GRUPO),

    CHECK (ROL IN ('MIEMBRO', 'MODERADOR', 'ADMIN'))
) ENGINE=InnoDB;


-- ==========================================
-- 10. TABLA AMISTAD
-- Permite conectar usuarios entre sí
-- ==========================================

CREATE TABLE AMISTAD (
    ID_AMISTAD INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    ID_AMIGO INT NOT NULL,
    estado VARCHAR(30) DEFAULT 'PENDIENTE',
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_amistad_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    CONSTRAINT fk_amistad_amigo
    FOREIGN KEY (ID_AMIGO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    UNIQUE (ID_USUARIO, ID_AMIGO),

    CHECK (ID_USUARIO < ID_AMIGO),
    CHECK (estado IN ('PENDIENTE', 'ACEPTADA', 'RECHAZADA'))
) ENGINE=InnoDB;


-- ==========================================
-- 11. TABLA REACCION
-- Guarda las reacciones a los clips
-- ==========================================

CREATE TABLE REACCION (
    ID_REACCION INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    ID_CLIP INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reaccion_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    CONSTRAINT fk_reaccion_clip
    FOREIGN KEY (ID_CLIP)
    REFERENCES CLIP(ID_CLIP)
    ON DELETE CASCADE,

    UNIQUE (ID_USUARIO, ID_CLIP),

    CHECK (tipo IN ('LIKE', 'ME_ENCANTA', 'DIVERTIDO', 'SORPRENDIDO'))
) ENGINE=InnoDB;


-- ==========================================
-- 12. TABLA NOTIFICACION
-- Guarda las notificaciones de los usuarios
-- ==========================================

CREATE TABLE NOTIFICACION (
    ID_NOTIFICACION INT AUTO_INCREMENT PRIMARY KEY,
    ID_USUARIO INT NOT NULL,
    ID_USUARIO_ORIGEN INT,
    tipo VARCHAR(50) NOT NULL,
    noticia VARCHAR(150) NOT NULL,
    informacion TEXT,
    estado VARCHAR(20) DEFAULT 'NO_LEIDA',
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_notificacion_usuario
    FOREIGN KEY (ID_USUARIO)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE CASCADE,

    CONSTRAINT fk_notificacion_origen
    FOREIGN KEY (ID_USUARIO_ORIGEN)
    REFERENCES USUARIO(ID_USUARIO)
    ON DELETE SET NULL,

    CHECK (estado IN ('NO_LEIDA', 'LEIDA'))
) ENGINE=InnoDB;


-- ==========================================
-- FIN DE LA BASE DE DATOS UPLAY
-- ==========================================