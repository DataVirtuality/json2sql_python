with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('./s03.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/coffee/",
    -- "XmlTable002"."/root/brewing/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    -- "XmlTable003"."/root/coffee/region/",
    -- "XmlTable003"."/root/coffee/country/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    -- "XmlTable004"."/root/coffee/region/id/@type",
    "XmlTable004"."/root/coffee/region/id/",
    "XmlTable004"."/root/coffee/region/name/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    -- "XmlTable005"."/root/coffee/country/id/@type",
    "XmlTable005"."/root/coffee/country/id/",
    "XmlTable005"."/root/coffee/country/company/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    -- "XmlTable006"."/root/brewing/region/",
    -- "XmlTable006"."/root/brewing/country/",
    -- "XmlTable007"."idColumn_007",
    -- "XmlTable007"."dv_xml_wrapper_parent_id",
    -- "XmlTable007"."dv_xml_wrapper_id_007",
    -- "XmlTable007"."/root/brewing/region/id/@type",
    "XmlTable007"."/root/brewing/region/id/",
    "XmlTable007"."/root/brewing/region/name/",
    -- "XmlTable008"."idColumn_008",
    -- "XmlTable008"."dv_xml_wrapper_parent_id",
    -- "XmlTable008"."dv_xml_wrapper_id_008",
    -- "XmlTable008"."/root/brewing/country/id/@type",
    "XmlTable008"."/root/brewing/country/id/",
    "XmlTable008"."/root/brewing/country/company/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/coffee/" xml PATH 'coffee',
               "/root/brewing/" xml PATH 'brewing'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/coffee' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/coffee/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/coffee/region/" xml PATH 'region',
               "/root/coffee/country/" xml PATH 'country'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/region' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/coffee/region/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/coffee/region/id/@type" STRING PATH 'id/@xsi:type',
               "/root/coffee/region/id/" INTEGER PATH 'id',
               "/root/coffee/region/name/" STRING PATH 'name'
        ) xt
) "XmlTable004"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/country' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/coffee/country/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/coffee/country/id/@type" STRING PATH 'id/@xsi:type',
               "/root/coffee/country/id/" INTEGER PATH 'id',
               "/root/coffee/country/company/" STRING PATH 'company'
        ) xt
) "XmlTable005"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/brewing' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/brewing/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/brewing/region/" xml PATH 'region',
               "/root/brewing/country/" xml PATH 'country'
        ) xt
) "XmlTable006"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable006"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_007",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/region' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/brewing/region/"
               )
		    COLUMNS
               "idColumn_007" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/brewing/region/id/@type" STRING PATH 'id/@xsi:type',
               "/root/brewing/region/id/" INTEGER PATH 'id',
               "/root/brewing/region/name/" STRING PATH 'name'
        ) xt
) "XmlTable007"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable007"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_008",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/country' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/brewing/country/"
               )
		    COLUMNS
               "idColumn_008" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/brewing/country/id/@type" STRING PATH 'id/@xsi:type',
               "/root/brewing/country/id/" INTEGER PATH 'id',
               "/root/brewing/country/company/" STRING PATH 'company'
        ) xt
) "XmlTable008"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable008"."dv_xml_wrapper_parent_id"