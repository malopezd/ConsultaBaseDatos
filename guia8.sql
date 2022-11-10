SELECT 
    ts.descripcion ||','||
    s.descripcion AS "SISTEMA_SALUD",
    COUNT(a.ate_id) AS "TOTAL ATENCIONES"
FROM atencion a
    JOIN paciente p ON (a.pac_run = p.pac_run)
    JOIN salud s ON (p.sal_id = s.sal_id)
    JOIN tipo_salud ts ON (s.tipo_sal_id = ts.tipo_sal_id)
WHERE EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) 
AND EXTRACT(MONTH FROM a.fecha_atencion) = 9
GROUP BY ts.descripcion,s.descripcion
HAVING COUNT(a.ate_id) > 
                      (SELECT 
                      AVG(COUNT(a.ate_id)) 
                      FROM atencion a
                      JOIN paciente p ON (a.pac_run = p.pac_run)
                      JOIN salud s ON (p.sal_id = s.sal_id)
                      JOIN tipo_salud ts ON (s.tipo_sal_id = ts.tipo_sal_id)
                      WHERE EXTRACT(YEAR FROM a.fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) 
                      AND EXTRACT(MONTH FROM a.fecha_atencion) = 9
                      GROUP BY ts.descripcion,s.descripcion)
ORDER BY "SISTEMA_SALUD","TOTAL ATENCIONES" 
;

--2

SELECT
    e.nombre AS "ESPECIALIDAD" ,
    TO_CHAR(m.med_run,'99G999G999')||'-'||
    m.dv_run AS "RUT",
    m.PNOMBRE || ' ' ||
    m.SNOMBRE || ' ' ||
    m.APATERNO || ' ' ||
    m.AMATERNO AS "MEDICO"
FROM especialidad_medico em
    JOIN medico m ON (em.med_run=m.med_run)
    JOIN especialidad e ON (em.esp_id=e.esp_id)
ORDER BY "ESPECIALIDAD",m.apaterno
;