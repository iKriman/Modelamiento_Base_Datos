DROP TABLE administrativo CASCADE CONSTRAINT;
DROP TABLE afp CASCADE CONSTRAINT;
DROP TABLE categoria CASCADE CONSTRAINT;
DROP TABLE comuna CASCADE CONSTRAINT;
DROP TABLE detalle_venta CASCADE CONSTRAINT;
DROP TABLE empleado CASCADE CONSTRAINT;
DROP TABLE marca CASCADE CONSTRAINT;
DROP TABLE medio_pago  CASCADE CONSTRAINT;
DROP TABLE producto CASCADE CONSTRAINT;
DROP TABLE proveedor CASCADE CONSTRAINT;
DROP TABLE region CASCADE CONSTRAINT;
DROP TABLE salud CASCADE CONSTRAINT;
DROP TABLE vendedor CASCADE CONSTRAINT;
DROP TABLE venta CASCADE CONSTRAINT;

DROP SEQUENCE SEQ_empleado;
DROP SEQUENCE SEQ_salud;


CREATE TABLE administrativo 
    ( 
     id_empleado NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE administrativo 
    ADD CONSTRAINT administrativo_pk PRIMARY KEY ( id_empleado ) ;

CREATE TABLE afp 
    ( 
     id_afp  NUMBER (5)  GENERATED ALWAYS AS IDENTITY
     START WITH 210
     MINVALUE 210
     NOMAXVALUE
     INCREMENT BY 6
     NOT NULL, 
     nom_afp VARCHAR2 (255)  NOT NULL 
    ) 
;

ALTER TABLE afp 
    ADD CONSTRAINT afp_pk PRIMARY KEY ( id_afp ) ;

CREATE TABLE categoria 
    ( 
     id_categoria     NUMBER (3)  NOT NULL , 
     nombre_categoria VARCHAR2 (255)  NOT NULL 
    ) 
;

ALTER TABLE categoria 
    ADD CONSTRAINT categoria_pk PRIMARY KEY ( id_categoria ) ;

CREATE TABLE comuna 
    ( 
     id_comuna  NUMBER (4)  NOT NULL , 
     nom_comuna VARCHAR2 (100)  NOT NULL , 
     cod_region NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE comuna 
    ADD CONSTRAINT comuna_pk PRIMARY KEY ( id_comuna ) ;

CREATE TABLE detalle_venta 
    ( 
     cod_venta    NUMBER (4)  NOT NULL , 
     cod_producto NUMBER (4)  NOT NULL , 
     cantidad     NUMBER (6)  NOT NULL 
    ) 
;

ALTER TABLE detalle_venta 
    ADD CONSTRAINT detalle_venta_pk PRIMARY KEY ( cod_venta, cod_producto ) ;

ALTER TABLE detalle_venta
ADD CONSTRAINT CK_restriccion_venta
CHECK (cantidad > 0);

CREATE TABLE empleado 
    ( 
     id_empleado        NUMBER (4)  NOT NULL , 
     rut_empleado       VARCHAR2 (11)  NOT NULL , 
     nombre_empleado    VARCHAR2 (25)  NOT NULL , 
     apellido_paterno   VARCHAR2 (25)  NOT NULL , 
     apellido_materno   VARCHAR2 (25)  NOT NULL , 
     fecha_contratacion DATE  NOT NULL , 
     sueldo_base        NUMBER (10)  NOT NULL , 
     bono_jefatura      NUMBER (10) , 
     activo             CHAR (1)  NOT NULL , 
     tipo_empleado      VARCHAR2 (25)  NOT NULL , 
     cod_empleado       NUMBER (4) , 
     cod_salud          NUMBER (4)  NOT NULL , 
     cod_afp            NUMBER (5)  NOT NULL 
    ) 
;

ALTER TABLE empleado 
    ADD CONSTRAINT empleado_pk PRIMARY KEY ( id_empleado ) ;

ALTER TABLE empleado
ADD CONSTRAINT CK_sueldo_minimo
CHECK (sueldo_base >= 400000);

CREATE TABLE marca 
    ( 
     id_marca     NUMBER (3)  NOT NULL , 
     nombre_marca VARCHAR2 (25)  NOT NULL 
    ) 
;

ALTER TABLE marca 
    ADD CONSTRAINT marca_pk PRIMARY KEY ( id_marca ) ;

ALTER TABLE marca
ADD CONSTRAINT UN_nombre_marca
UNIQUE (nombre_marca);

CREATE TABLE medio_pago 
    ( 
     id_mpago     NUMBER (3)  NOT NULL , 
     nombre_mpago VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE medio_pago 
    ADD CONSTRAINT medio_pago_pk PRIMARY KEY ( id_mpago ) ;

CREATE TABLE producto 
    ( 
     id_producto     NUMBER (4)  NOT NULL , 
     nombre_producto VARCHAR2 (100)  NOT NULL , 
     precio_unitario NUMBER  NOT NULL , 
     origen_nacional CHAR (1)  NOT NULL , 
     stock_minimo    NUMBER (3)  NOT NULL , 
     activo          CHAR (1)  NOT NULL , 
     cod_marca       NUMBER (3)  NOT NULL , 
     cod_categoria   NUMBER (3)  NOT NULL , 
     cod_proveedor   NUMBER (5)  NOT NULL 
    ) 
;

ALTER TABLE producto 
    ADD CONSTRAINT producto_pk PRIMARY KEY ( id_producto ) ;

ALTER TABLE producto
ADD CONSTRAINT CK_stock_minimo
CHECK (stock_minimo >= 3);

CREATE TABLE proveedor 
    ( 
     id_proveedor     NUMBER (5)  NOT NULL , 
     nombre_proveedor VARCHAR2 (150)  NOT NULL , 
     rut_proveedor    VARCHAR2 (10)  NOT NULL , 
     telefono         VARCHAR2 (10)  NOT NULL , 
     email            VARCHAR2 (200)  NOT NULL , 
     direccion        VARCHAR2 (200)  NOT NULL , 
     cod_comuna       NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE proveedor 
    ADD CONSTRAINT proveedor_pk PRIMARY KEY ( id_proveedor ) ;

ALTER TABLE proveedor
ADD CONSTRAINT UN_email_proveedor
UNIQUE (email);

CREATE TABLE region 
    ( 
     id_region  NUMBER (4)  NOT NULL , 
     nom_region VARCHAR2 (255)  NOT NULL 
    ) 
;

ALTER TABLE region 
    ADD CONSTRAINT region_pk PRIMARY KEY ( id_region ) ;

CREATE TABLE salud 
    ( 
     id_salud  NUMBER (4)  NOT NULL , 
     nom_salud VARCHAR2 (40)  NOT NULL 
    ) 
;

ALTER TABLE salud 
    ADD CONSTRAINT salud_pk PRIMARY KEY ( id_salud ) ;

CREATE TABLE vendedor 
    ( 
     id_empleado    NUMBER (4)  NOT NULL , 
     comision_venta NUMBER (5,2)  NOT NULL 
    ) 
;

ALTER TABLE vendedor 
    ADD CONSTRAINT vendedor_pk PRIMARY KEY ( id_empleado ) ;

ALTER TABLE vendedor
ADD CONSTRAINT ck_porcentaje_comision
CHECK (comision_venta BETWEEN 0 AND 0.25);

CREATE TABLE venta 
    ( 
     id_venta     NUMBER (4)  GENERATED ALWAYS AS IDENTITY
     START WITH 5050
     MINVALUE 5050
     NOMAXVALUE
     INCREMENT BY 3
     NOT NULL , 
     fecha_venta  DATE  NOT NULL , 
     total_venta  NUMBER (10)  NOT NULL , 
     cod_mpago    NUMBER (3)  NOT NULL , 
     cod_empleado NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE venta 
    ADD CONSTRAINT venta_pk PRIMARY KEY ( id_venta ) ;

ALTER TABLE administrativo 
    ADD CONSTRAINT admin_fk_empleado FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE comuna 
    ADD CONSTRAINT comuna_fk_region FOREIGN KEY 
    ( 
     cod_region
    ) 
    REFERENCES region 
    ( 
     id_region
    ) 
;

ALTER TABLE detalle_venta 
    ADD CONSTRAINT det_venta_fk_producto FOREIGN KEY 
    ( 
     cod_producto
    ) 
    REFERENCES producto 
    ( 
     id_producto
    ) 
;

ALTER TABLE detalle_venta 
    ADD CONSTRAINT det_venta_fk_venta FOREIGN KEY 
    ( 
     cod_venta
    ) 
    REFERENCES venta 
    ( 
     id_venta
    ) 
;

ALTER TABLE empleado 
    ADD CONSTRAINT empleado_fk_afp FOREIGN KEY 
    ( 
     cod_afp
    ) 
    REFERENCES afp 
    ( 
     id_afp
    ) 
;

ALTER TABLE empleado 
    ADD CONSTRAINT empleado_fk_empleado FOREIGN KEY 
    ( 
     cod_empleado
    ) 
    REFERENCES empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE empleado 
    ADD CONSTRAINT empleado_fk_salud FOREIGN KEY 
    ( 
     cod_salud
    ) 
    REFERENCES salud 
    ( 
     id_salud
    ) 
;

ALTER TABLE producto 
    ADD CONSTRAINT producto_fk_categoria FOREIGN KEY 
    ( 
     cod_categoria
    ) 
    REFERENCES categoria 
    ( 
     id_categoria
    ) 
;

ALTER TABLE producto 
    ADD CONSTRAINT producto_fk_marca FOREIGN KEY 
    ( 
     cod_marca
    ) 
    REFERENCES marca 
    ( 
     id_marca
    ) 
;

ALTER TABLE producto 
    ADD CONSTRAINT producto_fk_proveedor FOREIGN KEY 
    ( 
     cod_proveedor
    ) 
    REFERENCES proveedor 
    ( 
     id_proveedor
    ) 
;

ALTER TABLE proveedor 
    ADD CONSTRAINT proveedor_fk_comuna FOREIGN KEY 
    ( 
     cod_comuna
    ) 
    REFERENCES comuna 
    ( 
     id_comuna
    ) 
;

ALTER TABLE vendedor 
    ADD CONSTRAINT vendedor_fk_empleado FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE venta 
    ADD CONSTRAINT venta_fk_empleado FOREIGN KEY 
    ( 
     cod_empleado
    ) 
    REFERENCES empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE venta 
    ADD CONSTRAINT venta_fk_medio_pago FOREIGN KEY 
    ( 
     cod_mpago
    ) 
    REFERENCES medio_pago 
    ( 
     id_mpago
    ) 
;



-- creacion de secuencia para SALUD
CREATE SEQUENCE SEQ_salud
START WITH 2050 
NOMAXVALUE
INCREMENT BY 10
NOCYCLE
NOCACHE;

-- creacion de secuencia para EMPLEADO
CREATE SEQUENCE SEQ_empleado
START WITH 750 
INCREMENT BY 3
NOMAXVALUE
NOCYCLE
NOCACHE;

-- poblamiento de tablas

// region
INSERT INTO REGION (ID_REGION, NOM_REGION) VALUES (1, 'Región Metropolitana');
INSERT INTO REGION (ID_REGION, NOM_REGION) VALUES (2, 'Valparaíso');
INSERT INTO REGION (ID_REGION, NOM_REGION) VALUES (3, 'Biobío');
INSERT INTO REGION (ID_REGION, NOM_REGION) VALUES (4, 'Los Lagos');
// medio_pago
INSERT INTO MEDIO_PAGO (ID_MPAGO, NOMBRE_MPAGO) VALUES (11, 'Efectivo');
INSERT INTO MEDIO_PAGO (ID_MPAGO, NOMBRE_MPAGO) VALUES (12, 'Tarjeta Débito');
INSERT INTO MEDIO_PAGO (ID_MPAGO, NOMBRE_MPAGO) VALUES (13, 'Tarjeta Crédito');
INSERT INTO MEDIO_PAGO (ID_MPAGO, NOMBRE_MPAGO) VALUES (14, 'Cheque');
// salud
INSERT INTO SALUD (ID_SALUD, NOM_SALUD) VALUES (SEQ_salud.NEXTVAL, 'Fonasa');
INSERT INTO SALUD (ID_SALUD, NOM_SALUD) VALUES (SEQ_salud.NEXTVAL, 'Isapre Colmena');
INSERT INTO SALUD (ID_SALUD, NOM_SALUD) VALUES (SEQ_salud.NEXTVAL, 'Isapre Banmédica');
INSERT INTO SALUD (ID_SALUD, NOM_SALUD) VALUES (SEQ_salud.NEXTVAL, 'Isapre Cruz Blanca');
// afp
INSERT INTO AFP (NOM_AFP) VALUES ('AFP Habitat');
INSERT INTO AFP (NOM_AFP) VALUES ('AFP Cuprum');
INSERT INTO AFP (NOM_AFP) VALUES ('AFP Provida');
INSERT INTO AFP (NOM_AFP) VALUES ('AFP PlanVital');
// empleado 
INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '758111111-1', 'Marcela', 'González', 'Pérez', DATE '2022-03-15', 950000, 80000, 'S', 'Administrativo', NULL, 2050, 210); 

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '753222222-2', 'José', 'Muñoz', 'Ramírez', DATE '2021-07-18', 900000, 75000, 'S', 'Administrativo', NULL, 2060, 216);

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '756333333-3', 'Verónica', 'Soto', 'Alarcón', DATE '2020-01-05', 880000, 70000, 'S', 'Vendedor', 750, 2070, 228); 

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '759444444-4', 'Luis', 'Reyes', 'Fuentes', DATE '2023-04-01', 560000, NULL, 'S', 'Vendedor', 750, 2070, 228); 

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '762555555-5', 'Claudia', 'Fernández', 'Lagos', DATE '2023-04-15', 600000, NULL, 'S', 'Vendedor', 753, 2070, 216); 

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '765666666-6', 'Carlos', 'Navarro', 'Vega', DATE '2023-05-01', 610000, NULL, 'S', 'Administrativo', 753, 2060, 210); 

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '768777777-7', 'Javiera', 'Pino', 'Rojas', DATE '2023-05-10', 650000, NULL, 'S', 'Administrativo', 750, 2050, 210);

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '771888888-8', 'Diego', 'Mella', 'Contreras', DATE '2023-05-12', 620000, NULL, 'S', 'Vendedor', 750, 2070, 228); 

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '774999999-9', 'Fernanda', 'Salas', 'Herrera', DATE '2023-05-18', 570000, NULL, 'S', 'Vendedor', 753, 2070, 228); 

INSERT INTO EMPLEADO (ID_EMPLEADO, RUT_EMPLEADO, NOMBRE_EMPLEADO, APELLIDO_PATERNO, APELLIDO_MATERNO, FECHA_CONTRATACION, SUELDO_BASE, BONO_JEFATURA, ACTIVO, TIPO_EMPLEADO, COD_EMPLEADO, COD_SALUD, COD_AFP) 
VALUES (SEQ_empleado.NEXTVAL, '777101010-0', 'Tomás', 'Vidal', 'Espinoza', DATE '2023-06-01', 530000, NULL, 'S', 'Vendedor', NULL, 2050, 222); 
// vendedor
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (756, 0.20);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (759, 0.15);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (762, 0.18);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (771, 0.22);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (774, 0.10);
INSERT INTO VENDEDOR (id_empleado, comision_venta) VALUES (777, 0.25);
// administrativo
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (750);
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (753);
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (765);
INSERT INTO ADMINISTRATIVO (id_empleado) VALUES (768);
// venta 
INSERT INTO VENTA (FECHA_VENTA, TOTAL_VENTA, COD_MPAGO, COD_EMPLEADO) 
VALUES (DATE '2023-05-12', 225990, 12, 771);

INSERT INTO VENTA (FECHA_VENTA, TOTAL_VENTA, COD_MPAGO, COD_EMPLEADO) 
VALUES (DATE '2023-10-23', 524990, 13, 777);

INSERT INTO VENTA (FECHA_VENTA, TOTAL_VENTA, COD_MPAGO, COD_EMPLEADO) 
VALUES (DATE '2023-02-17', 466990, 11, 759);



-- INFORME 1
SELECT 
id_empleado AS IDENTIFICADOR,
nombre_empleado ||' '|| apellido_paterno ||' '|| apellido_materno AS "NOMBRE COMPLETO",
sueldo_base AS SALARIO,
bono_jefatura AS BONIFICACION,
(sueldo_base + bono_jefatura) AS "SALARIO SIMULADO"
FROM 
 empleado
WHERE
 bono_jefatura IS NOT NULL AND (activo = 'S')
ORDER BY
 "SALARIO SIMULADO" DESC, 
 apellido_paterno DESC;

-- INFORME 2

SELECT
nombre_empleado ||' '|| apellido_paterno ||' '|| apellido_materno AS "EMPLEADO",
sueldo_base AS SUELDO,
(sueldo_base * 0.08) AS "POSIBLE AUMENTO",
(sueldo_base * 1.08) AS "SALARIO SIMULADO"
FROM
 empleado
WHERE
 sueldo_base BETWEEN 550000 AND 800000
ORDER BY
 SUELDO ASC; 
