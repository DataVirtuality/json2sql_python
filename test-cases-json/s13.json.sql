with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./s13.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    "XmlTable002"."/root/data/allFilms/films/title/",
    "XmlTable002"."/root/data/allFilms/films/director/",
    "XmlTable002"."/root/data/allFilms/films/releaseDate/",
    -- "XmlTable002"."/root/data/allFilms/films/speciesConnection/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    "XmlTable003"."/root/data/allFilms/films/speciesConnection/species/name/",
    "XmlTable003"."/root/data/allFilms/films/speciesConnection/species/classification/",
    -- "XmlTable003"."/root/data/allFilms/films/speciesConnection/species/homeworld/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/data/allFilms/films/speciesConnection/species/homeworld/name/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/data/allFilms/films' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../../../@dv_xml_wrapper_parent_id',
               "/root/data/allFilms/films/title/" STRING PATH 'title',
               "/root/data/allFilms/films/director/" STRING PATH 'director',
               "/root/data/allFilms/films/releaseDate/" STRING PATH 'releaseDate',
               "/root/data/allFilms/films/speciesConnection/" xml PATH 'speciesConnection'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/speciesConnection/species' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/allFilms/films/speciesConnection/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/data/allFilms/films/speciesConnection/species/name/" STRING PATH 'name',
               "/root/data/allFilms/films/speciesConnection/species/classification/" STRING PATH 'classification',
               "/root/data/allFilms/films/speciesConnection/species/homeworld/" xml PATH 'homeworld'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/homeworld/name' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/data/allFilms/films/speciesConnection/species/homeworld/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/data/allFilms/films/speciesConnection/species/homeworld/name/" STRING PATH '.'
        ) xt
) "XmlTable004"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable004"."dv_xml_wrapper_parent_id"