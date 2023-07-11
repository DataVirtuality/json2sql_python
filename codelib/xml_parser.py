from typing import Optional, Set
import pandas as pd
from codelib.SqlGenConfig import SqlGenConfig
from codelib.metadata import DataTypeWrapper, TreeNodeInfo, NodeTypes, DataTypes
import xml.etree.ElementTree as ET


def is_float(val: str) -> bool:
    val = val.strip()
    if len(val) == 0:
        return False
    try:
        float(val)
        return True
    except Exception:
        return False


def is_int(val: str) -> bool:
    val = val.strip()
    if len(val) == 0:
        return False
    try:
        int(val)
        return True
    except Exception:
        return False


def determine_datatype(val: Optional[str]) -> DataTypes:
    if val is None:
        return DataTypes.UNKNOWN
    val = val.strip()
    if len(val) == 0:
        return DataTypes.UNKNOWN
    if is_float(val):
        return DataTypes.FLOAT
    if is_int(val):
        return DataTypes.INT
    return DataTypes.STR


class NodeInfo:
    def __init__(self) -> None:
        self.counter: int = 0


def xml_determine_node_type(xml_node: ET.Element, tni_parent_node: Optional[TreeNodeInfo]) -> NodeTypes:
    if tni_parent_node is not None and tni_parent_node.element_name == xml_node.tag:
        # This is probably a LIST
        return NodeTypes.LIST
    return NodeTypes.DATA


def xml_determine_data_type(xml_node: ET.Element) -> DataTypes:
    dtw: DataTypeWrapper = DataTypeWrapper()
    values: Set[Optional[str]] = {
        xml_node.text.strip() if xml_node.text is not None else None,
        xml_node.tail.strip() if xml_node.tail is not None else None
    }
    for v in values:
        if v is None or len(v) == 0:
            continue
        dtw.datatype = determine_datatype(v)
    return dtw.datatype


def convert_xml_to_treenode(
        xml_node: ET.Element,
        config: SqlGenConfig,
        tni_parent_node: Optional[TreeNodeInfo]
) -> TreeNodeInfo:
    tni = TreeNodeInfo.factory(
        element_name=xml_node.tag,
        parent=tni_parent_node,
        xml_attributes=None,
        node_type=xml_determine_node_type(xml_node, tni_parent_node),
        data_type=xml_determine_data_type(xml_node),
        config=config
    )

    for child in xml_node:
        convert_xml_to_treenode(
            child,
            config,
            tni
        )

    list_tags = [node.tag for node in xml_node]
    counts = pd.Series(list_tags).value_counts()

    if tni.node_type == NodeTypes.LIST:
        # This is probably a list
        # The value has already set by xml_determine_node_type
        # nothing more to do
        pass
    elif len(counts) > 1:
        # The Node has children with different tag names
        # It's a DICT
        tni.node_type = NodeTypes.DICT
    else:
        # Search for multiple children with the same name.
        # These are probably part of a LIST
        for key, count in counts.items():
            if count > 1:
                # This is probably a LIST
                node = tni.get_via_xpath(f'{tni.xpath}{key}/')
                node.node_type = NodeTypes.LIST

    return tni


def parse_xml(xml_str: str, config: SqlGenConfig) -> TreeNodeInfo:
    root = ET.fromstring(xml_str)
    return convert_xml_to_treenode(root, config, None)


def parse_xml_file(file_name: str, config: SqlGenConfig) -> TreeNodeInfo:
    tree = ET.parse(file_name)
    root = tree. getroot()
    return convert_xml_to_treenode(root, config, None)
