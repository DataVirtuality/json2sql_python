SELECT table1.*, table2.*, table3.*, table4.*, table5.*
FROM
(SELECT XMLPARSE(DOCUMENT f.file) as xmldata FROM "INSERT_DATA_SOURCE_NAME_HERE".getFiles('INSERT_FILE_PATH_HERE') f) as data,
XMLTABLE('/root/root/myint/text()' PASSING data.xmldata
COLUMNS
"idColumn_1" FOR ORDINALITY, 
"/root/root/myint/type xsi http://www.w3.org/2001/XMLSchema-instance" STRING PATH '../@type xsi http:/www.w3.org/2001/XMLSchema-instance',
"/root/root/myint/text" STRING PATH '../text()',
"/root/xsi xsi {}" STRING PATH '../../../@xsi xsi {}'
) "table1"
,XMLTABLE('/root/root/myfloat/text()' PASSING data.xmldata
COLUMNS
"idColumn_2" FOR ORDINALITY, 
"/root/root/myfloat/type xsi http://www.w3.org/2001/XMLSchema-instance" STRING PATH '../@type xsi http:/www.w3.org/2001/XMLSchema-instance',
"/root/root/myfloat/text" STRING PATH '../text()',
"/root/xsi xsi {}" STRING PATH '../../../@xsi xsi {}'
) "table2"
,XMLTABLE('/root/root/glossary/title/text()' PASSING data.xmldata
COLUMNS
"idColumn_3" FOR ORDINALITY, 
"/root/root/glossary/title/text" STRING PATH '../text()',
"/root/xsi xsi {}" STRING PATH '../../../../@xsi xsi {}'
) "table3"
,XMLTABLE('/root/root/glossary/keywords/text()' PASSING data.xmldata
COLUMNS
"idColumn_4" FOR ORDINALITY, 
"/root/root/glossary/keywords/text" STRING PATH '../text()',
"/root/xsi xsi {}" STRING PATH '../../../../@xsi xsi {}'
) "table4"
,XMLTABLE('/root/root/glossary/list/list/text()' PASSING data.xmldata
COLUMNS
"idColumn_5" FOR ORDINALITY, 
"/root/root/glossary/list/list/type xsi http://www.w3.org/2001/XMLSchema-instance" STRING PATH '../@type xsi http:/www.w3.org/2001/XMLSchema-instance',
"/root/root/glossary/list/list/text" STRING PATH '../text()',
"/root/xsi xsi {}" STRING PATH '../../../../../@xsi xsi {}'
) "table5"

;;