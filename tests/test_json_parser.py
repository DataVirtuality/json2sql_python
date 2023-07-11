import unittest
from codelib.json_parser import parse_json_file
from codelib.metadata import pretty_print_entire_tree
from codelib.SqlGenConfig import SqlGenConfig
import os
import glob
import difflib


class TestSqlGenerator(unittest.TestCase):
    config: SqlGenConfig

    @classmethod
    def setUpClass(cls):
        cls.config = SqlGenConfig(
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

    def test_parse_json_file(self):
        differ = difflib.Differ()

        sample_data_path = os.path.join('.', 'sample-data', '*.json')
        for file_path in glob.iglob(sample_data_path, recursive=True, include_hidden=True):
            file_name = os.path.basename(file_path)
            treenodeinfo = parse_json_file(file_path, self.config)
            tree_str_list = pretty_print_entire_tree(treenodeinfo)

            dest_file = os.path.join('.', 'test-cases-json', f'{file_name}.tree')
            with open(dest_file, 'rt', encoding='UTF-8') as f:
                test_case_tree_str_list = f.read().splitlines()

                delta = differ.compare(tree_str_list, test_case_tree_str_list)
                differences = [s for s in delta if not s.startswith('  ')]
                self.assertEqual(len(differences), 0)

                # print('\n'.join(differences))
                # print()
