--CASO 1

SELECT
    TO_CHAR(cli.NUMRUN,'99G999G999')||'-'||
    cli.DVRUN AS "RUN CLIENTE",
    cli.PNOMBRE || ' ' ||
    cli.SNOMBRE || ' ' ||
    cli.APPATERNO || ' ' ||
    cli.APMATERNO AS "NOMBRE CLIENTE",
    po.nombre_prof_ofic AS "PROFESION/OFICIO",
    TO_CHAR(FECHA_NACIMIENTO, 'DD "de" Month') AS "DIA DE CUMPLEAÑOS "
FROM CLIENTE cli
    JOIN PROFESION_OFICIO po ON cli.COD_PROF_OFIC = po.cod_prof_ofic
WHERE EXTRACT(MONTH FROM FECHA_NACIMIENTO) = 09
ORDER BY TO_CHAR(FECHA_NACIMIENTO, 'DD "de" Month'), cli.APPATERNO DESC;

--CASO 2

SELECT
    TO_CHAR(cli.NUMRUN,'99G999G999')||'-'||
    cli.DVRUN AS "RUN CLIENTE",
    cli.PNOMBRE || ' ' ||
    cli.SNOMBRE || ' ' ||
    cli.APPATERNO || ' ' ||
    cli.APMATERNO AS "NOMBRE CLIENTE",
    TO_CHAR(MONTO_SOLICITADO,'$999G999G999') AS "MONTO SOLICITADO CREDITOS",
    TO_CHAR(MONTO_SOLICITADO*0.012,'$999G999G999') AS "TOTAL PESOS TODOSUMA"
FROM CLIENTE cli JOIN CREDITO_CLIENTE cc ON cli.nro_cliente = cc.nro_cliente
WHERE EXTRACT(YEAR FROM FECHA_OTORGA_CRED) = EXTRACT(YEAR FROM SYSDATE) - 1
ORDER BY TO_CHAR(MONTO_SOLICITADO,'$999G999G999')ASC,cli.APPATERNO DESC,cli.numrun;

--CASO3

SELECT
    TO_CHAR (FECHA_SOLIC_CRED, 'mm/yyyy') AS "MES TRANSACCIÓN",
    cre.NOMBRE_CREDITO AS "TIPO CREDITO",
    TO_CHAR(cc.monto_solicitado, '$999G999G999') AS "MONTO SOLICITADO CREDITO",
    (CASE WHEN cc.monto_solicitado BETWEEN 100000 and 1000000 THEN TO_CHAR(cc.monto_solicitado*0.01, '$999G999G999') 
    WHEN cc.monto_solicitado BETWEEN 1000001 and 2000000 THEN TO_CHAR(cc.monto_solicitado*0.02, '$999G999G999')
    WHEN cc.monto_solicitado BETWEEN 2000001 and 4000000 THEN TO_CHAR(cc.monto_solicitado*0.03, '$999G999G999')
    WHEN cc.monto_solicitado BETWEEN 4000001 and 6000000 THEN TO_CHAR(cc.monto_solicitado*0.04, '$999G999G999')
    WHEN cc.monto_solicitado > 6000000 THEN TO_CHAR(cc.monto_solicitado*0.07, '$999G999G999')END) AS "APORTE A LA SBIF"
FROM CREDITO_CLIENTE cc JOIN CREDITO cre ON cc.COD_CREDITO = cre.COD_CREDITO
WHERE EXTRACT(YEAR FROM FECHA_SOLIC_CRED)=2021
ORDER BY TO_CHAR (FECHA_SOLIC_CRED, 'mm/yyyy'), cre.NOMBRE_CREDITO;

--CASO4

SELECT
    TO_CHAR(cli.NUMRUN,'99G999G999')||'-'||
    cli.DVRUN AS "RUN CLIENTE",
    cli.PNOMBRE || ' ' ||
    cli.SNOMBRE || ' ' ||
    cli.APPATERNO || ' ' ||
    cli.APMATERNO AS "NOMBRE CLIENTE",
    TO_CHAR(pic.MONTO_TOTAL_AHORRADO, '$999G999G999') AS "MONTO TOTAL AHORRADO",
    (CASE WHEN pic.MONTO_TOTAL_AHORRADO BETWEEN 100000 and 1000000 THEN 'BRONCE'
    WHEN pic.MONTO_TOTAL_AHORRADO BETWEEN 1000001 and 4000000 THEN 'PLATA'
    WHEN pic.MONTO_TOTAL_AHORRADO BETWEEN 4000001 and 8000000 THEN 'SILVER'
    WHEN pic.MONTO_TOTAL_AHORRADO BETWEEN 8000001 and 15000000 THEN 'GOLD'
    WHEN pic.MONTO_TOTAL_AHORRADO > 15000000 THEN 'PATINUM' END) AS "CATEGORIA CLIENTE"
FROM CLIENTE cli JOIN PRODUCTO_INVERSION_CLIENTE pic ON cli.NRO_CLIENTE = pic.NRO_CLIENTE
WHERE  pic.MONTO_TOTAL_AHORRADO > 0
ORDER BY cli.APPATERNO asc,TO_CHAR(pic.MONTO_TOTAL_AHORRADO, '$999G999G999') DESC;

--CASO 5

SELECT
    EXTRACT(YEAR FROM SYSDATE),
    TO_CHAR(cli.NUMRUN,'99G999G999')||'-'||
    cli.DVRUN AS "RUN CLIENTE",
    cli.PNOMBRE || ' ' ||
    cli.SNOMBRE || ' ' ||
    cli.APPATERNO || ' ' ||
    cli.APMATERNO AS "NOMBRE CLIENTE",
    TO_CHAR(pic.MONTO_TOTAL_AHORRADO, '$999G999G999') AS "MONTO TOTAL AHORRADO"
FROM CLIENTE cli JOIN PRODUCTO_INVERSION_CLIENTE pic ON cli.NRO_CLIENTE = pic.NRO_CLIENTE
WHERE pic.MONTO_TOTAL_AHORRADO > 0
ORDER BY cli.APPATERNO asc;

--CASO 6

--Informe 1

SELECT
    EXTRACT(YEAR FROM SYSDATE) AS "AÑO TRIBUTARIO",
    TO_CHAR(c.numrun,'99G999G999')||'-'||c.DVRUN AS "RUN CLIENTE",
    c.PNOMBRE || ' ' ||c.SNOMBRE || ' ' ||c.APPATERNO ||' '|| c.APMATERNO AS "NOMBRE CLIENTE",
    COUNT(cc.nro_solic_credito) AS "TOTAL CREDITOS SOLICITADOS",
    TO_CHAR(cc.monto_credito, '9G999G999') AS "MONTO TOTAL CREDITOS"
    
FROM CLIENTE c
JOIN credito_cliente cc ON c.nro_cliente = cc.nro_cliente
GROUP BY  c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno,cc.nro_solic_credito,cc.monto_credito
ORDER BY c.appaterno ASC
;

--Informe 2

SELECT
    TO_CHAR(c.numrun,'09G999G999')||'-' || c.dvrun AS "RUN CLIENTE",
    INITCAP(c.pnombre) || ' ' || INITCAP(c.snombre) ||' ' ||INITCAP(c.appaterno) || ' ' || INITCAP(c.apmaterno) AS "NOMBRE CLIENTE",
    mov.cod_tipo_mov,
    NVL(TO_CHAR((CASE WHEN mov.cod_tipo_mov=1 THEN mov.monto_movimiento END), 'L99G999G999'),'      NO REALIZO  ') AS "ABONOS",
    NVL(TO_CHAR((CASE WHEN mov.cod_tipo_mov=2 THEN mov.monto_movimiento END), 'L99G999G999'),'              NO REALIZO  ') AS "RESCATES"
FROM cliente c
    JOIN movimiento mov ON c.nro_Cliente = mov.nro_cliente
;