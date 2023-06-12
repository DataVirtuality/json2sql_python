from typing import Dict, Final, List, Optional, Self, cast, Any
import json
import glob
# import sys
from dataclasses import dataclass
import fileinput
from enum import Enum
# import pandas as pd
from gen_csv_files import gen_csv_files
from codelib.args import parse_args

args = parse_args()


class DataTypes(Enum):
    UNKNOWN = 'unknown'
    STR = 'string'
    INT = 'integer'
    FLOAT = 'float'
    # ARRAY = 'array'


class ObjInfo:
    parent_xpath: str
    current_xpath: str
    xpath: str
    _data_type: DataTypes = DataTypes.UNKNOWN
    is_array: bool = False
    cardinality: int = 1
    depth: int = 1

    def __init__(self,
                 parent_xpath: str,
                 current_xpath: str,
                 xpath: str,
                 data_type: DataTypes,
                 is_array: bool
                 ) -> None:
        self.parent_xpath = parent_xpath
        self.current_xpath = current_xpath
        self.xpath = xpath
        self.data_type = data_type
        self.depth = xpath.count('/') - 2
        self.is_array = is_array

    def inc_cardinality(self) -> None:
        self.cardinality += 1

    @property
    def data_type(self):
        return self._data_type

    @data_type.setter
    def data_type(self, datatype: DataTypes):
        if datatype != self._data_type:
            if self._data_type is DataTypes.UNKNOWN:
                self._data_type = datatype
            elif datatype is DataTypes.UNKNOWN:
                pass
            elif datatype in (DataTypes.INT, DataTypes.FLOAT) and self._data_type in (DataTypes.INT, DataTypes.FLOAT):
                self._data_type = DataTypes.FLOAT
            elif datatype == DataTypes.STR and self._data_type in (DataTypes.INT, DataTypes.FLOAT):
                self._data_type = DataTypes.STR


DICT_OBJ_INFO = Dict[str, ObjInfo]
XML_TABLE: Final[str] = 'dataset'


@dataclass
class HierarchyInfo:
    current_element: str
    xpath: str
    children: List[Self]
    parent: Optional[Self]
    xml_attributes: List[str]

    def is_leaf(self) -> bool:
        return len(self.children) == 0

    def is_branch(self) -> bool:
        return len(self.children) == 1

    def is_node(self) -> bool:
        return len(self.children) > 1

    def are_all_children_leaves(self) -> bool:
        return all(x.is_leaf() for x in self.children)

    def has_xml_attributes(self) -> bool:
        return len(self.xml_attributes) > 0


@dataclass
class IntWrapper:
    counter: int


def get_data_type(obj: Any) -> DataTypes:
    if obj is None:
        return DataTypes.UNKNOWN
    if isinstance(obj, str):
        return DataTypes.STR
    if isinstance(obj, float):
        return DataTypes.FLOAT
    if isinstance(obj, int):
        return DataTypes.INT
    raise Exception('Unhandled type')
    return DataTypes.UNKNOWN


def register_key_value(parsed_data: DICT_OBJ_INFO, parent_xpath: str, current_xpath: str, data_type: DataTypes, is_array: bool) -> None:
    xpath = f'{parent_xpath}{current_xpath}/'
    if xpath not in parsed_data:
        parsed_data[xpath] = ObjInfo(parent_xpath=parent_xpath, current_xpath=current_xpath, xpath=xpath, data_type=data_type, is_array=is_array)
    else:
        oi: ObjInfo = parsed_data[xpath]
        oi.data_type = data_type
        oi.inc_cardinality()


def parse_struct(obj: Any, parent_xpath: str, current_xpath: str, parsed_data: DICT_OBJ_INFO) -> None:
    if isinstance(obj, dict):
        d = cast(Dict[str, Any], obj)
        for key, val in d.items():
            if isinstance(val, dict):
                parse_struct(obj=val, parent_xpath=f'{parent_xpath}{key}/', current_xpath=f'{key}', parsed_data=parsed_data)
            elif isinstance(val, list):
                parse_struct(obj=val, parent_xpath=f'{parent_xpath}', current_xpath=f'{key}', parsed_data=parsed_data)
            else:
                register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
                                   current_xpath=key, data_type=get_data_type(val), is_array=False)
    elif isinstance(obj, list):
        lst = cast(List[Any], obj)
        for item in lst:
            if isinstance(item, dict):
                parse_struct(obj=item, parent_xpath=f'{parent_xpath}{current_xpath}/',
                             current_xpath=current_xpath, parsed_data=parsed_data)
            elif isinstance(item, list):
                parse_struct(obj=item, parent_xpath=f'{parent_xpath}{current_xpath}/',
                             current_xpath=current_xpath, parsed_data=parsed_data)
            else:
                register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
                                   current_xpath=current_xpath, data_type=get_data_type(item), is_array=True)
    else:
        register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
                           current_xpath=current_xpath, data_type=get_data_type(obj), is_array=False)


def helper_determine_children_by_path(parsed_data: DICT_OBJ_INFO) -> HierarchyInfo:
    hi_root: HierarchyInfo = HierarchyInfo(
        current_element='root',
        xpath='/root/',
        children=[],
        parent=None,
        xml_attributes=[]
    )

    for key, _ in parsed_data.items():
        xpath: str = '/root/'
        hi_current = hi_root
        elements = key.split('/')
        elements = [x for x in elements if len(x) > 0]
        for i in range(1, len(elements)):
            item = elements[i]
            lst = [x for x in hi_current.children if x.current_element == item]
            assert len(lst) <= 1
            xpath = f'{xpath}{item}/'
            if len(lst) == 0:
                hi = HierarchyInfo(
                    current_element=item,
                    xpath=xpath,
                    children=[],
                    parent=hi_current,
                    xml_attributes=[]
                )
                hi_current.children.append(hi)
                hi_current = hi
            else:
                hi_current = lst[0]
    return hi_root


def get_data_sql_type(parsed_data: DICT_OBJ_INFO, hi: HierarchyInfo) -> str:
    obj_info: ObjInfo = parsed_data[hi.xpath]
    return obj_info.data_type.value


def is_node_an_array(parsed_data: DICT_OBJ_INFO, hi: HierarchyInfo) -> bool:
    obj_info: ObjInfo = parsed_data[hi.xpath]
    return obj_info.is_array


def remove_last_char_from_str(s: str) -> str:
    return s[:-1]


def substract_string(prefix: str, target: str) -> str:
    assert target.startswith(prefix) is True
    return target[len(prefix):]


def helper_top_down(
        parsed_data: DICT_OBJ_INFO,
        hi: HierarchyInfo,
        sql_select: List[str],
        sql_from: List[str],
        alias_num: IntWrapper,
        relative_xpath: str,
        sql_parent_table: str,
        sql_parent_xml_column: str,
        parent_table_number: int
) -> None:
    '''
    alias_num - Python doesn't allow pass by reference so we use a class wrapper to get around this.
    '''

    current_table_number: Final[int] = alias_num.counter
    current_sql_table_name: Final[str] = f'{XML_TABLE}{alias_num.counter:03}'

    if hi.is_branch():
        # branch: has a single child
        helper_top_down(
            parsed_data=parsed_data,
            hi=hi.children[0],
            sql_select=sql_select,
            sql_from=sql_from,
            alias_num=alias_num,
            relative_xpath=relative_xpath,
            sql_parent_table=sql_parent_table,
            sql_parent_xml_column=sql_parent_xml_column,
            parent_table_number=parent_table_number
        )
    else:
        xpath_from_wrapper = remove_last_char_from_str(substract_string(relative_xpath, hi.xpath))
        xpath_relative_to_wrapper = xpath_from_wrapper.count('/') + 1
        x_path_move_back = '../' * xpath_relative_to_wrapper

        sql_from.append('left join lateral(')
        sql_from.append('   select')
        sql_from.append(f'       uuid() as "dv_xml_wrapper_id_{current_table_number:03}",')
        sql_from.append('       xt.*')
        sql_from.append('   from')
        sql_from.append('       XMLTABLE(')
        sql_from.append(
            f"           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as \"xsi\" ), '/DV_default_xml_wrapper/{xpath_from_wrapper}' PASSING ")
        sql_from.append('               XMLELEMENT(NAME "DV_default_xml_wrapper",')
        sql_from.append("                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as \"xsi\" ),")
        sql_from.append(f'                   XMLATTRIBUTES("{sql_parent_table}"."dv_xml_wrapper_id_{parent_table_number:03}" AS "dv_xml_wrapper_parent_id"),')
        sql_from.append(f'                    "{sql_parent_table}"."{sql_parent_xml_column}"')
        sql_from.append('               )')
        sql_from.append('		    COLUMNS')
        sql_from.append(f'               "idColumn_{current_table_number:03}" FOR ORDINALITY,')
        sql_from.append(f"               \"dv_xml_wrapper_parent_id\" string path '{x_path_move_back}@dv_xml_wrapper_parent_id',")

        sql_select.append(f'    -- "{current_sql_table_name}"."idColumn_{current_table_number:03}",')
        sql_select.append(f'    -- "{current_sql_table_name}"."dv_xml_wrapper_parent_id",')
        sql_select.append(f'    -- "{current_sql_table_name}"."dv_xml_wrapper_id_{current_table_number:03}",')

        xml_tables: List[HierarchyInfo] = []
        if hi.is_leaf() is True:
            sql_data_type = get_data_sql_type(parsed_data, hi)
            if sql_data_type != DataTypes.STR.value:
                sql_select.append(f'    "{current_sql_table_name}"."{hi.xpath}@type",')
                sql_from.append(f"               \"{hi.xpath}@type\" STRING PATH '{hi.current_element}/@xsi:type',")
        else:
            for child in hi.children:
                if is_node_an_array(parsed_data=parsed_data, hi=child) is True:
                    sql_select.append(f'    -- "{current_sql_table_name}"."{child.xpath}",')
                    sql_from.append(f'               "{child.xpath}" xml PATH \'{child.current_element}\',')
                else:
                    sql_data_type = get_data_sql_type(parsed_data, child)
                    if sql_data_type != DataTypes.STR.value:
                        sql_select.append(f'    "{current_sql_table_name}"."{child.xpath}@type",')
                        sql_from.append(f"               \"{child.xpath}@type\" STRING PATH '{child.current_element}/@xsi:type',")

                    sql_select.append(f'    "{current_sql_table_name}"."{child.xpath}",')
                    sql_from.append(f'               "{child.xpath}" {sql_data_type} PATH \'{child.current_element}\',')

        # Remove comma from last entry
        sql_from[-1] = remove_last_char_from_str(sql_from[-1])

        sql_from.append('        ) xt')
        sql_from.append(f') "{current_sql_table_name}"')
        sql_from.append(f'    on "{sql_parent_table}"."dv_xml_wrapper_id_{parent_table_number:03}" = "{current_sql_table_name}"."dv_xml_wrapper_parent_id"')
        alias_num.counter += 1

        for child in xml_tables:
            helper_top_down(
                parsed_data=parsed_data,
                hi=child,
                sql_select=sql_select,
                sql_from=sql_from,
                alias_num=alias_num,
                relative_xpath=hi.xpath,
                sql_parent_table=f'{current_sql_table_name}',
                sql_parent_xml_column=child.xpath,
                parent_table_number=current_table_number
            )


def top_down_sql_generation(parsed_data: DICT_OBJ_INFO, hi: HierarchyInfo, file_name: str, dsname: str) -> str:
    sql_select: List[str] = []
    sql_from: List[str] = []
    alias_num = IntWrapper(1)
    current_sql_table: Final[str] = f'{XML_TABLE}{alias_num.counter:03}'
    current_table_number: Final[int] = alias_num.counter

    sql_select.append(f'with "{current_sql_table}" as (')
    sql_select.append("    SELECT")
    sql_select.append(f"        uuid() as dv_xml_wrapper_id_{current_table_number:03},")
    sql_select.append("        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata")
    sql_select.append("    FROM")
    sql_select.append(f'        "{dsname}".getFiles(\'{file_name}\') f')
    sql_select.append(")")
    sql_select.append("select")
    sql_select.append(f'    "{current_sql_table}"."dv_xml_wrapper_id_{current_table_number:03}",')

    sql_from.append(f'from "{current_sql_table}"')

    alias_num.counter += 1
    helper_top_down(
        parsed_data=parsed_data,
        hi=hi,
        sql_select=sql_select,
        sql_from=sql_from,
        alias_num=alias_num,
        relative_xpath='/',
        sql_parent_table=f'{current_sql_table}',
        sql_parent_xml_column='xmldata',
        parent_table_number=current_table_number
    )

    # Remove comma from last entry
    sql_select[-1] = remove_last_char_from_str(sql_select[-1])

    sql = '\n'.join(sql_select) + '\n' + '\n'.join(sql_from)
    return sql


def parsed_data_2_sql(parsed_data: DICT_OBJ_INFO, hi: HierarchyInfo, file_name: str, dsname: str) -> str:
    return top_down_sql_generation(parsed_data, hi, file_name, dsname)


def generate_dv_sql(obj: Any, file_name: str, dsname: str) -> str:
    parsed_data: DICT_OBJ_INFO = {}
    parse_struct(obj=obj, parent_xpath='/root/', current_xpath='root', parsed_data=parsed_data)
    hi: HierarchyInfo = helper_determine_children_by_path(parsed_data)
    return parsed_data_2_sql(parsed_data, hi, file_name, dsname)


if args.stdio is True:
    str_data = fileinput.input()
    json_obj = json.loads(str_data)  # type: ignore
    print(generate_dv_sql(json_obj, 'stdio', args.dsname))
else:
    for file_name in glob.iglob(args.files, recursive=args.recurse, include_hidden=args.include_hidden):
        with open(file_name, 'rt', encoding='UTF-8') as f:
            json_obj = json.load(f)
            sql = generate_dv_sql(json_obj, file_name, args.dsname)
            with open(f'{file_name}.sql', 'wt', encoding='UTF-8') as fsql:
                fsql.write(sql)
            gen_csv_files(json_obj, file_name)
