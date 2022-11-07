-- 1
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
ORDER BY TIPO_SALUD,DSecripcion ;