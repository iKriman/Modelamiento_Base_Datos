DROP TABLE REGION CASCADE CONSTRAINT;
DROP TABLE COMUNA CASCADE CONSTRAINT;
DROP TABLE TIPO_MAQUINA CASCADE CONSTRAINT;
DROP TABLE MAQUINA CASCADE CONSTRAINT;
DROP TABLE PLANTA CASCADE CONSTRAINT;
DROP TABLE SALUD CASCADE CONSTRAINT;
DROP TABLE AFP CASCADE CONSTRAINT;
DROP TABLE EMPLEADO CASCADE CONSTRAINT;
DROP TABLE JEFE_TURNO CASCADE CONSTRAINT;
DROP TABLE OPERARIO CASCADE CONSTRAINT;
DROP TABLE TEC_MANTENCION CASCADE CONSTRAINT;
DROP TABLE MANTENCION CASCADE CONSTRAINT;
DROP TABLE PLANIFICACION CASCADE CONSTRAINT;
DROP TABLE TURNOS CASCADE CONSTRAINT;

-- drop sequence 
DROP SEQUENCE SEQ_idRegion;

CREATE TABLE AFP 
    ( 
     id_afp NUMBER  NOT NULL , 
     nombre VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE AFP 
    ADD CONSTRAINT AFP_PK PRIMARY KEY ( id_afp ) ;
 
ALTER TABLE AFP ADD CONSTRAINT UQ_NOMBRE_AFP UNIQUE (nombre);    

CREATE TABLE COMUNA 
    ( 
     id_comuna NUMBER  GENERATED ALWAYS AS IDENTITY
     START WITH 1050
     MINVALUE 1050
     NOMAXVALUE
     INCREMENT BY 5
     NOT NULL, 
     nombre    VARCHAR2 (50)  NOT NULL , 
     id_region NUMBER  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna ) ;

CREATE TABLE EMPLEADO 
    ( 
     id_empleado   NUMBER  NOT NULL , 
     rut           VARCHAR2 (12)  NOT NULL , 
     nombres       VARCHAR2 (50)  NOT NULL , 
     apePat        VARCHAR2 (15)  NOT NULL , 
     apeMat        VARCHAR2 (15)  NOT NULL , 
     contratacion  DATE  NOT NULL , -- fecha de inicio de actividades 
     sueldo_base   NUMBER  NOT NULL , 
     activo        CHAR (1) DEFAULT 'S'  NOT NULL , --  estado activo (S/N) by default S
     id_planta     NUMBER  NOT NULL , 
     id_afp        NUMBER  NOT NULL , 
     id_salud      NUMBER  NOT NULL , 
     id_jefe       NUMBER 
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_PK PRIMARY KEY ( id_empleado ) ;
    
ALTER TABLE EMPLEADO ADD CONSTRAINT UN_RUT UNIQUE (rut);
ALTER TABLE EMPLEADO ADD CONSTRAINT CK_ACTIVO CHECK ( activo IN ('S', 'N'));
ALTER TABLE EMPLEADO ADD CONSTRAINT CK_SUELDO CHECK ( sueldo_base > 0);

CREATE TABLE JEFE_TURNO 
    ( 
     area_Resp     VARCHAR2 (50)  NOT NULL , -- area de responosabilidad
     operarios_max NUMBER  NOT NULL , --  numero maximo de operarios a coordinar por turno
     id_empleado   NUMBER  NOT NULL 
    ) 
;


ALTER TABLE JEFE_TURNO 
    ADD CONSTRAINT JEFE_TURNO_PK PRIMARY KEY ( id_empleado ) ;

ALTER TABLE JEFE_TURNO ADD CONSTRAINT CH_OPERARIOS CHECK (operarios_max > 0);

CREATE TABLE MANTENCION 
    ( 
     id_mantencion NUMBER  NOT NULL , 
     fecha_prog    DATE  NOT NULL , -- fecha programada
     fecha_ejec    DATE ,  -- fecha ejecucion  si ya fue realizada
     descripcion   VARCHAR2 (100)  NOT NULL , 
     id_tec        NUMBER  NOT NULL , 
     id_maquina    NUMBER  NOT NULL , 
     id_empleado   NUMBER  NOT NULL 
    ) 
;

ALTER TABLE MANTENCION 
    ADD CONSTRAINT MANTENCION_PK PRIMARY KEY ( id_mantencion ) ;
    
ALTER TABLE MANTENCION ADD CONSTRAINT CK_FECHA CHECK (fecha_ejec IS NULL OR fecha_ejec >= fecha_prog);

CREATE TABLE MAQUINA 
    ( 
     id_maquina NUMBER  NOT NULL , 
     nombre     VARCHAR2 (50)  NOT NULL , 
     activo     CHAR (1)  NOT NULL , -- estado activo (S/N)
     id_planta  NUMBER  NOT NULL , 
     id_tipo    NUMBER  NOT NULL 
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT MAQUINA_PK PRIMARY KEY ( id_maquina ) ;

ALTER TABLE MAQUINA ADD CONSTRAINT CH_ACTIVO_MAQUINA CHECK (activo IN ('S','N'));

CREATE TABLE OPERARIO 
    ( 
     categoria     VARCHAR2 (50)  NOT NULL , -- categoría de proceso en la que trabajan: caliente, frío, inspección
     certificacion VARCHAR2 (50) , -- si es que aplica
     horas_turno   NUMBER  DEFAULT 8 NOT NULL , -- por defecto 8 horas por turno
     id_empleado   NUMBER  NOT NULL 
    ) 
;

ALTER TABLE OPERARIO ADD CONSTRAINT CH_HORA CHECK (horas_turno >= 8); 

ALTER TABLE OPERARIO 
    ADD CONSTRAINT OPERARIO_PK PRIMARY KEY ( id_empleado ) ;

CREATE TABLE PLANIFICACION 
    ( 
     id_planificacion     NUMBER  NOT NULL , 
     usuario_princi       VARCHAR2 (50)  NOT NULL , 
     fecha                DATE  NOT NULL , 
     id_empleado NUMBER  NOT NULL , 
     id_maquina   NUMBER  NOT NULL , 
     id_turno      VARCHAR2(50)  NOT NULL 
    ) 
;

ALTER TABLE PLANIFICACION 
    ADD CONSTRAINT PLANIFICACION_PK PRIMARY KEY ( id_planificacion ) ;

ALTER TABLE PLANIFICACION 
    ADD CONSTRAINT UN_PLANIFICACION UNIQUE ( id_empleado , fecha ) ;

CREATE TABLE PLANTA 
    ( 
     id_planta NUMBER  NOT NULL , 
     nombre    VARCHAR2 (50)  NOT NULL , 
     direccion VARCHAR2 (50)  NOT NULL , 
     id_comuna NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PLANTA 
    ADD CONSTRAINT PLANTA_PK PRIMARY KEY ( id_planta ) ;
 
ALTER TABLE PLANTA ADD CONSTRAINT UN_NOMBRE_PLANTA UNIQUE (nombre);    

CREATE TABLE REGION 
    ( 
     id_region NUMBER NOT NULL, 
     nombre    VARCHAR2 (50)  NOT NULL 
    ) 
;


ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region ) ;
    
 ALTER TABLE REGION ADD CONSTRAINT UN_NOMBRE_REGION UNIQUE (nombre);   

CREATE TABLE SALUD 
    ( 
     id_salud NUMBER  NOT NULL , 
     nombre   VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE SALUD 
    ADD CONSTRAINT SALUD_PK PRIMARY KEY ( id_salud ) ;
    
ALTER TABLE SALUD ADD CONSTRAINT UN_NOMBRE_SALUD UNIQUE (nombre);    

CREATE TABLE TEC_MANTENCION 
    ( 
     especialidad   VARCHAR2 (50)  NOT NULL , --por ejemplo: eléctrica, mecánica, instrumentación
     certificacion  VARCHAR2 (50) , -- si es que aplica
     tiem_respuesta NUMBER  NOT NULL , 
     id_empleado    NUMBER  NOT NULL 
    ) 
;


ALTER TABLE TEC_MANTENCION 
    ADD CONSTRAINT TEC_MANTENCION_PK PRIMARY KEY ( id_empleado ) ;
    
ALTER TABLE TEC_MANTENCION ADD CONSTRAINT CH_TIME_RESPUESTA CHECK (tiem_respuesta > 0);     

CREATE TABLE TIPO_MAQUINA 
    ( 
     id_tipo     NUMBER  NOT NULL , 
     nombre_tipo VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE TIPO_MAQUINA 
    ADD CONSTRAINT TIPO_MAQUINA_PK PRIMARY KEY ( id_tipo ) ;
 
ALTER TABLE TIPO_MAQUINA ADD CONSTRAINT UN_TIPO_MAQ UNIQUE (nombre_tipo);    

CREATE TABLE TURNOS 
    ( 
     id_turno    VARCHAR2(50) NOT NULL , 
     tipo        VARCHAR2 (10)  NOT NULL , -- manana, noche, tarde
     hora_inicio CHAR (5)  NOT NULL , 
     hora_salida CHAR (5)  NOT NULL 
    ) 
;

ALTER TABLE TURNOS 
    ADD CONSTRAINT TURNOS_PK PRIMARY KEY ( id_turno ) ;

ALTER TABLE TURNOS ADD CONSTRAINT UN_TIPO UNIQUE (tipo);

ALTER TABLE COMUNA 
    ADD CONSTRAINT COM_REG_FK FOREIGN KEY 
    ( 
        id_region
    ) 
    REFERENCES REGION 
    ( 
     id_region
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMP_AFP_FK FOREIGN KEY 
    ( 
     id_afp
    ) 
    REFERENCES AFP 
    ( 
     id_afp
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMP_EMP_FK FOREIGN KEY 
    ( 
     id_jefe
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;


ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMP_PLA_FK FOREIGN KEY 
    ( 
     id_planta
    ) 
    REFERENCES PLANTA 
    ( 
     id_planta
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMP_SAL_FK FOREIGN KEY 
    ( 
     id_salud
    ) 
    REFERENCES SALUD 
    ( 
     id_salud
    ) 
;

ALTER TABLE JEFE_TURNO 
    ADD CONSTRAINT JEF_TUR_EMP_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE MANTENCION 
    ADD CONSTRAINT MAN_MAQ_FK FOREIGN KEY 
    ( 
     id_maquina
    ) 
    REFERENCES MAQUINA 
    ( 
     id_maquina
    ) 
;

ALTER TABLE MANTENCION 
    ADD CONSTRAINT MAN_TEC_FK FOREIGN KEY 
    ( 
     id_tec
    ) 
    REFERENCES TEC_MANTENCION 
    ( 
     id_empleado
    ) 
;

ALTER TABLE MANTENCION ADD CONSTRAINT MAN_EMP_REP_FK FOREIGN KEY ( id_empleado ) REFERENCES EMPLEADO ( id_empleado );

ALTER TABLE MAQUINA 
    ADD CONSTRAINT MAQ_PLA_FK FOREIGN KEY 
    ( 
     id_planta
    ) 
    REFERENCES PLANTA 
    ( 
     id_planta
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT MAQ_TIP_MAQ_FK FOREIGN KEY 
    ( 
     id_tipo
    ) 
    REFERENCES TIPO_MAQUINA 
    ( 
     id_tipo
    ) 
;

ALTER TABLE OPERARIO 
    ADD CONSTRAINT OPE_EMP_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE PLANTA 
    ADD CONSTRAINT PLA_COM_FK FOREIGN KEY 
    ( 
     id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
    ) 
;

ALTER TABLE PLANIFICACION 
    ADD CONSTRAINT PLA_EMP_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE PLANIFICACION 
    ADD CONSTRAINT PLA_MAQ_FK FOREIGN KEY 
    ( 
     id_maquina
    ) 
    REFERENCES MAQUINA 
    ( 
     id_maquina
    ) 
;

ALTER TABLE PLANIFICACION 
    ADD CONSTRAINT PLA_TUR_FK FOREIGN KEY 
    ( 
     id_turno
    ) 
    REFERENCES TURNOS 
    ( 
     id_turno
    ) 
;

ALTER TABLE TEC_MANTENCION 
    ADD CONSTRAINT TEC_MAN_EMP_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;


-- SECUENCIAS

-- creacion de sequencia en region para que el id empiece en 21 y vaya de 1 en 1
CREATE SEQUENCE SEQ_idRegion
START WITH 21
MINVALUE 21
NOMAXVALUE
INCREMENT BY 1
NOCYCLE
NOCACHE;


-- POBLAMIENTO DE TABLAS

-- REGION
INSERT INTO REGION (id_region, nombre) VALUES (SEQ_idRegion.NEXTVAL, 'Region de Valparaiso');
INSERT INTO REGION (id_region, nombre) VALUES (SEQ_idRegion.NEXTVAL, 'Region Metropolitana');

-- COMUNA
INSERT INTO COMUNA (nombre, id_region) VALUES ('Quilpue', 21);
INSERT INTO COMUNA (nombre, id_region) VALUES ('Maipu', 22);

-- PLANTA
INSERT INTO PLANTA (id_planta, nombre, direccion, id_comuna) VALUES (45, 'Planta Oriente', 'Camino Industrial 1234', 1050);
INSERT INTO PLANTA (id_planta, nombre, direccion, id_comuna) VALUES (46, 'Planta Costa', 'Av. Vidrieras 890', 1055);

-- TURNO
INSERT INTO TURNOS (id_turno, tipo, hora_inicio, hora_salida) VALUES ('M0715', 'Mañana', '07:00', '15:00');
INSERT INTO TURNOS (id_turno, tipo, hora_inicio, hora_salida) VALUES ('N2307', 'Noche', '23:00', '07:00');
INSERT INTO TURNOS (id_turno, tipo, hora_inicio, hora_salida) VALUES ('T1523', 'Tarde', '15:00', '23:00');


-- INFORMES

-- informe 1: lista de turnos con hora de inicio posterior a las 20hrs, de manera desc por hora de inicio
SELECT
 id_turno AS TURNO,
 hora_inicio AS ENTRADA,
 hora_salida AS SALIDA
FROM 
 TURNOS
WHERE
 hora_inicio > '20:00'
ORDER BY
 hora_inicio DESC;
 
 -- informe 2: listar turnos diurnos con horario de incio entre 06:00 y 14:59 de manera asc por hora de inicio
SELECT
 id_turno AS TURNO,
 hora_inicio AS ENTRADA,
 hora_salida AS SALIDA
FROM 
 TURNOS
WHERE
 hora_inicio >= '06:00' AND hora_inicio <= '14:59'
ORDER BY
 hora_inicio ASC;
 
 
 

