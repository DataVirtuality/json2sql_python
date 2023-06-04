with cte as (
    SELECT
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "dv_sample_data".getFiles('sample-data\s02.json') f
)
select
    *
from cte
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/web-app' PASSING "cte"."xmldata"
    COLUMNS
    "idColumn_01" FOR ORDINALITY,
    "/root/web-app/servlet" xml PATH 'servlet',
    "/root/web-app/servlet-mapping" xml PATH 'servlet-mapping',
    "/root/web-app/taglib" xml PATH 'taglib'
) "xmltable01"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/web-app/servlet' PASSING "xmltable01"."/root/web-app/servlet"
    COLUMNS
    "idColumn_02" FOR ORDINALITY,
    "/root/web-app/servlet/servlet-name" string PATH 'servlet-name',
    "/root/web-app/servlet/servlet-class" string PATH 'servlet-class',
    "/root/web-app/servlet/init-param" xml PATH 'init-param'
) "xmltable02"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/web-app/servlet/init-param' PASSING "xmltable02"."/root/web-app/servlet/init-param"
    COLUMNS
    "idColumn_03" FOR ORDINALITY,
    "/root/web-app/servlet/init-param/configGlossary:installationAt" string PATH 'configGlossary:installationAt',
    "/root/web-app/servlet/init-param/configGlossary:adminEmail" string PATH 'configGlossary:adminEmail',
    "/root/web-app/servlet/init-param/configGlossary:poweredBy" string PATH 'configGlossary:poweredBy',
    "/root/web-app/servlet/init-param/configGlossary:poweredByIcon" string PATH 'configGlossary:poweredByIcon',
    "/root/web-app/servlet/init-param/configGlossary:staticPath" string PATH 'configGlossary:staticPath',
    "/root/web-app/servlet/init-param/templateProcessorClass" string PATH 'templateProcessorClass',
    "/root/web-app/servlet/init-param/templateLoaderClass" string PATH 'templateLoaderClass',
    "/root/web-app/servlet/init-param/templatePath" string PATH 'templatePath',
    "/root/web-app/servlet/init-param/templateOverridePath" string PATH 'templateOverridePath',
    "/root/web-app/servlet/init-param/defaultListTemplate" string PATH 'defaultListTemplate',
    "/root/web-app/servlet/init-param/defaultFileTemplate" string PATH 'defaultFileTemplate',
    "/root/web-app/servlet/init-param/useJSP/type" STRING PATH 'useJSP/@xsi:type',
    "/root/web-app/servlet/init-param/useJSP" integer PATH 'useJSP',
    "/root/web-app/servlet/init-param/jspListTemplate" string PATH 'jspListTemplate',
    "/root/web-app/servlet/init-param/jspFileTemplate" string PATH 'jspFileTemplate',
    "/root/web-app/servlet/init-param/cachePackageTagsTrack/type" STRING PATH 'cachePackageTagsTrack/@xsi:type',
    "/root/web-app/servlet/init-param/cachePackageTagsTrack" integer PATH 'cachePackageTagsTrack',
    "/root/web-app/servlet/init-param/cachePackageTagsStore/type" STRING PATH 'cachePackageTagsStore/@xsi:type',
    "/root/web-app/servlet/init-param/cachePackageTagsStore" integer PATH 'cachePackageTagsStore',
    "/root/web-app/servlet/init-param/cachePackageTagsRefresh/type" STRING PATH 'cachePackageTagsRefresh/@xsi:type',
    "/root/web-app/servlet/init-param/cachePackageTagsRefresh" integer PATH 'cachePackageTagsRefresh',
    "/root/web-app/servlet/init-param/cacheTemplatesTrack/type" STRING PATH 'cacheTemplatesTrack/@xsi:type',
    "/root/web-app/servlet/init-param/cacheTemplatesTrack" integer PATH 'cacheTemplatesTrack',
    "/root/web-app/servlet/init-param/cacheTemplatesStore/type" STRING PATH 'cacheTemplatesStore/@xsi:type',
    "/root/web-app/servlet/init-param/cacheTemplatesStore" integer PATH 'cacheTemplatesStore',
    "/root/web-app/servlet/init-param/cacheTemplatesRefresh/type" STRING PATH 'cacheTemplatesRefresh/@xsi:type',
    "/root/web-app/servlet/init-param/cacheTemplatesRefresh" integer PATH 'cacheTemplatesRefresh',
    "/root/web-app/servlet/init-param/cachePagesTrack/type" STRING PATH 'cachePagesTrack/@xsi:type',
    "/root/web-app/servlet/init-param/cachePagesTrack" integer PATH 'cachePagesTrack',
    "/root/web-app/servlet/init-param/cachePagesStore/type" STRING PATH 'cachePagesStore/@xsi:type',
    "/root/web-app/servlet/init-param/cachePagesStore" integer PATH 'cachePagesStore',
    "/root/web-app/servlet/init-param/cachePagesRefresh/type" STRING PATH 'cachePagesRefresh/@xsi:type',
    "/root/web-app/servlet/init-param/cachePagesRefresh" integer PATH 'cachePagesRefresh',
    "/root/web-app/servlet/init-param/cachePagesDirtyRead/type" STRING PATH 'cachePagesDirtyRead/@xsi:type',
    "/root/web-app/servlet/init-param/cachePagesDirtyRead" integer PATH 'cachePagesDirtyRead',
    "/root/web-app/servlet/init-param/searchEngineListTemplate" string PATH 'searchEngineListTemplate',
    "/root/web-app/servlet/init-param/searchEngineFileTemplate" string PATH 'searchEngineFileTemplate',
    "/root/web-app/servlet/init-param/searchEngineRobotsDb" string PATH 'searchEngineRobotsDb',
    "/root/web-app/servlet/init-param/useDataStore/type" STRING PATH 'useDataStore/@xsi:type',
    "/root/web-app/servlet/init-param/useDataStore" integer PATH 'useDataStore',
    "/root/web-app/servlet/init-param/dataStoreClass" string PATH 'dataStoreClass',
    "/root/web-app/servlet/init-param/redirectionClass" string PATH 'redirectionClass',
    "/root/web-app/servlet/init-param/dataStoreName" string PATH 'dataStoreName',
    "/root/web-app/servlet/init-param/dataStoreDriver" string PATH 'dataStoreDriver',
    "/root/web-app/servlet/init-param/dataStoreUrl" string PATH 'dataStoreUrl',
    "/root/web-app/servlet/init-param/dataStoreUser" string PATH 'dataStoreUser',
    "/root/web-app/servlet/init-param/dataStorePassword" string PATH 'dataStorePassword',
    "/root/web-app/servlet/init-param/dataStoreTestQuery" string PATH 'dataStoreTestQuery',
    "/root/web-app/servlet/init-param/dataStoreLogFile" string PATH 'dataStoreLogFile',
    "/root/web-app/servlet/init-param/dataStoreInitConns/type" STRING PATH 'dataStoreInitConns/@xsi:type',
    "/root/web-app/servlet/init-param/dataStoreInitConns" integer PATH 'dataStoreInitConns',
    "/root/web-app/servlet/init-param/dataStoreMaxConns/type" STRING PATH 'dataStoreMaxConns/@xsi:type',
    "/root/web-app/servlet/init-param/dataStoreMaxConns" integer PATH 'dataStoreMaxConns',
    "/root/web-app/servlet/init-param/dataStoreConnUsageLimit/type" STRING PATH 'dataStoreConnUsageLimit/@xsi:type',
    "/root/web-app/servlet/init-param/dataStoreConnUsageLimit" integer PATH 'dataStoreConnUsageLimit',
    "/root/web-app/servlet/init-param/dataStoreLogLevel" string PATH 'dataStoreLogLevel',
    "/root/web-app/servlet/init-param/maxUrlLength/type" STRING PATH 'maxUrlLength/@xsi:type',
    "/root/web-app/servlet/init-param/maxUrlLength" integer PATH 'maxUrlLength',
    "/root/web-app/servlet/init-param/mailHost" string PATH 'mailHost',
    "/root/web-app/servlet/init-param/mailHostOverride" string PATH 'mailHostOverride',
    "/root/web-app/servlet/init-param/log/type" STRING PATH 'log/@xsi:type',
    "/root/web-app/servlet/init-param/log" integer PATH 'log',
    "/root/web-app/servlet/init-param/logLocation" string PATH 'logLocation',
    "/root/web-app/servlet/init-param/logMaxSize" string PATH 'logMaxSize',
    "/root/web-app/servlet/init-param/dataLog/type" STRING PATH 'dataLog/@xsi:type',
    "/root/web-app/servlet/init-param/dataLog" integer PATH 'dataLog',
    "/root/web-app/servlet/init-param/dataLogLocation" string PATH 'dataLogLocation',
    "/root/web-app/servlet/init-param/dataLogMaxSize" string PATH 'dataLogMaxSize',
    "/root/web-app/servlet/init-param/removePageCache" string PATH 'removePageCache',
    "/root/web-app/servlet/init-param/removeTemplateCache" string PATH 'removeTemplateCache',
    "/root/web-app/servlet/init-param/fileTransferFolder" string PATH 'fileTransferFolder',
    "/root/web-app/servlet/init-param/lookInContext/type" STRING PATH 'lookInContext/@xsi:type',
    "/root/web-app/servlet/init-param/lookInContext" integer PATH 'lookInContext',
    "/root/web-app/servlet/init-param/adminGroupID/type" STRING PATH 'adminGroupID/@xsi:type',
    "/root/web-app/servlet/init-param/adminGroupID" integer PATH 'adminGroupID',
    "/root/web-app/servlet/init-param/betaServer/type" STRING PATH 'betaServer/@xsi:type',
    "/root/web-app/servlet/init-param/betaServer" integer PATH 'betaServer'
) "xmltable03"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/web-app/servlet-mapping' PASSING "xmltable01"."/root/web-app/servlet-mapping"
    COLUMNS
    "idColumn_04" FOR ORDINALITY,
    "/root/web-app/servlet-mapping/cofaxCDS" string PATH 'cofaxCDS',
    "/root/web-app/servlet-mapping/cofaxEmail" string PATH 'cofaxEmail',
    "/root/web-app/servlet-mapping/cofaxAdmin" string PATH 'cofaxAdmin',
    "/root/web-app/servlet-mapping/fileServlet" string PATH 'fileServlet',
    "/root/web-app/servlet-mapping/cofaxTools" string PATH 'cofaxTools'
) "xmltable04"
cross join XMLTABLE(
    XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/root/web-app/taglib' PASSING "xmltable01"."/root/web-app/taglib"
    COLUMNS
    "idColumn_05" FOR ORDINALITY,
    "/root/web-app/taglib/taglib-uri" string PATH 'taglib-uri',
    "/root/web-app/taglib/taglib-location" string PATH 'taglib-location'
) "xmltable05"