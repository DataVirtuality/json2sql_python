import json
from typing import Any, Dict, List, cast
from codelib.metadata import determine_data_type, DataTypes, TreeNodeInfo


def parse_struct(obj: Any, parent_xpath: str, element_name: str, parent_node: TreeNodeInfo) -> None:
    if isinstance(obj, dict):
        dictionary = cast(Dict[str, Any], obj)
        for key, val in dictionary.items():
            if isinstance(val, dict):
                parse_struct(obj=val, parent_xpath=f'{parent_xpath}{key}/', element_name=f'{key}', parent_node=parent_node)
            elif isinstance(val, list):
                parse_struct(obj=val, parent_xpath=f'{parent_xpath}', element_name=f'{key}', parent_node=parent_node)
            else:
                TreeNodeInfo.factory(
                    element_name=key,
                    xpath=f'{parent_xpath}{element_name}/',
                    parent=parent_node,
                    parent_xpath=parent_xpath,
                    xml_attributes=None,
                    data_type=determine_data_type(val),
                    is_array=False
                )
    elif isinstance(obj, list):
        lst = cast(List[Any], obj)
        for item in lst:
            if isinstance(item, dict):
                parse_struct(obj=item, parent_xpath=f'{parent_xpath}{element_name}/',
                             element_name=element_name, parent_node=parent_node)
            elif isinstance(item, list):
                parse_struct(obj=item, parent_xpath=f'{parent_xpath}{element_name}/',
                             element_name=element_name, parent_node=parent_node)
            else:
                TreeNodeInfo.factory(
                    element_name=element_name,
                    xpath=f'{parent_xpath}{element_name}/',
                    parent=parent_node,
                    parent_xpath=parent_xpath,
                    xml_attributes=None,
                    data_type=determine_data_type(item),
                    is_array=True
                )
                # register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
                #                    current_xpath=element_name, data_type=determine_data_type(item), is_array=True)
    else:
        TreeNodeInfo.factory(
            element_name=element_name,
            xpath=f'{parent_xpath}{element_name}/',
            parent=parent_node,
            parent_xpath=parent_xpath,
            xml_attributes=None,
            data_type=determine_data_type(obj),
            is_array=False
        )
        # register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
        #                    current_xpath=element_name, data_type=determine_data_type(obj), is_array=False)


# def helper_determine_children_by_path(parsed_data: DICT_OBJ_INFO) -> HierarchyInfo:
#     hi_root: HierarchyInfo = HierarchyInfo(
#         current_element='root',
#         xpath='/root/',
#         children=[],
#         parent=None,
#         xml_attributes=[]
#     )

#     for key, _ in parsed_data.items():
#         xpath: str = '/root/'
#         hi_current = hi_root
#         elements = key.split('/')
#         elements = [x for x in elements if len(x) > 0]
#         for i in range(1, len(elements)):
#             item = elements[i]
#             lst = [x for x in hi_current.children if x.current_element == item]
#             assert len(lst) <= 1
#             xpath = f'{xpath}{item}/'
#             if len(lst) == 0:
#                 hi = HierarchyInfo(
#                     current_element=item,
#                     xpath=xpath,
#                     children=[],
#                     parent=hi_current,
#                     xml_attributes=[]
#                 )
#                 hi_current.children.append(hi)
#                 hi_current = hi
#             else:
#                 hi_current = lst[0]
#     return hi_root


def parse_dict(obj: Any) -> TreeNodeInfo:
    root = TreeNodeInfo.factory(
        element_name='root',
        xpath='/root/',
        parent=None,
        parent_xpath=None,
        xml_attributes=None,
        data_type=DataTypes.UNKNOWN
    )
    parse_struct(obj=obj, parent_xpath='/root/', element_name='root', parent_node=root)
    return root


def parse_json_file(file_name: str) -> TreeNodeInfo:
    with open(file_name, 'rt', encoding='UTF-8') as f:
        json_obj = json.load(f)
    return parse_dict(obj=json_obj)
