import csv

# Define input file names
employee_file = "Employee.csv"
item_file = "Item.csv"

# Define the output CSV file name
output_file = "EmployeeSoldItem.csv"

# Read EmployeeID from Employee.csv
with open(employee_file, mode='r') as file:
    reader = csv.DictReader(file)
    employee_ids = [row["EmployeeID"] for row in reader]

# Read ItemID from Item.csv
with open(item_file, mode='r') as file:
    reader = csv.DictReader(file)
    item_ids = [row["ItemID"] for row in reader]

# Open the output file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["EmployeeID", "ItemID"])
    
    # Write the Cartesian product of EmployeeID and ItemID
    for employee_id in employee_ids:
        for item_id in item_ids:
            writer.writerow([employee_id, item_id])

print(f"CSV file '{output_file}' has been created with the Employee-Item relations.")
