import unittest
from codelib.SqlGenConfig import SqlGenConfig
from codelib.metadata import DataTypeWrapper, DataTypes, NodeTypes, TreeNodeInfo, determine_data_type, determine_node_type


class TestMetadata(unittest.TestCase):
    root: TreeNodeInfo
    node1_0: TreeNodeInfo
    node1_1: TreeNodeInfo
    node2_0: TreeNodeInfo
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

        TestMetadata.root = TreeNodeInfo.factory(
            element_name='root',
            parent=None,
            node_type=NodeTypes.DICT,
            data_type=DataTypes.UNKNOWN,
            config=cls.config,
            xml_attributes=None
        )

        assert len(TestMetadata.root.xpath_index) == 1

        TestMetadata.node1_0 = TreeNodeInfo.factory(
            element_name='node1_0',
            parent=TestMetadata.root,
            node_type=NodeTypes.DATA,
            data_type=DataTypes.FLOAT,
            xml_attributes=None,
            config=cls.config
        )

        assert len(TestMetadata.root.xpath_index) == 2

        TestMetadata.node1_1 = TreeNodeInfo.factory(
            element_name='node1_1',
            parent=TestMetadata.node1_0,
            node_type=NodeTypes.LIST,
            data_type=DataTypes.INT,
            xml_attributes={"test": DataTypeWrapper(DataTypes.STR)},
            config=cls.config
        )

        assert len(TestMetadata.root.xpath_index) == 3

        TestMetadata.node2_0 = TreeNodeInfo.factory(
            element_name='node2_0',
            parent=TestMetadata.root,
            node_type=NodeTypes.DICT,
            data_type=DataTypes.STR,
            xml_attributes=None,
            config=cls.config
        )

        assert len(TestMetadata.root.xpath_index) == 4

    def test_determine_node_type(self):
        self.assertEqual(NodeTypes.DATA, determine_node_type(5))
        self.assertEqual(NodeTypes.DATA, determine_node_type("a"))
        self.assertEqual(NodeTypes.DATA, determine_node_type(0.5))
        self.assertEqual(NodeTypes.LIST, determine_node_type([]))
        self.assertEqual(NodeTypes.DICT, determine_node_type({}))

    def test_determine_data_type(self):
        self.assertEqual(determine_data_type(None), DataTypes.UNKNOWN)
        self.assertEqual(determine_data_type({}), DataTypes.UNKNOWN)
        self.assertEqual(determine_data_type([]), DataTypes.UNKNOWN)
        self.assertEqual(determine_data_type("abc"), DataTypes.STR)
        self.assertEqual(determine_data_type(1.5), DataTypes.FLOAT)
        self.assertEqual(determine_data_type(True), DataTypes.BOOLEAN)
        self.assertEqual(determine_data_type(False), DataTypes.BOOLEAN)
        with self.assertRaises(Exception):
            determine_data_type(set("abc"))

    def test_TreeNodeInfo(self):
        # Test root
        self.assertEqual(self.root.element_name, 'root')
        self.assertEqual(self.root.xpath, '/root/')
        self.assertIsNone(self.root.parent)
        self.assertEqual(self.root.node_type, NodeTypes.DICT)
        self.assertEqual(self.root.datatype, DataTypes.UNKNOWN)
        self.assertIsNone(self.root.xml_attributes)
        self.assertEqual(self.root.has_been_processed, False)
        self.assertEqual(len(self.root.children), 2)

        # Make sure there isn't any issues between class variables and instance variables
        self.assertEqual(len(TestMetadata.root.xpath_index), 4)
        self.assertEqual(len(self.root.xpath_index), 4)

        self.assertDictEqual(TestMetadata.root.xpath_index, self.root.xpath_index)
        self.assertDictEqual(TestMetadata.root.xpath_index, self.node1_0.xpath_index)
        self.assertDictEqual(TestMetadata.root.xpath_index, self.node1_1.xpath_index)
        self.assertDictEqual(TestMetadata.root.xpath_index, self.node2_0.xpath_index)

        # Test node1_0
        self.assertEqual(self.node1_0.element_name, 'node1_0')
        self.assertEqual(self.node1_0.xpath, '/root/node1_0/')
        self.assertIs(self.node1_0.parent, self.root)
        self.assertEqual(self.node1_0.node_type, NodeTypes.DATA)
        self.assertEqual(self.node1_0.datatype, DataTypes.FLOAT)
        self.assertIsNone(self.node1_0.xml_attributes)
        self.assertEqual(self.node1_0.has_been_processed, False)
        self.assertEqual(len(self.node1_0.children), 1)

        # Test node1_1
        self.assertEqual(self.node1_1.element_name, 'node1_1')
        self.assertEqual(self.node1_1.xpath, '/root/node1_0/node1_1/')
        self.assertIs(self.node1_1.parent, self.node1_0)
        self.assertEqual(self.node1_1.node_type, NodeTypes.LIST)
        self.assertEqual(self.node1_1.datatype, DataTypes.INT)
        self.assertIsNotNone(self.node1_1.xml_attributes)
        self.assertDictEqual(self.node1_1.xml_attributes, {"test": DataTypeWrapper(DataTypes.STR)})  # type: ignore
        self.assertEqual(self.node1_1.has_been_processed, False)

        # Test node2_0
        self.assertEqual(self.node2_0.element_name, 'node2_0')
        self.assertEqual(self.node2_0.xpath, '/root/node2_0/')
        self.assertIs(self.node2_0.parent, self.root)
        self.assertEqual(self.node2_0.node_type, NodeTypes.DICT)
        self.assertEqual(self.node2_0.datatype, DataTypes.STR)
        self.assertIsNone(self.node2_0.xml_attributes)
        self.assertEqual(self.node2_0.has_been_processed, False)

    def test_exists(self):
        self.assertTrue(TestMetadata.root.exists('/root/'))
        self.assertTrue(TestMetadata.root.exists('/root/node1_0/'))
        self.assertTrue(TestMetadata.root.exists('/root/node1_0/node1_1/'))
        self.assertFalse(TestMetadata.root.exists('/fake/node1_0/node1_1/'))

    def test_get_via_xpath(self):
        self.assertIs(self.root, TestMetadata.root.get_via_xpath('/root/'))
        self.assertIs(self.node1_0, TestMetadata.root.get_via_xpath('/root/node1_0/'))  # todo
        self.assertIs(self.node1_1, TestMetadata.root.get_via_xpath('/root/node1_0/node1_1/'))
        with self.assertRaises(Exception):
            self.assertIsNone(TestMetadata.root.get_via_xpath('/fake/node1_0/node1_1/'))

    def test_has_children(self):
        self.assertTrue(self.root.has_children())
        self.assertTrue(self.node1_0.has_children())
        self.assertFalse(self.node1_1.has_children())
        self.assertFalse(self.node2_0.has_children())

    def test_has_single_child(self):
        self.assertFalse(self.root.has_single_child())
        self.assertTrue(self.node1_0.has_single_child())
        self.assertFalse(self.node1_1.has_single_child())
        self.assertFalse(self.node2_0.has_single_child())

    def test_depth(self):
        self.assertEqual(self.root.depth(), 0)
        self.assertEqual(self.node1_0.depth(), 1)
        self.assertEqual(self.node1_1.depth(), 2)
        self.assertEqual(self.node2_0.depth(), 1)

    def test_num_of_children(self):
        self.assertEqual(self.root.num_of_children(), 2)
        self.assertEqual(self.node1_0.num_of_children(), 1)
        self.assertEqual(self.node1_1.num_of_children(), 0)
        self.assertEqual(self.node2_0.num_of_children(), 0)

    def test_has_data(self):
        self.assertFalse(self.root.has_data())
        self.assertTrue(self.node1_0.has_data())
        self.assertTrue(self.node1_1.has_data())
        self.assertTrue(self.node2_0.has_data())

    def test_is_datatype_numeric(self):
        self.assertFalse(self.root.is_datatype_numeric())
        self.assertTrue(self.node1_0.is_datatype_numeric())
        self.assertTrue(self.node1_1.is_datatype_numeric())
        self.assertFalse(self.node2_0.is_datatype_numeric())

    def test_is_datatype_string(self):
        self.assertFalse(self.root.is_datatype_string())
        self.assertFalse(self.node1_0.is_datatype_string())
        self.assertFalse(self.node1_1.is_datatype_string())
        self.assertTrue(self.node2_0.is_datatype_string())

    def test_has_xml_attributes(self):
        self.assertFalse(self.root.has_xml_attributes())
        self.assertFalse(self.node1_0.has_xml_attributes())
        self.assertTrue(self.node1_1.has_xml_attributes())
        self.assertFalse(self.node2_0.has_xml_attributes())

    def test_make_subtable(self):
        self.assertTrue(self.root.make_subtable())
        self.assertFalse(self.node1_0.make_subtable())
        self.assertTrue(self.node1_1.make_subtable())
        self.assertTrue(self.node2_0.make_subtable())

    def test_is_root(self):
        self.assertTrue(self.root.is_root())
        self.assertFalse(self.node1_0.is_root())
        self.assertFalse(self.node1_1.is_root())
        self.assertFalse(self.node2_0.is_root())

    def test_is_list(self):
        self.assertFalse(self.root.is_node_list())
        self.assertFalse(self.node1_0.is_node_list())
        self.assertTrue(self.node1_1.is_node_list())
        self.assertFalse(self.node2_0.is_node_list())

    def test_is_dict(self):
        self.assertTrue(self.root.is_node_dict())
        self.assertFalse(self.node1_0.is_node_dict())
        self.assertFalse(self.node1_1.is_node_dict())
        self.assertTrue(self.node2_0.is_node_dict())

    def test_merge_xml_attributes(self):
        t1 = {"d1": DataTypeWrapper(DataTypes.STR)}
        t2 = {"d2": DataTypeWrapper(DataTypes.FLOAT)}
        t3 = {"d3": DataTypeWrapper(DataTypes.INT)}
        t4 = {"d1": DataTypeWrapper(DataTypes.INT), "d2": DataTypeWrapper(DataTypes.INT), "d3": DataTypeWrapper(DataTypes.STR)}
        t5 = {"d1": DataTypeWrapper(DataTypes.FLOAT), "d2": DataTypeWrapper(DataTypes.UNKNOWN), "d3": DataTypeWrapper(DataTypes.STR), "d4": DataTypeWrapper(DataTypes.UNKNOWN)}

        # Make sure the function is immutable and has no side effects
        t1_str = f"{t1!r}"
        t2_str = f"{t2!r}"
        t3_str = f"{t3!r}"
        t4_str = f"{t4!r}"
        t5_str = f"{t5!r}"

        self.assertIsNone(self.root.merge_xml_attributes(None, None))

        self.assertDictEqual(t1, TreeNodeInfo.merge_xml_attributes(t1, None))  # type: ignore
        self.assertDictEqual(t2, TreeNodeInfo.merge_xml_attributes(None, t2))  # type: ignore

        self.assertDictEqual(t4, TreeNodeInfo.merge_xml_attributes(t4, None))  # type: ignore
        self.assertDictEqual(t4, TreeNodeInfo.merge_xml_attributes(None, t4))  # type: ignore

        t1_plus_t4 = {"d1": DataTypeWrapper(DataTypes.STR), "d2": DataTypeWrapper(DataTypes.INT), "d3": DataTypeWrapper(DataTypes.STR)}
        self.assertDictEqual(t1_plus_t4, TreeNodeInfo.merge_xml_attributes(t1, t4))  # type: ignore
        self.assertDictEqual(t1_plus_t4, TreeNodeInfo.merge_xml_attributes(t4, t1))  # type: ignore

        t2_plus_t4 = {"d1": DataTypeWrapper(DataTypes.INT), "d2": DataTypeWrapper(DataTypes.FLOAT), "d3": DataTypeWrapper(DataTypes.STR)}
        self.assertDictEqual(t2_plus_t4, TreeNodeInfo.merge_xml_attributes(t2, t4))  # type: ignore
        self.assertDictEqual(t2_plus_t4, TreeNodeInfo.merge_xml_attributes(t4, t2))  # type: ignore

        t3_plus_t4 = {"d1": DataTypeWrapper(DataTypes.INT), "d2": DataTypeWrapper(DataTypes.INT), "d3": DataTypeWrapper(DataTypes.STR)}
        self.assertDictEqual(t3_plus_t4, TreeNodeInfo.merge_xml_attributes(t3, t4))  # type: ignore
        self.assertDictEqual(t3_plus_t4, TreeNodeInfo.merge_xml_attributes(t4, t3))  # type: ignore

        t4_plus_t5 = {"d1": DataTypeWrapper(DataTypes.FLOAT), "d2": DataTypeWrapper(DataTypes.INT), "d3": DataTypeWrapper(DataTypes.STR), "d4": DataTypeWrapper(DataTypes.UNKNOWN)}
        self.assertDictEqual(t4_plus_t5, TreeNodeInfo.merge_xml_attributes(t4, t5))  # type: ignore
        self.assertDictEqual(t4_plus_t5, TreeNodeInfo.merge_xml_attributes(t5, t4))  # type: ignore

        self.assertEqual(t1_str, f"{t1!r}")
        self.assertEqual(t2_str, f"{t2!r}")
        self.assertEqual(t3_str, f"{t3!r}")
        self.assertEqual(t4_str, f"{t4!r}")
        self.assertEqual(t5_str, f"{t5!r}")
