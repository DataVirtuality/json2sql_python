with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s03.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/roo' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/rootcoffee" xml PATH 'coffee',
    "/rootbrewing" xml PATH 'brewing'
) "xmltable01"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/coffee' PASSING "xmltable01"."/rootcoffee"
    COLUMNS
    "idColumn_02" FOR ORDINALITY,
    "/root/coffee/region" xml PATH 'region',
    "/root/coffee/country" xml PATH 'country'
) "xmltable02"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/coffee/region' PASSING "xmltable02"."/root/coffee/region"
    COLUMNS
    "idColumn_03" FOR ORDINALITY,
    "/root/coffee/region/id/type" STRING PATH 'id/@xsi:type',
    "/root/coffee/region/id" integer PATH 'id',
    "/root/coffee/region/name" string PATH 'name'
) "xmltable03"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/coffee/country' PASSING "xmltable02"."/root/coffee/country"
    COLUMNS
    "idColumn_04" FOR ORDINALITY,
    "/root/coffee/country/id/type" STRING PATH 'id/@xsi:type',
    "/root/coffee/country/id" integer PATH 'id',
    "/root/coffee/country/company" string PATH 'company'
) "xmltable04"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/brewing' PASSING "xmltable01"."/rootbrewing"
    COLUMNS
    "idColumn_05" FOR ORDINALITY,
    "/root/brewing/region" xml PATH 'region',
    "/root/brewing/country" xml PATH 'country'
) "xmltable05"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/brewing/region' PASSING "xmltable05"."/root/brewing/region"
    COLUMNS
    "idColumn_06" FOR ORDINALITY,
    "/root/brewing/region/id/type" STRING PATH 'id/@xsi:type',
    "/root/brewing/region/id" integer PATH 'id',
    "/root/brewing/region/name" string PATH 'name'
) "xmltable06"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/brewing/country' PASSING "xmltable05"."/root/brewing/country"
    COLUMNS
    "idColumn_07" FOR ORDINALITY,
    "/root/brewing/country/id/type" STRING PATH 'id/@xsi:type',
    "/root/brewing/country/id" integer PATH 'id',
    "/root/brewing/country/company" string PATH 'company'
) "xmltable07"