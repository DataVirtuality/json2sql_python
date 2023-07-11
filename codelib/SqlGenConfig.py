from dataclasses import dataclass
from typing import Optional


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

    dv_path_separator: str
    """
    Separator used building the file path in Data Virtuality SQL.
    """

    file_amalgamation: bool
    """
    False: The format of each file processed is unique.
    True: All of the files share the same format. The final format is an
        amalgamation of all the individual file formats.
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

    col_name_regex_ignore_case: bool
    """
    The regex statement is applied after the other column names modifiers. \n
    Must be a valid Python regex expression. \n
    See https://docs.python.org/3/library/re.html
    """

    col_name_path_separator: str
    """
    Specify the path separator used for the column names. \n
        Eg if separator=. then /root/root/col1/ -> .root.root.col1. \n
        Eg if separator=- then /root/root/col1/ -> -root-root-col1- \n
        Eg if separator=| then /root/root/col1/ -> |root|root|col1|
    """

    col_name_replace_prefix: Optional[str] = None
    """
    Replace the leading slash from the column name with the specified string. \n
        Eg prefix='' /root/root/col1/ -> root/root/col1/  \n
        Eg prefix='[' /root/root/col1/ -> [root/root/col1/
    """

    col_name_replace_suffix: Optional[str] = None
    """
    Replace the trailing slash from the column name. \n
    The last character Will not be removed if it is not a '/'.
        Eg suffix='' /root/root/col1/ -> /root/root/col1 \n
        Eg suffix=']' /root/root/col1/ -> /root/root/col1] \n
        NO change if last character is not a / \n
        Eg suffix=']' /root/root/col1/@type -> /root/root/col1/@type
    """

    col_name_replace_root: Optional[str] = None
    """
    Replace the leading '/root from the the column name. \n
        Eg replace_rootroot='' /root/col1/ -> /col1/ \n
        Eg replace_rootroot='' /root/root/col1/ -> /col1/ \n
        Eg replace_rootroot='srcName' /root/col1/ -> srcName/col1/ \n
        Eg replace_rootroot='srcName' /root/root/col1/ -> srcName/col1/
    """

    col_name_regex: Optional[str] = None
    """
    The regex statement is applied after the other column names modifiers. \n
    Must be a valid Python regex expression. \n
    See https://docs.python.org/3/library/re.html
    """

    col_name_regex_replacement: str = ''
    """
    The substitution text used in the regex replacement.
    """

    json_xml_file_to_parse: str = 'generic_name.json'
    """
    Name of the JSON or XML to parse.
    """
