MERGE INTO temp_table_dsw_mod8 t 
USING  
( 
   SELECT  
        a.teilenr,  
        SUM(a.resmenge) AS summe_auftrmenge 
FROM allocs a 
WHERE a.prodauftr LIKE 'KA2018120644%'
   GROUP BY a.teilenr 
) src 
ON (t.teilenr = src.teilenr) 
WHEN MATCHED THEN 
    UPDATE SET t.DSW_MENGE_1AUFTR = src.summe_auftrmenge; 

