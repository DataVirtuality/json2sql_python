import argparse
import os.path
# import getopt
# import xml.dom.minidom
# import xml.etree.ElementTree as ET
import os
import re
# import sys
from typing import Dict
# import xml.etree.ElementTree as ET
# from xml.dom.minidom import parse, parseString
from lxml import etree


def normalize_xpath(path):
    return re.sub(r'\[\d+\]', '', path)


def relpath(leaf, path):
    # @c Calculates the relative path from the $leaf path to the desired $path
    res = ""
    diff = re.sub(f"{leaf}.*=", "", path)
    for el in diff.split("/"):
        if el == "/":
            continue
        res = os.path.join(res, "..")
    return res


def query_from_xml_att(node, leaf_path):
    # @c Creates a 'COLUMNS' line for each node attribute
    # @a node: XML node object
    # @a leafPath: XPath to the leaf node in relation to which to calculate paths
    xpath = normalize_xpath(node.getroottree().getpath(node))
    result = ""
    for att in node.attrib:
        name = f"{xpath}/{att}"
        relpath_ = relpath(leaf_path, xpath)
        path = f"'{os.path.join(relpath_, '@' + att)}'"
        result += f'"{name}" STRING PATH {path},\n'
    return result


def query_from_xml_text(node, leaf_path):
    # @c Creates a 'COLUMNS' line for node's text value, if any
    # @a node: XML node object
    # @a leafPath: XPath to the leaf node in relation to which to calculate paths
    xpath = normalize_xpath(node.getroottree().getpath(node))
    text = node.text
    if text:
        name = f"{xpath}/text"
        relpath_ = relpath(leaf_path, xpath)
        path = f"'{os.path.join(relpath_, 'text()')}'"
        return f'"{name}" STRING PATH {path},\n'


def getparts(node) -> Dict:
    #
    # For Leaf nodes, simply return 'COLUMNS' section and the xpath
    #
    assert not isinstance(node, list) or (
        isinstance(node, list) and len(node) == 1)
    node = node[0]
    xpath = normalize_xpath(node.getroottree().getpath(node))
    if not node.getchildren():
        leaf_path = xpath
        my_query = query_from_xml_att(node, leaf_path)
        return {leaf_path: my_query}

    #
    # For parent nodes, recurse into children
    #
    parts = {}
    for child in node.getchildren():
        #
        # expect to possibly receive more than 1 result pair!
        #
        cparts = getparts(child)
        for cpath, cquery in cparts.items():
            if not parts:
                parts[cpath] = cquery
            elif cpath in parts:
                continue
            else:
                found = False
                for path in parts:
                    if cpath.startswith(path):
                        #
                        # current path is a substring of child path
                        # --> child node is nested deeper and is a better leaf
                        #
                        parts[cpath] = cquery
                        parts.pop(path)
                        found = True
                if not found:
                    parts[cpath] = cquery

    #
    # Add own attributes to each branch
    #
    for path in list(parts.keys()):
        parts[path] += query_from_xml_att(node, path)
        parts[path] += query_from_xml_text(node, path)
    return parts


def buildQuery(qparts, dsource, fpath):
    sql = ""
    count = 1
    tables = []
    firstLine = "SELECT "

    sql += "FROM\n"
    sql += "(SELECT XMLPARSE(DOCUMENT f.file) as xmldata FROM "
    sql += f"\"{dsource}\".getFiles('{fpath}') f) as data,\n"

    first = True
    for leafPath in qparts:
        mytable = f"table{count}"
        tables.append(mytable)
        firstLine += f"{mytable}.*, "

        if not first:
            sql += ","

        sql += f"XMLTABLE('{leafPath}' PASSING data.xmldata\n"
        sql += f"COLUMNS\n\"idColumn_{count}\" FOR ORDINALITY, \n"
        sql += f"{qparts[leafPath]}\n"

        sql = sql.rstrip(",\n")
        sql += f"\n) \"{mytable}\"\n"

        first = False
        count += 1

    firstLine = firstLine.rstrip(", ")
    sql = f"{firstLine}\n{sql}\n;;"
    return sql


def jsonChildren(node):
    # Select all proper children nodes =>
    # do not have '@' in their name || name = objectcontainer
    return node.selectNodes('*[not(contains(name(),"@") or contains(name(),"objectcontainer"))]')


def queryFromJsonAtt(node, leafPath):
    xpath = normalize_xpath(node.toXPath())
    result = ""
    for attNode in jsonAttributes(node):
        name = attNode.nodeName()
        name = name.lstrip('@')
        rel_path = relpath(leafPath, xpath)
        path = "'[file join {} _u0040_{} text()]'".format(rel_path, name)
        result += "\"[file join root {} {}]\" STRING PATH {},\n".format(
            xpath, name, path)
    return result


def jsonAttributes(node):
    # Select all children nodes that have '@' in their name
    atts = node.selectNodes("*[contains(name(), '@')]")
    atts.extend(node.selectNodes(
        "objectcontainer[1]/*[contains(name(), '@')]"))
    return atts


# def queryFromJsonAtt(node, leafPath):
#     xpath = node.toXPath().normalize()
#     result = ""
#     for attNode in jsonAttributes(node):
#         name = attNode.nodeName()
#         name = name.lstrip('@')
#         relpath = xpath.relpath(leafPath)
#         path = "'[file join " + relpath + " _u0040_" + name + " text()]'"
#         result += "\"[file join 'root' " + xpath + " " + \
#             name + "]\" STRING PATH " + path + ",\n"
#     return result


def queryFromXmlText(node, leafPath):
    xpath = normalize_xpath(node.toXPath())
    text = node.text
    if text != "":
        name = f"{xpath}/text"
        rel_path = relpath(leafPath, xpath)
        path = f"'[os.path.join({rel_path}, text())]'"
        return f'"{name}" STRING PATH {path},\n'


def getpartsJson(node):
    xpath = node.toXPath().normalize()
    children = jsonChildren(node)
    if not children:
        leafPath = xpath
        myQuery = queryFromJsonAtt(node, leafPath)
        return [(os.path.join('root', leafPath), myQuery)]
    parts = {}
    for child in children:
        cparts = getpartsJson(child)
        for (cpath, cquery) in cparts:
            if not parts:
                parts[cpath] = cquery
            elif cpath in parts:
                continue
            else:
                found = False
                for path in parts:
                    if cpath.startswith(path):
                        parts[cpath] = cquery
                        del parts[path]
                        found = True
                if not found:
                    parts[cpath] = cquery
    for path in parts:
        parts[path] += queryFromJsonAtt(node, path)
        # queryFromXmlText works also for Json nodes that don't have @ in the name
        parts[path] += queryFromXmlText(node, path)
    return list(parts.items())


def buildQueryJson(qparts, dsource, fpath):
    sql = ""
    count = 1
    tables = []
    firstLine = "SELECT "

    sql += "FROM\n"
    sql += "(SELECT JSONTOXML('root',to_chars(f.file,'UTF-8')) as xmldata FROM \"" + \
        dsource + "\".getFiles('" + fpath + "') f) as data,\n"

    first = True
    for leafPath in qparts.keys():
        mytable = "table" + str(count)
        tables.append(mytable)
        firstLine += mytable + ".*, "

        if not first:
            sql += ","
        sql += "XMLTABLE(XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as \"xsi\"),'root" + leafPath + "'\n"
        sql += "PASSING data.xmldata\n"
        sql += "COLUMNS\n\"idColumn_" + str(count) + "\" FOR ORDINALITY, \n"

        sql += qparts[leafPath]

        sql = sql.rstrip(",\n")
        sql += "\n) \"" + mytable + "\"\n"

        first = False
        count += 1
    firstLine = firstLine.rstrip(", ")
    sql = firstLine + "\n" + sql + "\n;;"
    return sql


parser = argparse.ArgumentParser()

parser.add_argument("-dsname", help="data source name")
parser.add_argument("-dspath",
                    help="file path within data source")
parser.add_argument("-infile",
                    help="input file path")
parser.add_argument("-outfile", help="output file path")
parser.add_argument("-root",
                    help="XPath to the root node")

args = parser.parse_args()


def parseargs():
    return args.dsname, args.dspath, args.infile, args.outfile, args.root


# def getparts(node):
#     parts = []
#     for child in node.childNodes:
#         if child.nodeType == xml.dom.Node.ELEMENT_NODE:
#             parts.append(getparts(child))
#         elif child.nodeType == xml.dom.Node.TEXT_NODE:
#             parts.append(child.nodeValue.strip())
#     return parts


# def buildQuery(parts, dsname, dspath):
#     query = f"SELECT * FROM XMLTABLE('/"
#     for part in parts:
#         if isinstance(part, list):
#             query += f"{part[0]}/"
#             query += buildQuery(part[1:], dsname, dspath)
#         else:
#             query += part
#     query += f"' PASSING (SELECT XMLTYPE(bfilename('{dsname}', '{dspath}'), 0) FROM dual))"
#     return query


def xml2sql():
    dsname, dspath, infile, outfile, root = parseargs()

    doc = etree.parse(infile)
    if not root:
        root = doc.documentElement
    else:
        try:
            root = doc.xpath(root)
        except IndexError:
            return f"Error selecting the root node: {root}"

    parts = getparts(root)
    sql = buildQuery(parts, dsname, dspath)

    with open(outfile, "w") as fp:
        fp.write(sql)


def json2sql():
    """
    Creates a SQL query to select all data from the given XML using XMLTABLE command

    -dsname: Data source name in Data Virtuality. This is used as-is to create the FROM part
    -dspath: File path of the JSON file within DV. Used as-is to create the FROM clause.
    -infile: Actual path to the JSON file used as input to create the SQL statement.
    -outfile: [Optional] output file. Defaults to "out.sql" in the current folder.
    -root: [Optional] XPath to the JSON node to be used as the document root.
    """
    dsname, dspath, infile, outfile, root = parseargs()

    doc = etree.parse(infile)
    if not root:
        root = doc
    else:
        try:
            root = doc.getElementsByTagName(root)
        except Exception:
            return "Error selecting the root node: " + root

    parts = getpartsJson(root)
    sql = buildQueryJson(parts, dsname, dspath)

    with open(outfile, "w") as fp:
        fp.write(sql)


xml2sql()
