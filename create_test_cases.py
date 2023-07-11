import glob
import os
from typing import Final, List
from codelib.SqlGenConfig import SqlGenConfig
from codelib.json_parser import parse_json_file
from codelib.metadata import pretty_print_entire_tree_as_str
import jaydebeapi
from flatten.flatten04 import flatten_nested_json
from pathlib import Path
# from xml.sax.saxutils import escape, unescape, quoteattr
import xml.etree.ElementTree as ET


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

dv_ip_addr: Final[str] = '192.168.6.130'
dv_port: Final[int] = 31000
jdbc_class_name: Final[str] = "com.datavirtuality.dv.jdbc.Driver"
dv_database: Final[str] = "datavirtuality"
dv_use_ssl: Final[bool] = False
dv_uid: Final[str] = "admin"
dv_pwd: Final[str] = "admin"
driver_file: Final[str] = "datavirtuality-jdbc_2.1.16-1.jar"
jdbc_use_ssl_str: Final[str] = "mms" if dv_use_ssl else "mm"
connection_string: Final[str] = f"jdbc:datavirtuality:{dv_database}@{jdbc_use_ssl_str}://{dv_ip_addr}:{dv_port};"

con = jaydebeapi.connect(jdbc_class_name, connection_string, [dv_uid, dv_pwd], driver_file)

cur = con.cursor()

# Test the connection
cur.execute("select * from INFORMATION_SCHEMA.tables")
results = cur.fetchall()

sample_data_path = os.path.join('.', 'sample-data-json', '*.json')
for file_path in glob.iglob(sample_data_path, recursive=True, include_hidden=True):
    file_name = os.path.basename(file_path)
    treenodeinfo = parse_json_file(file_path, config)

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
    dest_file = os.path.join('.', 'sample-data-json', f'{file_name_no_ext}.xml')
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
    dest_file = os.path.join('.', 'test-cases-json', f'{file_name}.tree')
    with open(dest_file, 'wt', encoding='UTF-8') as f:
        f.write(pretty_print_entire_tree_as_str(treenodeinfo))

    # ****************************************************************
    # Flatten the JSON to a CSV file for testing
    try:
        flatten_nested_json(file_path, os.path.join('test-cases-json', f'{file_name}.flatten04.csv'))
    except Exception as e:
        print(f'\n\nException occurred processing file [{file_name}]')
        print(e)
        print('\n\n')

    # ****************************************************************
    # ****************************************************************
    # Write output to test cases


cur.close()
