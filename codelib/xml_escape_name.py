import re
from typing import Dict, List


# XML element name - valid characters
# https://www.w3.org/TR/xml/#charsets
#
# NameStartChar	   ::=   	":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D]
#                           | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF]
#                           | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
# NameChar	   ::=   	NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
# Name	   ::=   	NameStartChar (NameChar)*
# regexNameStartChar = re.compile(
#     r'[:A-Za-z_\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\U00010000-\U000EFFFF]',
#     re.NOFLAG)
# regexNameChar = re.compile(r'[-.0-9\u00B7\u0300-\u036F\u203F-\u2040]', re.NOFLAG)


# DV XMLESCAPENAME - valid characters
# NameStartChar	   ::=   	[A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D]
#                           | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF]
#                           | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
# NameChar	   ::=   	NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
# Name	   ::=   	NameStartChar (NameChar)*
regexNameStartChar = re.compile(
    r'[A-Za-z_\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\U00010000-\U000EFFFF]',
    re.NOFLAG)
regexNameChar = re.compile(r'[-.0-9A-Za-z_\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\U00010000-\U000EFFFF\u00B7\u0300-\u036F\u203F-\u2040]', re.NOFLAG)


lookup_proper_xml_name: Dict[str, str] = {}
"""
optimization to speed up escaping of the XML name
"""


def is_name_start_char(c: str) -> bool:
    assert len(c) == 1
    return regexNameStartChar.match(c) is not None


def is_name_char(c: str) -> bool:
    assert len(c) == 1
    return regexNameChar.match(c) is not None


def xml_escape_name(name: str) -> str:
    """
    Mimic the DV function XmlEscapeName

    Note: The DV XML method XmlEscapeName doesn't follow the official W3 XML format.

    Examples:
        select XMLESCAPENAME(':X/', true) as col1;; -> _u003A_X_u002F_

    Args:
        name (str): Return the name with the characters escaped.

    Returns:
        str: escaped name
    """
    if len(name) == 0:
        return ''

    if name in lookup_proper_xml_name:
        return lookup_proper_xml_name[name]

    name_as_list: List[str] = list(name)
    for i, ch in enumerate(name):
        if i == 0:
            if is_name_start_char(ch) is False:
                if ord(ch) <= 0x0000FFFF:
                    name_as_list[i] = f'_u{ord(ch):04X}_'
                else:
                    name_as_list[i] = f'_u{ord(ch):08X}_'
        else:
            if is_name_char(ch) is False:
                if ord(ch) <= 0x0000FFFF:
                    name_as_list[i] = f'_u{ord(ch):04X}_'
                else:
                    name_as_list[i] = f'_u{ord(ch):08X}_'

    return ''.join(name_as_list)


# if __name__ == "__main__":
#     print('\u00C0')
#     m = regexNameStartChar.match(':')
#     m = regexNameStartChar.match('_')
#     m = regexNameStartChar.match('\u00C0')
#     m = regexNameStartChar.match('\u00D6')
#     m = regexNameStartChar.match('\u00D7')
#     m = regexNameStartChar.match('\u00D8')

#     print()
