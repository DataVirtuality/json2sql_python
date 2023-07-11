with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('./s06.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/problems/Diabetes/",
    -- "XmlTable002"."/root/problems/Asthma/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    -- "XmlTable003"."/root/problems/Diabetes/medications/",
    -- "XmlTable003"."/root/problems/Diabetes/labs/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    -- "XmlTable004"."/root/problems/Diabetes/medications/medicationsClasses/className/",
    -- "XmlTable004"."/root/problems/Diabetes/medications/medicationsClasses/className2/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    -- "XmlTable005"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/",
    -- "XmlTable005"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    "XmlTable006"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/name/",
    "XmlTable006"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/dose/",
    "XmlTable006"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/strength/",
    -- "XmlTable007"."idColumn_007",
    -- "XmlTable007"."dv_xml_wrapper_parent_id",
    -- "XmlTable007"."dv_xml_wrapper_id_007",
    "XmlTable007"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/name/",
    "XmlTable007"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/dose/",
    "XmlTable007"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/strength/",
    -- "XmlTable008"."idColumn_008",
    -- "XmlTable008"."dv_xml_wrapper_parent_id",
    -- "XmlTable008"."dv_xml_wrapper_id_008",
    -- "XmlTable008"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/",
    -- "XmlTable008"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/",
    -- "XmlTable009"."idColumn_009",
    -- "XmlTable009"."dv_xml_wrapper_parent_id",
    -- "XmlTable009"."dv_xml_wrapper_id_009",
    "XmlTable009"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/name/",
    "XmlTable009"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/dose/",
    "XmlTable009"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/strength/",
    -- "XmlTable010"."idColumn_010",
    -- "XmlTable010"."dv_xml_wrapper_parent_id",
    -- "XmlTable010"."dv_xml_wrapper_id_010",
    "XmlTable010"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/name/",
    "XmlTable010"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/dose/",
    "XmlTable010"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/strength/",
    -- "XmlTable011"."idColumn_011",
    -- "XmlTable011"."dv_xml_wrapper_parent_id",
    -- "XmlTable011"."dv_xml_wrapper_id_011",
    "XmlTable011"."/root/problems/Diabetes/labs/missing_field/",
    -- "XmlTable012"."idColumn_012",
    -- "XmlTable012"."dv_xml_wrapper_parent_id",
    -- "XmlTable012"."dv_xml_wrapper_id_012"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/problems' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/" xml PATH 'Diabetes',
               "/root/problems/Asthma/" xml PATH 'Asthma'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/Diabetes' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/problems/Diabetes/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/" xml PATH 'medications',
               "/root/problems/Diabetes/labs/" xml PATH 'labs'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/medications/medicationsClasses' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/problems/Diabetes/medications/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/medicationsClasses/className/" xml PATH 'className',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/" xml PATH 'className2'
        ) xt
) "XmlTable004"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/className' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable004"."dv_xml_wrapper_id_004" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable004"."/root/problems/Diabetes/medications/medicationsClasses/className/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/" xml PATH 'associatedDrug',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/" xml PATH 'associatedDrug_u0023_2'
        ) xt
) "XmlTable005"
    on "XmlTable004"."dv_xml_wrapper_id_004" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/associatedDrug' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable005"."dv_xml_wrapper_id_005" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable005"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/name/" STRING PATH 'name',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/dose/" STRING PATH 'dose',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/strength/" STRING PATH 'strength'
        ) xt
) "XmlTable006"
    on "XmlTable005"."dv_xml_wrapper_id_005" = "XmlTable006"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_007",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/associatedDrug_u0023_2' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable005"."dv_xml_wrapper_id_005" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable005"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug_u0023_2/"
               )
		    COLUMNS
               "idColumn_007" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/name/" STRING PATH 'name',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/dose/" STRING PATH 'dose',
               "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/strength/" STRING PATH 'strength'
        ) xt
) "XmlTable007"
    on "XmlTable005"."dv_xml_wrapper_id_005" = "XmlTable007"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_008",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/className2' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable004"."dv_xml_wrapper_id_004" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable004"."/root/problems/Diabetes/medications/medicationsClasses/className2/"
               )
		    COLUMNS
               "idColumn_008" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/" xml PATH 'associatedDrug',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/" xml PATH 'associatedDrug_u0023_2'
        ) xt
) "XmlTable008"
    on "XmlTable004"."dv_xml_wrapper_id_004" = "XmlTable008"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_009",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/associatedDrug' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable008"."dv_xml_wrapper_id_008" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable008"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/"
               )
		    COLUMNS
               "idColumn_009" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/name/" STRING PATH 'name',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/dose/" STRING PATH 'dose',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/strength/" STRING PATH 'strength'
        ) xt
) "XmlTable009"
    on "XmlTable008"."dv_xml_wrapper_id_008" = "XmlTable009"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_010",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/associatedDrug_u0023_2' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable008"."dv_xml_wrapper_id_008" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable008"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug_u0023_2/"
               )
		    COLUMNS
               "idColumn_010" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/name/" STRING PATH 'name',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/dose/" STRING PATH 'dose',
               "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/strength/" STRING PATH 'strength'
        ) xt
) "XmlTable010"
    on "XmlTable008"."dv_xml_wrapper_id_008" = "XmlTable010"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_011",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/labs/missing_field' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/problems/Diabetes/labs/"
               )
		    COLUMNS
               "idColumn_011" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/problems/Diabetes/labs/missing_field/" STRING PATH 'missing_field'
        ) xt
) "XmlTable011"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable011"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_012",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/Asthma' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/problems/Asthma/"
               )
		    COLUMNS
               "idColumn_012" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id'
        ) xt
) "XmlTable012"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable012"."dv_xml_wrapper_parent_id"