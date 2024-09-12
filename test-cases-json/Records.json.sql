with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./Records.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/data/runTradeReport/records/asset/",
    "XmlTable002"."/root/data/runTradeReport/records/knowledgeTime/",
    "XmlTable002"."/root/data/runTradeReport/records/validTime/",
    "XmlTable002"."/root/data/runTradeReport/records/type/",
    "XmlTable002"."/root/data/runTradeReport/records/knowledgeEndTime/",
    "XmlTable002"."/root/data/runTradeReport/records/assetType/",
    "XmlTable002"."/root/data/runTradeReport/records/clientOrderId/",
    "XmlTable002"."/root/data/runTradeReport/records/summa_id/",
    "XmlTable002"."/root/data/runTradeReport/records/quantity/",
    "XmlTable002"."/root/data/runTradeReport/records/price/",
    "XmlTable002"."/root/data/runTradeReport/records/cost/",
    "XmlTable002"."/root/data/runTradeReport/records/actualSettleDate/",
    "XmlTable002"."/root/data/runTradeReport/records/contractualSettleDate/",
    "XmlTable002"."/root/data/runTradeReport/records/aexeosId/",
    "XmlTable002"."/root/data/runTradeReport/records/standardSECFees/",
    "XmlTable002"."/root/data/runTradeReport/records/standardMiscellaneousFees/",
    "XmlTable002"."/root/data/runTradeReport/records/standardMiscellaneousExpenses/",
    "XmlTable002"."/root/data/runTradeReport/records/standardExpenses/",
    "XmlTable002"."/root/data/runTradeReport/records/standardCommissions/",
    -- "XmlTable002"."/root/data/runTradeReport/records/broker/",
    "XmlTable002"."/root/data/runTradeReport/records/basket/",
    -- "XmlTable002"."/root/data/runTradeReport/records/strategy/",
    -- "XmlTable002"."/root/data/runTradeReport/records/custodianAccount/",
    -- "XmlTable002"."/root/data/runTradeReport/records/manager/",
    -- "XmlTable002"."/root/data/runTradeReport/records/portfolio/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    "XmlTable003"."/root/data/runTradeReport/records/asset/assetName/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/assetKnowledgeTime/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/cusip/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/isin/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/sedol/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/priceFactor/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/tradeQuantityFactor/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/tid/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/symbol/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/description/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/bloomberg_rt/",
    "XmlTable003"."/root/data/runTradeReport/records/asset/assetAexeosId/",
    -- "XmlTable003"."/root/data/runTradeReport/records/asset/option/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/data/runTradeReport/records/asset/option/callPut/",
    "XmlTable004"."/root/data/runTradeReport/records/asset/option/contractSize/",
    "XmlTable004"."/root/data/runTradeReport/records/asset/option/expirationDate/",
    "XmlTable004"."/root/data/runTradeReport/records/asset/option/strikePrice/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    "XmlTable005"."/root/data/runTradeReport/records/broker/brokerName/",
    "XmlTable005"."/root/data/runTradeReport/records/broker/brokerAexeosId/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    "XmlTable006"."/root/data/runTradeReport/records/strategy/strategyName/",
    "XmlTable006"."/root/data/runTradeReport/records/strategy/strategyAexeosId/",
    -- "XmlTable007"."idColumn_007",
    -- "XmlTable007"."dv_xml_wrapper_parent_id",
    -- "XmlTable007"."dv_xml_wrapper_id_007",
    "XmlTable007"."/root/data/runTradeReport/records/custodianAccount/custodianAccountName/",
    "XmlTable007"."/root/data/runTradeReport/records/custodianAccount/custodianAccountShortName/",
    "XmlTable007"."/root/data/runTradeReport/records/custodianAccount/custodianAccountLongName/",
    "XmlTable007"."/root/data/runTradeReport/records/custodianAccount/custodianAccountAexeoSId/",
    -- "XmlTable008"."idColumn_008",
    -- "XmlTable008"."dv_xml_wrapper_parent_id",
    -- "XmlTable008"."dv_xml_wrapper_id_008",
    "XmlTable008"."/root/data/runTradeReport/records/manager/managerName/",
    "XmlTable008"."/root/data/runTradeReport/records/manager/managerAexeoSId/",
    -- "XmlTable009"."idColumn_009",
    -- "XmlTable009"."dv_xml_wrapper_parent_id",
    -- "XmlTable009"."dv_xml_wrapper_id_009",
    "XmlTable009"."/root/data/runTradeReport/records/portfolio/portfolioName/",
    "XmlTable009"."/root/data/runTradeReport/records/portfolio/portfolioAexeoSId/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/data/runTradeReport/records' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../../../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/asset/" xml PATH 'asset',
               "/root/data/runTradeReport/records/knowledgeTime/" STRING PATH 'knowledgeTime',
               "/root/data/runTradeReport/records/validTime/" STRING PATH 'validTime',
               "/root/data/runTradeReport/records/type/" STRING PATH 'type',
               "/root/data/runTradeReport/records/knowledgeEndTime/" STRING PATH 'knowledgeEndTime',
               "/root/data/runTradeReport/records/assetType/" STRING PATH 'assetType',
               "/root/data/runTradeReport/records/clientOrderId/" STRING PATH 'clientOrderId',
               "/root/data/runTradeReport/records/summa_id/" STRING PATH 'summa_id',
               "/root/data/runTradeReport/records/quantity/" STRING PATH 'quantity',
               "/root/data/runTradeReport/records/price/" STRING PATH 'price',
               "/root/data/runTradeReport/records/cost/" STRING PATH 'cost',
               "/root/data/runTradeReport/records/actualSettleDate/" STRING PATH 'actualSettleDate',
               "/root/data/runTradeReport/records/contractualSettleDate/" STRING PATH 'contractualSettleDate',
               "/root/data/runTradeReport/records/aexeosId/" STRING PATH 'aexeosId',
               "/root/data/runTradeReport/records/standardSECFees/" STRING PATH 'standardSECFees',
               "/root/data/runTradeReport/records/standardMiscellaneousFees/" STRING PATH 'standardMiscellaneousFees',
               "/root/data/runTradeReport/records/standardMiscellaneousExpenses/" STRING PATH 'standardMiscellaneousExpenses',
               "/root/data/runTradeReport/records/standardExpenses/" STRING PATH 'standardExpenses',
               "/root/data/runTradeReport/records/standardCommissions/" STRING PATH 'standardCommissions',
               "/root/data/runTradeReport/records/broker/" xml PATH 'broker',
               "/root/data/runTradeReport/records/basket/" STRING PATH 'basket',
               "/root/data/runTradeReport/records/strategy/" xml PATH 'strategy',
               "/root/data/runTradeReport/records/custodianAccount/" xml PATH 'custodianAccount',
               "/root/data/runTradeReport/records/manager/" xml PATH 'manager',
               "/root/data/runTradeReport/records/portfolio/" xml PATH 'portfolio'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/asset' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/records/asset/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/asset/assetName/" STRING PATH 'assetName',
               "/root/data/runTradeReport/records/asset/assetKnowledgeTime/" STRING PATH 'assetKnowledgeTime',
               "/root/data/runTradeReport/records/asset/cusip/" STRING PATH 'cusip',
               "/root/data/runTradeReport/records/asset/isin/" STRING PATH 'isin',
               "/root/data/runTradeReport/records/asset/sedol/" STRING PATH 'sedol',
               "/root/data/runTradeReport/records/asset/priceFactor/" STRING PATH 'priceFactor',
               "/root/data/runTradeReport/records/asset/tradeQuantityFactor/" STRING PATH 'tradeQuantityFactor',
               "/root/data/runTradeReport/records/asset/tid/" STRING PATH 'tid',
               "/root/data/runTradeReport/records/asset/symbol/" STRING PATH 'symbol',
               "/root/data/runTradeReport/records/asset/description/" STRING PATH 'description',
               "/root/data/runTradeReport/records/asset/bloomberg_rt/" STRING PATH 'bloomberg_rt',
               "/root/data/runTradeReport/records/asset/assetAexeosId/" STRING PATH 'assetAexeosId',
               "/root/data/runTradeReport/records/asset/option/" xml PATH 'option'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/option' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/data/runTradeReport/records/asset/option/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/asset/option/callPut/" STRING PATH 'callPut',
               "/root/data/runTradeReport/records/asset/option/contractSize/" STRING PATH 'contractSize',
               "/root/data/runTradeReport/records/asset/option/expirationDate/" STRING PATH 'expirationDate',
               "/root/data/runTradeReport/records/asset/option/strikePrice/" STRING PATH 'strikePrice'
        ) xt
) "XmlTable004"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/broker' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/records/broker/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/broker/brokerName/" STRING PATH 'brokerName',
               "/root/data/runTradeReport/records/broker/brokerAexeosId/" STRING PATH 'brokerAexeosId'
        ) xt
) "XmlTable005"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/strategy' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/records/strategy/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/strategy/strategyName/" STRING PATH 'strategyName',
               "/root/data/runTradeReport/records/strategy/strategyAexeosId/" STRING PATH 'strategyAexeosId'
        ) xt
) "XmlTable006"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable006"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_007",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/custodianAccount' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/records/custodianAccount/"
               )
		    COLUMNS
               "idColumn_007" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/custodianAccount/custodianAccountName/" STRING PATH 'custodianAccountName',
               "/root/data/runTradeReport/records/custodianAccount/custodianAccountShortName/" STRING PATH 'custodianAccountShortName',
               "/root/data/runTradeReport/records/custodianAccount/custodianAccountLongName/" STRING PATH 'custodianAccountLongName',
               "/root/data/runTradeReport/records/custodianAccount/custodianAccountAexeoSId/" STRING PATH 'custodianAccountAexeoSId'
        ) xt
) "XmlTable007"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable007"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_008",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/manager' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/records/manager/"
               )
		    COLUMNS
               "idColumn_008" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/manager/managerName/" STRING PATH 'managerName',
               "/root/data/runTradeReport/records/manager/managerAexeoSId/" STRING PATH 'managerAexeoSId'
        ) xt
) "XmlTable008"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable008"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_009",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/portfolio' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/data/runTradeReport/records/portfolio/"
               )
		    COLUMNS
               "idColumn_009" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/data/runTradeReport/records/portfolio/portfolioName/" STRING PATH 'portfolioName',
               "/root/data/runTradeReport/records/portfolio/portfolioAexeoSId/" STRING PATH 'portfolioAexeoSId'
        ) xt
) "XmlTable009"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable009"."dv_xml_wrapper_parent_id"