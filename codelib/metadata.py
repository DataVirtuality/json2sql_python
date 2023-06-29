from typing import Any, Dict, List, Optional, Self
# import json
# import glob
# import sys
# from dataclasses import dataclass
# import fileinput
from enum import Enum
# import pandas as pd


class NodeTypes(Enum):
    DATA = 'data'
    DICT = 'dict'
    LIST = 'list'


def determine_node_type(obj: Any) -> NodeTypes:
    if isinstance(obj, list):
        return NodeTypes.LIST
    if isinstance(obj, dict):
        return NodeTypes.DICT
    return NodeTypes.DATA


class DataTypes(Enum):
    UNKNOWN = 'unknown'
    STR = 'string'
    INT = 'integer'
    FLOAT = 'float'


def determine_data_type(obj: Any) -> DataTypes:
    if obj is None:
        return DataTypes.UNKNOWN
    if isinstance(obj, (list, dict)):
        return DataTypes.UNKNOWN
    if isinstance(obj, str):
        return DataTypes.STR
    if isinstance(obj, float):
        return DataTypes.FLOAT
    if isinstance(obj, int):
        return DataTypes.INT
    raise Exception('Unhandled type')
    return DataTypes.UNKNOWN


class TreeNodeInfo:
    """
    Abstract representation of the JSON or XML file.
    """

    xpath_index: Dict[str, Self] = {}
    """
    Index to all the nodes using the xpath of each node.
    """

    def __init__(
            self,
            element_name: str,
            xpath: str,
            parent: Optional[Self],
            parent_xpath: Optional[str],
            node_type: NodeTypes,
            data_type: DataTypes = DataTypes.UNKNOWN,
            xml_attributes: Optional[List[str]] = None,
            has_been_processed: bool = False
    ) -> None:
        """
        Initializer

        Args:
            element_name (str): name of the current element

            xpath (str): xpath from root. eg. "/", "/root/", "/root/data/"

            parent (Optional[Self]): Reference to parent. If this node is the root, then parent is None.

            parent_xpath (Optional[str]): XPath of parent. If this node is the root, then parent_xpath is None.

            xml_attributes (Optional[List[str]]): list of xml attributes. Defaults to None.

            data_type (DataTypes, optional): Type of data held in this node. Defaults to DataTypes.UNKNOWN.

            is_array (bool, optional): Indicates if this node is an array. Defaults to False.

            has_been_processed (bool, optional): Indicates if this node has been processed. Defaults to False.
        """
        self.element_name: str = element_name
        """
        name of the current element
        """

        self.xpath: str = xpath
        """
        xpath of the current element
        """

        self.parent: Optional[Self] = parent
        """
        Reference to this node's parent. If this node is the root, then the value is None.
        """

        self.parent_xpath: Optional[str] = parent_xpath
        """
        XPath of the this node's parent. If this node is the root, then the value is None.
        """

        self.xml_attributes = [] if xml_attributes is None else xml_attributes
        """
        List of XML attributes associated with this node.
        """

        self.children: List[Self] = []
        """
        List of immediate children.
        """

        self.xml_attributes: List[str] = []
        """
        XML attributes associated with this node.
        """

        self.node_type: NodeTypes = node_type
        """
        A node may be a list, dictionary, or data type
        """

        self._data_type: DataTypes = data_type
        """
        Data type of this node.
        """

        self.has_been_processed: bool = has_been_processed
        """
        Indicates if this node has been processed.
        """

    @classmethod
    def factory(
        cls,
        element_name: str,
        xpath: str,
        parent: Optional[Self],
        parent_xpath: Optional[str],
        xml_attributes: Optional[List[str]],
        node_type: NodeTypes,
        data_type: DataTypes,
        is_array: bool = False,
        has_been_processed: bool = False
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
        if TreeNodeInfo.exists(xpath):
            tni = TreeNodeInfo.get_via_xpath(xpath)
            tni.data_type = data_type  # update the data type
            # add any missing XML attributes
            if xml_attributes is not None:
                tni.xml_attributes = list(set(tni.xml_attributes).union(set(xml_attributes)))

            assert tni.parent == parent
            assert tni.parent_xpath == parent_xpath
            assert tni.has_been_processed is False

            return tni
        else:
            tni = TreeNodeInfo(
                element_name=element_name,
                xpath=xpath,
                parent=parent,
                parent_xpath=parent_xpath,
                node_type=node_type,
                data_type=data_type,
                xml_attributes=xml_attributes,
                has_been_processed=has_been_processed
            )
            TreeNodeInfo.xpath_index[xpath] = tni
            if parent is not None:
                parent.children.append(tni)
            return tni

    @classmethod
    def get_via_xpath(cls, xpath: str) -> Self:
        """
        Return the instance associated with the xpath.

        Args:
            xpath (str): xpath format '/root/elem1/elem2/'

        Returns:
            Self: instance of TreeNodeInfo
        """
        assert xpath in TreeNodeInfo.xpath_index
        return TreeNodeInfo.xpath_index[xpath]

    @classmethod
    def exists(cls, xpath: str) -> bool:
        """
        Check if an object exists in the index.

        Args:
            xpath (str): xpath format '/root/elem1/elem2/'

        Returns:
            bool:
            * True if an object is associated with the xpath.
            * False if an object is NOT associated with the xpath.
        """
        return xpath in TreeNodeInfo.xpath_index

    def depth(self) -> int:
        """
        Indicates the depth from the root.

        Returns:
            int: depth
        """
        return self.xpath.count('/') - 2

    @property
    def data_type(self):
        """
        Gets the data type of this node.

        Returns:
            _type_: data type
        """
        return self._data_type

    @data_type.setter
    def data_type(self, datatype: DataTypes):
        """
        Setter for the data type. This method handles the promotion of data types.
        Eg. When parsing the JSON document, [{"a": 1}, {"a": "foo"}] The 1st value is of type is int and
        the data type is set to int. But the 2nd value is of type string. The 2nd call to this method will
        promote the data type to string.

        Truth table
        |Current Data Type      | New Data Type        | Result            |
        |-----------------------|----------------------|-------------------|
        |same                   | same                 | no change         |
        |unknown                | str, int, float      | new value         |
        |str, int, float        | unknown              | no change         |
        |int                    | float                | float             |
        |float                  | int                  | float             |
        |int, float             | str                  | str               |

        Args:
            datatype (DataTypes): new data type
        """
        if datatype != self._data_type:
            if self._data_type is DataTypes.UNKNOWN:
                self._data_type = datatype
            elif datatype is DataTypes.UNKNOWN:
                pass
            elif datatype in (DataTypes.INT, DataTypes.FLOAT) and self._data_type in (DataTypes.INT, DataTypes.FLOAT):
                self._data_type = DataTypes.FLOAT
            elif datatype == DataTypes.STR and self._data_type in (DataTypes.INT, DataTypes.FLOAT):
                self._data_type = DataTypes.STR

    def has_children(self) -> bool:
        return len(self.children) > 0

    def has_single_child(self) -> bool:
        return len(self.children) == 1

    def num_of_children(self) -> int:
        return len(self.children)

    def has_data(self) -> bool:
        return self.data_type != DataTypes.UNKNOWN

    def is_datatype_numeric(self) -> bool:
        return self.data_type in [DataTypes.FLOAT, DataTypes.INT]

    def is_datatype_string(self) -> bool:
        return self.data_type == DataTypes.STR

    # def is_branch(self) -> bool:
    #     return len(self.children) == 1

    # def is_node(self) -> bool:
    #     return len(self.children) > 1

    # def are_all_children_leaves(self) -> bool:
    #     return all(x.is_leaf() for x in self.children)

    def has_xml_attributes(self) -> bool:
        return len(self.xml_attributes) > 0

    def make_subtable(self) -> bool:
        return self.node_type in [NodeTypes.LIST, NodeTypes.DICT]

    def is_list(self) -> bool:
        return self.node_type == NodeTypes.LIST

    def is_dict(self) -> bool:
        return self.node_type == NodeTypes.DICT
