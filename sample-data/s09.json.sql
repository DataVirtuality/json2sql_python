with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s09.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/root/glossary' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/root/root/glossary/title" string PATH 'title',
    "/root/root/glossary/keywords" xml PATH 'keywords',
    "/root/root/glossary/GlossDiv" xml PATH 'GlossDiv'
) "xmltable01"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/root/glossary/keywords' PASSING "xmltable01"."/root/root/glossary/keywords"
    COLUMNS
    "idColumn_02" FOR ORDINALITY
) "xmltable02"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/root/glossary/GlossDiv' PASSING "xmltable01"."/root/root/glossary/GlossDiv"
    COLUMNS
    "idColumn_03" FOR ORDINALITY,
    "/root/root/glossary/GlossDiv/title" string PATH 'title',
    "/root/root/glossary/GlossDiv/GlossList" xml PATH 'GlossList'
) "xmltable03"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/root/glossary/GlossDiv/GlossList/GlossEntry' PASSING "xmltable03"."/root/root/glossary/GlossDiv/GlossList"
    COLUMNS
    "idColumn_04" FOR ORDINALITY,
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/ID" string PATH 'ID',
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/SortAs" string PATH 'SortAs',
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossTerm" string PATH 'GlossTerm',
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/Acronym" string PATH 'Acronym',
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/Abbrev" string PATH 'Abbrev',
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef" xml PATH 'GlossDef',
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossSee" string PATH 'GlossSee'
) "xmltable04"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef' PASSING "xmltable04"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef"
    COLUMNS
    "idColumn_05" FOR ORDINALITY,
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/para" string PATH 'para',
    "/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso" xml PATH 'GlossSeeAlso'
) "xmltable05"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso' PASSING "xmltable05"."/root/root/glossary/GlossDiv/GlossList/GlossEntry/GlossDef/GlossSeeAlso"
    COLUMNS
    "idColumn_06" FOR ORDINALITY
) "xmltable06"