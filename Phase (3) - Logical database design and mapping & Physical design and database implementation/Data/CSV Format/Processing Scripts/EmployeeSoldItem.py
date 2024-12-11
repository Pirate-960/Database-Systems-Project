import csv

# Define the range of EmployeeID and ItemID
employee_ids = range(1, 41)  # EmployeeIDs 1 to 40
item_ids = range(1, 31)      # ItemIDs 1 to 30

# Define the output CSV file name
output_file = "EmployeeSoldItem.csv"

# Open the file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["EmployeeID", "ItemID"])
    
    # Write the Cartesian product of EmployeeID and ItemID
    for employee_id in employee_ids:
        for item_id in item_ids:
            writer.writerow([employee_id, item_id])

print(f"CSV file '{output_file}' has been created with the Employee-Item relations.")
