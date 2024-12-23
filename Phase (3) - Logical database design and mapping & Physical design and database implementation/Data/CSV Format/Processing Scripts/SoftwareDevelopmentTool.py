import pandas as pd
from io import StringIO

# Original data with semicolon-separated development tools
software_service_data = """
SoftwareServiceID,Name,StartDate,EndDate,Price,Status,City,State,Country,ServiceType,DevelopmentTool,DevelopmentType
6001,Mobile App Development,2023-01-10,2023-02-10,2500.00,Completed,Istanbul,Marmara,Turkey,Software Development,React Native;Xcode;Firebase,App
6002,Web Portal Development,2023-02-05,2023-02-25,3000.00,Completed,Ankara,Ankara,Turkey,Software Development,React;Node.js;MongoDB,Web
6003,Custom CRM System,2023-03-01,2023-03-15,2000.00,Completed,Izmir,Izmir,Turkey,Software Development,Angular;Node.js;PostgreSQL,Web
6004,Payment Gateway Integration,2023-04-01,2023-04-10,1500.00,Completed,Antalya,Antalya,Turkey,Software Development,PHP;MySQL,Web
6005,Android App Development,2023-05-01,2023-05-20,2200.00,Completed,Bursa,Bursa,Turkey,Software Development,Android Studio;Firebase,App
6006,E-commerce Platform Development,2023-06-05,2023-06-25,3500.00,Completed,Konya,Konya,Turkey,Software Development,React;Node.js;MongoDB,Web
6007,Internal Tool Development,2023-07-01,2023-07-10,1000.00,Completed,Istanbul,Marmara,Turkey,Software Development,Vue.js;Firebase,Web
6008,Hybrid App Development,2023-08-05,2023-08-25,2800.00,Completed,Izmir,Izmir,Turkey,Software Development,Flutter;Firebase,App
6009,Website Redesign,2023-09-01,2023-09-10,1200.00,Completed,Ankara,Ankara,Turkey,Software Development,HTML;CSS;JavaScript,Web
6010,App UI/UX Design,2023-10-01,2023-10-10,1500.00,Completed,Bursa,Bursa,Turkey,Software Development,Figma;Sketch,App
6011,Enterprise Resource Planning (ERP),2023-11-01,2023-11-20,4000.00,Completed,Antalya,Antalya,Turkey,Software Development,React;Node.js;MongoDB,Web
6012,Inventory Management System,2023-12-01,2023-12-15,2000.00,Completed,Istanbul,Marmara,Turkey,Software Development,Vue.js;Node.js;MySQL,Web
6013,Cloud App Development,2023-01-15,2023-02-05,2700.00,Completed,Izmir,Izmir,Turkey,Software Development,React Native;AWS,App
6014,Real-time Messaging App,2023-02-10,2023-02-25,2100.00,Completed,Ankara,Ankara,Turkey,Software Development,Flutter;Firebase,App
6015,Mobile Game Development,2023-03-10,2023-03-30,3000.00,Completed,Antalya,Antalya,Turkey,Software Development,Unity;C#,App
6016,Social Media Web App,2023-04-10,2023-04-30,3500.00,Completed,Istanbul,Marmara,Turkey,Software Development,React;Node.js;MongoDB,Web
6017,Dashboard Development,2023-05-15,2023-05-25,1800.00,Completed,Izmir,Izmir,Turkey,Software Development,Angular;TypeScript,Web
6018,Hotel Booking System,2023-06-15,2023-06-30,2500.00,Completed,Bursa,Bursa,Turkey,Software Development,React;Node.js;MySQL,Web
6019,Custom Mobile App,2023-07-10,2023-07-25,2200.00,Completed,Antalya,Antalya,Turkey,Software Development,React Native;Firebase,App
6020,Web Scraping Tool,2023-08-15,2023-08-25,1300.00,Completed,Istanbul,Marmara,Turkey,Software Development,Python;BeautifulSoup,Web
6021,Task Management App,2023-09-05,2023-09-15,1500.00,Completed,Izmir,Izmir,Turkey,Software Development,Flutter;SQLite,App
6022,Health Tracker App,2023-10-05,2023-10-15,1700.00,Completed,Bursa,Bursa,Turkey,Software Development,React Native;Firebase,App
6023,Online Learning Platform,2023-11-10,2023-11-25,3500.00,Completed,Antalya,Antalya,Turkey,Software Development,React;Node.js;MongoDB,Web
6024,CRM App Development,2023-12-01,2023-12-15,2200.00,Completed,Istanbul,Marmara,Turkey,Software Development,React Native;MySQL,App
6025,Booking App Development,2023-01-05,2023-01-20,1900.00,Completed,Izmir,Izmir,Turkey,Software Development,React Native;Node.js,App
"""

# Read the data into a DataFrame
software_service_df = pd.read_csv(StringIO(software_service_data), skipinitialspace=True)

# Explode the DevelopmentTool column into separate rows
software_service_tools_table = software_service_df.assign(DevelopmentTool=software_service_df['DevelopmentTool'].str.split(';')).explode('DevelopmentTool')

# Trim whitespace from the DevelopmentTool column
software_service_tools_table['DevelopmentTool'] = software_service_tools_table['DevelopmentTool'].str.strip()

# Create the SoftwareServiceTools table with only relevant columns
software_service_tools_table = software_service_tools_table[['SoftwareServiceID', 'DevelopmentTool']]

# Save the SoftwareServiceTools table to a CSV file
software_service_tools_table.to_csv("SoftwareDevelopmentTool.csv", index=False)

print("SoftwareServiceTools table has been saved as 'SoftwareDevelopmentTool.csv'")
