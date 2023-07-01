# from typing import Dict, Final, List, cast, Any
import argparse
import json
import glob
import os
# import sys
# from dataclasses import dataclass
import fileinput
from codelib.SqlGenConfig import SqlGenConfig
from codelib.json_parser import parse_json_file
# from codelib.metadata import TreeNodeInfo
from codelib.sql_generator import SqlGenerator
# from enum import Enum
# import pandas as pd
# from gen_csv_files import gen_csv_files
from codelib.args import parse_args
from flatten.flatten04 import flatten_nested_json


def ExtractConfigFromArgs(args: argparse.Namespace) -> SqlGenConfig:
    return SqlGenConfig(
        file_amalgamation=args.file_amalgamation,
        dv_datasource_name=args.dsname,
        dv_datasource_filepath=args.dspath,
        dv_path_separator=args.ds_path_separator,
        force_data_types_to_string=args.force_strings,
        sql_table_alias=args.sqlalias,
        col_name_replace_prefix=args.col_name_replace_prefix,
        col_name_replace_suffix=args.col_name_replace_suffix,
        col_name_replace_root=args.col_name_replace_root,
        col_name_path_separator=args.col_name_path_separator,
        col_name_regex=args.col_name_regex,
        col_name_regex_ignore_case=args.col_name_regex_ignore_case,
        col_name_regex_replacement=args.col_name_regex_replacement,
        explode_arrays=args.list_as_rows
    )


args = parse_args()
config: SqlGenConfig = ExtractConfigFromArgs(args)

if args.stdio is True:
    str_data = fileinput.input()
    json_obj = json.loads(str_data)  # type: ignore
    # print(generate_dv_sql(json_obj, 'stdio', args.dsname))
else:
    for file_name in glob.iglob(args.files, recursive=args.recurse, include_hidden=args.include_hidden):
        config.json_xml_file_to_parse = os.path.basename(file_name)
        treenodeinfo = parse_json_file(file_name)
        sqlgen = SqlGenerator(config=config, treenodeinfo=treenodeinfo)
        with open(f'{file_name}.sql', 'wt', encoding='UTF-8') as fsql:
            fsql.write(sqlgen.generate_dv_sql())

        flatten_nested_json(file_name, f'{file_name}.04.csv')
