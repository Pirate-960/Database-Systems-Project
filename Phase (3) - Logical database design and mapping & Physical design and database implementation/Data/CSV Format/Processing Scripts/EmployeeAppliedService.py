import csv

# Define the range of EmployeeID and ServiceID
employee_ids = range(1, 41)  # EmployeeIDs 1 to 40
service_ids = range(1001, 1151)  # ServiceIDs 1001 to 1150

# Define the output CSV file name
output_file = "EmployeeAppliedService.csv"

# Open the file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["EmployeeID", "ServiceID"])
    
    # Write the Cartesian product of EmployeeID and ServiceID
    for employee_id in employee_ids:
        for service_id in service_ids:
            writer.writerow([employee_id, service_id])

print(f"CSV file '{output_file}' has been created with the Employee-Service relations.")
