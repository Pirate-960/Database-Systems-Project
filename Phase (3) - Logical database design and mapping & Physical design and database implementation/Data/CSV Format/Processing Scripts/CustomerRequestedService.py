import csv

# Define the range of CustomerID and ServiceID
customer_ids = range(1, 41)  # CustomerIDs 1 to 40
service_ids = range(1001, 1151)  # ServiceIDs 1001 to 1150

# Define the output CSV file name
output_file = "CustomerRequestedService.csv"

# Open the file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["EmployeeID", "ServiceID"])
    
    # Write the Cartesian product of CustomerID and ServiceID
    for customer_id in customer_ids:
        for service_id in service_ids:
            writer.writerow([customer_id, service_id])

print(f"CSV file '{output_file}' has been created with the Customer-Service relations.")
