import pandas as pd

def generate_insert_queries(csv_file):
    # Extract the table name from the file name (without extension)
    table_name = csv_file.split('/')[-1].split('.')[0]

    # Read the CSV file (first row is assumed to be headers)
    data = pd.read_csv(csv_file)

    # Generate INSERT INTO statements
    queries = []
    for _, row in data.iterrows():
        columns = ', '.join(row.index)  # Use headers as column names
        # Escape single quotes in values
        values = ', '.join([f"'{str(value).replace('\'', '\'\'')}'" for value in row.values])
        query = f"INSERT INTO {table_name} ({columns}) VALUES ({values});"
        queries.append(query)

    # Write to output file
    output_file = f"{table_name}.sql"
    with open(output_file, 'w', encoding='utf-8') as file:
        file.write('\n'.join(queries))
    
    print(f"SQL queries have been written to {output_file}")

# Example usage:
csv_file_path = "Employee.csv"  # Replace with your CSV file path
generate_insert_queries(csv_file_path)
