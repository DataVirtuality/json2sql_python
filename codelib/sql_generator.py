from typing import Final, List, Optional
import re
from codelib.SqlGenConfig import SqlGenConfig
from codelib.metadata import DataTypes, TreeNodeInfo
# import copy
# from enum import Enum
# import pandas as pd
# from gen_csv_files import gen_csv_files
# from codelib.args import parse_args


def remove_last_char_from_str(s: str) -> str:
    return s[:-1]


def substract_string(prefix: str, target: str) -> str:
    if target.startswith(prefix) is False:
        print(f'substract_string prefix:[{prefix}] not in target:[{target}]')
        # assert target.startswith(prefix) is True
        return target
    return target[len(prefix):]


class SqlGenerator:
    _regex_root = re.compile(pattern=r"^(/root)+", flags=re.MULTILINE | re.IGNORECASE)
    """
    Regex expression used to replace the leading '/root' text of the column name
    """

    _regex_validate_col_name = re.compile(pattern=r"/@[\w_]+$", flags=re.IGNORECASE)
    """
    Regex expression used to verify the column name ends with '@type' \n
    For example  /../../@type
    """

    _regex_path_separator = re.compile(pattern=r"/", flags=re.NOFLAG)
    """
    Regex expression used to replace path separattor '/'
    """

    def __init__(self, treenodeinfo: TreeNodeInfo, config: SqlGenConfig) -> None:
        self.alias_num: int = 0
        """
        Counter to keep track of the table number
        """

        self.treenodeinfo: TreeNodeInfo = treenodeinfo
        """
        Holds the metadata
        """

        self.sql_select: List[str] = []
        """
        Holds the lines in the SQL SELECT portion of the clause.
        """

        self.sql_from: List[str] = []
        """
        Holds the lines in the SQL FROM portion of the clause.
        """

        self.sql_final_result: str = ''
        """
        Holds the generated SQL. This is the final result.
        """

        self.config = config
        """
        Class holding the configuration data
        """

        self.col_name_regex_compiled: Optional[re.Pattern[str]] = None
        """
        The regex statement is applied after the other column names modifiers. \n
        Must be a valid Python regex expression. \n
        See https://docs.python.org/3/library/re.html
        """

    def mod_col_name(self, col_name: str) -> str:
        """
        Modify column name based on the configuration parameters.

        Args:
            col_name (str): Original column name

        Returns:
            str: Modified column name
        """

        # Make a backup copy of the original name in case the modifications
        # result in an empty string
        original_col_name = col_name

        assert len(col_name) > 3  # minimum string length is 3. Eg. /a/
        assert col_name[0] == '/'
        # Ensure the col name ends with '/' or ends with '/@text'
        assert col_name[-1] == '/' or self._regex_validate_col_name.search(col_name) is not None

        if self.config.col_name_replace_root is not None:
            col_name = SqlGenerator._regex_root.sub(self.config.col_name_replace_root, col_name)

        if self.config.col_name_replace_prefix is not None:
            col_name = self.config.col_name_replace_prefix + col_name[1:]

        if self.config.col_name_replace_suffix is not None:
            col_name = col_name[:-1] + self.config.col_name_replace_suffix

        if self.col_name_regex_compiled is None and self.config.col_name_regex is not None:
            self.col_name_regex_compiled = re.compile(
                self.config.col_name_regex,
                re.IGNORECASE if self.config.col_name_regex_ignore_case else re.NOFLAG
            )

        if self.col_name_regex_compiled is not None:
            col_name = self.col_name_regex_compiled.sub(self.config.col_name_regex_replacement, col_name)

        col_name = col_name.strip()

        # If the length results in and empty string, use the original name as part of an error msg
        if len(col_name) == 0:
            col_name = f'ERROR__{original_col_name}__col_mods_resulted_in_empty_str'

        return col_name

    def helper_top_down(
            self,
            tni: TreeNodeInfo,
            relative_xpath: str,
            sql_parent_table: str,
            sql_parent_xml_column: str,
            sql_parent_unescaped_xml_column: str,
            parent_table_number: int
    ) -> None:
        """
        This method generates the LEFT LATERAL JOIN

        Args:
            tni (TreeNodeInfo): The current node we will be generating a LEFT LATERAL JOIN for.
            relative_xpath (str): The path of this tni NODE.
            sql_parent_table (str): Name of the SQL parent table.
            sql_parent_xml_column (str): The name of the SQL column name with XML data
            parent_table_number (int): The number of the parent table.
        """
        current_table_number: Final[int] = self.alias_num
        current_sql_table_name: Final[str] = f'{self.config.sql_table_alias}{self.alias_num:03}'

        if tni.has_single_child() is True and tni.has_data() is False:
            # branch: has a single child
            # Don't generate a LEFT JOIN LATERL for this node. It would have no purpose.
            # Just skip it.
            self.helper_top_down(
                tni=tni.children[0],
                relative_xpath=relative_xpath,
                sql_parent_table=sql_parent_table,
                sql_parent_xml_column=sql_parent_xml_column,
                sql_parent_unescaped_xml_column=sql_parent_unescaped_xml_column,
                parent_table_number=parent_table_number
            )
            return

        # Get the relative path of the current node minus the parent xpath
        xpath_from_wrapper = remove_last_char_from_str(substract_string(relative_xpath, tni.xpath))
        xpath_relative_to_wrapper = xpath_from_wrapper.count('/') + 1  # Used to determine the number of ../ to use
        x_path_move_back = '../' * xpath_relative_to_wrapper

        # Add these columns in the SELECT clause. Useful for debugging.
        self.sql_select.append(f'    -- "{current_sql_table_name}"."idColumn_{current_table_number:03}",')
        self.sql_select.append(f'    -- "{current_sql_table_name}"."dv_xml_wrapper_parent_id",')
        self.sql_select.append(f'    -- "{current_sql_table_name}"."dv_xml_wrapper_id_{current_table_number:03}",')

        # Build the LEFT JOIN LATERAL clause
        self.sql_from.append('left join lateral(')
        self.sql_from.append('   select')
        self.sql_from.append(f'       uuid() as "dv_xml_wrapper_id_{current_table_number:03}",')
        self.sql_from.append('       xt.*')
        self.sql_from.append('   from')
        self.sql_from.append('       XMLTABLE(')
        self.sql_from.append(f"           XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as \"xsi\" ), '/DV_default_xml_wrapper/{xpath_from_wrapper}' PASSING ")
        self.sql_from.append('               XMLELEMENT(NAME "DV_default_xml_wrapper",')
        self.sql_from.append("                   XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as \"xsi\" ),")
        self.sql_from.append(f'                   XMLATTRIBUTES("{sql_parent_table}"."dv_xml_wrapper_id_{parent_table_number:03}" AS "dv_xml_wrapper_parent_id"),')
        self.sql_from.append(f'                    "{sql_parent_table}"."{sql_parent_unescaped_xml_column}"')
        self.sql_from.append('               )')
        self.sql_from.append('		    COLUMNS')
        self.sql_from.append(f'               "idColumn_{current_table_number:03}" FOR ORDINALITY,')
        self.sql_from.append(f"               \"dv_xml_wrapper_parent_id\" string path '{x_path_move_back}@dv_xml_wrapper_parent_id',")

        xml_tables: List[TreeNodeInfo] = []  # List of columns that need to be turned into a LEFT JOIN LATERAL
        if tni.has_data():
            self.sql_select.append(f'    "{current_sql_table_name}"."{self.mod_col_name(tni.unescaped_xpath)}",')

            # The LIST and non-LIST code is very similar. Could be folded into a single code path. Separate it to
            # make it easier to maintain.
            # Edge case: If the xpath_from_wrapper includes the current element name, we need to use '.'
            if tni.is_node_list() or tni.is_node_data():
                # Treat LISTS differently. Use the '.' to get the data
                self.sql_from.append(f"               \"{self.mod_col_name(tni.unescaped_xpath)}\" {self.get_sql_datatype(tni)} PATH '.',")

                # If this is numeric then DV includes the data type when it converts it to XML.
                if tni.is_datatype_numeric():
                    self.sql_select.append(f'    -- "{current_sql_table_name}"."{self.mod_col_name(f"{tni.unescaped_xpath}@type")}",')
                    self.sql_from.append(f"               \"{self.mod_col_name(f'{tni.unescaped_xpath}@type')}\" STRING PATH './@xsi:type',")
            # else:
            #     # Use the element name to get the data
            #     self.sql_from.append(f"               \"{self.mod_col_name(tni.unescaped_xpath)}\" {self.get_sql_datatype(tni)} PATH '{tni.element_name}',")

            #     # If this is numeric then DV includes the data type when it converts it to XML.
            #     if tni.is_datatype_numeric():
            #         self.sql_select.append(f'    -- "{current_sql_table_name}"."{self.mod_col_name(f"{tni.unescaped_xpath}@type")}",')
            #         self.sql_from.append(f"               \"{self.mod_col_name(f'{tni.unescaped_xpath}@type')}\" STRING PATH '{tni.element_name}/@xsi:type',")

        # Process any children this node has
        for child in tni.children:
            if child.make_subtable():
                # This column will be an XML data type and be be a new sub-query
                self.sql_select.append(f'    -- "{current_sql_table_name}"."{self.mod_col_name(child.unescaped_xpath)}",')
                self.sql_from.append(f'               "{self.mod_col_name(child.unescaped_xpath)}" xml PATH \'{child.element_name}\',')
                xml_tables.append(child)  # We will need to recursively process this later.
            else:
                # Just process this child as a simple column
                if child.is_datatype_numeric():
                    self.sql_select.append(f'    -- "{current_sql_table_name}"."{self.mod_col_name(f"{child.unescaped_xpath}@type")}",')
                    self.sql_from.append(f"               \"{self.mod_col_name(f'{child.unescaped_xpath}@type')}\" STRING PATH '{child.element_name}/@xsi:type',")

                self.sql_select.append(f'    "{current_sql_table_name}"."{self.mod_col_name(child.unescaped_xpath)}",')
                self.sql_from.append(f'               "{self.mod_col_name(child.unescaped_xpath)}" {self.get_sql_datatype(child)} PATH \'{child.element_name}\',')

        # Remove comma from last entry
        self.sql_from[-1] = remove_last_char_from_str(self.sql_from[-1])

        # Close the LEFT JOIN LATERAL
        self.sql_from.append('        ) xt')
        self.sql_from.append(f') "{current_sql_table_name}"')
        self.sql_from.append(f'    on "{sql_parent_table}"."dv_xml_wrapper_id_{parent_table_number:03}" = "{current_sql_table_name}"."dv_xml_wrapper_parent_id"')
        self.alias_num += 1

        for child in xml_tables:
            # Recursively process columns marked as XML
            self.helper_top_down(
                tni=child,
                relative_xpath=tni.xpath,
                sql_parent_table=f'{current_sql_table_name}',
                sql_parent_xml_column=child.xpath,
                sql_parent_unescaped_xml_column=child.unescaped_xpath,
                parent_table_number=current_table_number
            )

    def top_down_sql_generation(self) -> None:
        """
        This method generates the initial part of the DV SQL.
        This also generates the CTE (Common Table Expression)

        The algorithm uses two Lists of strings.
        The 1st list is for the SELECT clauses
        The 2nd list is for the FROM clauses
        """
        self.alias_num = 1  # Reset the alias number in case we want to run the algorithm more than once.
        current_sql_table: Final[str] = f'{self.config.sql_table_alias}{self.alias_num:03}'
        current_table_number: Final[int] = self.alias_num

        # Create the SELECT clauses
        self.sql_select.append(f'with "{current_sql_table}" as (')
        self.sql_select.append("    SELECT")
        self.sql_select.append(f"        uuid() as dv_xml_wrapper_id_{current_table_number:03},")
        self.sql_select.append("        JSONTOXML('root', to_chars(f.file,'UTF-8')) as xmldata")
        self.sql_select.append("    FROM")
        self.sql_select.append(f'        "{self.config.dv_datasource_name}".getFiles(\'{self.config.dv_datasource_filepath}{self.config.col_name_path_separator}{self.config.json_xml_file_to_parse}\') f')
        self.sql_select.append(")")
        self.sql_select.append("select")
        self.sql_select.append(f'    --"{current_sql_table}"."dv_xml_wrapper_id_{current_table_number:03}",')

        # Create the FROM clauses
        self.sql_from.append(f'from "{current_sql_table}"')

        # Now recurse through the rest of the tree
        self.alias_num += 1
        self.helper_top_down(
            tni=self.treenodeinfo,
            relative_xpath='/',
            sql_parent_table=f'{current_sql_table}',
            sql_parent_xml_column='xmldata',  # column name defined in the CTE (Common Table Expression) block
            sql_parent_unescaped_xml_column='xmldata',  # column name defined in the CTE (Common Table Expression) block
            parent_table_number=current_table_number
        )

        # Remove comma from last uncommented SQL column
        self.remove_comma_from_last_uncommented_column()

        # Join the SELECT and FROM clauses. NOTE: we will need a line break between the SELECT and FROM clauses
        self.sql_final_result = '\n'.join(self.sql_select) + '\n' + '\n'.join(self.sql_from)

    def remove_comma_from_last_uncommented_column(self) -> None:
        """
        Find the last uncommented column and remove the trailing ','

        Example:
            Select
                -- col1,
                -- col2,
                col3,     <- remove this comma
                -- col4
        """

        # Remove comma from last entry
        # Traverse the list in reverse order maintaing the original index
        for idx, sql_col in reversed(list(enumerate(self.sql_select))):
            if sql_col.startswith('    -- ') is True:
                # This column is commented out. Keep looking
                continue

            if sql_col == 'select':
                # All of the columns are commented out
                # Strange situation.
                # To make this valid SQL, add a dummy column
                self.sql_select.append('    "DummyColumn" as DummyColumn')
                return

            # This is the last uncommented SQL column. Remove the trailing ','
            self.sql_select[idx] = remove_last_char_from_str(self.sql_select[idx])
            return

    def generate_dv_sql(self) -> str:
        """
        Generate the DV SQL statements.

        This method will only generate the DV SQL once. And cache the DV SQL as a list of strings
        and as a single string.

        Returns:
            str: Returns the DV SQL as a single string.
        """
        if len(self.sql_final_result) == 0:
            # generate the SQL code
            self.top_down_sql_generation()
        return self.sql_final_result

    def get_sql_datatype(self, tni: TreeNodeInfo) -> str:
        """
        Determine the DV datatype we will be using.

        Args:
            tni (TreeNodeInfo): The node we will be calculating a datatype for

        Returns:
            str: String name of the DV datatype
        """
        if self.config.force_data_types_to_string:
            return DataTypes.STR.value
        else:
            if tni.datatype == DataTypes.UNKNOWN:
                # Force the datatype to string
                # this happens when we have NULL or empty values
                return DataTypes.STR.value
            else:
                return tni.datatype.value
