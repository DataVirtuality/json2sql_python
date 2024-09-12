with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./finial_dataset.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    "XmlTable002"."/root/root/knowledgeTime/",
    "XmlTable002"."/root/root/validTime/",
    "XmlTable002"."/root/root/type/",
    "XmlTable002"."/root/root/knowledgeEndTime/",
    "XmlTable002"."/root/root/assetType/",
    "XmlTable002"."/root/root/aexeoOrderId/",
    "XmlTable002"."/root/root/clientOrderId/",
    "XmlTable002"."/root/root/summa_id/",
    "XmlTable002"."/root/root/portfolioName/",
    "XmlTable002"."/root/root/brokerName/",
    "XmlTable002"."/root/root/basketName/",
    "XmlTable002"."/root/root/strategyName/",
    "XmlTable002"."/root/root/custodianAccountName/",
    "XmlTable002"."/root/root/custodianName/",
    "XmlTable002"."/root/root/managerName/",
    "XmlTable002"."/root/root/quantity/",
    "XmlTable002"."/root/root/price/",
    "XmlTable002"."/root/root/cost/",
    "XmlTable002"."/root/root/secFeeAmount/",
    "XmlTable002"."/root/root/exFeeAmount/",
    "XmlTable002"."/root/root/brokerCommissionAmount/",
    "XmlTable002"."/root/root/legalFeeAmount/",
    "XmlTable002"."/root/root/totalExpenseAmount/",
    "XmlTable002"."/root/root/actualSettleDate/",
    "XmlTable002"."/root/root/contractualSettleDate/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/root' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/root/knowledgeTime/" STRING PATH 'knowledgeTime',
               "/root/root/validTime/" STRING PATH 'validTime',
               "/root/root/type/" STRING PATH 'type',
               "/root/root/knowledgeEndTime/" STRING PATH 'knowledgeEndTime',
               "/root/root/assetType/" STRING PATH 'assetType',
               "/root/root/aexeoOrderId/" STRING PATH 'aexeoOrderId',
               "/root/root/clientOrderId/" STRING PATH 'clientOrderId',
               "/root/root/summa_id/" STRING PATH 'summa_id',
               "/root/root/portfolioName/" STRING PATH 'portfolioName',
               "/root/root/brokerName/" STRING PATH 'brokerName',
               "/root/root/basketName/" STRING PATH 'basketName',
               "/root/root/strategyName/" STRING PATH 'strategyName',
               "/root/root/custodianAccountName/" STRING PATH 'custodianAccountName',
               "/root/root/custodianName/" STRING PATH 'custodianName',
               "/root/root/managerName/" STRING PATH 'managerName',
               "/root/root/quantity/" STRING PATH 'quantity',
               "/root/root/price/" STRING PATH 'price',
               "/root/root/cost/" STRING PATH 'cost',
               "/root/root/secFeeAmount/" STRING PATH 'secFeeAmount',
               "/root/root/exFeeAmount/" STRING PATH 'exFeeAmount',
               "/root/root/brokerCommissionAmount/" STRING PATH 'brokerCommissionAmount',
               "/root/root/legalFeeAmount/" STRING PATH 'legalFeeAmount',
               "/root/root/totalExpenseAmount/" STRING PATH 'totalExpenseAmount',
               "/root/root/actualSettleDate/" STRING PATH 'actualSettleDate',
               "/root/root/contractualSettleDate/" STRING PATH 'contractualSettleDate'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"