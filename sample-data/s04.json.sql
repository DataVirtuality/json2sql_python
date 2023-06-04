with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s04.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/root/quiz/sport" xml PATH 'sport',
    "/root/quiz/maths" xml PATH 'maths'
) "xmltable01"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz/sport/q1' PASSING "xmltable01"."/root/quiz/sport"
    COLUMNS
    "idColumn_02" FOR ORDINALITY,
    "/root/quiz/sport/q1/question" string PATH 'question',
    "/root/quiz/sport/q1/options" xml PATH 'options',
    "/root/quiz/sport/q1/answer" string PATH 'answer'
) "xmltable02"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz/sport/q1/options' PASSING "xmltable02"."/root/quiz/sport/q1/options"
    COLUMNS
    "idColumn_03" FOR ORDINALITY
) "xmltable03"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz/maths' PASSING "xmltable01"."/root/quiz/maths"
    COLUMNS
    "idColumn_04" FOR ORDINALITY,
    "/root/quiz/maths/q1" xml PATH 'q1',
    "/root/quiz/maths/q2" xml PATH 'q2'
) "xmltable04"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz/maths/q1' PASSING "xmltable04"."/root/quiz/maths/q1"
    COLUMNS
    "idColumn_05" FOR ORDINALITY,
    "/root/quiz/maths/q1/question" string PATH 'question',
    "/root/quiz/maths/q1/options" xml PATH 'options',
    "/root/quiz/maths/q1/answer" string PATH 'answer'
) "xmltable05"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz/maths/q1/options' PASSING "xmltable05"."/root/quiz/maths/q1/options"
    COLUMNS
    "idColumn_06" FOR ORDINALITY
) "xmltable06"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz/maths/q2' PASSING "xmltable04"."/root/quiz/maths/q2"
    COLUMNS
    "idColumn_07" FOR ORDINALITY,
    "/root/quiz/maths/q2/question" string PATH 'question',
    "/root/quiz/maths/q2/options" xml PATH 'options',
    "/root/quiz/maths/q2/answer" string PATH 'answer'
) "xmltable07"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/quiz/maths/q2/options' PASSING "xmltable07"."/root/quiz/maths/q2/options"
    COLUMNS
    "idColumn_08" FOR ORDINALITY
) "xmltable08"