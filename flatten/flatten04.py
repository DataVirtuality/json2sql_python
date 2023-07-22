# type: ignore
import pandas as pd
# from pandas.io.json import json_normalize
# import json
# from typing import Any


def flatten_nested_json(input_json_file: str, output_csv_file: str) -> None:
    # To avoid getting the exception: Mixing dicts with non-Series may lead to ambiguous ordering.
    # Load the JSON then call json_normalize
    # json_obj: Any
    # json_normalized: Any
    # with open(input_json_file, 'rt', encoding='UTF-8') as f:
    #     json_obj = json.load(f)
    #     json_normalized = pd.json_normalize(json_obj)
    df = pd.read_json(input_json_file)
    df = flatten_nested_json_df(df)
    df.to_csv(output_csv_file, index=False)


def flatten_nested_json_df(
    df: pd.DataFrame,
    verbose: bool = False
) -> pd.DataFrame:

    df = df.reset_index(drop=True)

    if verbose:
        print(f"original shape: {df.shape}")
        print(f"original columns: {df.columns}")

    # search for columns to explode/flatten
    s = (df.applymap(lambda x: isinstance(x, list))).any()
    list_columns = s[s].index.tolist()

    s = (df.applymap(lambda x: isinstance(x, dict))).any()
    dict_columns = s[s].index.tolist()

    if verbose:
        print(f"lists: {list_columns}, dicts: {dict_columns}")
    while len(list_columns) > 0 or len(dict_columns) > 0:
        new_columns = []

        for col in dict_columns:
            if verbose:
                print(f"flattening: {col}")
            # explode dictionaries horizontally, adding new columns
            horiz_exploded = pd.json_normalize(df[col]).add_prefix(f'{col}.')
            horiz_exploded.index = df.index
            df = pd.concat([df, horiz_exploded], axis=1).drop(columns=[col])
            new_columns.extend(horiz_exploded.columns)  # inplace

        for col in list_columns:
            # The column may have already been processed. See if it still exists.
            if col not in df.columns:
                continue
            if verbose:
                print(f"exploding: {col}")
            # explode lists vertically, adding new columns
            df = df.drop(columns=[col]).join(df[col].explode().to_frame())
            df = df.reset_index(drop=True)
            new_columns.append(col)

        # check if there are still dict o list fields to flatten
        s = (df[new_columns].applymap(lambda x: isinstance(x, list))).any()
        list_columns = s[s].index.tolist()

        s = (df[new_columns].applymap(lambda x: isinstance(x, dict))).any()
        dict_columns = s[s].index.tolist()

        if verbose:
            print(f"lists: {list_columns}, dicts: {dict_columns}")

    if verbose:
        print(f"final shape: {df.shape}")
        print(f"final columns: {df.columns}")
    return df
