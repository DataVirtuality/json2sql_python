import json
from typing import Any, Dict, List, Optional, cast
from codelib.SqlGenConfig import SqlGenConfig
from codelib.metadata import TreeNodeInfo, determine_data_type, determine_node_type


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
    # node = TreeNodeInfo.factory(
    #     element_name=parent_node.element_name,
    #     parent=parent_node,
    #     xml_attributes=None,
    #     node_type=determine_node_type(lst),
    #     data_type=determine_data_type(lst),
    #     config=config
    # )

    for item in lst:
        if isinstance(item, dict):
            parse_dict(
                dictionary=cast(Dict[str, Any], item),
                parent_node=parent_node,
                config=config
            )
        elif isinstance(item, list):
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
) -> TreeNodeInfo:
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

    return node


def parse_json(obj: Any, config: SqlGenConfig) -> TreeNodeInfo:
    root: TreeNodeInfo

    if isinstance(obj, List):
        root = TreeNodeInfo.factory(
            element_name='root',
            parent=None,
            xml_attributes=None,
            node_type=determine_node_type(obj),
            data_type=determine_data_type(obj),
            config=config
        )

        parse_obj(
            obj=obj,
            parent_node=root,
            element_name='root',
            config=config
        )
    else:
        root = parse_obj(
            obj=obj,
            parent_node=None,
            element_name='root',
            config=config
        )

    # print(pretty_print_entire_tree_as_str(root, False))

    return root


def parse_json_file(file_name: str, config: SqlGenConfig) -> TreeNodeInfo:
    with open(file_name, 'rt', encoding='UTF-8') as f:
        json_obj = json.load(f)
    return parse_json(obj=json_obj, config=config)
