-- Views

SELECT * FROM CompanyOverview;

SELECT * FROM DepartmentEmployeeOverview;

SELECT * FROM DepartmentEmployeeOverview;

SELECT * FROM ServiceStatusOverview;


-- Triggers + Log Table
SELECT * FROM Service;

INSERT INTO Service(ServiceID, Name, StartDate, EndDate, Price, Status, City, State, Country, Cloud, Security, Repair, Network, SoftwareDev, CompanyID, DepartmentNo)
Values(1, 'Special Servie', '2025-01-01', '2026-01-01', 100, 'Active', 'Istanbul', 'Esenyurt', 'Turkey', null, null, null, null, 'SoftwareDev', 1, 2);

SELECT * FROM ServiceLog;
SELECT * FROM Service;

EXEC DeleteService @ServiceID = 2;

SELECT * FROM Service;
SELECT * FROM ServiceLog;


-- Procedures
-- Company Procedures
SELECT * FROM Company;
-- Insert
EXEC InsertCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Inc.',
    @TradeNumber = 12345,
    @Street = '789 Innovation Blvd',
    @City = 'Metropolis',
    @State = 'CA',
    @Country = 'USA';

SELECT * FROM Company;

-- Delete
SELECT * FROM Company;

EXEC DeleteCompany 
    @CompanyID = 201;

SELECT * FROM Company;

-- Get
SELECT * FROM Company;

EXEC GetCompany 
    @CompanyID = 1;

SELECT * FROM Company;

-- Update
SELECT * FROM Company;
EXEC InsertCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Inc.',
    @TradeNumber = 12345,
    @Street = '789 Innovation Blvd',
    @City = 'Metropolis',
    @State = 'CA',
    @Country = 'USA';

SELECT * FROM Company;

-- Full Update
EXEC UpdateCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Limited',
    @TradeNumber = 67890,
    @Street = '456 Research Park Drive',
    @City = 'Innovation City',
    @State = 'NY',
    @Country = 'USA';
SELECT * FROM Company;

SELECT * FROM Company;
-- Partial update:
EXEC UpdateCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Updates Co.',
    @City = 'Silicon Valley';
SELECT * FROM Company;


-- Customer Procedures
SELECT * FROM Customer;
--
EXEC InsertCustomer 
    @CustomerID = 10001,
    @CustomerName = 'John Doe',
    @Email = 'johndoe@example.com',
    @TelephoneNo = '123-456-7890',
    @Street = '123 Elm Street',
    @City = 'Springfield',
    @State = 'IL',
    @Country = 'USA',
    @CompanyID = 1;

SELECT * FROM Customer;

-- Delete
SELECT * FROM Customer;

EXEC DeleteCustomer 
    @CustomerID = 10001;

SELECT * FROM Customer;



-- Get
SELECT * FROM Customer;

-- Example usage -- full table:
EXEC GetCustomer;

-- Example usage with parameter - specific record:
EXEC GetCustomer 
    @CustomerID = 101;


-- Update
SELECT * FROM Customer;
EXEC InsertCustomer 
    @CustomerID = 10001,
    @CustomerName = 'John Doe',
    @Email = 'johndoe@example.com',
    @TelephoneNo = '123-456-7890',
    @Street = '123 Elm Street',
    @City = 'Springfield',
    @State = 'IL',
    @Country = 'USA',
    @CompanyID = 1;
SELECT * FROM Customer;
EXEC UpdateCustomer 
    @CustomerID = 10001,
    @CustomerName = 'John A. Doe',
    @Email = 'john.adam.doe@example.com',
    @TelephoneNo = '987-654-3210',
    @Street = '456 Oak Street',
    @City = 'Shelbyville',
    @State = 'MO',
    @Country = 'USA',
    @CompanyID = 1;
SELECT * FROM Customer;


-- Department Procedures
-- Insert
SELECT * FROM Department;

EXEC InsertDepartment
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering',
    @NoOfEmployees = 50,
    @Mission = 'Innovate technology solutions.',
    @CompanyID = 1;

SELECT * FROM Department;

-- Delete
SELECT * FROM Department;

EXEC DeleteDepartment 
    @DepartmentNo = 101;

SELECT * FROM Department;

-- Get

EXEC GetDepartment 
    @DepartmentNo = 10;

EXEC GetDepartment;

SELECT * FROM Department;


-- Update
SELECT * FROM Department;

EXEC InsertDepartment
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering',
    @NoOfEmployees = 50,
    @Mission = 'Innovate technology solutions.',
    @CompanyID = 1;
SELECT * FROM Department;

EXEC UpdateDepartment 
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering Department',
    @NoOfEmployees = 60,
    @Mission = 'Innovate technology solutions for a better future.',
    @CompanyID = 1;

SELECT * FROM Department;

-- Items Procedures
-- Insert
SELECT * FROM Item;

EXEC InsertItem 
    @ItemID = 100,
    @ItemName = 'Laptop',
    @Quantity = 50,
    @Price = 1000,
    @CompanyID = 1;

SELECT * FROM Item;

-- Delete
SELECT * FROM Item;
EXEC DeleteItem @ItemID = 100;
SELECT * FROM Item;


-- Get
SELECT * FROM Item;
-- Retrieve all items:
EXEC GetItem;

-- Retrieve a specific item:
EXEC GetItem @ItemID = 1;

-- Update
SELECT * FROM Item;

EXEC InsertItem 
    @ItemID = 100,
    @ItemName = 'Laptop',
    @Quantity = 50,
    @Price = 1000,
    @CompanyID = 1;

SELECT * FROM Item;

EXEC UpdateItem 
    @ItemID = 100,
    @ItemName = 'Gaming Laptop',
    @Price = 1200;

SELECT * FROM Item;


-- Service Procedures
-- Insert
SELECT * FROM Service;

EXEC InsertService 
    @ServiceID = 1,
    @Name = 'Cloud Hosting',
    @StartDate = '2024-01-01',
    @EndDate = '2024-12-31',
    @Price = 5000,
    @Status = 'Active',
    @City = 'New York',
    @State = 'NY',
    @Country = 'USA',
    @Cloud = 'AWS',
    @CompanyID = 1,
    @DepartmentNo = 101;

SELECT * FROM Service;
SELECT * FROM ServiceLog;

EXEC InsertService 
    @ServiceID = 2,
    @Name = 'Network Security',
    @StartDate = '2024-01-01',
    @EndDate = '2024-12-31',
    @Price = 3000,
    @Status = 'Active',
    @City = 'San Francisco',
    @State = 'CA',
    @Country = 'USA',
    @Security = 'Firewall',
    @CompanyID = 2,
    @DepartmentNo = 201;

SELECT * FROM Service;
SELECT * FROM ServiceLog;

-- Delete

SELECT * FROM Service;
SELECT * FROM ServiceLog;

EXEC DeleteService @ServiceID = 1;

SELECT * FROM Service;
SELECT * FROM ServiceLog;


-- Get
SELECT * FROM Service;

-- Retrieve all services:
EXEC GetService;

-- Retrieve a specific service:
EXEC GetService @ServiceID = 2001;


-- Update
SELECT * FROM Service;

EXEC InsertService 
    @ServiceID = 1,
    @Name = 'Cloud Hosting',
    @StartDate = '2024-01-01',
    @EndDate = '2024-12-31',
    @Price = 5000,
    @Status = 'Active',
    @City = 'New York',
    @State = 'NY',
    @Country = 'USA',
    @Cloud = 'AWS',
    @CompanyID = 1,
    @DepartmentNo = 101;

SELECT * FROM Service;

EXEC InsertService 
    @ServiceID = 2,
    @Name = 'Network Security',
    @StartDate = '2024-01-01',
    @EndDate = '2024-12-31',
    @Price = 3000,
    @Status = 'Active',
    @City = 'San Francisco',
    @State = 'CA',
    @Country = 'USA',
    @Security = 'Firewall',
    @CompanyID = 1,
    @DepartmentNo = 101;

SELECT * FROM Service;

EXEC UpdateService 
    @ServiceID = 1,
    @Name = 'Advanced Cloud Hosting',
    @Price = 6000,
	@Cloud = 'Cloud';

	
EXEC UpdateService 
    @ServiceID = 2,
    @Name = 'Advanced Cloud Hosting',
    @Price = 6000,
	@Status = 'Completed',
	@Security = 'security';
SELECT * FROM Service;