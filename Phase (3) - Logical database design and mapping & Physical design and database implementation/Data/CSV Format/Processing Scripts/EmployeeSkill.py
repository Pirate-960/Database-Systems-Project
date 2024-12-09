import pandas as pd
from io import StringIO

# Original data with semicolon-separated skills
employee_data = """
EmployeeID,Skill
1,JavaScript;TypeScript;Node.js
2,Data Analysis;SQL;Excel
3,Cloud Computing;Networking;Python
4,CICD;Docker;Kubernetes
5,Agile Methodologies;Project Management;Leadership
6,Penetration Testing;Security Audits;Networking
7,SQL Server;Database Design;Performance Tuning
8,React.js;JavaScript;HTML/CSS
9,Routing and Switching;Network Security;Firewall Configuration
10,Automation Testing;Java;JUnit
11,Node.js;JavaScript;Backend Development
12,Flutter;Dart;Mobile Development
13,Unity;C#;Game Development
14,Machine Learning;Python;Deep Learning
15,System Troubleshooting;Networking;Technical Support
16,User Research;UX Design;Wireframing
17,AWS;Cloud Computing;DevOps
18,Python;Machine Learning;Data Science
19,MERN Stack;JavaScript;React.js;Node.js
20,IT Strategy;Consulting;Cloud Architecture
21,Firewall Management;Security;Network Protection
22,System Design;Architecture;Database Design
23,Ansible;Automation;DevOps
24,NoSQL Databases;MongoDB;Database Architecture
25,Cisco Networking;Network Design;Router Configuration
26,Figma;UI Design;Prototyping
27,Django;Python;Web Development
28,Documentation;Technical Writing;API Documentation
29,Ethereum;Blockchain;Smart Contracts
30,HTML/CSS;JavaScript;Web Development
31,Kotlin;Android Development;Mobile Apps
32,Manual Testing;QA Testing;Automation Tools
33,Data Mining;Data Analysis;Machine Learning
34,Penetration Testing;Network Security;Ethical Hacking
35,Automation Testing;Test Automation;Selenium
36,Agile Methodologies;Project Management;Scrum
37,Unity;Game Design;VR Development
38,System Troubleshooting;Technical Support;Windows Administration
39,NoSQL Databases;MongoDB;Cassandra
40,Google Cloud Platform;Cloud Computing;DevOps
"""

# Read the data into a DataFrame
employee_df = pd.read_csv(StringIO(employee_data), skipinitialspace=True)

# Explode the skills into separate rows
employee_skills_table = employee_df.assign(Skill=employee_df['Skill'].str.split(';')).explode('Skill')

# Trim whitespace from the Skill column
employee_skills_table['Skill'] = employee_skills_table['Skill'].str.strip()

# Save the EmployeeSkills table to a CSV file
employee_skills_table.to_csv("EmployeeSkill.csv", index=False)

print("EmployeeSkills table has been saved as 'EmployeeSkill.csv'")
