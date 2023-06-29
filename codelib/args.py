import argparse


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
        "-ih", "--include_hidden", action="store_true",
        required=False, help="Include hidden json files.")
    parser.add_argument(
        "--dsname", required=False, default='Data_Source_Name',
        help="Is the name of Data Source (configured in Data Virtuality).")
    parser.add_argument(
        "--dspath", required=False, default='.',
        help="Is the file path of the XML file within the Data source.")
    parser.add_argument(
        "--force_strings", required=False, action='store_true',
        help="Is the file path of the XML file within the Data source.")
    parser.add_argument(
        "--sqlalias", required=False, default="XmlTable",
        help="Alias for the XML tables in the FROM clause. Eg left join (...) as XmlTable001")

    parser.add_argument(
        "--path_separator", required=False, default="/", choices=['/', 'linux', '\\', 'windows'],
        help="Separator to be used. Eg \\ is windows. / is Linux.")

    group_list = parser.add_mutually_exclusive_group()
    group_list.add_argument(
        '--list_as_rows', action='store_false',
        help="This is the default.")
    group_list.add_argument(
        '--list_as_array', action='store_true')

    return parser.parse_args()
