import argparse
from typing import Optional


def none_or_str(value: Optional[str]) -> Optional[str]:
    if value is None or value.lower() == 'none':
        return None
    return value


def windows_or_linux(value: str) -> str:
    match value.lower():
        case '/' | 'linux':
            return '/'
        case '\\' | 'windows':
            return '\\'
        case _:
            # default to linux
            return '/'


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--stdio", action="store_true",
        help="Read json from STDIN.")

    parser.add_argument(
        "-f", "--files", default='*.json', required=False,
        help="Read json files. Supports wildcards. Case insensitive search.")

    parser.add_argument(
        "-r", "--recurse", action="store_true", required=False,
        help="Recursively search subfolders for json files.")

    parser.add_argument(
        "--file_amalgamation", action="store_true", required=False,
        help="Recursively search subfolders for json files.")

    parser.add_argument(
        "-ih", "--include_hidden", action="store_true",
        required=False, help="Include hidden json files.")

    parser.add_argument(
        "--dsname", required=False, default='Data_Source_Name',
        help="Is the name of Data Source (configured in Data Virtuality).")

    parser.add_argument(
        "--dspath", required=False, default='.',
        help="Is the file path of the XML file within the Data source.")

    parser.add_argument(
        "--ds_path_separator", required=False, type=windows_or_linux, default="/", choices=['/', 'linux', '\\', 'windows'],
        help="Separator to be used by Data Virtuality when creating data source path. Eg '\\' is windows. '/' is Linux.")

    parser.add_argument(
        "--force_strings", required=False, action='store_true',
        help="Is the file path of the XML file within the Data source.")

    parser.add_argument(
        "--sqlalias", required=False, default="XmlTable",
        help="Alias for the XML tables in the FROM clause. Eg left join (...) as XmlTable001")

    parser.add_argument(
        "--col_name_replace_prefix", type=none_or_str, nargs='?', default=None,
        help=(
            "Replace the leading slash from the column name with the specified string.\n"
            "\tEg prefix='' /root/root/col1/ -> root/root/col1/\n"
            "\tEg prefix='[' /root/root/col1/ -> [root/root/col1/"
        ))

    parser.add_argument(
        "--col_name_replace_suffix", type=none_or_str, nargs='?', default=None,
        help=(
            "Replace the trailing slash from the column name.\n"
            "The last character Will not be removed if it is not a '/'.\n"
            "\tEg suffix='' /root/root/col1/ -> /root/root/col1 \n"
            "\tEg suffix=']' /root/root/col1/ -> /root/root/col1] \n"
            "NO change if last character is not a / \n"
            "Eg suffix=']' /root/root/col1/@type -> /root/root/col1/@type"
        ))

    parser.add_argument(
        "--col_name_replace_root", type=none_or_str, nargs='?', default=None,
        help=(
            "Replace the leading '/root from the the column name. \n"
            "\tEg replace_rootroot='' /root/col1/ -> /col1/ \n"
            "\tEg replace_rootroot='' /root/root/col1/ -> /col1/ \n"
            "\tEg replace_rootroot='srcName' /root/col1/ -> srcName/col1/ \n"
            "\tEg replace_rootroot='srcName' /root/root/col1/ -> srcName/col1/"
        ))

    parser.add_argument(
        "--col_name_path_separator", required=False, default='/',
        help=(
            "Specify the path separator used for the column names.\n"
            "\tEg if separator=. then /root/root/col1/ -> .root.root.col1.\n"
            "\tEg if separator=- then /root/root/col1/ -> -root-root-col1-"
        ))

    parser.add_argument(
        "--col_name_regex", type=none_or_str, nargs='?', default=None,
        help=(
            "The regex statement is applied after the other column names modifiers. \n"
            "Must be a valid Python regex expression. \n"
            "See https://docs.python.org/3/library/re.html"
        ))

    parser.add_argument(
        "--col_name_regex_ignore_case", required=False, action='store_true',
        help=(
            "If specified regex statement will ignore case. \n"
            "The default is case sensitive. \n"
        ))

    parser.add_argument(
        "--col_name_regex_replacement", required=False, default='',
        help=(
            "The substitution text used in the regex replacement. The default is an empty string."
        ))

    group_list = parser.add_mutually_exclusive_group()
    group_list.add_argument(
        '--list_as_rows', action='store_false',
        help="This is the default.")
    group_list.add_argument(
        '--list_as_array', action='store_true')

    return parser.parse_args()
