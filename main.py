# from typing import Dict, Final, List, cast, Any
import argparse
import json
import glob
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


def ExtractConfigFromArgs(args: argparse.Namespace) -> SqlGenConfig:
    return SqlGenConfig(
        dv_datasource_name=args.dsname,
        dv_datasource_filepath=args.dspath,
        force_data_types_to_string=args.force_strings,
        explode_arrays=args.explode_arrays,
        xml_table_name=args.list_as_rows
    )


args = parse_args()
config: SqlGenConfig = ExtractConfigFromArgs(args)

if args.stdio is True:
    str_data = fileinput.input()
    json_obj = json.loads(str_data)  # type: ignore
    # print(generate_dv_sql(json_obj, 'stdio', args.dsname))
else:
    for file_name in glob.iglob(args.files, recursive=args.recurse, include_hidden=args.include_hidden):
        treenodeinfo = parse_json_file(file_name)
        sqlgen = SqlGenerator(config=config, treenodeinfo=treenodeinfo)
        with open(f'{file_name}.sql', 'wt', encoding='UTF-8') as fsql:
            fsql.write(sqlgen.generate_dv_sql())
