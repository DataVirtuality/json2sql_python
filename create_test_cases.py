#!/usr/bin/env python3
import glob
import os
from typing import List, Set, Tuple, cast
from codelib.SqlGenConfig import SqlGenConfig
from codelib.json_parser import parse_json_file
from codelib.metadata import pretty_print_entire_tree_as_str
import jaydebeapi
from flatten.flatten04 import flatten_nested_json
from pathlib import Path
# from xml.sax.saxutils import escape, unescape, quoteattr
import xml.etree.ElementTree as ET
from codelib.common_definitions import (
    LOCAL_PATH_SAMPLE_DATA_JSON, DV_CONNECTION_NAMES, DV_CONNECTION_PATHS, LOCAL_PATH_TEST_CASES_JSON,
    LOCAL_CONNECTION_PATHS, SAMPLE_DATA_JSON, SAMPLE_DATA_XML, TEST_CASES_JSON, TEST_CASES_XML, DV_ConnectionInfo,
    # DV_PATH_SAMPLE_DATA_JSON, DV_PATH_SAMPLE_DATA_XML, LOCAL_PATH_TEST_CASES_XML,
    # DV_PATH_TEST_CASES_JSON, DV_PATH_TEST_CASES_XML, LOCAL_PATH_SAMPLE_DATA_XML,
)


config = SqlGenConfig(
    dv_datasource_filepath='/',
    dv_datasource_name='ds_name',
    col_name_path_separator='/',
    col_name_regex=None,
    col_name_regex_ignore_case=True,
    col_name_regex_replacement='',
    col_name_replace_prefix=None,
    col_name_replace_root=None,
    col_name_replace_suffix=None,
    dv_path_separator='\\',
    explode_arrays=False,
    file_amalgamation=False,
    force_data_types_to_string=True,
    json_xml_file_to_parse='file.json',
    sql_table_alias='XmlTable'
)

dv_conn_info: DV_ConnectionInfo = DV_ConnectionInfo()

con = jaydebeapi.connect(dv_conn_info.jdbc_class_name, dv_conn_info.connection_string(), [dv_conn_info.dv_uid, dv_conn_info.dv_pwd], dv_conn_info.driver_file)

cur = con.cursor()

# ****************************************************************
# Test the connection
# cur.execute("select * from INFORMATION_SCHEMA.tables")
# results = cur.fetchall()


# ****************************************************************
# ****************************************************************
# Create the folders on DV
for dv_path in DV_CONNECTION_PATHS.values():
    cur.execute(f"call SYSADMIN.execExternalProcess(command => 'mkdir', args => ARRAY('-p', '{dv_path}'));;")


# ****************************************************************
# ****************************************************************
# Create the DV connections
cur.execute(f"SELECT name FROM SYSADMIN.Connections where name in ('{SAMPLE_DATA_JSON}', '{SAMPLE_DATA_XML}', '{TEST_CASES_JSON}', '{TEST_CASES_XML}');;")
existing_connection_names: Set[str] = set([x[0] for x in cast(List[Tuple[str, None]], cur.fetchall())])

# Determine which connection do not exist and create them
for conn_name in DV_CONNECTION_NAMES - existing_connection_names:
    parent_dir = DV_CONNECTION_PATHS[conn_name]
    dv_connection_str = (
        "call SYSADMIN.createConnection("
        f"name => '{conn_name}',"
        "jbossCliTemplateName => 'ufile',"
        f"connectionOrResourceAdapterProperties => 'ParentDirectory={parent_dir},decompressCompressedFiles=false',"
        "encryptedProperties => ''"
        ");;"
    )
    cur.execute(dv_connection_str)


# ****************************************************************
# ****************************************************************
# Create the DV datasources
cur.execute(f"SELECT name FROM SYSADMIN.DataSources where name in ('{SAMPLE_DATA_JSON}', '{SAMPLE_DATA_XML}', '{TEST_CASES_JSON}', '{TEST_CASES_XML}');;")
existing_connection_names: Set[str] = set([x[0] for x in cast(List[Tuple[str, None]], cur.fetchall())])

# Determine which connection do not exist and create them
for conn_name in DV_CONNECTION_NAMES - existing_connection_names:
    dv_datasource_str = (
        "call SYSADMIN.createDatasource("
        f"name => '{conn_name}',"
        "translator => 'ufile',"
        "modelProperties => 'importer.useFullSchemaName=false',"
        "translatorProperties => '',"
        "encryptedModelProperties => '',"
        "encryptedTranslatorProperties => ''"
        ");;"
    )
    cur.execute(dv_datasource_str)


# ****************************************************************
# ****************************************************************
# Create sample data based on JSON files

sample_data_path = os.path.join('.', LOCAL_PATH_SAMPLE_DATA_JSON, '*.json')
for file_path in glob.iglob(sample_data_path, recursive=True, include_hidden=True):
    file_name = os.path.basename(file_path)
    treenodeinfo = parse_json_file(file_path, config)
    # print(pretty_print_entire_tree_as_str(treenodeinfo, False))

    # ****************************************************************
    # Determine the list of characters to escape by using
    # str_list: List[str] = []
    # for i in range(32, 1001):
    #     if i == ord('A'):  # char A is our separator. No need to test it
    #         continue
    #     str_list.append(f"{i:#0{6}x}{chr(i)}")
    # char_str = 'A'.join(str_list)  # 'A' is our separator
    # cur.execute("select XMLESCAPENAME(cast(? as string), true) as col1;;", [char_str])
    # results = cur.fetchall()
    # xml_str = results[0][0]

    # ****************************************************************
    # ****************************************************************
    # Convert the JSON to XML using DV
    file_name_no_ext = Path(file_path).stem
    dest_file = os.path.join('.', LOCAL_PATH_SAMPLE_DATA_JSON, f'{file_name_no_ext}.xml')
    with open(file_path, 'rt', encoding='UTF-8') as f:
        json_txt = f.read()
    cur.execute("select XmlSerialize(JSONTOXML('root', cast(? as string)) as string) as x;;", [json_txt])
    results: List[str] = cur.fetchall()
    xml_str: str = results[0][0]
    # xml_bytes: bytes = xml_str.encode(encoding='utf-8')  # convert from Unicode to UTF-8
    root: ET.Element = ET.fromstring(xml_str)
    ET.indent(root, space='    ')
    formatted_xml: str = ET.tostring(root, encoding='UTF-8').decode()
    with open(dest_file, 'wt', encoding='UTF-8') as fxml:
        fxml.write(formatted_xml)

    # ****************************************************************
    # ****************************************************************
    # Create the test cases for the JSON parser
    dest_file = os.path.join('.', LOCAL_PATH_TEST_CASES_JSON, f'{file_name}.tree')
    with open(dest_file, 'wt', encoding='UTF-8') as f:
        f.write(pretty_print_entire_tree_as_str(treenodeinfo))

    # ****************************************************************
    # ****************************************************************
    # Flatten the JSON to a CSV file for testing
    try:
        flatten_nested_json(file_path, os.path.join('.', LOCAL_PATH_TEST_CASES_JSON, f'{file_name}.flatten04.csv'))
    except Exception as e:
        print(f'\n\nException occurred processing file [{file_name}]')
        print(e)
        print('\n\n')

    # ****************************************************************
    # ****************************************************************
    # Write output to test cases


# ****************************************************************
# ****************************************************************
# Copy sample data to DV
for dv_conn_name, local_path in LOCAL_CONNECTION_PATHS.items():
    data_path: str = os.path.join(local_path, '*')
    for file_path in glob.iglob(data_path, recursive=True, include_hidden=True):
        file_name = os.path.basename(file_path)
        file_content: str
        with open(file_path, 'rt', encoding='UTF-8') as f:
            file_content = f.read()
        cur.execute(
            f"call \"{dv_conn_name}.saveFile\"(\"filePath\" => '{file_name}', \"file\" => to_chars(?, 'UTF-8'));;",
            [file_content]
        )
        # results: List[str] = cur.fetchall()
print()


cur.close()
