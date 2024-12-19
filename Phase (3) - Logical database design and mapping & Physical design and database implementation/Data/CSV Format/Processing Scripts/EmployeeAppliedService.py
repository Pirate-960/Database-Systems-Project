import csv

# Define input file names
employee_file = "Employee.csv"
service_file = "Service.csv"

# Define the output CSV file name
output_file = "EmployeeAppliedService.csv"

# Read EmployeeID from Employee.csv
with open(employee_file, mode='r') as file:
    reader = csv.DictReader(file)
    employee_ids = [row["EmployeeID"] for row in reader]

# Read ServiceID from Service.csv
with open(service_file, mode='r') as file:
    reader = csv.DictReader(file)
    service_ids = [row["ServiceID"] for row in reader]

# Open the output file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["EmployeeID", "ServiceID"])
    
    # Write the Cartesian product of EmployeeID and ServiceID
    for employee_id in employee_ids:
        for service_id in service_ids:
            writer.writerow([employee_id, service_id])

print(f"CSV file '{output_file}' has been created with the Employee-Service relations.")
