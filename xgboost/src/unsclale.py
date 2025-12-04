import pickle
import ast
import pandas as pd

text_file = "../outputs/learned-clauses_german_credit.txt"   # contains the pasted text
scaler_file = "../models/dataset/german_credit/scaler.pkl"   # your trained scaler
output_file = "../outputs/learned-clauses_german_credit_unscaled.txt"

with open(scaler_file, "rb") as f:
    scaler = pickle.load(f)

rows = []
with open(text_file, "r") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            parsed = ast.literal_eval(line)  
        except Exception as e:
            print(f"Skipping line: {line} ({e})")
            continue

        row = {}
        for tup in parsed:  
            _, feat, val = tup
            row[feat] = float(val)
        rows.append(row)

df_scaled = pd.DataFrame(rows)

df_unscaled = pd.DataFrame(
    scaler.inverse_transform(df_scaled),
    columns=df_scaled.columns
)

with open(output_file, "w") as f:
    for i in range(len(df_scaled)):
        f.write(f"Row {i+1}:\n")
        for col in df_scaled.columns:
            scaled_val = df_scaled.loc[i, col]
            unscaled_val = df_unscaled.loc[i, col]
            f.write(f"  {col}: scaled={scaled_val:.6f}  ->  unc={unscaled_val:.6f}\n")
        f.write("\n")

print(f"Done! Results saved to {output_file}")
