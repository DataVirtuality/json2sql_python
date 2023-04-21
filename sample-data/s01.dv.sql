SELECT 
"xmlTable.idColumn",
"xmlTable.myint",
"xmlTable.myfloat",
"xmlTable.glossary",
"xmlTable.title"
FROM 
"dv_sample_data".getFiles('./s01.json') f,
XMLTABLE(XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),'/root/root' PASSING JSONTOXML('root',to_chars(f.file,'UTF-8'))
	COLUMNS 
	"idColumn" FOR ORDINALITY,
	"myint" STRING  PATH 'myint',
	"myfloat" STRING  PATH 'myfloat',
	"glossary" STRING  PATH 'glossary',
	"title" STRING  PATH 'glossary/title'
) "xmlTable"
;;