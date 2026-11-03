/* ============================
   CREACIÓN DE TABLAS
   ============================ */

-- 1) DIVISION

CREATE TABLE DIVISION (
    den_oficial      VARCHAR2(100) PRIMARY KEY,
    nombre_comercial VARCHAR2(100) NOT NULL
);


-- 2) TEMPORADA

CREATE TABLE TEMPORADA (
    anyo_ini_fin VARCHAR2(15)  NOT NULL,
    id_division  VARCHAR2(100) NOT NULL,
    
    CONSTRAINT TEMPORADA_PK PRIMARY KEY (anyo_ini_fin, id_division),
    CONSTRAINT TEMPORADA_DIVISION_FK FOREIGN KEY (id_division)
        REFERENCES DIVISION (den_oficial)
);


-- 3) JORNADA

CREATE TABLE JORNADA (
    num_jornada  NUMBER(3)     NOT NULL,
    id_temporada VARCHAR2(15)  NOT NULL,
    id_division  VARCHAR2(100) NOT NULL,
  
  CONSTRAINT JORNADA_PK PRIMARY KEY (num_jornada, id_temporada, id_division),
  CONSTRAINT JORNADA_TEMPORADA_FK FOREIGN KEY (id_temporada, id_division)
      REFERENCES TEMPORADA (anyo_ini_fin, id_division),
  CONSTRAINT JORNADA_NUM_CHK CHECK (num_jornada > 0)
);


-- 4) ESTADIO

CREATE TABLE ESTADIO (
    nombre             VARCHAR2(120) PRIMARY KEY,
    capacidad          NUMBER(8),
    fecha_inauguracion NUMBER(4),
  
  CONSTRAINT ESTADIO_CAP_CHK CHECK (capacidad IS NULL OR capacidad > 0)
);


-- 5) EQUIPO

CREATE TABLE EQUIPO (
    nombre_oficial   VARCHAR2(120) PRIMARY KEY,
    nombre_corto     VARCHAR2(60),
    nombre_historico VARCHAR2(200),
    ciudad           VARCHAR2(80),
    fecha_fundacion  NUMBER(4),
    id_estadio       VARCHAR2(120),

    CONSTRAINT EQUIPO_ESTADIO_FK FOREIGN KEY (id_estadio)
        REFERENCES ESTADIO (nombre),
    CONSTRAINT EQUIPO_NOMBRE_CORTO_UQ UNIQUE (nombre_corto)
);


-- 6) EQUIPO_OTROS_NOMBRE

CREATE TABLE EQUIPO_OTROS_NOMBRE (
    id_equipo   VARCHAR2(120) NOT NULL,
    otro_nombre VARCHAR2(200) NOT NULL,
    CONSTRAINT EQUIPO_OTROS_NOMBRE_PK PRIMARY KEY (id_equipo, otro_nombre),
    CONSTRAINT EQUIPO_OTROS_NOMBRE_EQUIPO_FK FOREIGN KEY (id_equipo)
        REFERENCES EQUIPO (nombre_oficial)
);


-- 7) PARTIDO

CREATE TABLE PARTIDO (
    id_temporada    VARCHAR2(15)  NOT NULL,
    id_division     VARCHAR2(100) NOT NULL,
    num_jornada     NUMBER(3)     NOT NULL,
    juegaLocal      VARCHAR2(60)  NOT NULL,
    juegaVisitante  VARCHAR2(60)  NOT NULL,
    goles_local     NUMBER(2)     NOT NULL,
    goles_visitante NUMBER(2)     NOT NULL,
    fechaPartido    DATE,

  CONSTRAINT PARTIDO_PK PRIMARY KEY (id_temporada, id_division, num_jornada, juegaLocal),
  CONSTRAINT PARTIDO_JORNADA_FK FOREIGN KEY (num_jornada, id_temporada, id_division)
      REFERENCES JORNADA (num_jornada, id_temporada, id_division),
  CONSTRAINT PARTIDO_LOCAL_FK FOREIGN KEY (juegaLocal)
      REFERENCES EQUIPO (nombre_corto),
  CONSTRAINT PARTIDO_VISITANTE_FK FOREIGN KEY (juegaVisitante)
      REFERENCES EQUIPO (nombre_corto),
  CONSTRAINT PARTIDO_EQUIPOS_DISTINTOS_CHK CHECK (juegaLocal <> juegaVisitante),
  CONSTRAINT PARTIDO_GOLES_CHK CHECK (goles_local >= 0 AND goles_visitante >= 0)
);

ALTER TABLE PARTIDO ADD CONSTRAINT PARTIDO_UNQ_VISITANTE
  UNIQUE (num_jornada, id_temporada, id_division, juegaVisitante);