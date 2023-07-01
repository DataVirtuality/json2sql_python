import unittest

from codelib.metadata import DataTypeWrapper, DataTypes, NodeTypes, TreeNodeInfo, determine_node_type, determine_data_type


class TestMetadata(unittest.TestCase):
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
        with self.assertRaises(Exception):
            determine_data_type(set("abc"))

    def test_TreeNodeInfo(self):
        self.assertEqual(len(TreeNodeInfo.xpath_index), 0)

        root = TreeNodeInfo.factory(
            element_name='root',
            xpath='/root/',
            parent=None,
            parent_xpath=None,
            node_type=NodeTypes.DATA,
            data_type=DataTypes.UNKNOWN,
            xml_attributes=None
        )

        self.assertEqual(len(TreeNodeInfo.xpath_index), 1)
        self.assertEqual(len(root.xpath_index), 1)
        self.assertDictEqual(TreeNodeInfo.xpath_index, root.xpath_index)

        self.assertEqual(root.element_name, 'root')
        self.assertEqual(root.xpath, '/root/')
        self.assertIsNone(root.parent)
        self.assertIsNone(root.parent_xpath)
        self.assertEqual(root.node_type, NodeTypes.DATA)
        self.assertEqual(root.datatype, DataTypes.UNKNOWN)
        self.assertIsNone(root.xml_attributes)
        self.assertEqual(root.has_been_processed, False)
        self.assertEqual(len(root.children), 0)

        node1_0 = TreeNodeInfo.factory(
            element_name='node1_0',
            xpath='/root/node1_0/',
            parent=root,
            parent_xpath=root.xpath,
            node_type=NodeTypes.DICT,
            data_type=DataTypes.FLOAT,
            xml_attributes=None,
            has_been_processed=False
        )

        self.assertEqual(len(TreeNodeInfo.xpath_index), 2)
        self.assertEqual(len(root.xpath_index), 2)
        self.assertDictEqual(TreeNodeInfo.xpath_index, root.xpath_index)
        self.assertDictEqual(TreeNodeInfo.xpath_index, node1_0.xpath_index)

        self.assertEqual(node1_0.element_name, 'node1_0')
        self.assertEqual(node1_0.xpath, '/root/node1_0/')
        self.assertIs(node1_0.parent, root)
        self.assertIs(node1_0.parent_xpath, root.xpath)
        self.assertEqual(node1_0.node_type, NodeTypes.DICT)
        self.assertEqual(node1_0.datatype, DataTypes.FLOAT)
        self.assertIsNone(node1_0.xml_attributes)
        self.assertEqual(node1_0.has_been_processed, False)

        self.assertEqual(len(root.children), 1)
        self.assertEqual(len(node1_0.children), 0)

        node1_1 = TreeNodeInfo.factory(
            element_name='node1_1',
            xpath='/root/node1_0/node1_1/',
            parent=node1_0,
            parent_xpath=node1_0.xpath,
            node_type=NodeTypes.LIST,
            data_type=DataTypes.INT,
            xml_attributes={"test": DataTypeWrapper(DataTypes.STR)},
            has_been_processed=True
        )

        self.assertEqual(len(TreeNodeInfo.xpath_index), 3)
        self.assertEqual(len(root.xpath_index), 3)
        self.assertEqual(len(node1_1.xpath_index), 3)
        self.assertDictEqual(TreeNodeInfo.xpath_index, root.xpath_index)
        self.assertDictEqual(TreeNodeInfo.xpath_index, node1_0.xpath_index)
        self.assertDictEqual(TreeNodeInfo.xpath_index, node1_1.xpath_index)

        self.assertEqual(node1_1.element_name, 'node1_1')
        self.assertEqual(node1_1.xpath, '/root/node1_0/node1_1/')
        self.assertIs(node1_1.parent, node1_0)
        self.assertIs(node1_1.parent_xpath, node1_0.xpath)
        self.assertEqual(node1_1.node_type, NodeTypes.LIST)
        self.assertEqual(node1_1.datatype, DataTypes.INT)
        self.assertIsNotNone(node1_1.xml_attributes)
        self.assertDictEqual(node1_1.xml_attributes, {"test": DataTypeWrapper(DataTypes.STR)})  # type: ignore
        self.assertEqual(node1_1.has_been_processed, True)

        self.assertEqual(len(root.children), 1)
        self.assertEqual(len(node1_0.children), 1)
        self.assertEqual(len(node1_1.children), 0)
