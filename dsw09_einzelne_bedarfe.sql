DECLARE
    v_start_ziffer NUMBER := 44; -- Startwert (erste Endziffer)
    v_end_ziffer   NUMBER := 64; -- Endwert (letzte Endziffer)
    v_sql          VARCHAR2(4000);
BEGIN
    -- Spezialfall: Der erste Schritt basiert auf LAGERBESTAND
    v_sql := '
        UPDATE TEMP_TABLE_DSW_MOD8_techa
        SET
            REST_LAGER_' || v_start_ziffer || ' = CASE
                WHEN NVL(LAGERBESTAND, 0) > NVL(BEDARF_1206' || v_start_ziffer || ', 0)
                THEN NVL(LAGERBESTAND, 0) - NVL(BEDARF_1206' || v_start_ziffer || ', 0)
                ELSE NULL
            END,
            ABZGL_LAGER_' || v_start_ziffer || ' = CASE
                WHEN NVL(LAGERBESTAND, 0) < NVL(BEDARF_1206' || v_start_ziffer || ', 0)
                THEN NVL(BEDARF_1206' || v_start_ziffer || ', 0) - NVL(LAGERBESTAND, 0)
                ELSE NULL
            END';
    EXECUTE IMMEDIATE v_sql;

    -- Nachfolgende Iterationen basieren auf den vorherigen REST_LAGER-Werten
    FOR i IN v_start_ziffer+1..v_end_ziffer LOOP
        v_sql := '
            UPDATE TEMP_TABLE_DSW_MOD8_techa
            SET
                REST_LAGER_' || i || ' = CASE
                    WHEN NVL(REST_LAGER_' || (i-1) || ', 0) > NVL(BEDARF_1206' || i || ', 0)
                    THEN NVL(REST_LAGER_' || (i-1) || ', 0) - NVL(BEDARF_1206' || i || ', 0)
                    ELSE NULL
                END,
                ABZGL_LAGER_' || i || ' = CASE
                    WHEN NVL(REST_LAGER_' || (i-1) || ', 0) < NVL(BEDARF_1206' || i || ', 0)
                    THEN NVL(BEDARF_1206' || i || ', 0) - NVL(REST_LAGER_' || (i-1) || ', 0)
                    ELSE NULL
                END';
        EXECUTE IMMEDIATE v_sql;
    END LOOP;
END;
/
