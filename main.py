from typing import Dict, List, Self, cast, Any
import json
import argparse
import glob
# import sys
from dataclasses import dataclass
import fileinput
from enum import Enum
import pandas as pd

from gen_csv_files import gen_csv_files


parser = argparse.ArgumentParser()

parser.add_argument("-sio", "--stdio", action="store_true",
                    help="Read json from STDIN.")
parser.add_argument("-f", "--files", default='*.json', required=False,
                    help="Read json files. Supports wildcards. Case insensitive search.")
parser.add_argument("-r", "--recurse", action="store_true", required=False,
                    help="Recursively search subfolders for json files.")
parser.add_argument("-ih", "--include_hidden", action="store_true",
                    required=False, help="Include hidden json files.")
group = parser.add_mutually_exclusive_group()
group.add_argument('--topdown', action='store_true')
group.add_argument('--bottomup', action='store_false')

args = parser.parse_args()


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
    cardinality: int = 1
    depth: int = 1

    def __init__(self,
                 parent_xpath: str,
                 current_xpath: str,
                 xpath: str,
                 data_type: DataTypes) -> None:
        self.parent_xpath = parent_xpath
        self.current_xpath = current_xpath
        self.xpath = xpath
        self.data_type = data_type
        self.depth = xpath.count('/') - 2

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
            elif datatype == DataTypes.UNKNOWN:
                pass
            elif datatype in (DataTypes.INT, DataTypes.FLOAT) and self._data_type in (DataTypes.INT, DataTypes.FLOAT):
                self._data_type = DataTypes.FLOAT
            elif datatype == DataTypes.STR and self._data_type in (DataTypes.INT, DataTypes.FLOAT):
                self._data_type = DataTypes.STR


DICT_OBJ_INFO = Dict[str, ObjInfo]


@dataclass
class HierarchyInfo:
    current_element: str
    xpath: str
    children: List[Self]


def get_data_type(obj: Any) -> DataTypes:
    if obj is None:
        return DataTypes.UNKNOWN
    if isinstance(obj, str):
        return DataTypes.STR
    if isinstance(obj, float):
        return DataTypes.FLOAT
    if isinstance(obj, int):
        return DataTypes.INT
    # if isinstance(obj, list):
    #     return DataTypes.ARRAY
    raise Exception('Unhandled type')
    return DataTypes.UNKNOWN


def register_key_value(parsed_data: DICT_OBJ_INFO, parent_xpath: str, current_xpath: str, data_type: DataTypes) -> None:
    xpath = f'{parent_xpath}{current_xpath}/'
    if xpath not in parsed_data:
        parsed_data[xpath] = ObjInfo(
            parent_xpath=parent_xpath, current_xpath=current_xpath, xpath=xpath, data_type=data_type)
    else:
        oi: ObjInfo = parsed_data[xpath]
        oi.data_type = data_type
        oi.inc_cardinality()


def parse_struct(obj: Any, parent_xpath: str, current_xpath: str, parsed_data: DICT_OBJ_INFO) -> None:
    if isinstance(obj, dict):
        d = cast(dict, obj)
        for key, val in d.items():
            if isinstance(val, dict):
                parse_struct(
                    obj=val, parent_xpath=f'{parent_xpath}{key}/', current_xpath=f'{key}', parsed_data=parsed_data)
            elif isinstance(val, list):
                parse_struct(
                    obj=val, parent_xpath=f'{parent_xpath}', current_xpath=f'{key}', parsed_data=parsed_data)
            else:
                register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
                                   current_xpath=key, data_type=get_data_type(val))
    elif isinstance(obj, list):
        l = cast(list, obj)
        for item in l:
            if isinstance(item, dict):
                parse_struct(obj=item, parent_xpath=f'{parent_xpath}{current_xpath}/',
                             current_xpath=current_xpath, parsed_data=parsed_data)
            elif isinstance(item, list):
                parse_struct(obj=item, parent_xpath=f'{parent_xpath}{current_xpath}/',
                             current_xpath=current_xpath, parsed_data=parsed_data)
            else:
                register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
                                   current_xpath=current_xpath, data_type=get_data_type(item))
    else:
        register_key_value(parsed_data=parsed_data, parent_xpath=parent_xpath,
                           current_xpath=current_xpath, data_type=get_data_type(obj))


def helper_determine_children_by_path(parsed_data: DICT_OBJ_INFO) -> HierarchyInfo:
    hi_root: HierarchyInfo = HierarchyInfo('root', '/root/', [])

    for key, val in parsed_data.items():
        xpath: str = '/root/'
        hi_current = hi_root
        elements = key.split('/')
        elements = [x for x in elements if len(x) > 0]
        for i in range(1, len(elements)):
            item = elements[i]
            l = [x for x in hi_current.children if x.current_element == item]
            assert len(l) <= 1
            xpath = f'{xpath}{item}/'
            if len(l) == 0:
                hi = HierarchyInfo(item, xpath, [])
                hi_current.children.append(hi)
                hi_current = hi
            else:
                hi_current = l[0]
    return hi_root


def helper_top_down(hi: HierarchyInfo, sql_select: List[str], sql_from: List[str]) -> str:

    return ''


def top_down_sql_generation(parsed_data: DICT_OBJ_INFO, hi: HierarchyInfo) -> str:
    sql_select: List[str] = []
    sql_from: List[str] = []
    return helper_top_down(hi, sql_select, sql_from)


def bottom_up_sql_generation(parsed_data: DICT_OBJ_INFO, hi: HierarchyInfo) -> str:
    return ''


def parsed_data_2_sql(parsed_data: DICT_OBJ_INFO) -> str:
    hi: HierarchyInfo = helper_determine_children_by_path(parsed_data)
    if args.topdown:
        return top_down_sql_generation(parsed_data, hi)
    else:
        return ''


def generate_dv_sql(obj: Any) -> str:
    parsed_data: DICT_OBJ_INFO = {}
    parse_struct(obj=obj, parent_xpath='/root/',
                 current_xpath='root', parsed_data=parsed_data)
    return parsed_data_2_sql(parsed_data)


if args.stdio is True:
    json_obj = json.loads(fileinput.input())
    print(generate_dv_sql(json_obj))
else:
    for file_name in glob.iglob(args.files, recursive=args.recurse, include_hidden=args.include_hidden):
        with open(file_name, 'rt', encoding='UTF-8') as f:
            json_obj = json.load(f)
            sql = generate_dv_sql(json_obj)
            with open(f'{file_name}.sql', 'wt', encoding='UTF-8') as fsql:
                fsql.write(sql)
            gen_csv_files(json_obj, file_name)
