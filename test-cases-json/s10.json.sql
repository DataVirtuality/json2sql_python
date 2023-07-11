with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('./s10.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/root/bool_first/",
    -- "XmlTable002"."/root/root/bool_first_int5_last/",
    -- "XmlTable002"."/root/root/int_first/",
    -- "XmlTable002"."/root/root/str_last/",
    -- "XmlTable002"."/root/root/str_first/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    "XmlTable003"."/root/root/bool_first/bool_true/",
    -- "XmlTable003"."/root/root/bool_first/int_0/@type",
    "XmlTable003"."/root/root/bool_first/int_0/",
    -- "XmlTable003"."/root/root/bool_first/int_1/@type",
    "XmlTable003"."/root/root/bool_first/int_1/",
    "XmlTable003"."/root/root/bool_first/bool_false/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/root/bool_first_int5_last/bool_true/",
    -- "XmlTable004"."/root/root/bool_first_int5_last/int_0/@type",
    "XmlTable004"."/root/root/bool_first_int5_last/int_0/",
    -- "XmlTable004"."/root/root/bool_first_int5_last/int_1/@type",
    "XmlTable004"."/root/root/bool_first_int5_last/int_1/",
    "XmlTable004"."/root/root/bool_first_int5_last/bool_false/",
    -- "XmlTable004"."/root/root/bool_first_int5_last/int_5/@type",
    "XmlTable004"."/root/root/bool_first_int5_last/int_5/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    -- "XmlTable005"."/root/root/int_first/int_0/@type",
    "XmlTable005"."/root/root/int_first/int_0/",
    "XmlTable005"."/root/root/int_first/bool_true/",
    "XmlTable005"."/root/root/int_first/bool_false/",
    -- "XmlTable005"."/root/root/int_first/int_1/@type",
    "XmlTable005"."/root/root/int_first/int_1/",
    -- "XmlTable005"."/root/root/int_first/int_5/@type",
    "XmlTable005"."/root/root/int_first/int_5/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    -- "XmlTable006"."/root/root/str_last/int_0/@type",
    "XmlTable006"."/root/root/str_last/int_0/",
    "XmlTable006"."/root/root/str_last/bool_true/",
    "XmlTable006"."/root/root/str_last/bool_false/",
    -- "XmlTable006"."/root/root/str_last/int_1/@type",
    "XmlTable006"."/root/root/str_last/int_1/",
    -- "XmlTable006"."/root/root/str_last/int_5/@type",
    "XmlTable006"."/root/root/str_last/int_5/",
    "XmlTable006"."/root/root/str_last/str_last/",
    -- "XmlTable007"."idColumn_007",
    -- "XmlTable007"."dv_xml_wrapper_parent_id",
    -- "XmlTable007"."dv_xml_wrapper_id_007",
    "XmlTable007"."/root/root/str_first/str_first/",
    -- "XmlTable007"."/root/root/str_first/int_0/@type",
    "XmlTable007"."/root/root/str_first/int_0/",
    "XmlTable007"."/root/root/str_first/bool_true/",
    "XmlTable007"."/root/root/str_first/bool_false/",
    -- "XmlTable007"."/root/root/str_first/int_1/@type",
    "XmlTable007"."/root/root/str_first/int_1/",
    -- "XmlTable007"."/root/root/str_first/int_5/@type",
    "XmlTable007"."/root/root/str_first/int_5/",
    "XmlTable007"."/root/root/str_first/str_last/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/root/bool_first/" xml PATH 'bool_first',
               "/root/root/bool_first_int5_last/" xml PATH 'bool_first_int5_last',
               "/root/root/int_first/" xml PATH 'int_first',
               "/root/root/str_last/" xml PATH 'str_last',
               "/root/root/str_first/" xml PATH 'str_first'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/bool_first' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/root/bool_first/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/bool_first/bool_true/" BOOLEAN PATH 'bool_true',
               "/root/root/bool_first/int_0/@type" STRING PATH 'int_0/@xsi:type',
               "/root/root/bool_first/int_0/" INTEGER PATH 'int_0',
               "/root/root/bool_first/int_1/@type" STRING PATH 'int_1/@xsi:type',
               "/root/root/bool_first/int_1/" INTEGER PATH 'int_1',
               "/root/root/bool_first/bool_false/" BOOLEAN PATH 'bool_false'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/bool_first_int5_last' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/root/bool_first_int5_last/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/bool_first_int5_last/bool_true/" BOOLEAN PATH 'bool_true',
               "/root/root/bool_first_int5_last/int_0/@type" STRING PATH 'int_0/@xsi:type',
               "/root/root/bool_first_int5_last/int_0/" INTEGER PATH 'int_0',
               "/root/root/bool_first_int5_last/int_1/@type" STRING PATH 'int_1/@xsi:type',
               "/root/root/bool_first_int5_last/int_1/" INTEGER PATH 'int_1',
               "/root/root/bool_first_int5_last/bool_false/" BOOLEAN PATH 'bool_false',
               "/root/root/bool_first_int5_last/int_5/@type" STRING PATH 'int_5/@xsi:type',
               "/root/root/bool_first_int5_last/int_5/" INTEGER PATH 'int_5'
        ) xt
) "XmlTable004"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/int_first' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/root/int_first/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/int_first/int_0/@type" STRING PATH 'int_0/@xsi:type',
               "/root/root/int_first/int_0/" INTEGER PATH 'int_0',
               "/root/root/int_first/bool_true/" BOOLEAN PATH 'bool_true',
               "/root/root/int_first/bool_false/" BOOLEAN PATH 'bool_false',
               "/root/root/int_first/int_1/@type" STRING PATH 'int_1/@xsi:type',
               "/root/root/int_first/int_1/" INTEGER PATH 'int_1',
               "/root/root/int_first/int_5/@type" STRING PATH 'int_5/@xsi:type',
               "/root/root/int_first/int_5/" INTEGER PATH 'int_5'
        ) xt
) "XmlTable005"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/str_last' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/root/str_last/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/str_last/int_0/@type" STRING PATH 'int_0/@xsi:type',
               "/root/root/str_last/int_0/" INTEGER PATH 'int_0',
               "/root/root/str_last/bool_true/" BOOLEAN PATH 'bool_true',
               "/root/root/str_last/bool_false/" BOOLEAN PATH 'bool_false',
               "/root/root/str_last/int_1/@type" STRING PATH 'int_1/@xsi:type',
               "/root/root/str_last/int_1/" INTEGER PATH 'int_1',
               "/root/root/str_last/int_5/@type" STRING PATH 'int_5/@xsi:type',
               "/root/root/str_last/int_5/" INTEGER PATH 'int_5',
               "/root/root/str_last/str_last/" STRING PATH 'str_last'
        ) xt
) "XmlTable006"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable006"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_007",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/str_first' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/root/str_first/"
               )
		    COLUMNS
               "idColumn_007" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/root/str_first/str_first/" STRING PATH 'str_first',
               "/root/root/str_first/int_0/@type" STRING PATH 'int_0/@xsi:type',
               "/root/root/str_first/int_0/" INTEGER PATH 'int_0',
               "/root/root/str_first/bool_true/" BOOLEAN PATH 'bool_true',
               "/root/root/str_first/bool_false/" BOOLEAN PATH 'bool_false',
               "/root/root/str_first/int_1/@type" STRING PATH 'int_1/@xsi:type',
               "/root/root/str_first/int_1/" INTEGER PATH 'int_1',
               "/root/root/str_first/int_5/@type" STRING PATH 'int_5/@xsi:type',
               "/root/root/str_first/int_5/" INTEGER PATH 'int_5',
               "/root/root/str_first/str_last/" STRING PATH 'str_last'
        ) xt
) "XmlTable007"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable007"."dv_xml_wrapper_parent_id"