# type: ignore
from typing import Any
import pandas as pd
from flatten01 import json_to_dataframe
# from flatten02 import to_csv
from flatten03 import flatten
from flatten04 import flatten_nested_json_df
import flatten_json


def gen_csv_files(json_obj: Any, file_name: str) -> None:
    df = pd.json_normalize(json_obj, sep='/')
    df.to_csv(f'{file_name}.00.csv')

    df = json_to_dataframe(json_obj)
    df.to_csv(f'{file_name}.01.csv')

    # broken
    # if isinstance(json_obj, list):
    #     dic_flattened = flatten({"root": json_obj})
    #     to_csv(dic_flattened, filename=f'{file_name}.02.csv')
    # else:
    #     to_csv(json_obj, filename=f'{file_name}.02.csv')

    if isinstance(json_obj, list):
        dic_flattened = flatten({"root": json_obj})
    else:
        dic_flattened = flatten(json_obj)
    df = pd.DataFrame(dic_flattened, index=[0])
    df.to_csv(f'{file_name}.03.csv')

    if isinstance(json_obj, list):
        dic_flattened = flatten({"root": json_obj})
    else:
        dic_flattened = flatten_json.flatten(json_obj)
    df = pd.DataFrame(dic_flattened, index=[0])
    df.to_csv(f'{file_name}.04.csv')

    df = flatten_nested_json_df(pd.json_normalize(json_obj, sep='/'))
    df.to_csv(f'{file_name}.05.csv')
    print()
