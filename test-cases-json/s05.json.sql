with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./s05.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    "XmlTable002"."/root/Employees/userId/",
    "XmlTable002"."/root/Employees/jobTitleName/",
    "XmlTable002"."/root/Employees/firstName/",
    "XmlTable002"."/root/Employees/lastName/",
    "XmlTable002"."/root/Employees/preferredFullName/",
    "XmlTable002"."/root/Employees/employeeCode/",
    "XmlTable002"."/root/Employees/region/",
    "XmlTable002"."/root/Employees/phoneNumber/",
    "XmlTable002"."/root/Employees/emailAddress/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/Employees' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/Employees/userId/" STRING PATH 'userId',
               "/root/Employees/jobTitleName/" STRING PATH 'jobTitleName',
               "/root/Employees/firstName/" STRING PATH 'firstName',
               "/root/Employees/lastName/" STRING PATH 'lastName',
               "/root/Employees/preferredFullName/" STRING PATH 'preferredFullName',
               "/root/Employees/employeeCode/" STRING PATH 'employeeCode',
               "/root/Employees/region/" STRING PATH 'region',
               "/root/Employees/phoneNumber/" STRING PATH 'phoneNumber',
               "/root/Employees/emailAddress/" STRING PATH 'emailAddress'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"