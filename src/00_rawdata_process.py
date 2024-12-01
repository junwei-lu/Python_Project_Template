import pandas as pd
import numpy as np

def process_boston_data():
    # Define column names from the header
    columns = [
        'CRIM', 'ZN', 'INDUS', 'CHAS', 'NOX', 'RM', 'AGE', 'DIS', 'RAD',
        'TAX', 'PTRATIO', 'B', 'LSTAT', 'MEDV'
    ]
    
    # Open the file and read lines starting from line 23
    with open('raw_data/boston.txt', 'r') as file:
        lines = file.readlines()[22:]  # Skip the first 22 lines

    # Process the data
    data = []
    for i in range(0, len(lines), 2):
        # Combine two lines into one record
        line1 = lines[i].strip()
        line2 = lines[i+1].strip()
        combined_line = f"{line1} {line2}"
        values = combined_line.split()
        data.append(values)

    # Create a DataFrame with the specified columns
    df = pd.DataFrame(data, columns=columns)
    
    # Convert data types as necessary
    df = df.astype(float)
    
    # Ensure data folder exists
    import os
    os.makedirs('data', exist_ok=True)
    
    # Save to CSV
    df.to_csv('data/boston.csv', index=False)
    print(f"Processed {len(df)} rows of data")
    print("Saved to data/boston.csv")

if __name__ == "__main__":
    process_boston_data() 