with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./s02.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/web-app/servlet/",
    -- "XmlTable002"."/root/web-app/servlet-mapping/",
    -- "XmlTable002"."/root/web-app/taglib/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    "XmlTable003"."/root/web-app/servlet/servlet-name/",
    "XmlTable003"."/root/web-app/servlet/servlet-class/",
    -- "XmlTable003"."/root/web-app/servlet/init-param/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/web-app/servlet/init-param/configGlossary:installationAt/",
    "XmlTable004"."/root/web-app/servlet/init-param/configGlossary:adminEmail/",
    "XmlTable004"."/root/web-app/servlet/init-param/configGlossary:poweredBy/",
    "XmlTable004"."/root/web-app/servlet/init-param/configGlossary:poweredByIcon/",
    "XmlTable004"."/root/web-app/servlet/init-param/configGlossary:staticPath/",
    "XmlTable004"."/root/web-app/servlet/init-param/templateProcessorClass/",
    "XmlTable004"."/root/web-app/servlet/init-param/templateLoaderClass/",
    "XmlTable004"."/root/web-app/servlet/init-param/templatePath/",
    "XmlTable004"."/root/web-app/servlet/init-param/templateOverridePath/",
    "XmlTable004"."/root/web-app/servlet/init-param/defaultListTemplate/",
    "XmlTable004"."/root/web-app/servlet/init-param/defaultFileTemplate/",
    "XmlTable004"."/root/web-app/servlet/init-param/useJSP/",
    "XmlTable004"."/root/web-app/servlet/init-param/jspListTemplate/",
    "XmlTable004"."/root/web-app/servlet/init-param/jspFileTemplate/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cachePackageTagsTrack/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cachePackageTagsTrack/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cachePackageTagsStore/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cachePackageTagsStore/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cachePackageTagsRefresh/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cachePackageTagsRefresh/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cacheTemplatesTrack/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cacheTemplatesTrack/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cacheTemplatesStore/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cacheTemplatesStore/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cacheTemplatesRefresh/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cacheTemplatesRefresh/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cachePagesTrack/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cachePagesTrack/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cachePagesStore/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cachePagesStore/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cachePagesRefresh/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cachePagesRefresh/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/cachePagesDirtyRead/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/cachePagesDirtyRead/",
    "XmlTable004"."/root/web-app/servlet/init-param/searchEngineListTemplate/",
    "XmlTable004"."/root/web-app/servlet/init-param/searchEngineFileTemplate/",
    "XmlTable004"."/root/web-app/servlet/init-param/searchEngineRobotsDb/",
    "XmlTable004"."/root/web-app/servlet/init-param/useDataStore/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreClass/",
    "XmlTable004"."/root/web-app/servlet/init-param/redirectionClass/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreName/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreDriver/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreUrl/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreUser/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStorePassword/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreTestQuery/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreLogFile/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/dataStoreInitConns/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreInitConns/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/dataStoreMaxConns/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreMaxConns/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/dataStoreConnUsageLimit/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreConnUsageLimit/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataStoreLogLevel/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/maxUrlLength/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/maxUrlLength/",
    "XmlTable004"."/root/web-app/servlet/init-param/mailHost/",
    "XmlTable004"."/root/web-app/servlet/init-param/mailHostOverride/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/log/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/log/",
    "XmlTable004"."/root/web-app/servlet/init-param/logLocation/",
    "XmlTable004"."/root/web-app/servlet/init-param/logMaxSize/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/dataLog/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/dataLog/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataLogLocation/",
    "XmlTable004"."/root/web-app/servlet/init-param/dataLogMaxSize/",
    "XmlTable004"."/root/web-app/servlet/init-param/removePageCache/",
    "XmlTable004"."/root/web-app/servlet/init-param/removeTemplateCache/",
    "XmlTable004"."/root/web-app/servlet/init-param/fileTransferFolder/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/lookInContext/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/lookInContext/",
    -- "XmlTable004"."/root/web-app/servlet/init-param/adminGroupID/@type",
    "XmlTable004"."/root/web-app/servlet/init-param/adminGroupID/",
    "XmlTable004"."/root/web-app/servlet/init-param/betaServer/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    "XmlTable005"."/root/web-app/servlet-mapping/cofaxCDS/",
    "XmlTable005"."/root/web-app/servlet-mapping/cofaxEmail/",
    "XmlTable005"."/root/web-app/servlet-mapping/cofaxAdmin/",
    "XmlTable005"."/root/web-app/servlet-mapping/fileServlet/",
    "XmlTable005"."/root/web-app/servlet-mapping/cofaxTools/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    "XmlTable006"."/root/web-app/taglib/taglib-uri/",
    "XmlTable006"."/root/web-app/taglib/taglib-location/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/web-app' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/web-app/servlet/" xml PATH 'servlet',
               "/root/web-app/servlet-mapping/" xml PATH 'servlet-mapping',
               "/root/web-app/taglib/" xml PATH 'taglib'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/servlet' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/web-app/servlet/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/web-app/servlet/servlet-name/" STRING PATH 'servlet-name',
               "/root/web-app/servlet/servlet-class/" STRING PATH 'servlet-class',
               "/root/web-app/servlet/init-param/" xml PATH 'init-param'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/init-param' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/web-app/servlet/init-param/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/web-app/servlet/init-param/configGlossary:installationAt/" STRING PATH 'configGlossary_u003A_installationAt',
               "/root/web-app/servlet/init-param/configGlossary:adminEmail/" STRING PATH 'configGlossary_u003A_adminEmail',
               "/root/web-app/servlet/init-param/configGlossary:poweredBy/" STRING PATH 'configGlossary_u003A_poweredBy',
               "/root/web-app/servlet/init-param/configGlossary:poweredByIcon/" STRING PATH 'configGlossary_u003A_poweredByIcon',
               "/root/web-app/servlet/init-param/configGlossary:staticPath/" STRING PATH 'configGlossary_u003A_staticPath',
               "/root/web-app/servlet/init-param/templateProcessorClass/" STRING PATH 'templateProcessorClass',
               "/root/web-app/servlet/init-param/templateLoaderClass/" STRING PATH 'templateLoaderClass',
               "/root/web-app/servlet/init-param/templatePath/" STRING PATH 'templatePath',
               "/root/web-app/servlet/init-param/templateOverridePath/" STRING PATH 'templateOverridePath',
               "/root/web-app/servlet/init-param/defaultListTemplate/" STRING PATH 'defaultListTemplate',
               "/root/web-app/servlet/init-param/defaultFileTemplate/" STRING PATH 'defaultFileTemplate',
               "/root/web-app/servlet/init-param/useJSP/" BOOLEAN PATH 'useJSP',
               "/root/web-app/servlet/init-param/jspListTemplate/" STRING PATH 'jspListTemplate',
               "/root/web-app/servlet/init-param/jspFileTemplate/" STRING PATH 'jspFileTemplate',
               "/root/web-app/servlet/init-param/cachePackageTagsTrack/@type" STRING PATH 'cachePackageTagsTrack/@xsi:type',
               "/root/web-app/servlet/init-param/cachePackageTagsTrack/" INTEGER PATH 'cachePackageTagsTrack',
               "/root/web-app/servlet/init-param/cachePackageTagsStore/@type" STRING PATH 'cachePackageTagsStore/@xsi:type',
               "/root/web-app/servlet/init-param/cachePackageTagsStore/" INTEGER PATH 'cachePackageTagsStore',
               "/root/web-app/servlet/init-param/cachePackageTagsRefresh/@type" STRING PATH 'cachePackageTagsRefresh/@xsi:type',
               "/root/web-app/servlet/init-param/cachePackageTagsRefresh/" INTEGER PATH 'cachePackageTagsRefresh',
               "/root/web-app/servlet/init-param/cacheTemplatesTrack/@type" STRING PATH 'cacheTemplatesTrack/@xsi:type',
               "/root/web-app/servlet/init-param/cacheTemplatesTrack/" INTEGER PATH 'cacheTemplatesTrack',
               "/root/web-app/servlet/init-param/cacheTemplatesStore/@type" STRING PATH 'cacheTemplatesStore/@xsi:type',
               "/root/web-app/servlet/init-param/cacheTemplatesStore/" INTEGER PATH 'cacheTemplatesStore',
               "/root/web-app/servlet/init-param/cacheTemplatesRefresh/@type" STRING PATH 'cacheTemplatesRefresh/@xsi:type',
               "/root/web-app/servlet/init-param/cacheTemplatesRefresh/" INTEGER PATH 'cacheTemplatesRefresh',
               "/root/web-app/servlet/init-param/cachePagesTrack/@type" STRING PATH 'cachePagesTrack/@xsi:type',
               "/root/web-app/servlet/init-param/cachePagesTrack/" INTEGER PATH 'cachePagesTrack',
               "/root/web-app/servlet/init-param/cachePagesStore/@type" STRING PATH 'cachePagesStore/@xsi:type',
               "/root/web-app/servlet/init-param/cachePagesStore/" INTEGER PATH 'cachePagesStore',
               "/root/web-app/servlet/init-param/cachePagesRefresh/@type" STRING PATH 'cachePagesRefresh/@xsi:type',
               "/root/web-app/servlet/init-param/cachePagesRefresh/" INTEGER PATH 'cachePagesRefresh',
               "/root/web-app/servlet/init-param/cachePagesDirtyRead/@type" STRING PATH 'cachePagesDirtyRead/@xsi:type',
               "/root/web-app/servlet/init-param/cachePagesDirtyRead/" INTEGER PATH 'cachePagesDirtyRead',
               "/root/web-app/servlet/init-param/searchEngineListTemplate/" STRING PATH 'searchEngineListTemplate',
               "/root/web-app/servlet/init-param/searchEngineFileTemplate/" STRING PATH 'searchEngineFileTemplate',
               "/root/web-app/servlet/init-param/searchEngineRobotsDb/" STRING PATH 'searchEngineRobotsDb',
               "/root/web-app/servlet/init-param/useDataStore/" BOOLEAN PATH 'useDataStore',
               "/root/web-app/servlet/init-param/dataStoreClass/" STRING PATH 'dataStoreClass',
               "/root/web-app/servlet/init-param/redirectionClass/" STRING PATH 'redirectionClass',
               "/root/web-app/servlet/init-param/dataStoreName/" STRING PATH 'dataStoreName',
               "/root/web-app/servlet/init-param/dataStoreDriver/" STRING PATH 'dataStoreDriver',
               "/root/web-app/servlet/init-param/dataStoreUrl/" STRING PATH 'dataStoreUrl',
               "/root/web-app/servlet/init-param/dataStoreUser/" STRING PATH 'dataStoreUser',
               "/root/web-app/servlet/init-param/dataStorePassword/" STRING PATH 'dataStorePassword',
               "/root/web-app/servlet/init-param/dataStoreTestQuery/" STRING PATH 'dataStoreTestQuery',
               "/root/web-app/servlet/init-param/dataStoreLogFile/" STRING PATH 'dataStoreLogFile',
               "/root/web-app/servlet/init-param/dataStoreInitConns/@type" STRING PATH 'dataStoreInitConns/@xsi:type',
               "/root/web-app/servlet/init-param/dataStoreInitConns/" INTEGER PATH 'dataStoreInitConns',
               "/root/web-app/servlet/init-param/dataStoreMaxConns/@type" STRING PATH 'dataStoreMaxConns/@xsi:type',
               "/root/web-app/servlet/init-param/dataStoreMaxConns/" INTEGER PATH 'dataStoreMaxConns',
               "/root/web-app/servlet/init-param/dataStoreConnUsageLimit/@type" STRING PATH 'dataStoreConnUsageLimit/@xsi:type',
               "/root/web-app/servlet/init-param/dataStoreConnUsageLimit/" INTEGER PATH 'dataStoreConnUsageLimit',
               "/root/web-app/servlet/init-param/dataStoreLogLevel/" STRING PATH 'dataStoreLogLevel',
               "/root/web-app/servlet/init-param/maxUrlLength/@type" STRING PATH 'maxUrlLength/@xsi:type',
               "/root/web-app/servlet/init-param/maxUrlLength/" INTEGER PATH 'maxUrlLength',
               "/root/web-app/servlet/init-param/mailHost/" STRING PATH 'mailHost',
               "/root/web-app/servlet/init-param/mailHostOverride/" STRING PATH 'mailHostOverride',
               "/root/web-app/servlet/init-param/log/@type" STRING PATH 'log/@xsi:type',
               "/root/web-app/servlet/init-param/log/" INTEGER PATH 'log',
               "/root/web-app/servlet/init-param/logLocation/" STRING PATH 'logLocation',
               "/root/web-app/servlet/init-param/logMaxSize/" STRING PATH 'logMaxSize',
               "/root/web-app/servlet/init-param/dataLog/@type" STRING PATH 'dataLog/@xsi:type',
               "/root/web-app/servlet/init-param/dataLog/" INTEGER PATH 'dataLog',
               "/root/web-app/servlet/init-param/dataLogLocation/" STRING PATH 'dataLogLocation',
               "/root/web-app/servlet/init-param/dataLogMaxSize/" STRING PATH 'dataLogMaxSize',
               "/root/web-app/servlet/init-param/removePageCache/" STRING PATH 'removePageCache',
               "/root/web-app/servlet/init-param/removeTemplateCache/" STRING PATH 'removeTemplateCache',
               "/root/web-app/servlet/init-param/fileTransferFolder/" STRING PATH 'fileTransferFolder',
               "/root/web-app/servlet/init-param/lookInContext/@type" STRING PATH 'lookInContext/@xsi:type',
               "/root/web-app/servlet/init-param/lookInContext/" INTEGER PATH 'lookInContext',
               "/root/web-app/servlet/init-param/adminGroupID/@type" STRING PATH 'adminGroupID/@xsi:type',
               "/root/web-app/servlet/init-param/adminGroupID/" INTEGER PATH 'adminGroupID',
               "/root/web-app/servlet/init-param/betaServer/" BOOLEAN PATH 'betaServer'
        ) xt
) "XmlTable004"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/servlet-mapping' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/web-app/servlet-mapping/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/web-app/servlet-mapping/cofaxCDS/" STRING PATH 'cofaxCDS',
               "/root/web-app/servlet-mapping/cofaxEmail/" STRING PATH 'cofaxEmail',
               "/root/web-app/servlet-mapping/cofaxAdmin/" STRING PATH 'cofaxAdmin',
               "/root/web-app/servlet-mapping/fileServlet/" STRING PATH 'fileServlet',
               "/root/web-app/servlet-mapping/cofaxTools/" STRING PATH 'cofaxTools'
        ) xt
) "XmlTable005"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/taglib' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/web-app/taglib/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/web-app/taglib/taglib-uri/" STRING PATH 'taglib-uri',
               "/root/web-app/taglib/taglib-location/" STRING PATH 'taglib-location'
        ) xt
) "XmlTable006"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable006"."dv_xml_wrapper_parent_id"