import csv

# Define input file names
customer_file = "Customer.csv"
item_file = "Item.csv"

# Define the output CSV file name
output_file = "CustomerPurchasedItem.csv"

# Read CustomerID from Customer.csv
with open(customer_file, mode='r') as file:
    reader = csv.DictReader(file)
    customer_ids = [row["CustomerID"] for row in reader]

# Read ItemID from Item.csv
with open(item_file, mode='r') as file:
    reader = csv.DictReader(file)
    item_ids = [row["ItemID"] for row in reader]

# Open the output file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["CustomerID", "ItemID"])
    
    # Write the Cartesian product of CustomerID and ItemID
    for customer_id in customer_ids:
        for item_id in item_ids:
            writer.writerow([customer_id, item_id])

print(f"CSV file '{output_file}' has been created with the Customer-Item relations.")
