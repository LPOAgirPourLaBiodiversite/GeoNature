SET search_path = ref_geo, pg_catalog, public;

INSERT INTO l_areas (id_type, area_code, area_name, geom, geojson_4326)
SELECT get_id_area_type('COM') AS id_type, insee_com, nom_com, geom, geojson FROM temp_fr_municipalities
-- on ne met pas les arrondissement
WHERE id ILIKE 'commune%'
;

TRUNCATE TABLE li_municipalities;
INSERT INTO li_municipalities (id_municipality, id_area, status, insee_com, nom_com, insee_arr, insee_dep, insee_reg, code_epci)
SELECT id,  a.id_area, statut, insee_com, nom_com, insee_arr, insee_dep, insee_reg, code_epci
FROM temp_fr_municipalities t
JOIN l_areas a ON a.area_code = t.insee_com
-- on ne met pas les arrondissement
WHERE id ILIKE 'commune%'
;
REINDEX INDEX index_l_areas_geom;
