with "dataset001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "Data_Source_Name".getFiles('sample-data/s01.json') f
)
select
    "dataset001"."dv_xml_wrapper_id_001",
    -- "dataset002"."idColumn_002",
    -- "dataset002"."dv_xml_wrapper_parent_id",
    -- "dataset002"."dv_xml_wrapper_id_002",
    "dataset002"."/root/root/myint/type",
    "dataset002"."/root/root/myint",
    "dataset002"."/root/root/myfloat/type",
    "dataset002"."/root/root/myfloat",
    -- "dataset002"."/root/root/glossary",
    -- "dataset003"."idColumn_003",
    -- "dataset003"."dv_xml_wrapper_parent_id",
    -- "dataset003"."dv_xml_wrapper_id_003",
    "dataset003"."/root/root/glossary/title",
    -- "dataset003"."/root/root/glossary/keywords",
    -- "dataset003"."/root/root/glossary/list",
    -- "dataset003"."/root/root/glossary/list_objs",
    -- "dataset004"."idColumn_004",
    -- "dataset004"."dv_xml_wrapper_parent_id",
    -- "dataset004"."dv_xml_wrapper_id_004",
    -- "dataset005"."idColumn_005",
    -- "dataset005"."dv_xml_wrapper_parent_id",
    -- "dataset005"."dv_xml_wrapper_id_005",
    -- "dataset006"."idColumn_006",
    -- "dataset006"."dv_xml_wrapper_parent_id",
    -- "dataset006"."dv_xml_wrapper_id_006",
    "dataset006"."/root/root/glossary/list_objs/servlet-name",
    "dataset006"."/root/root/glossary/list_objs/servlet-class"
from "dataset001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("dataset001"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "dataset001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/root/myint/type" STRING PATH 'myint/@xsi:type',
               "/root/root/myint" integer PATH 'myint',
               "/root/root/myfloat/type" STRING PATH 'myfloat/@xsi:type',
               "/root/root/myfloat" float PATH 'myfloat',
               "/root/root/glossary" xml PATH 'glossary'
) "dataset002"
    on "dataset001"."dv_xml_wrapper_parent_id" = "dataset002"."dv_xml_wrapper_id_002"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("dataset002"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "dataset002"."/root/root/glossary"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/title" string PATH 'title',
               "/root/root/glossary/keywords" xml PATH 'keywords',
               "/root/root/glossary/list" xml PATH 'list',
               "/root/root/glossary/list_objs" xml PATH 'list_objs'
) "dataset003"
    on "dataset002"."dv_xml_wrapper_parent_id" = "dataset003"."dv_xml_wrapper_id_003"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("dataset003"."dv_xml_wrapper_id_004" AS "dv_xml_wrapper_parent_id"),
                    "dataset003"."/root/root/glossary/keywords"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id'
) "dataset004"
    on "dataset003"."dv_xml_wrapper_parent_id" = "dataset004"."dv_xml_wrapper_id_004"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("dataset003"."dv_xml_wrapper_id_005" AS "dv_xml_wrapper_parent_id"),
                    "dataset003"."/root/root/glossary/list"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id'
) "dataset005"
    on "dataset003"."dv_xml_wrapper_parent_id" = "dataset005"."dv_xml_wrapper_id_005"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("dataset003"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "dataset003"."/root/root/glossary/list_objs"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/root/glossary/list_objs/servlet-name" string PATH 'servlet-name',
               "/root/root/glossary/list_objs/servlet-class" string PATH 'servlet-class'
) "dataset006"
    on "dataset003"."dv_xml_wrapper_parent_id" = "dataset006"."dv_xml_wrapper_id_006"