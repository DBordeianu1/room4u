# Python script to transform an excel file into csv one
# Must have pandas and openpyxl installed

import pandas as pd
import os

EXCEL_FILE="hotelchains.xlsx"
OUTPUT_DIR="sql/csv_files"

os.makedirs(OUTPUT_DIR,exist_ok=True)

xl=pd.ExcelFile(EXCEL_FILE)

for sheet_name in xl.sheet_names:
    df=pd.read_excel(xl,sheet_name=sheet_name)
    output_path=os.path.join(OUTPUT_DIR,f"{sheet_name}.csv")
    df.to_csv(output_path,index=False)
    print(f"Exported: {sheet_name} -> {output_path}")


print("Done!")
