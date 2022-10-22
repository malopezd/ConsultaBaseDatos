--CASO 1

SELECT
    TO_CHAR(cli.NUMRUN,'99G999G999')||'-'||
    cli.DVRUN AS "RUN CLIENTE",
    cli.PNOMBRE || ' ' ||
    cli.SNOMBRE || ' ' ||
    cli.APPATERNO || ' ' ||
    cli.APMATERNO AS "NOMBRE CLIENTE",
    TO_CHAR(cli.FECHA_NACIMIENTO, 'DD "de" Month') AS "DIA DE CUMPLEAÑOS",
    SR.DIRECCION AS "SUCURSAL"
FROM cliente cli
    JOIN comuna com ON cli.cod_comuna = com.cod_comuna AND cli.cod_provincia = com.cod_provincia AND cli.cod_region = com.cod_region
    JOIN sucursal_retail sr ON com.cod_comuna = sr.cod_comuna AND sr.cod_provincia = com.cod_provincia AND sr.cod_region = com.cod_region
    ORDER BY "DIA DE CUMPLEAÑOS" ASC, cli.APPATERNO;


--CASO 2

SELECT
    TO_CHAR(cli.NUMRUN,'99G999G999')||'-'||
    cli.DVRUN AS "RUN CLIENTE",
    cli.PNOMBRE || ' ' ||
    cli.SNOMBRE || ' ' ||
    cli.APPATERNO || ' ' ||
    cli.APMATERNO AS "NOMBRE CLIENTE",
    TO_CHAR(SUM(TTC.MONTO_TRANSACCION), '$99G999G999') AS "MONTO COMPRAS/AVANCES/S.AVANCES",
    TO_CHAR(ROUND((SUM(TTC.MONTO_TRANSACCION)/10000)*250), '999G999') AS "TOTAL PUNTOS ACUMULADOS"
FROM CLIENTE cli 
    JOIN TARJETA_CLIENTE tc ON (cli.NUMRUN = tc.NUMRUN)
    JOIN TRANSACCION_TARJETA_CLIENTE ttc ON (tc.NRO_TARJETA = ttc.NRO_TARJETA)
WHERE EXTRACT(YEAR FROM ttc.FECHA_TRANSACCION) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY CLI.NUMRUN, CLI.DVRUN, CLI.PNOMBRE, CLI.SNOMBRE, CLI.APPATERNO, CLI.APMATERNO
ORDER BY "TOTAL PUNTOS ACUMULADOS", CLI.APPATERNO;