--- USER FA
CREATE USER "MDY2131_ET_FA" IDENTIFIED BY "Jada20042001"  
DEFAULT TABLESPACE "DATA"
TEMPORARY TABLESPACE "TEMP";
ALTER USER "MDY2131_ET_FA" QUOTA UNLIMITED ON "DATA";
GRANT CREATE SEQUENCE TO "MDY2131_ET_FA" ;
GRANT ALTER TABLE TO "MDY2131_ET_FA" ;
GRANT CREATE SESSION TO "MDY2131_ET_FA" ;
GRANT DROP ANY TABLE TO "MDY2131_ET_FA" ;
GRANT CREATE INDEXTYPE TO "MDY2131_ET_FA" ;
GRANT CREATE TABLE TO "MDY2131_ET_FA" ;
GRANT CREATE SYNONYM TO "MDY2131_ET_FA" ;
GRANT CREATE PUBLIC SYNONYM TO "MDY2131_ET_FA" ;

--- USER FA_DES
CREATE USER "MDY2131_ET_FA_DES" IDENTIFIED BY "Jada20042001"  
DEFAULT TABLESPACE "DATA"
TEMPORARY TABLESPACE "TEMP";
ALTER USER "MDY2131_ET_FA_DES" QUOTA UNLIMITED ON "DATA";
GRANT CREATE VIEW TO "MDY2131_ET_FA_DES" ;
GRANT CREATE MATERIALIZED VIEW TO "MDY2131_ET_FA_DES" ;
GRANT CREATE TRIGGER TO "MDY2131_ET_FA_DES" ;
GRANT CREATE PROCEDURE TO "MDY2131_ET_FA_DES" ;
GRANT CREATE SESSION TO "MDY2131_ET_FA_DES" ;

--- USER FA_DES
CREATE USER "MDY2131_ET_FA_DES" IDENTIFIED BY "Jada20042001"  
DEFAULT TABLESPACE "DATA"
TEMPORARY TABLESPACE "TEMP";
ALTER USER "MDY2131_ET_FA_DES" QUOTA UNLIMITED ON "DATA";
GRANT CREATE VIEW TO "MDY2131_ET_FA_DES" ;
GRANT CREATE MATERIALIZED VIEW TO "MDY2131_ET_FA_DES" ;
GRANT CREATE TRIGGER TO "MDY2131_ET_FA_DES" ;
GRANT CREATE PROCEDURE TO "MDY2131_ET_FA_DES" ;
GRANT CREATE SESSION TO "MDY2131_ET_FA_DES" ;

--- USER FA_DES_CON
CREATE USER "MDY2131_ET_FA_CON" IDENTIFIED BY "Jada20042001"  
DEFAULT TABLESPACE "DATA"
TEMPORARY TABLESPACE "TEMP";
ALTER USER "MDY2131_ET_FA_CON" QUOTA UNLIMITED ON "DATA";
GRANT CREATE SESSION TO "MDY2131_ET_FA_CON" ;

---Cierre de ADMIN

--- Se inicia conexión con USER FA

CREATE OR REPLACE PUBLIC SYNONYM syn_at FOR ATENCION;
CREATE OR REPLACE PUBLIC SYNONYM syn_med FOR MEDICO;
CREATE OR REPLACE PUBLIC SYNONYM syn_esp FOR ESPECIALIDAD;
CREATE OR REPLACE PUBLIC SYNONYM syn_pagat FOR PAGO_ATENCION;

GRANT SELECT ON syn_at TO "MDY2131_ET_FA_DES";
GRANT SELECT ON syn_med TO "MDY2131_ET_FA_DES";
GRANT SELECT ON syn_esp TO "MDY2131_ET_FA_DES";
GRANT SELECT ON syn_pagat TO "MDY2131_ET_FA_DES";

--- Cierre de USER FA

--- Se inicia conexión con USER FA_DES

--- INFORME 1

CREATE OR REPLACE VIEW med_at AS
SELECT 
esp.nombre "ESPECIALIDAD",
COUNT(*) AS "TOTAL MEDICOS",

    (SELECT
        COUNT(at.pac_run)
        FROM syn_esp esps JOIN syn_med medd ON(medd.ESP_ID = esps.esp_id) 
        JOIN syn_at at ON(medd.MED_RUN=at.MED_RUN)
        WHERE TO_CHAR(at.FECHA_ATENCION, 'MM-YYYY') >= TO_CHAR(SYSDATE -150, 'MM-YYYY') AND esp.nombre = esps.nombre
        group by esps.NOMBRE) as "CANTIDAD ATENCIONES",
        
     (SELECT
        TO_CHAR(SUM(at.COSTO), 'L999G999G999')
        FROM syn_esp esps JOIN syn_med medd ON(medd.ESP_ID = esps.esp_id) 
        JOIN syn_at at ON(medd.MED_RUN=at.MED_RUN)
        WHERE TO_CHAR(at.FECHA_ATENCION, 'MM-YYYY') >= TO_CHAR(SYSDATE -150, 'MM-YYYY') AND esp.nombre = esps.nombre
        group by esps.NOMBRE) as "COSTO TOTAL",
        
    (SELECT
        TO_CHAR(AVG(at.COSTO), 'L999G999G999')
        FROM syn_esp esps JOIN syn_med medd ON(medd.ESP_ID = esps.esp_id) 
        JOIN syn_at at ON(medd.MED_RUN=at.MED_RUN)
        WHERE TO_CHAR(at.FECHA_ATENCION, 'MM-YYYY') >= TO_CHAR(SYSDATE -150, 'MM-YYYY') AND esp.nombre = esps.nombre
        group by esps.NOMBRE) as "COSTO PROMEDIO"

FROM syn_esp esp JOIN syn_med med ON(esp.esp_id = med.esp_id) 
group by esp.nombre
order by 3 desc
WITH READ ONLY;

--- Cierre de USER FA_DES

--- Se inicia conexión con USER FA

--- INFORME 2 (JOIN)
INSERT INTO SELECCION_ESPECIALIDAD
SELECT 
TO_CHAR(SYSDATE, 'MM-DD-YYYY') AS FECHA,
esp.ESP_ID AS ID_ESPECIALIDAD,
esp.NOMBRE AS ESPECIALIDAD,
TRUNC(AVG(SUELDO_BASE)) AS SUELDO_PROMEDIO,
COUNT(*) AS TOTAL_MEDICOS
FROM syn_esp esp JOIN syn_med med ON(esp.esp_id = med.esp_id) 
WHERE (SELECT
        COUNT(at.pac_run)
        FROM syn_esp esps JOIN syn_med medd ON(medd.ESP_ID = esps.esp_id) 
        JOIN syn_at at ON(medd.MED_RUN=at.MED_RUN)
        ---WHERE TO_CHAR(at.FECHA_ATENCION, 'MM-YYYY') >= TO_CHAR(SYSDATE -60, 'MM-YYYY') AND 
        where esp.nombre = esps.nombre and esps.nombre !='Medicina General'
        group by esps.NOMBRE) >=30
GROUP BY esp.esp_id, esp.nombre, TO_CHAR(SYSDATE, 'MM-DD-YYYY')
ORDER BY 3 asc;

--- Informe 2 (SET/UNION)
INSERT INTO SELECCION_ESPECIALIDAD
SELECT 
TO_CHAR(SYSDATE, 'MM-DD-YYYY') AS "FECHA_EMISION",
esp.ESP_ID AS "ID_ESPECIALIDAD",
esp.NOMBRE AS "ESPECIALIDAD",
TRUNC(AVG(SUELDO_BASE)) AS "SUELDO_PROMEDIO",
COUNT(*) AS "TOTAL_MEDICOS"
FROM syn_esp esp JOIN syn_med med ON(esp.esp_id = med.esp_id) 
WHERE (SELECT
        COUNT(at.pac_run)
        FROM syn_esp esps JOIN syn_med medd ON(medd.ESP_ID = esps.esp_id) 
        JOIN syn_at at ON(medd.MED_RUN=at.MED_RUN)
        WHERE esp.nombre = esps.nombre and esps.nombre !='Medicina General'
        GROUP by esps.NOMBRE) >=30
GROUP BY esp.esp_id, esp.nombre, TO_CHAR(SYSDATE, 'MM-DD-YYYY')
INTERSECT
SELECT 
TO_CHAR(SYSDATE, 'MM-DD-YYYY') AS "FECHA",
esp.ESP_ID AS "ID_ESPECIALIDAD",
esp.NOMBRE AS "ESPECIALIDAD",
TRUNC(AVG(SUELDO_BASE)) AS "SUELDO_PROMEDIO",
COUNT(*) AS "TOTAL_MEDICOS"
FROM syn_esp esp JOIN syn_med med ON(esp.esp_id = med.esp_id) 
WHERE (SELECT
        COUNT(at.pac_run)
        FROM syn_esp esps JOIN syn_med medd ON(medd.ESP_ID = esps.esp_id) 
        JOIN syn_at at ON(medd.MED_RUN=at.MED_RUN)
        WHERE esp.nombre = esps.nombre and esps.nombre !='Medicina General'
        GROUP by esps.NOMBRE) >=30
GROUP BY esp.esp_id, esp.nombre, TO_CHAR(SYSDATE, 'MM-DD-YYYY')
ORDER BY 3 asc;


--- Inicio de UPDATE

SELECT
ID_ESPECIALIDAD
FROM SELECCION_ESPECIALIDAD
    WHERE SUELDO_PROMEDIO > (SELECT
    TRUNC(AVG(med.SUELDO_BASE)) AS SUELDO_PROMEDIO
    FROM syn_med med);

UPDATE ESPECIALIDAD
SET DESCUENTO = 0.02
WHERE ESP_ID IN(SELECT
ID_ESPECIALIDAD
FROM SELECCION_ESPECIALIDAD
    WHERE SUELDO_PROMEDIO > (SELECT
    TRUNC(AVG(med.SUELDO_BASE)) AS SUELDO_PROMEDIO
    FROM syn_med med));

--- UPDATE finalizado
--- Cierre de USER FA

--- Preguntas
--- 1) Se debe de actualizar los porcentajes de descuento de las especialidades.
--- 2) Especialidad, sueldo base, sueldo promedio.
--- 3) El proposito es saber que especialiades son las que poseen un salario promedio mas alto, y darles asi un porcentaje de descuento.
--- 4) Primero se debe de sacar la fecha en la que se realiza la consulta, luego los id de las especialidades, sus nombres, y luego se saca el promedio del sueldo base de los médicos, y cuantos médicos hay por especialidad, para luego filtrarlos en una subconsulta que devuelve las especialidades que cuentan con 30 o más atenciones, además de eliminar la especialidad "Medicina General", para al final ordenarlas por su especialida de forma ascendente.




