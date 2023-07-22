with "XmlTable001" as (
    SELECT
        uuid() as dv_xml_wrapper_id_001,
        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata
    FROM
        "sample_data_json".getFiles('./s08.json') f
)
select
    --"XmlTable001"."dv_xml_wrapper_id_001",
    -- "XmlTable002"."idColumn_002",
    -- "XmlTable002"."dv_xml_wrapper_parent_id",
    -- "XmlTable002"."dv_xml_wrapper_id_002",
    -- "XmlTable002"."/root/feed/author/",
    -- "XmlTable002"."/root/feed/entry/",
    -- "XmlTable002"."/root/feed/updated/",
    -- "XmlTable002"."/root/feed/rights/",
    -- "XmlTable002"."/root/feed/title/",
    -- "XmlTable002"."/root/feed/icon/",
    -- "XmlTable002"."/root/feed/link/",
    -- "XmlTable002"."/root/feed/id/",
    -- "XmlTable003"."idColumn_003",
    -- "XmlTable003"."dv_xml_wrapper_parent_id",
    -- "XmlTable003"."dv_xml_wrapper_id_003",
    -- "XmlTable003"."/root/feed/author/name/",
    -- "XmlTable003"."/root/feed/author/uri/",
    -- "XmlTable004"."idColumn_004",
    -- "XmlTable004"."dv_xml_wrapper_parent_id",
    -- "XmlTable004"."dv_xml_wrapper_id_004",
    "XmlTable004"."/root/feed/author/name/label/",
    -- "XmlTable005"."idColumn_005",
    -- "XmlTable005"."dv_xml_wrapper_parent_id",
    -- "XmlTable005"."dv_xml_wrapper_id_005",
    "XmlTable005"."/root/feed/author/uri/label/",
    -- "XmlTable006"."idColumn_006",
    -- "XmlTable006"."dv_xml_wrapper_parent_id",
    -- "XmlTable006"."dv_xml_wrapper_id_006",
    -- "XmlTable006"."/root/feed/entry/author/",
    -- "XmlTable006"."/root/feed/entry/updated/",
    -- "XmlTable006"."/root/feed/entry/im:rating/",
    -- "XmlTable006"."/root/feed/entry/im:version/",
    -- "XmlTable006"."/root/feed/entry/id/",
    -- "XmlTable006"."/root/feed/entry/title/",
    -- "XmlTable006"."/root/feed/entry/content/",
    -- "XmlTable006"."/root/feed/entry/link/",
    -- "XmlTable006"."/root/feed/entry/im:voteSum/",
    -- "XmlTable006"."/root/feed/entry/im:contentType/",
    -- "XmlTable006"."/root/feed/entry/im:voteCount/",
    -- "XmlTable007"."idColumn_007",
    -- "XmlTable007"."dv_xml_wrapper_parent_id",
    -- "XmlTable007"."dv_xml_wrapper_id_007",
    -- "XmlTable007"."/root/feed/entry/author/uri/",
    -- "XmlTable007"."/root/feed/entry/author/name/",
    "XmlTable007"."/root/feed/entry/author/label/",
    -- "XmlTable008"."idColumn_008",
    -- "XmlTable008"."dv_xml_wrapper_parent_id",
    -- "XmlTable008"."dv_xml_wrapper_id_008",
    "XmlTable008"."/root/feed/entry/author/uri/label/",
    -- "XmlTable009"."idColumn_009",
    -- "XmlTable009"."dv_xml_wrapper_parent_id",
    -- "XmlTable009"."dv_xml_wrapper_id_009",
    "XmlTable009"."/root/feed/entry/author/name/label/",
    -- "XmlTable010"."idColumn_010",
    -- "XmlTable010"."dv_xml_wrapper_parent_id",
    -- "XmlTable010"."dv_xml_wrapper_id_010",
    "XmlTable010"."/root/feed/entry/updated/label/",
    -- "XmlTable011"."idColumn_011",
    -- "XmlTable011"."dv_xml_wrapper_parent_id",
    -- "XmlTable011"."dv_xml_wrapper_id_011",
    "XmlTable011"."/root/feed/entry/im:rating/label/",
    -- "XmlTable012"."idColumn_012",
    -- "XmlTable012"."dv_xml_wrapper_parent_id",
    -- "XmlTable012"."dv_xml_wrapper_id_012",
    "XmlTable012"."/root/feed/entry/im:version/label/",
    -- "XmlTable013"."idColumn_013",
    -- "XmlTable013"."dv_xml_wrapper_parent_id",
    -- "XmlTable013"."dv_xml_wrapper_id_013",
    "XmlTable013"."/root/feed/entry/id/label/",
    -- "XmlTable014"."idColumn_014",
    -- "XmlTable014"."dv_xml_wrapper_parent_id",
    -- "XmlTable014"."dv_xml_wrapper_id_014",
    "XmlTable014"."/root/feed/entry/title/label/",
    -- "XmlTable015"."idColumn_015",
    -- "XmlTable015"."dv_xml_wrapper_parent_id",
    -- "XmlTable015"."dv_xml_wrapper_id_015",
    "XmlTable015"."/root/feed/entry/content/label/",
    -- "XmlTable015"."/root/feed/entry/content/attributes/",
    -- "XmlTable016"."idColumn_016",
    -- "XmlTable016"."dv_xml_wrapper_parent_id",
    -- "XmlTable016"."dv_xml_wrapper_id_016",
    "XmlTable016"."/root/feed/entry/content/attributes/type/",
    -- "XmlTable017"."idColumn_017",
    -- "XmlTable017"."dv_xml_wrapper_parent_id",
    -- "XmlTable017"."dv_xml_wrapper_id_017",
    "XmlTable017"."/root/feed/entry/link/attributes/rel/",
    "XmlTable017"."/root/feed/entry/link/attributes/href/",
    -- "XmlTable018"."idColumn_018",
    -- "XmlTable018"."dv_xml_wrapper_parent_id",
    -- "XmlTable018"."dv_xml_wrapper_id_018",
    "XmlTable018"."/root/feed/entry/im:voteSum/label/",
    -- "XmlTable019"."idColumn_019",
    -- "XmlTable019"."dv_xml_wrapper_parent_id",
    -- "XmlTable019"."dv_xml_wrapper_id_019",
    "XmlTable019"."/root/feed/entry/im:contentType/attributes/term/",
    "XmlTable019"."/root/feed/entry/im:contentType/attributes/label/",
    -- "XmlTable020"."idColumn_020",
    -- "XmlTable020"."dv_xml_wrapper_parent_id",
    -- "XmlTable020"."dv_xml_wrapper_id_020",
    "XmlTable020"."/root/feed/entry/im:voteCount/label/",
    -- "XmlTable021"."idColumn_021",
    -- "XmlTable021"."dv_xml_wrapper_parent_id",
    -- "XmlTable021"."dv_xml_wrapper_id_021",
    "XmlTable021"."/root/feed/updated/label/",
    -- "XmlTable022"."idColumn_022",
    -- "XmlTable022"."dv_xml_wrapper_parent_id",
    -- "XmlTable022"."dv_xml_wrapper_id_022",
    "XmlTable022"."/root/feed/rights/label/",
    -- "XmlTable023"."idColumn_023",
    -- "XmlTable023"."dv_xml_wrapper_parent_id",
    -- "XmlTable023"."dv_xml_wrapper_id_023",
    "XmlTable023"."/root/feed/title/label/",
    -- "XmlTable024"."idColumn_024",
    -- "XmlTable024"."dv_xml_wrapper_parent_id",
    -- "XmlTable024"."dv_xml_wrapper_id_024",
    "XmlTable024"."/root/feed/icon/label/",
    -- "XmlTable025"."idColumn_025",
    -- "XmlTable025"."dv_xml_wrapper_parent_id",
    -- "XmlTable025"."dv_xml_wrapper_id_025",
    "XmlTable025"."/root/feed/link/attributes/rel/",
    "XmlTable025"."/root/feed/link/attributes/type/",
    "XmlTable025"."/root/feed/link/attributes/href/",
    -- "XmlTable026"."idColumn_026",
    -- "XmlTable026"."dv_xml_wrapper_parent_id",
    -- "XmlTable026"."dv_xml_wrapper_id_026",
    "XmlTable026"."/root/feed/id/label/"
from "XmlTable001"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_002",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/root/feed' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable001"."dv_xml_wrapper_id_001" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable001"."xmldata"
               )
		    COLUMNS
               "idColumn_002" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/author/" xml PATH 'author',
               "/root/feed/entry/" xml PATH 'entry',
               "/root/feed/updated/" xml PATH 'updated',
               "/root/feed/rights/" xml PATH 'rights',
               "/root/feed/title/" xml PATH 'title',
               "/root/feed/icon/" xml PATH 'icon',
               "/root/feed/link/" xml PATH 'link',
               "/root/feed/id/" xml PATH 'id'
        ) xt
) "XmlTable002"
    on "XmlTable001"."dv_xml_wrapper_id_001" = "XmlTable002"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_003",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/author' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/author/"
               )
		    COLUMNS
               "idColumn_003" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/feed/author/name/" xml PATH 'name',
               "/root/feed/author/uri/" xml PATH 'uri'
        ) xt
) "XmlTable003"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable003"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_004",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/name/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/feed/author/name/"
               )
		    COLUMNS
               "idColumn_004" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/author/name/label/" STRING PATH '.'
        ) xt
) "XmlTable004"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable004"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_005",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/uri/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable003"."dv_xml_wrapper_id_003" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable003"."/root/feed/author/uri/"
               )
		    COLUMNS
               "idColumn_005" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/author/uri/label/" STRING PATH '.'
        ) xt
) "XmlTable005"
    on "XmlTable003"."dv_xml_wrapper_id_003" = "XmlTable005"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_006",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/entry' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/entry/"
               )
		    COLUMNS
               "idColumn_006" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/author/" xml PATH 'author',
               "/root/feed/entry/updated/" xml PATH 'updated',
               "/root/feed/entry/im:rating/" xml PATH 'im_u003A_rating',
               "/root/feed/entry/im:version/" xml PATH 'im_u003A_version',
               "/root/feed/entry/id/" xml PATH 'id',
               "/root/feed/entry/title/" xml PATH 'title',
               "/root/feed/entry/content/" xml PATH 'content',
               "/root/feed/entry/link/" xml PATH 'link',
               "/root/feed/entry/im:voteSum/" xml PATH 'im_u003A_voteSum',
               "/root/feed/entry/im:contentType/" xml PATH 'im_u003A_contentType',
               "/root/feed/entry/im:voteCount/" xml PATH 'im_u003A_voteCount'
        ) xt
) "XmlTable006"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable006"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_007",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/author' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/author/"
               )
		    COLUMNS
               "idColumn_007" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/author/uri/" xml PATH 'uri',
               "/root/feed/entry/author/name/" xml PATH 'name',
               "/root/feed/entry/author/label/" STRING PATH 'label'
        ) xt
) "XmlTable007"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable007"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_008",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/uri/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable007"."dv_xml_wrapper_id_007" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable007"."/root/feed/entry/author/uri/"
               )
		    COLUMNS
               "idColumn_008" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/author/uri/label/" STRING PATH '.'
        ) xt
) "XmlTable008"
    on "XmlTable007"."dv_xml_wrapper_id_007" = "XmlTable008"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_009",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/name/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable007"."dv_xml_wrapper_id_007" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable007"."/root/feed/entry/author/name/"
               )
		    COLUMNS
               "idColumn_009" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/author/name/label/" STRING PATH '.'
        ) xt
) "XmlTable009"
    on "XmlTable007"."dv_xml_wrapper_id_007" = "XmlTable009"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_010",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/updated/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/updated/"
               )
		    COLUMNS
               "idColumn_010" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/updated/label/" STRING PATH '.'
        ) xt
) "XmlTable010"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable010"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_011",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/im_u003A_rating/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/im:rating/"
               )
		    COLUMNS
               "idColumn_011" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/im:rating/label/" STRING PATH '.'
        ) xt
) "XmlTable011"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable011"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_012",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/im_u003A_version/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/im:version/"
               )
		    COLUMNS
               "idColumn_012" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/im:version/label/" STRING PATH '.'
        ) xt
) "XmlTable012"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable012"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_013",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/id/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/id/"
               )
		    COLUMNS
               "idColumn_013" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/id/label/" STRING PATH '.'
        ) xt
) "XmlTable013"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable013"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_014",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/title/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/title/"
               )
		    COLUMNS
               "idColumn_014" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/title/label/" STRING PATH '.'
        ) xt
) "XmlTable014"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable014"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_015",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/content' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/content/"
               )
		    COLUMNS
               "idColumn_015" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/content/label/" STRING PATH 'label',
               "/root/feed/entry/content/attributes/" xml PATH 'attributes'
        ) xt
) "XmlTable015"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable015"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_016",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/attributes/type' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable015"."dv_xml_wrapper_id_015" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable015"."/root/feed/entry/content/attributes/"
               )
		    COLUMNS
               "idColumn_016" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/content/attributes/type/" STRING PATH '.'
        ) xt
) "XmlTable016"
    on "XmlTable015"."dv_xml_wrapper_id_015" = "XmlTable016"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_017",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/link/attributes' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/link/"
               )
		    COLUMNS
               "idColumn_017" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/link/attributes/rel/" STRING PATH 'rel',
               "/root/feed/entry/link/attributes/href/" STRING PATH 'href'
        ) xt
) "XmlTable017"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable017"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_018",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/im_u003A_voteSum/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/im:voteSum/"
               )
		    COLUMNS
               "idColumn_018" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/im:voteSum/label/" STRING PATH '.'
        ) xt
) "XmlTable018"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable018"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_019",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/im_u003A_contentType/attributes' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/im:contentType/"
               )
		    COLUMNS
               "idColumn_019" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/im:contentType/attributes/term/" STRING PATH 'term',
               "/root/feed/entry/im:contentType/attributes/label/" STRING PATH 'label'
        ) xt
) "XmlTable019"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable019"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_020",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/im_u003A_voteCount/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable006"."dv_xml_wrapper_id_006" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable006"."/root/feed/entry/im:voteCount/"
               )
		    COLUMNS
               "idColumn_020" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/entry/im:voteCount/label/" STRING PATH '.'
        ) xt
) "XmlTable020"
    on "XmlTable006"."dv_xml_wrapper_id_006" = "XmlTable020"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_021",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/updated/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/updated/"
               )
		    COLUMNS
               "idColumn_021" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/updated/label/" STRING PATH '.'
        ) xt
) "XmlTable021"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable021"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_022",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/rights/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/rights/"
               )
		    COLUMNS
               "idColumn_022" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/rights/label/" STRING PATH '.'
        ) xt
) "XmlTable022"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable022"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_023",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/title/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/title/"
               )
		    COLUMNS
               "idColumn_023" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/title/label/" STRING PATH '.'
        ) xt
) "XmlTable023"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable023"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_024",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/icon/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/icon/"
               )
		    COLUMNS
               "idColumn_024" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/icon/label/" STRING PATH '.'
        ) xt
) "XmlTable024"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable024"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_025",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/link/attributes' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/link/"
               )
		    COLUMNS
               "idColumn_025" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/link/attributes/rel/" STRING PATH 'rel',
               "/root/feed/link/attributes/type/" STRING PATH 'type',
               "/root/feed/link/attributes/href/" STRING PATH 'href'
        ) xt
) "XmlTable025"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable025"."dv_xml_wrapper_parent_id"
left join lateral(
   select
       uuid() as "dv_xml_wrapper_id_026",
       xt.*
   from
       XMLTABLE(
           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ), '/DV_default_xml_wrapper/id/label' PASSING 
               XMLELEMENT(NAME "DV_default_xml_wrapper",
                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),
                   XMLATTRIBUTES("XmlTable002"."dv_xml_wrapper_id_002" AS "dv_xml_wrapper_parent_id"),
                    "XmlTable002"."/root/feed/id/"
               )
		    COLUMNS
               "idColumn_026" FOR ORDINALITY,
               "dv_xml_wrapper_parent_id" string path '../../@dv_xml_wrapper_parent_id',
               "/root/feed/id/label/" STRING PATH '.'
        ) xt
) "XmlTable026"
    on "XmlTable002"."dv_xml_wrapper_id_002" = "XmlTable026"."dv_xml_wrapper_parent_id"