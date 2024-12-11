import csv

# Define the range of CustomerID and ItemID
customer_ids = range(1, 51)  # CustomerIDs 1 to 50
item_ids = range(1, 31)      # ItemIDs 1 to 30

# Define the output CSV file name
output_file = "CustomerPurchasedItem.csv"

# Open the file for writing
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    # Write the header
    writer.writerow(["CustomerID", "ItemID"])
    
    # Write the Cartesian product of CustomerID and ItemID
    for customer_id in customer_ids:
        for item_id in item_ids:
            writer.writerow([customer_id, item_id])

print(f"CSV file '{output_file}' has been created with the Customer-Item relations.")
