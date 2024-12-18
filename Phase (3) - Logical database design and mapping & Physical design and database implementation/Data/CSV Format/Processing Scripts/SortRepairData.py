import csv

# Input CSV data as a string
csv_data = """RepairServiceID,Name,StartDate,EndDate,Price,Status,City,State,Country,ServiceType,Duration,DeviceName,DeviceType,DeviceModel,RepairType
4001,Phone Screen Repair,1/1/2023,1/3/2023,150,Completed,Istanbul,Marmara,Turkey,Repair,2,iPhone,Smartphone,iPhone 12,Hardware
4002,Laptop Hard Drive Replacement,2/1/2023,2/3/2023,250,Completed,Izmir,Izmir,Turkey,Repair,2,MacBook,Laptop,MacBook Air,Hardware
4003,Software Reinstallation,3/1/2023,3/2/2023,80,Completed,Ankara,Ankara,Turkey,Repair,1,Lenovo,Laptop,ThinkPad X1,Software
4004,Phone Battery Replacement,4/1/2023,4/3/2023,120,Completed,Istanbul,Marmara,Turkey,Repair,2,Galaxy,Smartphone,Samsung Galaxy S20,Hardware
4005,PC RAM Upgrade,5/1/2023,5/3/2023,200,Completed,Izmir,Izmir,Turkey,Repair,2,HP,Laptop,HP Pavilion,Hardware
4006,Tablet Screen Repair,6/1/2023,6/4/2023,180,Completed,Ankara,Ankara,Turkey,Repair,3,Galaxy,Tablet,Samsung Tab S7,Hardware
4007,MacBook Key Replacement,7/1/2023,7/2/2023,100,Completed,Istanbul,Marmara,Turkey,Repair,1,MacBook,Laptop,MacBook Pro 13,Hardware
4008,Smartphone Software Update,8/1/2023,8/2/2023,50,Completed,Izmir,Izmir,Turkey,Repair,1,Nokia,Smartphone,Nokia 8,Software
4009,PC Software Optimization,9/1/2023,9/2/2023,75,Completed,Ankara,Ankara,Turkey,Repair,1,Dell,Laptop,Dell XPS 13,Software
4010,Laptop Battery Replacement,10/1/2023,10/3/2023,140,Completed,Istanbul,Marmara,Turkey,Repair,2,HP,Laptop,HP Envy,Hardware
4011,Smartwatch Screen Repair,11/1/2023,11/2/2023,100,Completed,Izmir,Izmir,Turkey,Repair,1,Apple Watch,Smartwatch,Apple Watch Series 6,Hardware
4012,Phone Speaker Repair,12/1/2023,12/2/2023,90,Completed,Ankara,Ankara,Turkey,Repair,1,Xiaomi,Smartphone,Xiaomi Mi 11,Hardware
4013,Software Bug Fix,1/2/2023,1/4/2023,60,Completed,Istanbul,Marmara,Turkey,Repair,2,Asus,Laptop,Asus ROG,Software
4014,Laptop Screen Replacement,2/1/2023,2/4/2023,300,Completed,Izmir,Izmir,Turkey,Repair,3,Acer,Laptop,Acer Aspire,Hardware
4015,Tablet Battery Replacement,3/1/2023,3/3/2023,130,Completed,Ankara,Ankara,Turkey,Repair,2,Lenovo,Tablet,Lenovo Tab M10,Hardware
4016,Phone Camera Replacement,4/1/2023,4/3/2023,110,Completed,Istanbul,Marmara,Turkey,Repair,2,iPhone,Smartphone,iPhone 11 Pro,Hardware
4017,PC Hard Drive Repair,5/1/2023,5/2/2023,180,Completed,Izmir,Izmir,Turkey,Repair,1,Lenovo,PC,Lenovo Desktop,Hardware
4018,Smartphone Screen Repair,6/1/2023,6/3/2023,160,Completed,Ankara,Ankara,Turkey,Repair,2,OnePlus,Smartphone,OnePlus 8,Hardware
4019,Laptop Upgrade,7/1/2023,7/3/2023,250,Completed,Istanbul,Marmara,Turkey,Repair,2,MacBook,Laptop,MacBook Pro 15,Hardware
4020,Tablet Software Fix,8/1/2023,8/2/2023,70,Completed,Izmir,Izmir,Turkey,Repair,1,Samsung,Tablet,Samsung Tab S5,Software
4021,Smartphone Factory Reset,9/1/2023,9/2/2023,60,Completed,Ankara,Ankara,Turkey,Repair,1,Sony,Smartphone,Sony Xperia Z5,Software
4022,Phone Charger Repair,10/1/2023,10/3/2023,80,Completed,Istanbul,Marmara,Turkey,Repair,2,LG,Smartphone,LG G6,Hardware
4023,Laptop Software Reinstallation,11/1/2023,11/3/2023,90,Completed,Izmir,Izmir,Turkey,Repair,2,HP,Laptop,HP EliteBook,Software
4024,PC Power Supply Repair,12/1/2023,12/3/2023,200,Completed,Ankara,Ankara,Turkey,Repair,2,Dell,PC,Dell Inspiron,Hardware
4025,Smartphone Hardware Fix,1/3/2023,1/4/2023,100,Completed,Istanbul,Marmara,Turkey,Repair,1,Huawei,Smartphone,Huawei P30,Hardware
4026,Laptop Keyboard Repair,2/3/2023,2/4/2023,150,Completed,Izmir,Izmir,Turkey,Repair,1,Asus,Laptop,Asus VivoBook,Hardware
4027,Phone Software Repair,3/3/2023,3/4/2023,50,Completed,Ankara,Ankara,Turkey,Repair,1,Samsung,Smartphone,Samsung Galaxy A50,Software
4028,PC Antivirus Fix,4/3/2023,4/4/2023,60,Completed,Istanbul,Marmara,Turkey,Repair,1,HP,PC,HP Desktop,Software
4029,Tablet Speaker Repair,5/3/2023,5/4/2023,80,Completed,Izmir,Izmir,Turkey,Repair,1,Amazon,Tablet,Amazon Fire HD 10,Hardware
4030,Smartphone Update,6/3/2023,6/4/2023,40,Completed,Ankara,Ankara,Turkey,Repair,1,Google Pixel,Smartphone,Pixel 4,Software
4031,Laptop Graphic Card Fix,7/3/2023,7/5/2023,220,Completed,Istanbul,Marmara,Turkey,Repair,2,MSI,Laptop,MSI GE75,Hardware
4032,PC Software Update,8/3/2023,8/4/2023,50,Completed,Izmir,Izmir,Turkey,Repair,1,Asus,PC,Asus Tower,Software
4033,Phone Back Cover Repair,9/3/2023,9/4/2023,70,Completed,Ankara,Ankara,Turkey,Repair,1,Motorola,Smartphone,Motorola Edge,Hardware
4034,Tablet Camera Replacement,10/3/2023,10/4/2023,120,Completed,Istanbul,Marmara,Turkey,Repair,1,Samsung,Tablet,Samsung Tab A7,Hardware
4035,PC RAM Issue Fix,11/3/2023,11/4/2023,150,Completed,Izmir,Izmir,Turkey,Repair,1,Acer,PC,Acer Desktop,Hardware
4036,Smartphone Charging Port Repair,12/3/2023,12/4/2023,100,Completed,Ankara,Ankara,Turkey,Repair,1,Nokia,Smartphone,Nokia 6,Hardware
4037,Laptop Audio Jack Repair,1/4/2023,1/5/2023,90,Completed,Istanbul,Marmara,Turkey,Repair,1,Toshiba,Laptop,Toshiba Satellite,Hardware
4038,Tablet Repair (Miscellaneous),2/4/2023,2/5/2023,130,Completed,Izmir,Izmir,Turkey,Repair,1,Apple,Tablet,iPad Mini,Hardware
4039,Phone Water Damage Fix,3/4/2023,3/5/2023,160,Completed,Ankara,Ankara,Turkey,Repair,1,Sony,Smartphone,Sony Xperia XZ,Hardware
4040,PC Overheating Issue Fix,4/4/2023,4/6/2023,180,Completed,Istanbul,Marmara,Turkey,Repair,2,Lenovo,PC,Lenovo ThinkCentre,Hardware
"""

# Convert the input CSV data string into a list of dictionaries
def parse_csv_data(data):
    lines = data.strip().split("\n")
    reader = csv.DictReader(lines)
    return list(reader)

# Sort the CSV data by RepairType
def sort_by_repair_type(data):
    return sorted(data, key=lambda x: x["RepairType"].lower())

# Write sorted data to a new CSV file
def write_sorted_csv(sorted_data, output_file):
    with open(output_file, "w", newline="", encoding="utf-8") as csvfile:
        fieldnames = sorted_data[0].keys()
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(sorted_data)

# Main execution
csv_rows = parse_csv_data(csv_data)
sorted_rows = sort_by_repair_type(csv_rows)
write_sorted_csv(sorted_rows, "RepairDataSort.csv")

print("CSV data sorted by RepairType and saved to 'RepairDataSort.csv'")
