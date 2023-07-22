from typing import Any, Dict, List, Optional, Self
# import json
# import glob
# import sys
# from dataclasses import dataclass
# import fileinput
from enum import Enum
# import pandas as pd
import copy
from codelib.SqlGenConfig import SqlGenConfig

from codelib.xml_escape_name import xml_escape_name


class NodeTypes(Enum):
    """
    Describes the type of node.

    DATA - is a catch-all. It may have data.
    """
    DATA = 'data'
    DICT = 'dict'
    LIST = 'list'


def determine_node_type(obj: Any) -> NodeTypes:
    """
    Function to determine the type of node.

    Args:
        obj (Any): Any type of object.

    Returns:
        NodeTypes: Returns the type of node.
    """
    if isinstance(obj, List):
        return NodeTypes.LIST
    if isinstance(obj, Dict):
        return NodeTypes.DICT
    return NodeTypes.DATA


class DataTypes(Enum):
    """
    Describes the type of data the node has.

    This description does not refer to the XML attributes.
    """
    UNKNOWN = 'unknown'
    STR = 'STRING'
    INT = 'INTEGER'
    FLOAT = 'FLOAT'
    BOOLEAN = 'BOOLEAN'


class DataTypeWrapper:
    """
    Wrapper for DataTypes so we can easily implement a getter/setter for the DataType.
    """

    def __init__(self, default_datatype: DataTypes = DataTypes.UNKNOWN) -> None:
        self._datatype = default_datatype

    def __eq__(self, __value: Any) -> bool:
        """
        Tests for equality

        Args:
            __value (Any): Another DataTypeWrapper or DataTypes

        Returns:
            bool:
                True - if equal \n
                False - if NOT equal
        """
        if isinstance(__value, DataTypeWrapper):
            return self._datatype == __value._datatype
        elif isinstance(__value, DataTypes):
            return self._datatype == __value
        else:
            return False

    @property
    def datatype(self) -> DataTypes:
        return self._datatype

    @datatype.setter
    def datatype(self, datatype: DataTypes) -> None:
        """
        Setter for the data type. This method handles the promotion of data types.
        Eg. When parsing the JSON document, [{"a": 1}, {"a": "foo"}] The 1st value is of type is int and
        the data type is set to int. But the 2nd value is of type string. The 2nd call to this method will
        promote the data type to string.

        Truth table
        |Current Data Type             | New Data Type                 | Result            |
        |------------------------------|-------------------------------|-------------------|
        |same                          | same                          | no change         |
        |unknown                       | str, int, float, bool         | new value         |
        |str, int, float, bool         | unknown                       | no change         |
        |int                           | float                         | float             |
        |float                         | int                           | float             |
        |int, float                    | str                           | str               |
        |bool                          | str, int, float               | str               |

        Args:
            datatype (DataTypes): new data type
        """
        if datatype != self._datatype:
            if self._datatype is DataTypes.UNKNOWN:
                self._datatype = datatype
            elif datatype is DataTypes.UNKNOWN:
                pass
            elif datatype == DataTypes.FLOAT and self._datatype == DataTypes.INT:
                self._datatype = DataTypes.FLOAT
            elif datatype == DataTypes.STR and self._datatype in (DataTypes.INT, DataTypes.FLOAT):
                self._datatype = DataTypes.STR
            elif datatype == DataTypes.BOOLEAN or self._datatype == DataTypes.BOOLEAN:
                self._datatype = DataTypes.STR

    def __repr__(self):
        class_name = type(self).__name__
        return f"{class_name}(datatype={self._datatype.value!r},mem_self={id(self)},mem_datatype={id(self._datatype)})"

    def __str__(self):
        class_name = type(self).__name__
        return f"{class_name}(datatype={self._datatype.value})"


def determine_data_type(obj: Any) -> DataTypes:
    """
    Programmatically map the TYPE to our list of data types.

    Args:
        obj (Any): _description_

    Raises:
        Exception: _description_

    Returns:
        DataTypes: _description_
    """
    if obj is None:
        return DataTypes.UNKNOWN
    if isinstance(obj, (list, dict)):
        return DataTypes.UNKNOWN
    if isinstance(obj, bool):
        return DataTypes.BOOLEAN
    if isinstance(obj, str):
        return DataTypes.STR
    if isinstance(obj, float):
        return DataTypes.FLOAT
    if isinstance(obj, int):
        return DataTypes.INT
    raise Exception('Unhandled type')
    # return DataTypes.UNKNOWN


class TreeNodeInfo(DataTypeWrapper):
    """
    Abstract representation of the JSON or XML file.
    """

    def __init__(
            self,
            element_name: str,
            unescaped_element_name: str,
            xpath: str,
            unescaped_xpath: str,
            parent: Optional[Self],
            node_type: NodeTypes,
            depth: int,
            data_type: DataTypes = DataTypes.UNKNOWN,
            xml_attributes: Optional[Dict[str, DataTypeWrapper]] = None,
            has_been_processed: bool = False
    ) -> None:
        """
        Initializer: Do NOT call directly. Use the factory method.

        Args:
            element_name (str): name of the current element

            xpath (str): xpath from root. eg. "/", "/root/", "/root/data/"

            parent (Optional[Self]): Reference to parent. If this node is the root, then parent is None.

            parent_xpath (Optional[str]): XPath of parent. If this node is the root, then parent_xpath is None.

            xml_attributes (Optional[Dict[str, DataTypeWrapper]]): list of xml attributes. Defaults to None.

            data_type (DataTypes, optional): Type of data held in this node. Defaults to DataTypes.UNKNOWN.

            is_array (bool, optional): Indicates if this node is an array. Defaults to False.

            has_been_processed (bool, optional): Indicates if this node has been processed. Defaults to False.
        """
        super().__init__(data_type)
        """
        Data type of this node.
        """

        self.element_name: str = element_name
        """
        name of the current element escaped
        """

        self.unescaped_element_name: str = unescaped_element_name
        """
        The original unescaped element name.
        """

        self.xpath: str = xpath
        """
        xpath of the current element
        """

        self.unescaped_xpath: str = unescaped_xpath
        """
        xpath of the current element using the unescaped element name custom path separator.
        """

        self.parent: Optional[Self] = parent
        """
        Reference to this node's parent. If this node is the root, then the value is None.
        """

        self.xml_attributes: Optional[Dict[str, DataTypeWrapper]] = xml_attributes
        """
        List of XML attributes associated with this node.
        """

        self.children: List[Self] = []
        """
        List of immediate children.
        """

        self._depth = depth
        """
        Depth in the tree.

        ROOT is zero. Increments by 1 the farther from ROOT.

        """

        self.node_type: NodeTypes = node_type
        """
        A node may be a list, dictionary, or data type
        """

        self.has_been_processed: bool = has_been_processed
        """
        Indicates if this node has been processed.
        """

        self.xpath_index: Dict[str, Self]
        """
        Index to all the nodes using the xpath of each node.

        If this is the ROOT node, create an index to all of the child nodes.

        If this is a child node, point this to the index of ROOT.
        """
        if parent is None:
            # This is the ROOT node. Create a single instance for the tree.
            self.xpath_index = {}
            self.xpath_index[xpath] = self
        else:
            # Point to the parent node. Which is the ROOT's xpath index.
            self.xpath_index = parent.xpath_index

    @classmethod
    def factory(
        cls,
        element_name: str,
        parent: Optional[Self],
        xml_attributes: Optional[Dict[str, DataTypeWrapper]],
        node_type: NodeTypes,
        data_type: DataTypes,
        config: SqlGenConfig
    ) -> Self:
        """
        Retrieve an existing instance or create a new instance of class.

        Args:
            element_name (str): name of the current element

            xpath (str): xpath from root. eg. "/", "/root/", "/root/data/"

            parent (Optional[Self]): Reference to parent. If this node is the root, then parent is None.

            parent_xpath (Optional[str]): XPath of parent. If this node is the root, then parent_xpath is None.

            xml_attributes (Optional[List[str]]): list of xml attributes. Defaults to None.

            data_type (DataTypes, optional): Type of data held in this node. Defaults to DataTypes.UNKNOWN.

            is_array (bool, optional): Indicates if this node is an array. Defaults to False.

            has_been_processed (bool, optional): Indicates if this node has been processed. Defaults to False.

        Returns:
            Self: new instance of TreeNodeInfo or existing instance
        """
        assert element_name[0] != '/'
        assert element_name[-1] != '/'

        xpath: str
        unescaped_xpath: str
        unescaped_element_name: str = element_name  # store the unescaped name
        element_name = xml_escape_name(element_name)
        if parent is None:
            xpath = f"/{element_name}/"
            unescaped_xpath = f"{config.col_name_path_separator}{unescaped_element_name}{config.col_name_path_separator}"
        else:
            xpath = f"{parent.xpath}{element_name}/"
            unescaped_xpath = f"{parent.unescaped_xpath}{unescaped_element_name}{config.col_name_path_separator}"

        assert xpath[0] == '/'
        assert xpath[-1] == '/'

        if parent is not None and parent.exists(xpath):
            tni = parent.get_via_xpath(xpath)
            tni.datatype = data_type  # update the data type
            # add any missing XML attributes
            tni.xml_attributes = TreeNodeInfo.merge_xml_attributes(tni.xml_attributes, xml_attributes)

            assert parent is None or (parent is not None and tni.parent == parent)
            assert tni.has_been_processed is False
            assert tni.xpath[0] == '/'
            assert tni.xpath[-1] == '/'

            return tni
        else:
            depth: int = 0
            if parent is not None:
                depth = parent.depth() + 1
            tni = TreeNodeInfo(
                element_name=element_name,
                unescaped_element_name=unescaped_element_name,
                xpath=xpath,
                unescaped_xpath=unescaped_xpath,
                parent=parent,
                depth=depth,
                node_type=node_type,
                data_type=data_type,
                xml_attributes=xml_attributes
            )
            if parent is not None:
                parent.children.append(tni)
                parent.xpath_index[xpath] = tni

            assert tni.xpath[0] == '/'
            assert tni.xpath[-1] == '/'

            return tni

    def get_via_xpath(self, xpath: str) -> Self:
        """
        Return the instance associated with the xpath.

        Args:
            xpath (str): xpath format '/root/elem1/elem2/'

        Returns:
            Self: instance of TreeNodeInfo
        """
        assert xpath[0] == '/'
        assert xpath[-1] == '/'

        assert xpath in self.xpath_index
        return self.xpath_index[xpath]

    def exists(self, xpath: str) -> bool:
        """
        Check if an object exists in the index.

        Args:
            xpath (str): xpath format '/root/elem1/elem2/'

        Returns:
            bool:
                True - if an object is associated with the xpath. \n
                False - if an object is NOT associated with the xpath.
        """
        return xpath in self.xpath_index

    def is_root(self) -> bool:
        return self.depth() == 0

    def depth(self) -> int:
        """
        Indicates the depth from the root.

        Depth is zero based and increments by 1 the farther it is from the ROOT.

        ROOT has a depth of zero.

        Returns:
            int: depth is zero based
        """
        assert self._depth >= 0
        return self._depth

    def has_children(self) -> bool:
        """
        Helper to determine if the node has children.

        Returns:
            bool:
                True - if the node has children \n
                False - if the node has NO children
        """
        return len(self.children) > 0

    def has_single_child(self) -> bool:
        """
        Helper to determine if the node has a single child.

        Returns:
            bool:
                True - if the node has a single child \n
                False - if the node has NO children or more than one child
        """
        return len(self.children) == 1

    def num_of_children(self) -> int:
        """
        Number of children the node has.

        Returns:
            int: May be zero or a positive value
        """
        return len(self.children)

    def has_data(self) -> bool:
        """
        Does the node have data?
        Does not consider XML attributes.

        Returns:
            bool:
                True - if the node has data. \n
                False - if the node has NO data.
        """
        return self.datatype != DataTypes.UNKNOWN

    def is_datatype_numeric(self) -> bool:
        """
        Does the node have a numeric type.

        Returns:
            bool:
                True - if the node has numeric data. \n
                False - if the node has NO data or the datatype is not numeric.
        """
        return self.datatype in [DataTypes.FLOAT, DataTypes.INT]

    def is_datatype_string(self) -> bool:
        """
        Does the node have a string type.

        Returns:
            bool:
                True - if the node has string data. \n
                False - if the node has NO data or the datatype is not a string.
        """
        return self.datatype == DataTypes.STR

    def has_xml_attributes(self) -> bool:
        """
        Does the node have any XML attributes?

        Returns:
            bool:
                True - if the node has XML attribute data. \n
                False - if the node has NO XML attribute data.
        """
        if self.xml_attributes is None:
            return False
        else:
            return len(self.xml_attributes) > 0

    def has_data_or_xml_attributes(self) -> bool:
        """
        Does the node have any XML attributes or data?

        Returns:
            bool:
                True - if the node has XML attribute data or node data. \n
                False - if the node has NO XML attribute data and no node data.
        """
        return self.has_xml_attributes() or self.has_data()

    def make_subtable(self) -> bool:
        """
        If the node is a list or dict, then this node should be made into subtable
        when generating the DV SQL.

        Returns:
            bool:
                TRUE - Make the node into a subtable.\n
                FALSE - Do not make into a subtable.
        """
        return self.node_type in [NodeTypes.LIST, NodeTypes.DICT]

    def is_node_list(self) -> bool:
        """
        Is the node is a list?

        Returns:
            bool:
                TRUE - The node is a list.\n
                FALSE - The node is NOT a list.
        """
        return self.node_type == NodeTypes.LIST

    def is_node_data(self) -> bool:
        """
        Is the node is a data type?

        Returns:
            bool:
                TRUE - The node is a data type.\n
                FALSE - The node is NOT a data type.
        """
        return self.node_type == NodeTypes.DATA

    def is_node_dict(self) -> bool:
        """
        Is the node is a dict?

        Returns:
            bool:
                TRUE - The node is a dict.\n
                FALSE - The node is NOT a dict.
        """
        return self.node_type == NodeTypes.DICT

    @classmethod
    def merge_xml_attributes(
        cls,
        dict1: Optional[Dict[str, DataTypeWrapper]],
        dict2: Optional[Dict[str, DataTypeWrapper]]
    ) -> Optional[Dict[str, DataTypeWrapper]]:
        """
        Merge two XML attribute dictionaries.

        If the same key exists in both, then the data type is updates
        using the DataTypes getter/setter.

        The arguments are not modified and the method has no side effects.

        Args:
            dict1 (Optional[Dict[str, DataTypeWrapper]]): XML attributes
            dict2 (Optional[Dict[str, DataTypeWrapper]]): XML attributes

        Returns:
            Optional[Dict[str, DataTypeWrapper]]: _description_
        """
        if dict1 is not None and dict2 is not None:
            dict_merged = copy.deepcopy(dict1)
            for k, v in dict2.items():
                if k in dict1:
                    dict_merged[k].datatype = copy.copy(v.datatype)
                else:
                    dict_merged[k] = v  # Since this is an enum, there is not need to perform a copy
            return dict_merged

        elif dict1 is None and dict2 is None:
            return None

        elif dict1 is not None:
            return copy.deepcopy(dict1)

        elif dict2 is not None:
            return copy.deepcopy(dict2)

    def to_str_list(self) -> List[str]:
        """
        Pretty print this node to a list of strings

        Returns:
            List[str]: Pretty printted node
        """
        str_builder: List[str] = []

        str_builder.append(f"{self.xpath}")
        str_builder.append(f"    unescaped_xpath={self.unescaped_xpath}")
        str_builder.append(f"    element_name={self.element_name}")
        str_builder.append(f"    unescaped_element_name={self.unescaped_element_name}")
        str_builder.append(f"    datatype={self.datatype}")
        str_builder.append(f"    node_type={self.node_type}")
        str_builder.append(f"    depth={self.depth()}")
        str_builder.append(f"    has_been_processed={self.has_been_processed}")
        str_builder.append(f"    num_of_children={self.num_of_children()}")
        str_builder.append(f"    parent={self.parent.xpath if self.parent is not None else 'None'}")

        str_builder.append("    Children")
        if self.has_children():
            children_xpaths: List[str] = sorted([x.xpath for x in self.children])
            for c in children_xpaths:
                str_builder.append(f"        xpath={c}")
        else:
            str_builder.append("        None")

        str_builder.append("    XML_attributes")
        if self.has_xml_attributes():
            assert self.xml_attributes is not None
            sorted_xml_attr = sorted(self.xml_attributes.items())
            for x in sorted_xml_attr:
                str_builder.append(f"        datatype={x[1]} attr={x[0]}")
        else:
            str_builder.append("        None")

        return str_builder

    def __str__(self):
        return '\n'.join(self.to_str_list()) + '\n'


def find_root(tni: TreeNodeInfo) -> TreeNodeInfo:
    """
    Find the root node

    Args:
        tni (TreeNodeInfo): A tree node anywhere in the hierarchy

    Returns:
        TreeNodeInfo: Returns the root node
    """
    root_keys = [k for k, v in tni.xpath_index.items() if v.is_root()]
    assert len(root_keys) == 1

    return tni.get_via_xpath(root_keys[0])


def pretty_print_entire_tree(tni: TreeNodeInfo, full_info: bool = True) -> List[str]:
    """
    Pretty print the entire tree as a list of strings

    Args:
        tni (TreeNodeInfo): Any node in the tree

    Returns:
        List[str]: list of strings
    """
    output: List[str] = []

    output.append('=====================================')
    output.append('TreeNodeInfo')
    output.append('-------------------------------------')
    output.append('Indexes')
    for k in sorted(tni.xpath_index.keys()):
        output.append(f'    {k}')

    if full_info:
        # Print out the individual nodes
        for k in sorted(tni.xpath_index.keys()):
            output.append('-------------------------------------')
            node = tni.get_via_xpath(k)
            output.extend(node.to_str_list())

    return output


def pretty_print_entire_tree_as_str(tni: TreeNodeInfo, full_info: bool = True) -> str:
    """
    Pretty print the entire tree as a single string

    Args:
        tni (TreeNodeInfo): Any node in the tree

    Returns:
        str: Single string
    """
    return '\n'.join(pretty_print_entire_tree(tni, full_info)) + '\n'
