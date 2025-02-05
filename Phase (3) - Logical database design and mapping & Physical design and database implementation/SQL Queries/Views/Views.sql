-- Database: Database-001
use [Database-001]
go
--=======================================================================================================================
-- Create a view named 'CompanyOverview' to summarize key company data
-- including the total number of employees, departments, services, 
-- and items for each company.
CREATE VIEW CompanyOverview AS
SELECT 
    -- Selecting the unique CompanyID from the Company table
    c.CompanyID,

    -- Selecting the company name
    c.CompanyName,

    -- Counting the total number of distinct employees in the company
    -- This provides the total number of employees associated with each company.
    COUNT(DISTINCT e.EmployeeID) AS [TotalEmployees],

    -- Counting the total number of distinct departments in the company
    -- This gives us the number of departments that belong to the company.
    COUNT(DISTINCT d.DepartmentNo) AS [TotalDepartments],

    -- Counting the total number of distinct services provided by the company
    -- This aggregates the distinct services the company is offering.
    COUNT(DISTINCT s.ServiceID) AS [TotalServices],

    -- Counting the total number of distinct items that the company sells or manages
    -- This will tell us how many distinct products or items are available for the company.
    COUNT(DISTINCT i.ItemID) AS [TotalItems]

FROM 
    -- The 'Company' table is the base table, representing each company in the database.
    Company c

-- Left join with the Employee table to count the number of employees for each company
-- LEFT JOIN ensures that companies with no employees are still included with a count of 0.
LEFT JOIN Employee e ON c.CompanyID = e.CompanyID

-- Left join with the Department table to count the number of departments for each company
-- A company with no departments will still be included in the result with a count of 0.
LEFT JOIN Department d ON c.CompanyID = d.CompanyID

-- Left join with the Service table to count the number of services offered by the company
-- Companies without services will still be included with a count of 0.
LEFT JOIN Service s ON c.CompanyID = s.CompanyID

-- Left join with the Item table to count the number of items sold or managed by the company
-- Companies without any items will still appear with a count of 0.
LEFT JOIN Item i ON c.CompanyID = i.CompanyID

-- Grouping the results by CompanyID and CompanyName to aggregate the counts for each company
-- Each unique company is returned with the summarized counts of employees, departments, services, and items.
GROUP BY 
    c.CompanyID, c.CompanyName;

-- Query to display the data from the CompanyOverview view
-- This will show the summarized company data with employee count, department count, service count, and item count.
select * from CompanyOverview;
--=======================================================================================================================
--=======================================================================================================================
-- Index creation for the CompanyID column in various tables to improve query performance.
-- Indexes are created on the CompanyID column in the Employee, Department, Service, Item, and Company tables.
-- This will speed up queries that involve filtering or joining based on the CompanyID.
--=======================================================================================================================
-- Index on CompanyID in the Employee table
CREATE INDEX idx_Employee_CompanyID ON Employee (CompanyID);

-- Index on CompanyID in the Department table
CREATE INDEX idx_Department_CompanyID ON Department (CompanyID);

-- Index on CompanyID in the Service table
CREATE INDEX idx_Service_CompanyID ON Service (CompanyID);

-- Index on CompanyID in the Item table
CREATE INDEX idx_Item_CompanyID ON Item (CompanyID);
--=======================================================================================================================
--=======================================================================================================================
-- Create a view to provide an overview of employee data within each department, 
-- including the total number of employees, the average salary, 
-- and the highest and lowest salary within each department.
CREATE VIEW DepartmentEmployeeOverview AS
SELECT 
    -- Department number from the Department table.
    d.DepartmentNo,

    -- Department name from the Department table.
    d.DepartmentName,

    -- Department mission from the Department table.
    d.Mission,

    -- Count the total number of employees in each department by counting the distinct EmployeeIDs.
    COUNT(e.EmployeeID) AS [TotalEmployees],

    -- Calculate the average salary of employees in the department.
    AVG(e.Salary) AS [AverageSalary],

    -- Find the highest salary among employees in the department.
    MAX(e.Salary) AS [HighestSalary],

    -- Find the lowest salary among employees in the department.
    MIN(e.Salary) AS [LowestSalary]

FROM 
    -- The Department table is used as the main table to fetch department data.
    Department d

-- Join the Employee table to the Department table based on the DepartmentNo.
-- This ensures that we retrieve employee data for each department.
JOIN Employee e ON d.DepartmentNo = e.DepartmentNo

-- Group the results by department number, name, and mission to calculate 
-- the aggregation values (COUNT, AVG, MAX, MIN) for each department.
GROUP BY 
    d.DepartmentNo, 
    d.DepartmentName, 
    d.Mission;

-- Query to display the data from the DepartmentEmployeeOverview view.
-- This will show the summarized department data with employee count, salary averages, 
-- and salary ranges for each department.
select * from DepartmentEmployeeOverview;
--=======================================================================================================================
--=======================================================================================================================
-- Create a view to provide an overview of the status of services offered by each company.
-- This includes the total number of services, the total service duration, and the average service duration,
-- grouped by the service status (e.g., active, completed, etc.) for each company.
CREATE VIEW ServiceStatusOverview AS
SELECT 
    -- The CompanyID from the Service table, which indicates the company that provides the service.
    s.CompanyID,

    -- The CompanyName from the Company table, which represents the name of the company providing the service.
    c.CompanyName,

    -- The Status of the service (e.g., 'active', 'completed', etc.) from the Service table.
    -- This will categorize the services by their current status.
    s.Status AS ServiceStatus,

    -- Count the total number of services per company and service status by counting distinct ServiceIDs.
    COUNT(s.ServiceID) AS [TotalServices],

    -- Sum the duration of all services per company and service status.
    -- This gives the total time or duration spent on services grouped by status.
    SUM(s.Duration) AS [TotalServiceDuration],

    -- Calculate the average duration of services per company and service status.
    -- This gives insight into the typical duration of a service provided by the company, grouped by status.
    AVG(s.Duration) AS [AverageServiceDuration]

FROM 
    -- The Service table is used as the main table to retrieve the services provided by companies.
    Service s

-- Join the Company table with the Service table using the CompanyID to get the company name associated with each service.
JOIN Company c ON s.CompanyID = c.CompanyID

-- Group the results by CompanyID, CompanyName, and Service Status to aggregate the service data.
-- This ensures that we get a summary of services per company and their respective statuses.
GROUP BY 
    s.CompanyID,        -- The CompanyID is grouped to aggregate data by company.
    c.CompanyName,      -- The CompanyName is included to show the company details in the result.
    s.Status;           -- The Service Status is included to categorize the data based on service status.

-- Query to display the data from the ServiceStatusOverview view.
-- This will show the summarized service data, including the number of services,
-- total service duration, and average service duration for each company and each service status.
select * from ServiceStatusOverview;
--=======================================================================================================================
--=======================================================================================================================
-- Create an advanced view summarizing item data for each department under the same company.
-- This view includes the total number of items, average item price, most expensive and least expensive item prices,
-- and the names of the most and least expensive items in each department.
CREATE VIEW DepartmentItemOverview AS
SELECT
    -- =========================================================================================
    -- Department Details: Fetching information specific to each department in the company.
    -- =========================================================================================
    d.DepartmentNo,                 -- Department Number: The unique identifier for each department.
    d.DepartmentName,               -- Department Name: The name of the department.
    d.Mission,                      -- Department Mission: The mission or purpose of the department.

    -- =========================================================================================
    -- Company Details: Fetching information about the company that owns the department.
    -- =========================================================================================
    c.CompanyID,                    -- Company ID: The unique identifier for each company.
    c.CompanyName,                  -- Company Name: The name of the company.

    -- =========================================================================================
    -- Aggregated Item Data: Calculating various statistics based on the items in the departments.
    -- =========================================================================================

    -- Total number of items in the department (across all departments within the company)
    COUNT(i.ItemID) AS [TotalItems],                        -- Counting the total distinct items in the department(s).
    
    -- Average price of items across the department(s). If no items exist, return 0.
    ISNULL(AVG(i.Price), 0) AS [AverageItemPrice],          -- Using ISNULL to handle cases where there are no items.
    
    -- Most expensive item price in the department. If no items exist, return 0.
    ISNULL(MAX(i.Price), 0) AS [MostExpensiveItemPrice],    -- Maximum price of items in the department(s).
    
    -- Least expensive item price in the department. If no items exist, return 0.
    ISNULL(MIN(i.Price), 0) AS [LeastExpensiveItemPrice],   -- Minimum price of items in the department(s).
    
    -- =========================================================================================
    -- Subquery for Most Expensive Item: Identifying the name of the most expensive item in the department.
    -- =========================================================================================
    (SELECT TOP 1 i1.ItemName                               -- Subquery to select the name of the most expensive item in the department
     FROM Item i1 
     JOIN Department d1 ON d1.CompanyID = i1.CompanyID      -- Joining with Department to link item to the right department
     WHERE d1.DepartmentNo = d.DepartmentNo                 -- Filtering by the current department number
     ORDER BY i1.Price DESC) AS [MostExpensiveItemName],    -- Sorting by price in descending order to get the most expensive item.

    -- =========================================================================================
    -- Subquery for Least Expensive Item: Identifying the name of the least expensive item in the department.
    -- =========================================================================================
    (SELECT TOP 1 i2.ItemName                               -- Subquery to select the name of the least expensive item in the department
     FROM Item i2 
     JOIN Department d2 ON d2.CompanyID = i2.CompanyID      -- Joining with Department to link item to the correct department
     WHERE d2.DepartmentNo = d.DepartmentNo                 -- Filtering by department number to target the right department
     ORDER BY i2.Price ASC) AS [LeastExpensiveItemName]     -- Sorting by price in ascending order to get the least expensive item.

FROM 
    -- =========================================================================================
    -- Base Table: Department
    -- =========================================================================================
    Department d                                -- The main table representing departments in the company.

-- =========================================================================================
-- Join the Company table to link departments to their respective companies.
-- =========================================================================================
JOIN Company c ON d.CompanyID = c.CompanyID     -- Joining the Company table to retrieve company-related information.

-- =========================================================================================
-- Join the Item table to link items with the departments.
-- Using LEFT JOIN to include departments that do not have any items.
-- =========================================================================================
LEFT JOIN Item i ON c.CompanyID = i.CompanyID   -- Linking departments with items based on the CompanyID, to ensure we get item data.

-- =========================================================================================
-- Grouping the results by department and company to calculate aggregate values.
-- =========================================================================================
GROUP BY 
    d.DepartmentNo,     -- Grouping by department number for department-specific aggregation.
    d.DepartmentName,   -- Grouping by department name for better readability in the result.
    d.Mission,          -- Grouping by department mission to include that context in the result.
    c.CompanyID,        -- Grouping by CompanyID to ensure the statistics are specific to each company.
    c.CompanyName;      -- Grouping by company name for better context in the results.

-- =========================================================================================
-- Query to test and display data from the newly created view
-- =========================================================================================
SELECT * FROM DepartmentItemOverview;

-- =========================================================================================
-- Query to display departments with no items (total items = 0)
-- =========================================================================================
SELECT * FROM DepartmentItemOverview WHERE TotalItems = 0;

-- =========================================================================================
-- Query to display departments that have items (total items > 0)
-- =========================================================================================
SELECT * FROM DepartmentItemOverview WHERE TotalItems > 0;

-- =========================================================================================
-- Query to display departments and their respective item price ranges.
-- This checks if there are any items with price ranges above 0 (for departments with items).
-- =========================================================================================
SELECT * FROM DepartmentItemOverview WHERE MostExpensiveItemPrice > 0 OR LeastExpensiveItemPrice > 0;
--=======================================================================================================================

