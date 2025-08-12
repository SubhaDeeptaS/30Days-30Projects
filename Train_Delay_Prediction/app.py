import re
import pandas as pd
from datetime import datetime
import requests
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.multioutput import MultiOutputRegressor
from sklearn.model_selection import train_test_split

def extract_tooltipdata_to_dataframe(response_text):
    """
    Extract et.rsStat.tooltipData from response.text and convert to pandas DataFrame
    """
    
    # Extract the tooltipData array using regex
    tooltip_pattern = r'et\.rsStat\.tooltipData\s*=\s*(\[.*?\]);'
    match = re.search(tooltip_pattern, response_text, re.DOTALL)
    
    if not match:
        raise ValueError("et.rsStat.tooltipData not found in response")
    
    js_array_str = match.group(1)
    rows = js_array_str.split('\n,')
    
    # Extract column names from header row
    header_row = rows[0].strip().lstrip('[').rstrip(']')
    header_data = eval(header_row)
    
    columns = []
    for item in header_data:
        if isinstance(item, str):
            columns.append(item)
        elif isinstance(item, dict) and 'label' in item:
            columns.append(item['label'])
    
    # Process data rows
    data_rows = []
    for i in range(1, len(rows)):
        row = rows[i].strip().rstrip(']').lstrip('[')
        
        # Handle JavaScript Date constructor
        if 'new Date(' in row:
            date_match = re.search(r'new Date\((\d+),(\d+),(\d+)\)', row)
            if date_match:
                year = int(date_match.group(1))
                month = int(date_match.group(2)) + 1  # JS months are 0-based
                day = int(date_match.group(3))
                date_obj = datetime(year, month, day)
                row = re.sub(r'new Date\(\d+,\d+,\d+\)', f'"{date_obj.strftime("%Y-%m-%d")}"', row)
        
        try:
            row_data = eval('[' + row + ']')
            if len(row_data) == len(columns):
                data_rows.append(row_data)
        except:
            continue
    
    # Create DataFrame
    df = pd.DataFrame(data_rows, columns=columns)
    if 'Date' in df.columns:
        df['Date'] = pd.to_datetime(df['Date'])
    
    return df


# Prepare
def predict(df, input_station, input_delay):
    station_names = list(df.columns)[1:]
    station_index = {st: i for i, st in enumerate(station_names)}
    records = []
    for _, row in df.iterrows():
        delays = [row[st] for st in station_names]
        for k in range(len(station_names)-1):
            records.append({
                'input_station_idx': k,
                'input_delay': delays[k],
                'next_delays': delays[k+1:]
            })
    reshaped_df = pd.DataFrame(records)

    X = reshaped_df[['input_station_idx', 'input_delay']]
    y = pd.DataFrame(reshaped_df['next_delays'].tolist())

    mask = ~y.isna().any(axis=1)
    X_clean = X[mask]
    y_clean = y[mask]

    # Model
    model = MultiOutputRegressor(RandomForestRegressor())
    model.fit(X_clean, y_clean)

    station_idx = station_index[input_station]
    X_new = pd.DataFrame([[station_idx, input_delay]], columns=['input_station_idx', 'input_delay'])
    predicted = model.predict(X_new)[0]
    pred_stations = station_names[station_idx+1:]
    result = dict(zip(pred_stations, predicted))

    cleaned_result = {k: float(v) for k, v in result.items()}

    print(cleaned_result)


# Your HTTP request
def main():
    response = requests.get('https://etrain.info/train/Puri-Bgy-Express-12892/history?d=3m')

    # Extract to DataFrame
    df = extract_tooltipdata_to_dataframe(response.text)

    print("Data extracted successfully!")
    print(f"Shape: {df.shape}")
    # print(df.head())

    input_station = 'KUR'
    input_delay = 20

    predict(df, input_station, input_delay)

    # Save to CSV if needed
    df.to_csv('extracted_data.csv', index=False)

if __name__ == '__main__':
    main()

    
    
