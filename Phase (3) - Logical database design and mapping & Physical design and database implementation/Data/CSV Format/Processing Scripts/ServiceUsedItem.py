import csv

# Define input file names
service_file = "Service.csv"
item_file = "Item.csv"

# Define the output CSV file name
output_file = "ServiceUsedItem.csv"

# Read ServiceID from Service.csv
with open(service_file, mode='r') as file:
    reader = csv.DictReader(file)
    service_ids = [row["ServiceID"] for row in reader]

# Read ItemID from Item.csv
with open(item_file, mode='r') as file:
    reader = csv.DictReader(file)
    item_ids = [row["ItemID"] for row in reader]

# Open the output file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["ServiceID", "ItemID"])
    
    # Write the Cartesian product of ServiceID and ItemID
    for service_id in service_ids:
        for item_id in item_ids:
            writer.writerow([service_id, item_id])

print(f"CSV file '{output_file}' has been created with the Service-Item relations.")
