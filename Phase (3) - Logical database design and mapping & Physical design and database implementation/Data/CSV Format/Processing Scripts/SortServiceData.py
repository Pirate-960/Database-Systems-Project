import csv

# Input CSV data as a string
csv_data = """ServiceID,Name,StartDate,EndDate,Price,Status,City,State,Country,ServiceType,Duration
1001,Cloud Hosting,1/15/2023,1/25/2023,5000,Active,Istanbul,Marmara,Turkey,Cloud,10
1002,Network Security,2/1/2023,2/15/2023,3000,Completed,Ankara,Ankara,Turkey,Security,14
1003,Device Repair,3/10/2023,3/12/2023,150,Completed,Izmir,Izmir,Turkey,Repair,2
1004,Web Development,4/5/2023,4/20/2023,2000,Active,Istanbul,Marmara,Turkey,Development,15
1005,SEO Optimization,5/12/2023,5/22/2023,1800,Completed,Izmir,Izmir,Turkey,Marketing,10
1006,Cloud Services Migration,6/1/2023,6/10/2023,4000,Active,Ankara,Ankara,Turkey,Cloud,9
1007,App Development,7/15/2023,7/30/2023,3500,Completed,Istanbul,Marmara,Turkey,Development,15
1008,Security Audit,8/1/2023,8/15/2023,2500,Active,Izmir,Izmir,Turkey,Security,14
1009,Network Optimization,9/10/2023,9/20/2023,4500,Completed,Ankara,Ankara,Turkey,Security,10
1010,Data Backup Services,10/5/2023,10/15/2023,3000,Active,Izmir,Izmir,Turkey,Cloud,10
1011,Cloud Backup Services,11/1/2023,11/12/2023,2500,Completed,Istanbul,Marmara,Turkey,Cloud,11
1012,IT Support,12/10/2023,12/20/2023,3000,Completed,Ankara,Ankara,Turkey,Support,10
1013,E-commerce Solutions,1/20/2023,2/10/2023,5500,Completed,Izmir,Izmir,Turkey,Consulting,21
1014,Digital Transformation,2/1/2023,2/18/2023,4000,Active,Istanbul,Marmara,Turkey,Consulting,17
1015,Blockchain Development,3/5/2023,3/18/2023,5000,Completed,Izmir,Izmir,Turkey,Development,13
1016,IT Security Solutions,4/12/2023,4/26/2023,3500,Active,Ankara,Ankara,Turkey,Security,14
1017,Cloud Migration,5/7/2023,5/20/2023,4000,Completed,Istanbul,Marmara,Turkey,Cloud,13
1018,App Development Strategy,6/5/2023,6/15/2023,2500,Completed,Izmir,Izmir,Turkey,Development,10
1019,Consulting Services,7/1/2023,7/12/2023,3000,Completed,Istanbul,Marmara,Turkey,Consulting,11
1020,Mobile App Solutions,8/1/2023,8/15/2023,4500,Active,Izmir,Izmir,Turkey,Development,14
1021,Cloud Automation,9/1/2023,9/10/2023,5000,Completed,Istanbul,Marmara,Turkey,Cloud,9
1022,IT Infrastructure Consulting,10/5/2023,10/17/2023,4500,Completed,Ankara,Ankara,Turkey,Consulting,12
1023,UX/UI Design,11/10/2023,11/22/2023,4000,Active,Izmir,Izmir,Turkey,Design,12
1024,Web Optimization,12/1/2023,12/13/2023,2500,Completed,Istanbul,Marmara,Turkey,Cloud,12
1025,Data Science Solutions,1/25/2023,2/8/2023,3500,Active,Ankara,Ankara,Turkey,Analytics,14
1026,Cloud Security,2/15/2023,3/1/2023,3000,Completed,Istanbul,Marmara,Turkey,Security,14
1027,Custom Software Development,3/10/2023,3/22/2023,4500,Completed,Izmir,Izmir,Turkey,Development,12
1028,Mobile App Development,4/5/2023,4/18/2023,5500,Completed,Istanbul,Marmara,Turkey,Development,13
1029,IT Support Services,5/10/2023,5/22/2023,3000,Active,Izmir,Izmir,Turkey,Support,12
1030,E-commerce Development,6/20/2023,7/10/2023,5000,Completed,Ankara,Ankara,Turkey,Consulting,20
1031,Cloud Consulting,7/5/2023,7/17/2023,4000,Completed,Izmir,Izmir,Turkey,Cloud,12
1032,AI Solutions,8/10/2023,8/24/2023,6000,Completed,Ankara,Ankara,Turkey,AI,14
1033,Data Analytics Services,9/1/2023,9/15/2023,5000,Active,Istanbul,Marmara,Turkey,Analytics,14
1034,Server Optimization,10/15/2023,10/28/2023,3000,Completed,Izmir,Izmir,Turkey,Security,13
1035,Cloud Service Management,11/1/2023,11/12/2023,3500,Active,Ankara,Ankara,Turkey,Cloud,11
1036,Digital Marketing,12/1/2023,12/15/2023,2000,Completed,Izmir,Izmir,Turkey,Marketing,14
1037,Website Development,1/1/2023,1/15/2023,2500,Completed,Istanbul,Marmara,Turkey,Development,14
1038,AI Development Services,2/15/2023,2/28/2023,5500,Active,Ankara,Ankara,Turkey,AI,13
1039,Cloud Backup Solutions,3/1/2023,3/14/2023,3000,Completed,Izmir,Izmir,Turkey,Cloud,13
1040,Network Monitoring,4/10/2023,4/22/2023,3500,Completed,Ankara,Ankara,Turkey,Security,12
1041,Software Development,5/1/2023,5/15/2023,4000,Completed,Istanbul,Marmara,Turkey,Development,14
1042,Network Configuration,6/1/2023,6/10/2023,3500,Active,Izmir,Izmir,Turkey,Security,9
1043,Cloud Deployment,7/5/2023,7/20/2023,5000,Completed,Ankara,Ankara,Turkey,Cloud,15
1044,App Maintenance,8/1/2023,8/12/2023,3000,Active,Istanbul,Marmara,Turkey,Development,11
1045,Website Optimization,9/1/2023,9/12/2023,2500,Completed,Izmir,Izmir,Turkey,Development,11
1046,Data Storage Services,10/1/2023,10/15/2023,4000,Completed,Ankara,Ankara,Turkey,Cloud,14
1047,SEO Services,11/10/2023,11/20/2023,2500,Active,Istanbul,Marmara,Turkey,Marketing,10
1048,IT Consulting,12/1/2023,12/10/2023,3500,Completed,Izmir,Izmir,Turkey,Consulting,9
1049,Cloud Computing Services,1/15/2023,1/25/2023,4500,Active,Ankara,Ankara,Turkey,Cloud,10
1050,Digital Transformation Consulting,2/1/2023,2/15/2023,3000,Completed,Izmir,Izmir,Turkey,Consulting,14
1051,AI Integration Services,3/5/2023,3/18/2023,5500,Completed,Istanbul,Marmara,Turkey,AI,13
1052,Database Management Services,4/1/2023,4/10/2023,3500,Active,Ankara,Ankara,Turkey,Cloud,9
1053,DevOps Consulting,5/1/2023,5/10/2023,4000,Completed,Izmir,Izmir,Turkey,Consulting,9
1054,Mobile App Marketing,6/10/2023,6/20/2023,2500,Active,Istanbul,Marmara,Turkey,Marketing,10
1055,Blockchain Solutions,7/1/2023,7/15/2023,5000,Completed,Ankara,Ankara,Turkey,Blockchain,14
1056,Web Application Security,8/1/2023,8/12/2023,3500,Active,Izmir,Izmir,Turkey,Security,11
1057,Cloud Security Solutions,9/10/2023,9/20/2023,4000,Completed,Istanbul,Marmara,Turkey,Security,10
1058,AI Research and Development,10/1/2023,10/12/2023,6000,Completed,Izmir,Izmir,Turkey,AI,11
1059,Website Security,11/1/2023,11/10/2023,3500,Completed,Ankara,Ankara,Turkey,Security,9
1060,Data Recovery Services,12/1/2023,12/10/2023,3000,Completed,Izmir,Izmir,Turkey,Cloud,9
1061,Cloud Platform Services,1/15/2023,1/28/2023,4500,Completed,Istanbul,Marmara,Turkey,Cloud,13
1062,Customer Support Solutions,2/1/2023,2/14/2023,2500,Active,Izmir,Izmir,Turkey,Support,13
1063,Software Testing Services,3/10/2023,3/22/2023,3500,Completed,Ankara,Ankara,Turkey,Development,12
1064,Cloud Infrastructure,4/1/2023,4/14/2023,4000,Active,Istanbul,Marmara,Turkey,Cloud,13
1065,Network Audit,5/5/2023,5/18/2023,3000,Completed,Izmir,Izmir,Turkey,Security,13
1066,Mobile Development Services,6/1/2023,6/10/2023,4500,Active,Ankara,Ankara,Turkey,Development,9
1067,IT Project Management,7/1/2023,7/13/2023,4000,Completed,Izmir,Izmir,Turkey,Consulting,12
1068,Software Architecture,8/1/2023,8/12/2023,5000,Completed,Istanbul,Marmara,Turkey,Development,11
1069,IT Outsourcing,9/1/2023,9/12/2023,3000,Completed,Ankara,Ankara,Turkey,Support,11
1070,IT Risk Assessment,10/5/2023,10/18/2023,4000,Completed,Izmir,Izmir,Turkey,Security,13
1071,Cloud Development,11/1/2023,11/15/2023,3500,Active,Istanbul,Marmara,Turkey,Cloud,14
1072,Website Design Services,12/5/2023,12/15/2023,2500,Completed,Ankara,Ankara,Turkey,Design,10
1073,Blockchain Development Consulting,1/1/2023,1/12/2023,4500,Completed,Izmir,Izmir,Turkey,Consulting,11
1074,Enterprise IT Solutions,2/5/2023,2/18/2023,5000,Completed,Ankara,Ankara,Turkey,Consulting,13
1075,SEO Audit Services,3/1/2023,3/14/2023,3000,Completed,Izmir,Izmir,Turkey,Marketing,13
1076,Mobile Application Development,4/15/2023,4/28/2023,5500,Active,Istanbul,Marmara,Turkey,Development,13
1077,AI Development Solutions,5/1/2023,5/15/2023,6000,Completed,Izmir,Izmir,Turkey,AI,14
1078,Cloud Storage Solutions,6/1/2023,6/10/2023,3000,Completed,Ankara,Ankara,Turkey,Cloud,9
1079,Data Center Solutions,7/15/2023,7/27/2023,4000,Active,Istanbul,Marmara,Turkey,Cloud,12
1080,Web Development Consulting,8/5/2023,8/18/2023,3500,Completed,Izmir,Izmir,Turkey,Consulting,13
1081,Software Integration Services,9/1/2023,9/13/2023,5000,Completed,Ankara,Ankara,Turkey,Development,12
1082,Network Security Services,10/5/2023,10/17/2023,4500,Active,Izmir,Izmir,Turkey,Security,12
1083,Software Solutions,11/15/2023,11/28/2023,4000,Completed,Istanbul,Marmara,Turkey,Development,13
1084,Website Development Solutions,12/1/2023,12/15/2023,3500,Completed,Izmir,Izmir,Turkey,Development,14
1085,Data Science Development,1/10/2023,1/20/2023,5000,Completed,Ankara,Ankara,Turkey,AI,10
1086,IT Strategy Consulting,2/1/2023,2/13/2023,4000,Active,Istanbul,Marmara,Turkey,Consulting,12
1087,Mobile App Design,3/1/2023,3/13/2023,3000,Completed,Izmir,Izmir,Turkey,Design,12
1088,Cloud Consulting Services,4/10/2023,4/22/2023,5000,Completed,Ankara,Ankara,Turkey,Cloud,12
1089,Infrastructure Management,5/5/2023,5/18/2023,4500,Completed,Izmir,Izmir,Turkey,Security,13
1090,Mobile Marketing,6/1/2023,6/13/2023,3500,Completed,Ankara,Ankara,Turkey,Marketing,12
1091,Custom Development,7/1/2023,7/13/2023,5500,Completed,Izmir,Izmir,Turkey,Development,12
1092,Network Optimization Services,8/10/2023,8/22/2023,4000,Completed,Ankara,Ankara,Turkey,Security,12
1093,Cloud Service Optimization,9/1/2023,9/13/2023,3500,Completed,Izmir,Izmir,Turkey,Cloud,12
1094,AI-Driven Solutions,10/1/2023,10/13/2023,5000,Active,Istanbul,Marmara,Turkey,AI,12
1095,IT Infrastructure Optimization,11/5/2023,11/18/2023,4000,Completed,Ankara,Ankara,Turkey,Consulting,13
1096,Web Application Optimization,12/1/2023,12/13/2023,3500,Completed,Izmir,Izmir,Turkey,Development,12
1097,Enterprise Security Services,1/1/2023,1/12/2023,4000,Completed,Istanbul,Marmara,Turkey,Security,11
1098,Web Design and Development,2/5/2023,2/18/2023,3500,Completed,Izmir,Izmir,Turkey,Design,13
1099,AI Solutions Integration,3/1/2023,3/13/2023,5000,Completed,Ankara,Ankara,Turkey,AI,12
1100,Data Analytics Consulting,4/1/2023,4/13/2023,3500,Completed,Izmir,Izmir,Turkey,Consulting,12
1101,Cloud Migration Services,5/1/2023,5/13/2023,4000,Completed,Ankara,Ankara,Turkey,Cloud,12
1102,Software as a Service (SaaS),6/1/2023,6/13/2023,5000,Active,Istanbul,Marmara,Turkey,Cloud,12
1103,Data Management Solutions,7/1/2023,7/13/2023,4500,Completed,Izmir,Izmir,Turkey,Cloud,12
1104,Network Management Services,8/1/2023,8/13/2023,3000,Completed,Ankara,Ankara,Turkey,Security,12
1105,Cloud-Based Software Solutions,9/1/2023,9/13/2023,4000,Completed,Izmir,Izmir,Turkey,Cloud,12
1106,IT Infrastructure Management,10/1/2023,10/13/2023,3500,Completed,Istanbul,Marmara,Turkey,Security,12
1107,Mobile App Development,11/1/2023,11/13/2023,4500,Completed,Ankara,Ankara,Turkey,Development,12
1108,Cloud Security Architecture,12/1/2023,12/13/2023,5000,Completed,Izmir,Izmir,Turkey,Security,12
1109,Blockchain Technology Solutions,1/10/2023,1/22/2023,5500,Completed,Ankara,Ankara,Turkey,Blockchain,12
1110,IT Systems Integration,2/1/2023,2/13/2023,4000,Active,Istanbul,Marmara,Turkey,Consulting,12
1111,Cloud Platform Development,3/5/2023,3/17/2023,5000,Completed,Izmir,Izmir,Turkey,Cloud,12
1112,Virtualization Services,4/1/2023,4/13/2023,3500,Completed,Ankara,Ankara,Turkey,Cloud,12
1113,AI-Based Analytics Services,5/1/2023,5/13/2023,6000,Completed,Istanbul,Marmara,Turkey,AI,12
1114,Web Optimization Services,6/1/2023,6/13/2023,3000,Completed,Izmir,Izmir,Turkey,Development,12
1115,IT Service Management,7/1/2023,7/13/2023,4000,Completed,Ankara,Ankara,Turkey,Consulting,12
1116,Digital Marketing Services,8/1/2023,8/13/2023,3500,Completed,Izmir,Izmir,Turkey,Marketing,12
1117,Data Center Optimization,9/1/2023,9/13/2023,5000,Completed,Ankara,Ankara,Turkey,Cloud,12
1118,Cloud Application Services,10/1/2023,10/13/2023,3500,Completed,Izmir,Izmir,Turkey,Cloud,12
1119,Website Development Solutions,11/1/2023,11/13/2023,4000,Completed,Ankara,Ankara,Turkey,Development,12
1120,Mobile App Security,12/1/2023,12/13/2023,3000,Active,Istanbul,Marmara,Turkey,Security,12
1121,Software Support Services,1/5/2023,1/18/2023,4000,Completed,Izmir,Izmir,Turkey,Support,13
1122,AI Integration Services,2/1/2023,2/13/2023,5000,Completed,Istanbul,Marmara,Turkey,AI,12
1123,Cloud Hosting Services,3/1/2023,3/13/2023,4500,Completed,Ankara,Ankara,Turkey,Cloud,12
1124,Software Development Solutions,4/1/2023,4/13/2023,5000,Completed,Izmir,Izmir,Turkey,Development,12
1125,Network Solutions,5/1/2023,5/13/2023,3500,Completed,Ankara,Ankara,Turkey,Security,12
1126,Data Analytics,6/1/2023,6/13/2023,4000,Completed,Izmir,Izmir,Turkey,AI,12
1127,Website Design and Development,7/1/2023,7/13/2023,3000,Completed,Ankara,Ankara,Turkey,Design,12
1128,Cloud Backup Solutions,8/1/2023,8/13/2023,4500,Completed,Izmir,Izmir,Turkey,Cloud,12
1129,Digital Transformation Services,9/1/2023,9/13/2023,5000,Completed,Istanbul,Marmara,Turkey,Consulting,12
1130,AI-Powered Solutions,10/1/2023,10/13/2023,6000,Completed,Ankara,Ankara,Turkey,AI,12
1131,Security and Compliance Services,11/1/2023,11/13/2023,4000,Completed,Izmir,Izmir,Turkey,Security,12
1132,Web Application Development,12/1/2023,12/13/2023,3500,Completed,Ankara,Ankara,Turkey,Development,12
1133,Enterprise Resource Planning,1/1/2023,1/13/2023,5000,Completed,Izmir,Izmir,Turkey,Consulting,12
1134,IT Disaster Recovery Services,2/1/2023,2/13/2023,4500,Completed,Istanbul,Marmara,Turkey,Cloud,12
1135,Mobile Solutions,3/1/2023,3/13/2023,4000,Completed,Ankara,Ankara,Turkey,Development,12
1136,Cloud Application Consulting,4/1/2023,4/13/2023,5000,Completed,Izmir,Izmir,Turkey,Cloud,12
1137,Blockchain Consulting,5/1/2023,5/13/2023,5500,Completed,Ankara,Ankara,Turkey,Blockchain,12
1138,Smart Automation Solutions,6/1/2023,6/13/2023,6000,Completed,Izmir,Izmir,Turkey,AI,12
1139,Network Security Solutions,7/1/2023,7/13/2023,4500,Completed,Istanbul,Marmara,Turkey,Security,12
1140,Custom Cloud Solutions,8/1/2023,8/13/2023,3500,Completed,Ankara,Ankara,Turkey,Cloud,12
1141,AI-Based Solutions,9/1/2023,9/13/2023,5000,Completed,Izmir,Izmir,Turkey,AI,12
1142,Data Center Services,10/1/2023,10/13/2023,4000,Completed,Ankara,Ankara,Turkey,Cloud,12
1143,IT Managed Services,11/1/2023,11/13/2023,3500,Completed,Istanbul,Marmara,Turkey,Security,12
1144,Digital Marketing and SEO,12/1/2023,12/13/2023,3000,Completed,Izmir,Izmir,Turkey,Marketing,12
1145,DevOps Solutions,1/1/2023,1/13/2023,4000,Completed,Ankara,Ankara,Turkey,Development,12
1146,Cloud Infrastructure Management,2/1/2023,2/13/2023,4500,Completed,Istanbul,Marmara,Turkey,Cloud,12
1147,Website Management Services,3/1/2023,3/13/2023,3500,Completed,Izmir,Izmir,Turkey,Development,12
1148,AI and Machine Learning,4/1/2023,4/13/2023,5000,Completed,Ankara,Ankara,Turkey,AI,12
1149,Web Hosting Services,5/1/2023,5/13/2023,3000,Completed,Istanbul,Marmara,Turkey,Cloud,12
1150,Custom Development Solutions,6/1/2023,6/13/2023,4500,Completed,Ankara,Ankara,Turkey,Development,12
"""

# Convert the input CSV data string into a list of dictionaries
def parse_csv_data(data):
    lines = data.strip().split("\n")
    reader = csv.DictReader(lines)
    return list(reader)

# Sort the CSV data by ServiceType
def sort_by_service_type(data):
    return sorted(data, key=lambda x: x["ServiceType"].lower())

# Write sorted data to a new CSV file
def write_sorted_csv(sorted_data, output_file):
    with open(output_file, "w", newline="", encoding="utf-8") as csvfile:
        fieldnames = sorted_data[0].keys()
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(sorted_data)

# Main execution
csv_rows = parse_csv_data(csv_data)
sorted_rows = sort_by_service_type(csv_rows)
write_sorted_csv(sorted_rows, "ServiceDataSort.csv")

print("CSV data sorted by ServiceType and saved to 'ServiceDataSort.csv'")
