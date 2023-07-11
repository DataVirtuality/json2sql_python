import unittest

from codelib.metadata import DataTypeWrapper, DataTypes

# See metadata.py for the most recent version of this table
# Truth table
# |Current Data Type             | New Data Type                 | Result            |
# |------------------------------|-------------------------------|-------------------|
# |same                          | same                          | no change         |
# |unknown                       | str, int, float, bool         | new value         |
# |str, int, float, bool         | unknown                       | no change         |
# |int                           | float                         | float             |
# |float                         | int                           | float             |
# |int, float                    | str                           | str               |
# |bool                          | str, int, float               | str               |


class TestMetadata_DataTypes_str(unittest.TestCase):
    def setUp(self):
        super().setUp()
        self.dtw: DataTypeWrapper = DataTypeWrapper(DataTypes.STR)

    def test_assign_unknown(self):
        self.dtw.datatype = DataTypes.UNKNOWN
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_int(self):
        self.dtw.datatype = DataTypes.INT
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_float(self):
        self.dtw.datatype = DataTypes.FLOAT
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_bool(self):
        self.dtw.datatype = DataTypes.BOOLEAN
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_str(self):
        self.dtw.datatype = DataTypes.STR
        self.assertEqual(self.dtw, DataTypes.STR)


class TestMetadata_DataTypes_unknown(unittest.TestCase):
    def setUp(self):
        super().setUp()
        self.dtw: DataTypeWrapper = DataTypeWrapper(DataTypes.UNKNOWN)

    def test_assign_unknown(self):
        self.dtw.datatype = DataTypes.UNKNOWN
        self.assertEqual(self.dtw, DataTypes.UNKNOWN)

    def test_assign_int(self):
        self.dtw.datatype = DataTypes.INT
        self.assertEqual(self.dtw, DataTypes.INT)

    def test_assign_float(self):
        self.dtw.datatype = DataTypes.FLOAT
        self.assertEqual(self.dtw, DataTypes.FLOAT)

    def test_assign_bool(self):
        self.dtw.datatype = DataTypes.BOOLEAN
        self.assertEqual(self.dtw, DataTypes.BOOLEAN)

    def test_assign_str(self):
        self.dtw.datatype = DataTypes.STR
        self.assertEqual(self.dtw, DataTypes.STR)


class TestMetadata_DataTypes_int(unittest.TestCase):
    def setUp(self):
        super().setUp()
        self.dtw: DataTypeWrapper = DataTypeWrapper(DataTypes.INT)

    def test_assign_unknown(self):
        self.dtw.datatype = DataTypes.UNKNOWN
        self.assertEqual(self.dtw, DataTypes.INT)

    def test_assign_int(self):
        self.dtw.datatype = DataTypes.INT
        self.assertEqual(self.dtw, DataTypes.INT)

    def test_assign_float(self):
        self.dtw.datatype = DataTypes.FLOAT
        self.assertEqual(self.dtw, DataTypes.FLOAT)

    def test_assign_bool(self):
        self.dtw.datatype = DataTypes.BOOLEAN
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_str(self):
        self.dtw.datatype = DataTypes.STR
        self.assertEqual(self.dtw, DataTypes.STR)


class TestMetadata_DataTypes_float(unittest.TestCase):
    def setUp(self):
        super().setUp()
        self.dtw: DataTypeWrapper = DataTypeWrapper(DataTypes.FLOAT)

    def test_assign_unknown(self):
        self.dtw.datatype = DataTypes.UNKNOWN
        self.assertEqual(self.dtw, DataTypes.FLOAT)

    def test_assign_int(self):
        self.dtw.datatype = DataTypes.INT
        self.assertEqual(self.dtw, DataTypes.FLOAT)

    def test_assign_float(self):
        self.dtw.datatype = DataTypes.FLOAT
        self.assertEqual(self.dtw, DataTypes.FLOAT)

    def test_assign_bool(self):
        self.dtw.datatype = DataTypes.BOOLEAN
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_str(self):
        self.dtw.datatype = DataTypes.STR
        self.assertEqual(self.dtw, DataTypes.STR)


class TestMetadata_DataTypes_bool(unittest.TestCase):
    def setUp(self):
        super().setUp()
        self.dtw: DataTypeWrapper = DataTypeWrapper(DataTypes.BOOLEAN)

    def test_assign_unknown(self):
        self.dtw.datatype = DataTypes.UNKNOWN
        self.assertEqual(self.dtw, DataTypes.BOOLEAN)

    def test_assign_int(self):
        self.dtw.datatype = DataTypes.INT
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_float(self):
        self.dtw.datatype = DataTypes.FLOAT
        self.assertEqual(self.dtw, DataTypes.STR)

    def test_assign_bool(self):
        self.dtw.datatype = DataTypes.BOOLEAN
        self.assertEqual(self.dtw, DataTypes.BOOLEAN)

    def test_assign_str(self):
        self.dtw.datatype = DataTypes.STR
        self.assertEqual(self.dtw, DataTypes.STR)
