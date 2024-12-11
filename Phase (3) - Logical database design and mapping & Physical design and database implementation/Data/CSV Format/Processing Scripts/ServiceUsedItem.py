import csv

# Define the range of ServiceID and ItemID
service_ids = range(1001, 1151)  # ServiceIDs 1001 to 1150
item_ids = range(1, 31)      # ItemIDs 1 to 30

# Define the output CSV file name
output_file = "ServiceUsedItem.csv"

# Open the file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["ServiceID", "ItemID"])
    
    # Write the Cartesian product of ServiceID and ItemID
    for service_id in service_ids:
        for item_id in item_ids:
            writer.writerow([service_id, item_id])

print(f"CSV file '{output_file}' has been created with the Service-Item relations.")
