MERGE INTO temp_table_alle_kt_dsw_mod8 t 
USING ( 
    SELECT  
        p.teilenr, 
        SUM(NVL(l.lagerb, 0)) - 
        NVL((
            SELECT tt.REST_LAGER_43 
            FROM temp_table_alle_kt_dsw_mod6 tt 
            WHERE tt.teilenr = p.teilenr
        ), 0) AS Gesamt_Lagerbestand 
    FROM parts p 
    LEFT JOIN lagerpl l ON p.teilenr = l.teilenr 
    LEFT JOIN lagerorte lo ON l.lagerort = lo.lagerort 
    WHERE p.teilenr IN (  
        SELECT DISTINCT a.teilenr  
        FROM allocs a 
        WHERE a.prodauftr LIKE 'KA2018120644%'
    ) 
    AND NVL(l.lagerb, 0) > 0 
    AND l.lagerb IS NOT NULL
    GROUP BY p.teilenr 
) src 
ON (t.teilenr = src.teilenr) 
WHEN MATCHED THEN 
    UPDATE SET t.Lagerbestand = src.Gesamt_Lagerbestand;
