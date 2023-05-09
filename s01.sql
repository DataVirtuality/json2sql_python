SELECT table1.*
FROM
(SELECT XMLPARSE(DOCUMENT f.file) as xmldata FROM "MY_DATASOURCE".getFiles('./sample-data/s01.xml') f) as data,
XMLTABLE('/root/root/myint' PASSING data.xmldata
COLUMNS
"idColumn_1" FOR ORDINALITY, 
"/root/root/myint/{http://www.w3.org/2001/XMLSchema-instance}type" STRING PATH '..\..\..\..\@{http://www.w3.org/2001/XMLSchema-instance}type',
"/root/text" STRING PATH '..\..\text()'
) "table1"

;;