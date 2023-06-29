import json
from typing import Any, Dict, List, Optional, cast
from codelib.metadata import NodeTypes, determine_data_type, DataTypes, TreeNodeInfo, determine_node_type


def parse_dict(
    dictionary: Dict[str, Any],
    parent_xpath: str,
    parent_node: TreeNodeInfo
) -> None:
    for key, val in dictionary.items():
        node = TreeNodeInfo.factory(
            element_name=key,
            xpath=f'{parent_xpath}{key}/',
            parent=parent_node,
            parent_xpath=parent_xpath,
            node_type=determine_node_type(val),
            data_type=determine_data_type(val),
            xml_attributes=None,
            is_array=False
        )
        if isinstance(val, dict):
            parse_dict(
                dictionary=cast(Dict[str, Any], val),
                parent_xpath=node.xpath,
                parent_node=node
            )
        elif isinstance(val, list):
            parse_list(
                lst=cast(List[Any], val),
                parent_xpath=node.xpath,
                parent_node=node
            )


def parse_list(
    lst: List[Any],
    parent_xpath: str,
    parent_node: TreeNodeInfo
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
                parent_xpath=parent_xpath,
                parent_node=parent_node
            )
        elif isinstance(item, list):
            # parse_list(
            #     lst=cast(List[Any], item),
            #     parent_xpath=parent_xpath,
            #     parent_node=parent_node
            # )
            parse_obj(
                obj=item,
                parent_xpath=parent_xpath,
                parent_node=parent_node,
                element_name=parent_node.element_name
            )
        else:
            parent_node.data_type = determine_data_type(item)


def parse_obj(
    obj: Any,
    parent_xpath: Optional[str],
    parent_node: Optional[TreeNodeInfo],
    element_name: str
) -> None:
    node = TreeNodeInfo.factory(
        element_name=element_name,
        xpath=f'{parent_xpath}{element_name}/',
        parent=parent_node,
        parent_xpath=parent_xpath,
        xml_attributes=None,
        node_type=determine_node_type(obj),
        data_type=determine_data_type(obj)
    )

    if isinstance(obj, dict):
        parse_dict(
            dictionary=cast(Dict[str, Any], obj),
            parent_node=node,
            parent_xpath=node.xpath
        )
    elif isinstance(obj, list):
        parse_list(
            lst=cast(List[Any], obj),
            parent_node=node,
            parent_xpath=node.xpath
        )
    else:
        raise Exception('Unhandled case')


def parse_json(obj: Any) -> TreeNodeInfo:
    root = TreeNodeInfo.factory(
        element_name='/root/',
        xpath='/root/',
        parent=None,
        parent_xpath=None,
        xml_attributes=None,
        node_type=NodeTypes.DATA,
        data_type=DataTypes.UNKNOWN
    )
    parse_obj(
        obj=obj,
        parent_xpath=root.xpath,
        parent_node=root,
        element_name='root'
    )
    return root


def parse_json_file(file_name: str) -> TreeNodeInfo:
    with open(file_name, 'rt', encoding='UTF-8') as f:
        json_obj = json.load(f)
    return parse_json(obj=json_obj)
