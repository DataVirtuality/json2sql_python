import argparse


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument("-sio", "--stdio", action="store_true",
                        help="Read json from STDIN.")
    parser.add_argument("-f", "--files", default='*.json', required=False,
                        help="Read json files. Supports wildcards. Case insensitive search.")
    parser.add_argument("-r", "--recurse", action="store_true", required=False,
                        help="Recursively search subfolders for json files.")
    parser.add_argument("-ih", "--include_hidden", action="store_true",
                        required=False, help="Include hidden json files.")
    parser.add_argument("--dsname", required=False, default='Data_Source_Name',
                        help="Is the name of Data Source (configured in Data Virtuality).")
    parser.add_argument("--dspath", required=False,
                        help="Is the file path of the XML file within the Data source.")

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--list_as_rows', action='store_false',
                       help="This is the default.")
    group.add_argument('--list_as_array', action='store_true')

    return parser.parse_args()
