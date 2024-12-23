import os
import pandas as pd

def generate_queries_in_script_directory(script_dir, folder_path):
    # List all CSV files in the folder
    csv_files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

    if not csv_files:
        print("No CSV files found in the folder.")
        return

    for csv_file in csv_files:
        csv_path = os.path.join(folder_path, csv_file)
        table_name = os.path.splitext(csv_file)[0]  # Extract table name from file name

        # Read the CSV file
        data = pd.read_csv(csv_path)

        # Generate INSERT INTO statements
        queries = []
        for _, row in data.iterrows():
            columns = ', '.join(row.index)  # Use headers as column names
            # Escape single quotes in values
            values = ', '.join([f"'{str(value).replace('\'', '\'\'')}'" for value in row.values])
            query = f"INSERT INTO {table_name} ({columns}) VALUES ({values});"
            queries.append(query)

        # Write to output SQL file in the script directory
        output_file = os.path.join(script_dir, f"{table_name}.sql")
        with open(output_file, 'w', encoding='utf-8') as file:
            file.write('\n'.join(queries))
        
        print(f"Generated SQL file for {csv_file}: {output_file}")

# Example usage:
if __name__ == "__main__":
    # Directory containing the script
    script_directory = os.path.dirname(os.path.abspath(__file__))

    # Path to the folder containing CSV files
    folder_with_csv_files = "../CSV Format/Post-Processing Phase - Information"  # Replace with your folder path

    # Generate SQL queries
    generate_queries_in_script_directory(script_directory, folder_with_csv_files)
    