# Train Delay Prediction Tool

## Overview
This Python application scrapes historical train delay data from **etrain.info** for a specific train and uses a machine learning model to predict delays at subsequent stations.

It works in three main steps:
1. **Scraping Data** – Extracts JavaScript-based `tooltipData` from the train's history page and parses it into a Pandas DataFrame.
2. **Data Processing** – Cleans and transforms the data into a model-friendly format.
3. **Prediction** – Uses a `RandomForestRegressor` wrapped in `MultiOutputRegressor` to predict delays at future stations based on a given starting station and delay.

---

## Features
- Fetches and parses historical delay data for a train.
- Automatically handles JavaScript date formats in the source.
- Trains a multi-output machine learning model.
- Predicts delays for remaining stations after a given station.
- Supports saving extracted data to CSV for later analysis.

---

## Requirements
The script requires Python 3.8+ and the following Python libraries:

```bash
pip install pandas requests scikit-learn
```

---

## How It Works
1. **Data Extraction**  
   The function `extract_tooltipdata_to_dataframe()`:
   - Scrapes the HTML page of a train's history.
   - Extracts the `et.rsStat.tooltipData` JavaScript array using regex.
   - Cleans the date fields and constructs a Pandas DataFrame.

2. **Prediction**  
   The function `predict()`:
   - Transforms the DataFrame into features (`input_station_idx`, `input_delay`) and multiple target outputs (delays for all subsequent stations).
   - Trains a `RandomForestRegressor` for multi-output regression.
   - Predicts delays for the next stations given an input station and delay.

3. **Main Script**  
   - Fetches data for **Puri–Bgy Express (12892)** for the last 3 months.
   - Predicts delays starting from `KUR` station with an assumed 20-minute delay.
   - Prints the predicted delays for the remaining stations.

---

## Usage
1. Clone or download this repository.
2. Install the dependencies:
   ```bash
   pip install pandas requests scikit-learn
   ```
3. Run the script:
   ```bash
   python app1.py
   ```

---

## Example Output
```
Data extracted successfully!
Shape: (90, 12)
{'BBS': 15.2, 'CTC': 18.5, 'KUR': 22.1, ...}
```

---

## Customization
- **Change Train**: Update the URL in `main()` to fetch data for a different train.
- **Change Input Station or Delay**: Modify `input_station` and `input_delay` in `main()`.
- **Save Data**: Uncomment the `df.to_csv()` line in `main()` to store extracted data.

---

## Disclaimer
- This tool is for **educational and experimental purposes only**.
- Data is sourced from `etrain.info`, which loads data dynamically — scraping may be subject to changes in the site structure.
- Always respect the website's terms of service before scraping.

---
