with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s07.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/roo' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/rootboolean_key" string PATH 'boolean_key',
    "/rootempty_string_translation" string PATH 'empty_string_translation',
    "/rootkey_with_description" string PATH 'key_with_description',
    "/rootkey_with_line-break" string PATH 'key_with_line-break',
    "/rootnested" xml PATH 'nested',
    "/rootnull_translation/type" STRING PATH 'null_translation/@xsi:type',
    "/rootnull_translation" unknown PATH 'null_translation',
    "/rootpluralized_key" xml PATH 'pluralized_key',
    "/rootsample_collection" xml PATH 'sample_collection',
    "/rootsimple_key" string PATH 'simple_key',
    "/rootunverified_key" string PATH 'unverified_key'
) "xmltable01"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/nested' PASSING "xmltable01"."/rootnested"
    COLUMNS
    "idColumn_02" FOR ORDINALITY,
    "/root/nested/deeply" xml PATH 'deeply',
    "/root/nested/key" string PATH 'key'
) "xmltable02"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/nested/deeply/key' PASSING "xmltable02"."/root/nested/deeply"
    COLUMNS
    "idColumn_03" FOR ORDINALITY
) "xmltable03"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/pluralized_key' PASSING "xmltable01"."/rootpluralized_key"
    COLUMNS
    "idColumn_04" FOR ORDINALITY,
    "/root/pluralized_key/one" string PATH 'one',
    "/root/pluralized_key/other" string PATH 'other',
    "/root/pluralized_key/zero" string PATH 'zero'
) "xmltable04"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/sample_collection' PASSING "xmltable01"."/rootsample_collection"
    COLUMNS
    "idColumn_05" FOR ORDINALITY
) "xmltable05"