with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./s09.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    "XmlTable002"."/root/root/glossary/title/",
    -- "XmlTable002"."/root/root/glossary/keywords/",
    -- "XmlTable002"."/root/root/glossary/GlossDiv/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    "XmlTable003"."/root/root/glossary/keywords/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/root/glossary/GlossDiv/title/",
    -- "XmlTable004"."/root/root/glossary/GlossDiv/GlossList/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/ID/",
    "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/SortAs/",
    "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossTerm/",
    "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/Acronym/",
    "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/Abbrev/",
    -- "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/",
    "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossSee/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    "XmlTable006"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/para/",
    -- "XmlTable006"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso/",
    -- "XmlTable007"."idColumn_007",
    -- "XmlTable007"."dv_xml_wrapper_parent_id",
    -- "XmlTable007"."dv_xml_wrapper_id_007",
    "XmlTable007"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root/glossary' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/title/" STRING PATH 'title',
               "/root/root/glossary/keywords/" xml PATH 'keywords',
               "/root/root/glossary/GlossDiv/" xml PATH 'GlossDiv'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/keywords' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/root/glossary/keywords/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/keywords/" STRING PATH '.'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/GlossDiv' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/root/glossary/GlossDiv/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/GlossDiv/title/" STRING PATH 'title',
               "/root/root/glossary/GlossDiv/GlossList/" xml PATH 'GlossList'
        ) xt
) "XmlTable004"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/GlossList/GlossEntry' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable004"."dv_xml_wrapper_id_004" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable004"."/root/root/glossary/GlossDiv/GlossList/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/ID/" STRING PATH 'ID',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/SortAs/" STRING PATH 'SortAs',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossTerm/" STRING PATH 'GlossTerm',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/Acronym/" STRING PATH 'Acronym',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/Abbrev/" STRING PATH 'Abbrev',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/" xml PATH 'GlossDef',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossSee/" STRING PATH 'GlossSee'
        ) xt
) "XmlTable005"
    on "XmlTable004"."dv_xml_wrapper_id_004" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/GlossDef' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable005"."dv_xml_wrapper_id_005" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable005"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/para/" STRING PATH 'para',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso/" xml PATH 'GlossSeeAlso'
        ) xt
) "XmlTable006"
    on "XmlTable005"."dv_xml_wrapper_id_005" = "XmlTable006"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_007",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/GlossSeeAlso' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso/"
               )
		    COLUMNS
               "idColumn_007" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso/" STRING PATH '.'
        ) xt
) "XmlTable007"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable007"."dv_xml_wrapper_parent_id"