from dataclasses import dataclass


@dataclass
class SqlGenConfig:
    """
    These config setting are used when generating the SQL code.
    """

    dv_datasource_name: str
    """
    Name of the datasource in DV.
    """

    dv_datasource_filepath: str
    """
    Is the file path of the XML file within the Data source.
    """

    force_data_types_to_string: bool
    """
    * True - force all data types to string.
    * False - use the calculated data type.
    """

    explode_arrays: bool
    """
    * True - The array elements will be exploded into a new row for each element. Eg. 'col1' int 'xpath'
    * False - The array will be converted into an array. Eg. 'col1' int[] 'xpath'
    """

    sql_table_alias: str
    """
    Name used in from clause of SQL query.
    """

    path_separator: str
    """
    Name of the JSON or XML to parse.
    """

    json_xml_file_to_parse: str = 'generic_name.json'
    """
    Name of the JSON or XML to parse.
    """
