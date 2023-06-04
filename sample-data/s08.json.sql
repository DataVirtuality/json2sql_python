with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s08.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/root/feed/author" xml PATH 'author',
    "/root/feed/entry" xml PATH 'entry',
    "/root/feed/updated" xml PATH 'updated',
    "/root/feed/rights" xml PATH 'rights',
    "/root/feed/title" xml PATH 'title',
    "/root/feed/icon" xml PATH 'icon',
    "/root/feed/link" xml PATH 'link',
    "/root/feed/id" xml PATH 'id'
) "xmltable01"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/author' PASSING "xmltable01"."/root/feed/author"
    COLUMNS
    "idColumn_02" FOR ORDINALITY,
    "/root/feed/author/name" xml PATH 'name',
    "/root/feed/author/uri" xml PATH 'uri'
) "xmltable02"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/author/name/label' PASSING "xmltable02"."/root/feed/author/name"
    COLUMNS
    "idColumn_03" FOR ORDINALITY
) "xmltable03"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/author/uri/label' PASSING "xmltable02"."/root/feed/author/uri"
    COLUMNS
    "idColumn_04" FOR ORDINALITY
) "xmltable04"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry' PASSING "xmltable01"."/root/feed/entry"
    COLUMNS
    "idColumn_05" FOR ORDINALITY,
    "/root/feed/entry/author" xml PATH 'author',
    "/root/feed/entry/updated" xml PATH 'updated',
    "/root/feed/entry/im:rating" xml PATH 'im:rating',
    "/root/feed/entry/im:version" xml PATH 'im:version',
    "/root/feed/entry/id" xml PATH 'id',
    "/root/feed/entry/title" xml PATH 'title',
    "/root/feed/entry/content" xml PATH 'content',
    "/root/feed/entry/link" xml PATH 'link',
    "/root/feed/entry/im:voteSum" xml PATH 'im:voteSum',
    "/root/feed/entry/im:contentType" xml PATH 'im:contentType',
    "/root/feed/entry/im:voteCount" xml PATH 'im:voteCount'
) "xmltable05"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/author' PASSING "xmltable05"."/root/feed/entry/author"
    COLUMNS
    "idColumn_06" FOR ORDINALITY,
    "/root/feed/entry/author/uri" xml PATH 'uri',
    "/root/feed/entry/author/name" xml PATH 'name',
    "/root/feed/entry/author/label" string PATH 'label'
) "xmltable06"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/author/uri/label' PASSING "xmltable06"."/root/feed/entry/author/uri"
    COLUMNS
    "idColumn_07" FOR ORDINALITY
) "xmltable07"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/author/name/label' PASSING "xmltable06"."/root/feed/entry/author/name"
    COLUMNS
    "idColumn_08" FOR ORDINALITY
) "xmltable08"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/updated/label' PASSING "xmltable05"."/root/feed/entry/updated"
    COLUMNS
    "idColumn_09" FOR ORDINALITY
) "xmltable09"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/im:rating/label' PASSING "xmltable05"."/root/feed/entry/im:rating"
    COLUMNS
    "idColumn_10" FOR ORDINALITY
) "xmltable10"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/im:version/label' PASSING "xmltable05"."/root/feed/entry/im:version"
    COLUMNS
    "idColumn_11" FOR ORDINALITY
) "xmltable11"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/id/label' PASSING "xmltable05"."/root/feed/entry/id"
    COLUMNS
    "idColumn_12" FOR ORDINALITY
) "xmltable12"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/title/label' PASSING "xmltable05"."/root/feed/entry/title"
    COLUMNS
    "idColumn_13" FOR ORDINALITY
) "xmltable13"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/content' PASSING "xmltable05"."/root/feed/entry/content"
    COLUMNS
    "idColumn_14" FOR ORDINALITY,
    "/root/feed/entry/content/label" string PATH 'label',
    "/root/feed/entry/content/attributes" xml PATH 'attributes'
) "xmltable14"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/content/attributes/type' PASSING "xmltable14"."/root/feed/entry/content/attributes"
    COLUMNS
    "idColumn_15" FOR ORDINALITY
) "xmltable15"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/link/attributes' PASSING "xmltable05"."/root/feed/entry/link"
    COLUMNS
    "idColumn_16" FOR ORDINALITY,
    "/root/feed/entry/link/attributes/rel" string PATH 'rel',
    "/root/feed/entry/link/attributes/href" string PATH 'href'
) "xmltable16"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/im:voteSum/label' PASSING "xmltable05"."/root/feed/entry/im:voteSum"
    COLUMNS
    "idColumn_17" FOR ORDINALITY
) "xmltable17"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/im:contentType/attributes' PASSING "xmltable05"."/root/feed/entry/im:contentType"
    COLUMNS
    "idColumn_18" FOR ORDINALITY,
    "/root/feed/entry/im:contentType/attributes/term" string PATH 'term',
    "/root/feed/entry/im:contentType/attributes/label" string PATH 'label'
) "xmltable18"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/entry/im:voteCount/label' PASSING "xmltable05"."/root/feed/entry/im:voteCount"
    COLUMNS
    "idColumn_19" FOR ORDINALITY
) "xmltable19"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/updated/label' PASSING "xmltable01"."/root/feed/updated"
    COLUMNS
    "idColumn_20" FOR ORDINALITY
) "xmltable20"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/rights/label' PASSING "xmltable01"."/root/feed/rights"
    COLUMNS
    "idColumn_21" FOR ORDINALITY
) "xmltable21"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/title/label' PASSING "xmltable01"."/root/feed/title"
    COLUMNS
    "idColumn_22" FOR ORDINALITY
) "xmltable22"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/icon/label' PASSING "xmltable01"."/root/feed/icon"
    COLUMNS
    "idColumn_23" FOR ORDINALITY
) "xmltable23"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/link/attributes' PASSING "xmltable01"."/root/feed/link"
    COLUMNS
    "idColumn_24" FOR ORDINALITY,
    "/root/feed/link/attributes/rel" string PATH 'rel',
    "/root/feed/link/attributes/type" string PATH 'type',
    "/root/feed/link/attributes/href" string PATH 'href'
) "xmltable24"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/feed/id/label' PASSING "xmltable01"."/root/feed/id"
    COLUMNS
    "idColumn_25" FOR ORDINALITY
) "xmltable25"