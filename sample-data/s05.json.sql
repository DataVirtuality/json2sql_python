with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s05.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/Employees' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/root/Employees/userId" string PATH 'userId',
    "/root/Employees/jobTitleName" string PATH 'jobTitleName',
    "/root/Employees/firstName" string PATH 'firstName',
    "/root/Employees/lastName" string PATH 'lastName',
    "/root/Employees/preferredFullName" string PATH 'preferredFullName',
    "/root/Employees/employeeCode" string PATH 'employeeCode',
    "/root/Employees/region" string PATH 'region',
    "/root/Employees/phoneNumber" string PATH 'phoneNumber',
    "/root/Employees/emailAddress" string PATH 'emailAddress'
) "xmltable01"