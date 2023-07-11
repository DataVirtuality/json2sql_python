import unittest
from codelib.SqlGenConfig import SqlGenConfig
from codelib.metadata import DataTypes, NodeTypes, TreeNodeInfo
from codelib.sql_generator import SqlGenerator, remove_last_char_from_str, substract_string


class TestSqlGenerator(unittest.TestCase):
    def test_remove_last_char_from_str(self):
        self.assertEqual('', remove_last_char_from_str(''))
        self.assertEqual('', remove_last_char_from_str('a'))
        self.assertEqual('a', remove_last_char_from_str('ab'))
        self.assertEqual('abcdefg', remove_last_char_from_str('abcdefgh'))

    def test_substract_string(self):
        self.assertEqual('', substract_string('', ''))
        self.assertEqual('abcd', substract_string('', 'abcd'))
        self.assertEqual('bcd', substract_string('a', 'abcd'))
        self.assertEqual('d', substract_string('abc', 'abcd'))
        self.assertEqual('', substract_string('abcd', 'abcd'))
        self.assertEqual('abcd', substract_string('z', 'abcd'))

    def setUp(self):
        self.config = SqlGenConfig(
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

        self.tni: TreeNodeInfo = TreeNodeInfo.factory(
            data_type=DataTypes.FLOAT,
            element_name='root',
            node_type=NodeTypes.DATA,
            parent=None,
            xml_attributes=None,
            config=self.config,
        )

        self.sqlgen = SqlGenerator(self.tni, self.config)

    def test_mod_col_name_01(self):
        self.assertEqual('/root/root/foo/bar/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    def test_mod_col_name_02(self):
        self.config.col_name_replace_root = 'leaf'
        self.assertEqual('leaf/foo/bar/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

        self.config.col_name_replace_root = ''
        self.assertEqual('/foo/bar/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    def test_mod_col_name_03(self):
        self.config.col_name_replace_prefix = 'pre'
        self.assertEqual('preroot/root/foo/bar/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

        self.config.col_name_replace_prefix = '='
        self.assertEqual('=root/root/foo/bar/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

        self.config.col_name_replace_prefix = ''
        self.assertEqual('root/root/foo/bar/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    def test_mod_col_name_04(self):
        self.config.col_name_replace_suffix = 'pre'
        self.assertEqual('/root/root/foo/barpre', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

        self.config.col_name_replace_suffix = '='
        self.assertEqual('/root/root/foo/bar=', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

        self.config.col_name_replace_suffix = ''
        self.assertEqual('/root/root/foo/bar', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    # def test_mod_col_name_05(self):
    #     self.config.col_name_path_separator = 'T|T'
    #     self.assertEqual('T|TrootT|TrootT|TfooT|TbarT|T', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    #     self.config.col_name_path_separator = '*'
    #     self.assertEqual('*root*root*foo*bar*', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    #     self.config.col_name_path_separator = ''
    #     self.assertEqual('rootrootfoobar', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    def test_mod_col_name_06(self):
        self.config.col_name_regex = 'T|r'
        self.config.col_name_regex_ignore_case = False
        self.config.col_name_regex_replacement = 'X'
        self.assertEqual('/Xoot/Xoot/foo/baX/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))

    def test_mod_col_name_07(self):
        self.config.col_name_regex = 'T|r'
        self.config.col_name_regex_ignore_case = True
        self.config.col_name_regex_replacement = 'X'
        self.assertEqual('/XooX/XooX/foo/baX/', self.sqlgen.mod_col_name('/root/root/foo/bar/'))
