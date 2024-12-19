import csv

# Define input file names
customer_file = "Customer.csv"
service_file = "Service.csv"

# Define the output CSV file name
output_file = "CustomerRequestedService.csv"

# Read CustomerID from Customer.csv
with open(customer_file, mode='r') as file:
    reader = csv.DictReader(file)
    customer_ids = [row["CustomerID"] for row in reader]

# Read ServiceID from Service.csv
with open(service_file, mode='r') as file:
    reader = csv.DictReader(file)
    service_ids = [row["ServiceID"] for row in reader]

# Open the output file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["CustomerID", "ServiceID"])
    
    # Write the Cartesian product of CustomerID and ServiceID
    for customer_id in customer_ids:
        for service_id in service_ids:
            writer.writerow([customer_id, service_id])

print(f"CSV file '{output_file}' has been created with the Customer-Service relations.")
