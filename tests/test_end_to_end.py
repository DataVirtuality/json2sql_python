import glob
import os
from typing import List
import unittest
import jaydebeapi
from codelib.SqlGenConfig import SqlGenConfig
from codelib.common_definitions import DV_ConnectionInfo
from codelib.common_definitions import (
    LOCAL_PATH_SAMPLE_DATA_JSON, SAMPLE_DATA_JSON,
    # DV_CONNECTION_NAMES, DV_CONNECTION_PATHS, LOCAL_PATH_TEST_CASES_JSON,
    # LOCAL_CONNECTION_PATHS,  SAMPLE_DATA_XML, TEST_CASES_JSON, TEST_CASES_XML,
    # DV_PATH_SAMPLE_DATA_JSON, DV_PATH_SAMPLE_DATA_XML, LOCAL_PATH_TEST_CASES_XML,
    # DV_PATH_TEST_CASES_JSON, DV_PATH_TEST_CASES_XML, LOCAL_PATH_SAMPLE_DATA_XML,
)
from codelib.json_parser import parse_json_file
from codelib.metadata import TreeNodeInfo
from codelib.sql_generator import SqlGenerator
from codelib.xml_parser import parse_xml_file


config = SqlGenConfig(
    dv_datasource_filepath='/',
    dv_datasource_name=SAMPLE_DATA_JSON,
    col_name_path_separator='/',
    col_name_regex=None,
    col_name_regex_ignore_case=True,
    col_name_regex_replacement='',
    col_name_replace_prefix=None,
    col_name_replace_root=None,
    col_name_replace_suffix=None,
    dv_path_separator='\\',
    explode_arrays=True,
    file_amalgamation=False,
    force_data_types_to_string=False,
    json_xml_file_to_parse='file.json',
    sql_table_alias='XmlTable'
)


class TestSqlGenerator(unittest.TestCase):
    def test_json_against_DV(self):
        dv_conn_info: DV_ConnectionInfo = DV_ConnectionInfo()

        con = jaydebeapi.connect(
            dv_conn_info.jdbc_class_name,
            dv_conn_info.connection_string(),
            [dv_conn_info.dv_uid, dv_conn_info.dv_pwd],
            dv_conn_info.driver_file
        )

        cur = con.cursor()

        for file_path in glob.iglob(
            os.path.join('.', LOCAL_PATH_SAMPLE_DATA_JSON, '*.json'),
            recursive=True,
            include_hidden=True
        ):
            file_name: str = os.path.basename(file_path)
            config.json_xml_file_to_parse = file_name

            treenodeinfo: TreeNodeInfo
            if file_name.lower().endswith('.xml'):
                treenodeinfo = parse_xml_file(file_path, config)
            elif file_name.lower().endswith('.json'):
                treenodeinfo = parse_json_file(file_path, config)
            else:
                print("Unsupported file type [{file_name}]")
                continue

            assert treenodeinfo is not None
            sqlgen = SqlGenerator(config=config, treenodeinfo=treenodeinfo)

            print('==========================================')
            print('==========================================')
            print(file_name)
            print('==========================================')
            cur.execute(sqlgen.generate_dv_sql())
            results: List[str] = cur.fetchall()
            self.assertGreater(len(results), 0)
            # print(results)
        # print()
