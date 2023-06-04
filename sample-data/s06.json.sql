with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s06.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/root/problems/Diabetes/medications" xml PATH 'medications',
    "/root/problems/Diabetes/labs" xml PATH 'labs'
) "xmltable01"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/medications/medicationsClasses' PASSING "xmltable01"."/root/problems/Diabetes/medications"
    COLUMNS
    "idColumn_02" FOR ORDINALITY,
    "/root/problems/Diabetes/medications/medicationsClasses/className" xml PATH 'className',
    "/root/problems/Diabetes/medications/medicationsClasses/className2" xml PATH 'className2'
) "xmltable02"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/medications/medicationsClasses/className' PASSING "xmltable02"."/root/problems/Diabetes/medications/medicationsClasses/className"
    COLUMNS
    "idColumn_03" FOR ORDINALITY,
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug" xml PATH 'associatedDrug',
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2" xml PATH 'associatedDrug#2'
) "xmltable03"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug' PASSING "xmltable03"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug"
    COLUMNS
    "idColumn_04" FOR ORDINALITY,
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/name" string PATH 'name',
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/dose" string PATH 'dose',
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug/strength" string PATH 'strength'
) "xmltable04"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2' PASSING "xmltable03"."/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2"
    COLUMNS
    "idColumn_05" FOR ORDINALITY,
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/name" string PATH 'name',
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/dose" string PATH 'dose',
    "/root/problems/Diabetes/medications/medicationsClasses/className/associatedDrug#2/strength" string PATH 'strength'
) "xmltable05"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/medications/medicationsClasses/className2' PASSING "xmltable02"."/root/problems/Diabetes/medications/medicationsClasses/className2"
    COLUMNS
    "idColumn_06" FOR ORDINALITY,
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug" xml PATH 'associatedDrug',
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2" xml PATH 'associatedDrug#2'
) "xmltable06"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug' PASSING "xmltable06"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug"
    COLUMNS
    "idColumn_07" FOR ORDINALITY,
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/name" string PATH 'name',
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/dose" string PATH 'dose',
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug/strength" string PATH 'strength'
) "xmltable07"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2' PASSING "xmltable06"."/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2"
    COLUMNS
    "idColumn_08" FOR ORDINALITY,
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/name" string PATH 'name',
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/dose" string PATH 'dose',
    "/root/problems/Diabetes/medications/medicationsClasses/className2/associatedDrug#2/strength" string PATH 'strength'
) "xmltable08"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/problems/Diabetes/labs/missing_field' PASSING "xmltable01"."/root/problems/Diabetes/labs"
    COLUMNS
    "idColumn_09" FOR ORDINALITY
) "xmltable09"