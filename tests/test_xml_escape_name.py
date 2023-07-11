import unittest
from codelib.xml_escape_name import xml_escape_name


class TestXmlEscapeName(unittest.TestCase):
    def test_xml_escape_name(self):
        self.assertEqual(xml_escape_name('111:222'), "_u0031_11_u003A_222")
        self.assertEqual(xml_escape_name('@111:222'), "_u0040_111_u003A_222")
        self.assertEqual(xml_escape_name('/1/11:222'), "_u002F_1_u002F_11_u003A_222")
        self.assertEqual(xml_escape_name('\\1\\11:222'), "_u005C_1_u005C_11_u003A_222")
