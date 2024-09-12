with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./first_rsp.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/data/runTradeReport/pageInfo/",
    -- "XmlTable002"."/root/data/runTradeReport/records/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    "XmlTable003"."/root/data/runTradeReport/pageInfo/forwardCursor/",
    "XmlTable003"."/root/data/runTradeReport/pageInfo/hasNextPage/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/data/runTradeReport/records/knowledgeTime/",
    "XmlTable004"."/root/data/runTradeReport/records/validTime/",
    "XmlTable004"."/root/data/runTradeReport/records/type/",
    "XmlTable004"."/root/data/runTradeReport/records/knowledgeEndTime/",
    "XmlTable004"."/root/data/runTradeReport/records/assetType/",
    "XmlTable004"."/root/data/runTradeReport/records/aexeoOrderId/",
    "XmlTable004"."/root/data/runTradeReport/records/clientOrderId/",
    "XmlTable004"."/root/data/runTradeReport/records/summa_id/",
    "XmlTable004"."/root/data/runTradeReport/records/portfolioName/",
    "XmlTable004"."/root/data/runTradeReport/records/brokerName/",
    "XmlTable004"."/root/data/runTradeReport/records/basketName/",
    "XmlTable004"."/root/data/runTradeReport/records/strategyName/",
    "XmlTable004"."/root/data/runTradeReport/records/custodianAccountName/",
    "XmlTable004"."/root/data/runTradeReport/records/custodianName/",
    "XmlTable004"."/root/data/runTradeReport/records/managerName/",
    "XmlTable004"."/root/data/runTradeReport/records/quantity/",
    "XmlTable004"."/root/data/runTradeReport/records/price/",
    "XmlTable004"."/root/data/runTradeReport/records/cost/",
    "XmlTable004"."/root/data/runTradeReport/records/secFeeAmount/",
    "XmlTable004"."/root/data/runTradeReport/records/exFeeAmount/",
    "XmlTable004"."/root/data/runTradeReport/records/brokerCommissionAmount/",
    "XmlTable004"."/root/data/runTradeReport/records/legalFeeAmount/",
    "XmlTable004"."/root/data/runTradeReport/records/totalExpenseAmount/",
    "XmlTable004"."/root/data/runTradeReport/records/actualSettleDate/",
    "XmlTable004"."/root/data/runTradeReport/records/contractualSettleDate/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/data/runTradeReport' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/pageInfo/" xml PATH 'pageInfo',
               "/root/data/runTradeReport/records/" xml PATH 'records'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/pageInfo' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/pageInfo/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/pageInfo/forwardCursor/" STRING PATH 'forwardCursor',
               "/root/data/runTradeReport/pageInfo/hasNextPage/" BOOLEAN PATH 'hasNextPage'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/records' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/records/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/knowledgeTime/" STRING PATH 'knowledgeTime',
               "/root/data/runTradeReport/records/validTime/" STRING PATH 'validTime',
               "/root/data/runTradeReport/records/type/" STRING PATH 'type',
               "/root/data/runTradeReport/records/knowledgeEndTime/" STRING PATH 'knowledgeEndTime',
               "/root/data/runTradeReport/records/assetType/" STRING PATH 'assetType',
               "/root/data/runTradeReport/records/aexeoOrderId/" STRING PATH 'aexeoOrderId',
               "/root/data/runTradeReport/records/clientOrderId/" STRING PATH 'clientOrderId',
               "/root/data/runTradeReport/records/summa_id/" STRING PATH 'summa_id',
               "/root/data/runTradeReport/records/portfolioName/" STRING PATH 'portfolioName',
               "/root/data/runTradeReport/records/brokerName/" STRING PATH 'brokerName',
               "/root/data/runTradeReport/records/basketName/" STRING PATH 'basketName',
               "/root/data/runTradeReport/records/strategyName/" STRING PATH 'strategyName',
               "/root/data/runTradeReport/records/custodianAccountName/" STRING PATH 'custodianAccountName',
               "/root/data/runTradeReport/records/custodianName/" STRING PATH 'custodianName',
               "/root/data/runTradeReport/records/managerName/" STRING PATH 'managerName',
               "/root/data/runTradeReport/records/quantity/" STRING PATH 'quantity',
               "/root/data/runTradeReport/records/price/" STRING PATH 'price',
               "/root/data/runTradeReport/records/cost/" STRING PATH 'cost',
               "/root/data/runTradeReport/records/secFeeAmount/" STRING PATH 'secFeeAmount',
               "/root/data/runTradeReport/records/exFeeAmount/" STRING PATH 'exFeeAmount',
               "/root/data/runTradeReport/records/brokerCommissionAmount/" STRING PATH 'brokerCommissionAmount',
               "/root/data/runTradeReport/records/legalFeeAmount/" STRING PATH 'legalFeeAmount',
               "/root/data/runTradeReport/records/totalExpenseAmount/" STRING PATH 'totalExpenseAmount',
               "/root/data/runTradeReport/records/actualSettleDate/" STRING PATH 'actualSettleDate',
               "/root/data/runTradeReport/records/contractualSettleDate/" STRING PATH 'contractualSettleDate'
        ) xt
) "XmlTable004"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable004"."dv_xml_wrapper_parent_id"