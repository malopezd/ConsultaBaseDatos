 --CASO 1 
SELECT
    TO_CHAR(CLI.NUMRUN, '99G999G999')||'-'||INITCAP(CLI.DVRUN)  "RUN CLIENTE",
    CLI.PNOMBRE||' '||CLI.SNOMBRE||' '||CLI.APPATERNO||' '||CLI.APMATERNO  "NOMBRE CLIENTE",
    PO.NOMBRE_PROF_OFIC  "PROFESIÓN U OFICIO",
    TC.NOMBRE_TIPO_CONTRATO  "TIPO CONTRATO",
    TO_CHAR(SUM(PIC.MONTO_TOTAL_AHORRADO), '$99G999G999')  "MONTO TOTAL AHORRADO",
    CASE WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 0 AND 1000000 THEN 'BRONCE'
    WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 1000001 AND 4000000 THEN 'PLATA'
    WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 4000001 AND 8000000 THEN 'SILVER'
    WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) BETWEEN 8000001 AND 15000000 THEN 'GOLD'
    WHEN SUM(PIC.MONTO_TOTAL_AHORRADO) > 15000000 THEN 'PLATINUM'
    END "CATEGORIZACIÓN CLIENTE"
FROM CLIENTE CLI
    JOIN PROFESION_OFICIO PO ON CLI.COD_PROF_OFIC = PO.COD_PROF_OFIC
    JOIN TIPO_CONTRATO TC ON CLI.COD_TIPO_CONTRATO = TC.COD_TIPO_CONTRATO
    JOIN PRODUCTO_INVERSION_CLIENTE PIC ON CLI.NRO_CLIENTE = PIC.NRO_CLIENTE
GROUP BY  CLI.NUMRUN, CLI.DVRUN
    , CLI.PNOMBRE, CLI.SNOMBRE, CLI.APPATERNO, CLI.APMATERNO
    , PO.NOMBRE_PROF_OFIC
    , TC.NOMBRE_TIPO_CONTRATO
ORDER BY CLI.APPATERNO ASC, "MONTO TOTAL AHORRADO" DESC


 --CASO 2

SELECT
    TO_CHAR(CC.FECHA_OTORGA_CRED, 'mmyyyy') "MES TRANSACCIÓN",
    C.NOMBRE_CREDITO  "TIPO CRÉDITO",
    SUM(MONTO_CREDITO)  "MONTO SOLICITADO CRÉDITO",
    SUM(MONTO_CREDITO*(SBIF.PORC_ENTREGA_SBIF/100)) "APORTE A LA SBIF"
FROM CREDITO_CLIENTE CC
    JOIN CREDITO C ON C.COD_CREDITO = CC.COD_CREDITO
    JOIN APORTE_A_SBIF sbif ON CC.MONTO_CREDITO BETWEEN SBIF.MONTO_CREDITO_DESDE AND SBIF.MONTO_CREDITO_HASTA
WHERE EXTRACT(YEAR FROM CC.FECHA_OTORGA_CRED) = EXTRACT(YEAR FROM SYSDATE)-1
GROUP BY CC.FECHA_OTORGA_CRED, C.NOMBRE_CREDITO
ORDER BY "MES TRANSACCIÓN" ASC, "TIPO CRÉDITO"
