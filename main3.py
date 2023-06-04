# type: ignore
import os
import re
# import xml.etree.ElementTree as ET


def normalize_xpath(path):
    return re.sub(r'\[\d+\]', '', path)


def relpath(leaf, path):
    # Calculates the relative path from the leaf path to the desired path
    res = ""
    diff = re.sub(f'{leaf}=***{path}', '', leaf)
    for el in os.path.split(diff):
        if el == '/':
            continue
        res = os.path.join(res, '..')
    return res


def query_from_xml_att(node, leaf_path):
    # Creates a 'COLUMNS' line for each node attribute
    xpath = normalize_xpath(node.getroottree().getpath(node))
    result = ""
    for att, value in node.attrib.items():
        name = f"{xpath}/{att}"
        relpath_ = relpath(leaf_path, xpath)
        path = f"'{os.path.join(relpath_, f'@{att}')}'"
        result += f'"{name}" STRING PATH {path},\n'
    return result


def query_from_xml_text(node, leaf_path):
    # Creates a 'COLUMNS' line for node's text value, if any
    xpath = normalize_xpath(node.getroottree().getpath(node))
    text = node.text
    if text:
        name = f"{xpath}/text()"
        relpath_ = relpath(leaf_path, xpath)
        path = f"'{os.path.join(relpath_, 'text()')}'"
        return f'"{name}" STRING PATH {path},\n'


def get_parts(node):
    """
    For Leaf nodes, simply return 'COLUMNS' section and the xpath.
    For parent nodes, recurse into children.
    """
    xpath = normalize_xpath(node.getroottree().getpath(node))
    if not node:
        return
    if not list(node):
        leaf_path = xpath
        my_query = query_from_xml_att(node, leaf_path)
        return leaf_path, my_query
    parts = {}
    for child in node:
        # expect to possibly receive more than 1 result pair!
        cpath, cquery = get_parts(child)
        if cpath not in parts:
            parts[cpath] = cquery
        else:
            found = False
            for path in parts.keys():
                if path.startswith(cpath):
                    # current path is a substring of child path
                    # child node is nested deeper and is a better leaf
                    parts[cpath] = cquery
                    del parts[path]
                    found = True
            if not found:
                parts[cpath] = cquery
    for path in parts.keys():
        parts[path] += query_from_xml_att(node, path)
        parts[path] += query_from_xml_text(node, path) or ''
    return parts


def build_query(qparts, dsource, fpath):
    sql = ""
    count = 1
    tables = []
    first_line = "SELECT "
    sql += "FROM\n"
    sql += f"(SELECT XMLPARSE(DOCUMENT f.file) as xmldata FROM \"{dsource}\".getFiles('{fpath}') f) as data,\n"
    first = True
    for leaf_path in qparts.keys():
        mytable = f"table{count}"
        tables.append(mytable)
        first_line += f"{mytable}.*, "
        if not first:
            sql += ","
        sql += f"XMLTABLE('{leaf_path}' PASSING data.xmldata\n"
        sql += "COLUMNS\n\"idColumn_{count}\" FOR ORDINALITY"
