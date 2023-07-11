import json
from typing import Any, Dict, List, Optional, cast
from codelib.SqlGenConfig import SqlGenConfig
from codelib.metadata import NodeTypes, DataTypes, TreeNodeInfo, determine_data_type, determine_node_type


def parse_dict(
    dictionary: Dict[str, Any],
    parent_node: TreeNodeInfo,
    config: SqlGenConfig
) -> None:
    for key, val in dictionary.items():
        node = TreeNodeInfo.factory(
            element_name=key,
            parent=parent_node,
            node_type=determine_node_type(val),
            data_type=determine_data_type(val),
            config=config,
            xml_attributes=None
        )
        if isinstance(val, Dict):
            parse_dict(
                dictionary=cast(Dict[str, Any], val),
                parent_node=node,
                config=config
            )
        elif isinstance(val, List):
            parse_list(
                lst=cast(List[Any], val),
                parent_node=node,
                config=config
            )


def parse_list(
    lst: List[Any],
    parent_node: TreeNodeInfo,
    config: SqlGenConfig
) -> None:
    for item in lst:
        if isinstance(item, dict):
            # parse_obj(
            #     obj=item,
            #     parent_xpath=parent_xpath,
            #     parent_node=parent_node,
            #     element_name=parent_node.element_name
            # )
            parse_dict(
                dictionary=cast(Dict[str, Any], item),
                parent_node=parent_node,
                config=config
            )
        elif isinstance(item, list):
            # parse_list(
            #     lst=cast(List[Any], item),
            #     parent_xpath=parent_xpath,
            #     parent_node=parent_node
            # )
            parse_obj(
                obj=item,
                parent_node=parent_node,
                element_name=parent_node.element_name,
                config=config
            )
        else:
            parent_node.datatype = determine_data_type(item)


def parse_obj(
    obj: Any,
    parent_node: Optional[TreeNodeInfo],
    element_name: str,
    config: SqlGenConfig
) -> None:
    node = TreeNodeInfo.factory(
        element_name=element_name,
        parent=parent_node,
        xml_attributes=None,
        node_type=determine_node_type(obj),
        data_type=determine_data_type(obj),
        config=config
    )

    if isinstance(obj, dict):
        parse_dict(
            dictionary=cast(Dict[str, Any], obj),
            parent_node=node,
            config=config
        )
    elif isinstance(obj, list):
        parse_list(
            lst=cast(List[Any], obj),
            parent_node=node,
            config=config
        )
    else:
        raise Exception('Unhandled case')


def parse_json(obj: Any, config: SqlGenConfig) -> TreeNodeInfo:
    root = TreeNodeInfo.factory(
        element_name='root',
        parent=None,
        xml_attributes=None,
        node_type=NodeTypes.DATA,
        config=config,
        data_type=DataTypes.UNKNOWN
    )
    parse_obj(
        obj=obj,
        parent_node=root,
        element_name='root',
        config=config
    )
    return root


def parse_json_file(file_name: str, config: SqlGenConfig) -> TreeNodeInfo:
    with open(file_name, 'rt', encoding='UTF-8') as f:
        json_obj = json.load(f)
    return parse_json(obj=json_obj, config=config)
