with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('./s04.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/quiz/sport/",
    -- "XmlTable002"."/root/quiz/maths/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    "XmlTable003"."/root/quiz/sport/q1/question/",
    -- "XmlTable003"."/root/quiz/sport/q1/options/",
    "XmlTable003"."/root/quiz/sport/q1/answer/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/quiz/sport/q1/options/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    -- "XmlTable005"."/root/quiz/maths/q1/",
    -- "XmlTable005"."/root/quiz/maths/q2/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    "XmlTable006"."/root/quiz/maths/q1/question/",
    -- "XmlTable006"."/root/quiz/maths/q1/options/",
    "XmlTable006"."/root/quiz/maths/q1/answer/",
    -- "XmlTable007"."idColumn_007",
    -- "XmlTable007"."dv_xml_wrapper_parent_id",
    -- "XmlTable007"."dv_xml_wrapper_id_007",
    "XmlTable007"."/root/quiz/maths/q1/options/",
    -- "XmlTable008"."idColumn_008",
    -- "XmlTable008"."dv_xml_wrapper_parent_id",
    -- "XmlTable008"."dv_xml_wrapper_id_008",
    "XmlTable008"."/root/quiz/maths/q2/question/",
    -- "XmlTable008"."/root/quiz/maths/q2/options/",
    "XmlTable008"."/root/quiz/maths/q2/answer/",
    -- "XmlTable009"."idColumn_009",
    -- "XmlTable009"."dv_xml_wrapper_parent_id",
    -- "XmlTable009"."dv_xml_wrapper_id_009",
    "XmlTable009"."/root/quiz/maths/q2/options/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/quiz' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/quiz/sport/" xml PATH 'sport',
               "/root/quiz/maths/" xml PATH 'maths'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/sport/q1' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/quiz/sport/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/quiz/sport/q1/question/" STRING PATH 'question',
               "/root/quiz/sport/q1/options/" xml PATH 'options',
               "/root/quiz/sport/q1/answer/" STRING PATH 'answer'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/options' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/quiz/sport/q1/options/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/quiz/sport/q1/options/" STRING PATH '.'
        ) xt
) "XmlTable004"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/maths' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/quiz/maths/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/quiz/maths/q1/" xml PATH 'q1',
               "/root/quiz/maths/q2/" xml PATH 'q2'
        ) xt
) "XmlTable005"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/q1' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable005"."dv_xml_wrapper_id_005" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable005"."/root/quiz/maths/q1/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/quiz/maths/q1/question/" STRING PATH 'question',
               "/root/quiz/maths/q1/options/" xml PATH 'options',
               "/root/quiz/maths/q1/answer/" STRING PATH 'answer'
        ) xt
) "XmlTable006"
    on "XmlTable005"."dv_xml_wrapper_id_005" = "XmlTable006"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_007",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/options' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/quiz/maths/q1/options/"
               )
		    COLUMNS
               "idColumn_007" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/quiz/maths/q1/options/" STRING PATH '.'
        ) xt
) "XmlTable007"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable007"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_008",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/q2' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable005"."dv_xml_wrapper_id_005" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable005"."/root/quiz/maths/q2/"
               )
		    COLUMNS
               "idColumn_008" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/quiz/maths/q2/question/" STRING PATH 'question',
               "/root/quiz/maths/q2/options/" xml PATH 'options',
               "/root/quiz/maths/q2/answer/" STRING PATH 'answer'
        ) xt
) "XmlTable008"
    on "XmlTable005"."dv_xml_wrapper_id_005" = "XmlTable008"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_009",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/options' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable008"."dv_xml_wrapper_id_008" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable008"."/root/quiz/maths/q2/options/"
               )
		    COLUMNS
               "idColumn_009" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/quiz/maths/q2/options/" STRING PATH '.'
        ) xt
) "XmlTable009"
    on "XmlTable008"."dv_xml_wrapper_id_008" = "XmlTable009"."dv_xml_wrapper_parent_id"