-- Views

-- The following queries retrieve data from various views that provide summarized or detailed information
-- about different aspects of the database. Views are virtual tables that represent the result of a stored query.

-- Retrieves all columns from the CompanyOverview view, which likely provides a summary of company-related data.
SELECT * FROM CompanyOverview;

-- Retrieves all columns from the DepartmentEmployeeOverview view, which likely provides a summary of employees within departments.
SELECT * FROM DepartmentEmployeeOverview;

-- Retrieves all columns from the DepartmentItemOverview view, which likely provides a summary of items associated with departments.
SELECT * FROM DepartmentItemOverview;

-- Retrieves all columns from the ServiceStatusOverview view, which likely provides a summary of service statuses.
SELECT * FROM ServiceStatusOverview;


-- Triggers + Log Table

-- The following section demonstrates the use of triggers and a log table to track changes to the Service table.

-- Retrieves all columns from the Service table to show its current state before any modifications.
SELECT * FROM Service;

-- Inserts a new record into the Service table. This operation may trigger an associated trigger that logs the change.
INSERT INTO Service(ServiceID, Name, StartDate, EndDate, Price, Status, City, State, Country, Cloud, Security, Repair, Network, SoftwareDev, CompanyID, DepartmentNo)
Values(1, 'Special Servie', '2025-01-01', '2026-01-01', 100, 'Active', 'Istanbul', 'Esenyurt', 'Turkey', null, null, null, null, 'SoftwareDev', 1, 2);

-- Retrieves all columns from the ServiceLog table to show the log entries created by the trigger after the insert operation.
SELECT * FROM ServiceLog;

-- Retrieves all columns from the Service table to show its state after the insert operation.
SELECT * FROM Service;

-- Executes the DeleteService stored procedure to delete a service with the specified ServiceID.
EXEC DeleteService @ServiceID = 1;

-- Retrieves all columns from the Service table to show its state after the delete operation.
SELECT * FROM Service;

-- Retrieves all columns from the ServiceLog table to show the log entries created by the trigger after the delete operation.
SELECT * FROM ServiceLog;


-- Procedures

-- The following section demonstrates the use of stored procedures to perform CRUD (Create, Read, Update, Delete) operations
-- on various tables in the database.

-- Company Procedures

-- Retrieves all columns from the Company table to show its current state before any modifications.
SELECT * FROM Company;

-- Inserts a new record into the Company table using the InsertCompany stored procedure.
EXEC InsertCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Inc.',
    @TradeNumber = 12345,
    @Street = '789 Innovation Blvd',
    @City = 'Metropolis',
    @State = 'CA',
    @Country = 'USA';

-- Retrieves all columns from the Company table to show its state after the insert operation.
SELECT * FROM Company;

-- Deletes a record from the Company table using the DeleteCompany stored procedure.
SELECT * FROM Company;

EXEC DeleteCompany 
    @CompanyID = 201;

-- Retrieves all columns from the Company table to show its state after the delete operation.
SELECT * FROM Company;

-- Retrieves a specific record from the Company table using the GetCompany stored procedure.
SELECT * FROM Company;

EXEC GetCompany 
    @CompanyID = 1;

-- Retrieves all columns from the Company table to show its state after the get operation.
SELECT * FROM Company;

-- Updates a record in the Company table using the UpdateCompany stored procedure.
SELECT * FROM Company;
EXEC InsertCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Inc.',
    @TradeNumber = 12345,
    @Street = '789 Innovation Blvd',
    @City = 'Metropolis',
    @State = 'CA',
    @Country = 'USA';

-- Retrieves all columns from the Company table to show its state after the insert operation.
SELECT * FROM Company;

-- Performs a full update on a record in the Company table using the UpdateCompany stored procedure.
EXEC UpdateCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Limited',
    @TradeNumber = 67890,
    @Street = '456 Research Park Drive',
    @City = 'Innovation City',
    @State = 'NY',
    @Country = 'USA';

-- Retrieves all columns from the Company table to show its state after the full update operation.
SELECT * FROM Company;

-- Performs a partial update on a record in the Company table using the UpdateCompany stored procedure.
SELECT * FROM Company;
EXEC UpdateCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Updates Co.',
    @City = 'Silicon Valley';

-- Retrieves all columns from the Company table to show its state after the partial update operation.
SELECT * FROM Company;


-- Customer Procedures

-- Retrieves all columns from the Customer table to show its current state before any modifications.
SELECT * FROM Customer;

-- Inserts a new record into the Customer table using the InsertCustomer stored procedure.
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

-- Retrieves all columns from the Customer table to show its state after the insert operation.
SELECT * FROM Customer;

-- Deletes a record from the Customer table using the DeleteCustomer stored procedure.
SELECT * FROM Customer;

EXEC DeleteCustomer 
    @CustomerID = 10001;

-- Retrieves all columns from the Customer table to show its state after the delete operation.
SELECT * FROM Customer;

-- Retrieves records from the Customer table using the GetCustomer stored procedure.
SELECT * FROM Customer;

-- Example usage -- full table:
EXEC GetCustomer;

-- Example usage with parameter - specific record:
EXEC GetCustomer 
    @CustomerID = 101;


-- Updates a record in the Customer table using the UpdateCustomer stored procedure.
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

-- Retrieves all columns from the Customer table to show its state after the insert operation.
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

-- Retrieves all columns from the Customer table to show its state after the update operation.
SELECT * FROM Customer;


-- Department Procedures

-- Inserts a new record into the Department table using the InsertDepartment stored procedure.
SELECT * FROM Department;

EXEC InsertDepartment
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering',
    @NoOfEmployees = 50,
    @Mission = 'Innovate technology solutions.',
    @CompanyID = 1;

-- Retrieves all columns from the Department table to show its state after the insert operation.
SELECT * FROM Department;

-- Deletes a record from the Department table using the DeleteDepartment stored procedure.
SELECT * FROM Department;

EXEC DeleteDepartment 
    @DepartmentNo = 101;

-- Retrieves all columns from the Department table to show its state after the delete operation.
SELECT * FROM Department;

-- Retrieves records from the Department table using the GetDepartment stored procedure.
EXEC GetDepartment 
    @DepartmentNo = 10;

EXEC GetDepartment;

-- Retrieves all columns from the Department table to show its state after the get operation.
SELECT * FROM Department;


-- Updates a record in the Department table using the UpdateDepartment stored procedure.
SELECT * FROM Department;

EXEC InsertDepartment
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering',
    @NoOfEmployees = 50,
    @Mission = 'Innovate technology solutions.',
    @CompanyID = 1;

-- Retrieves all columns from the Department table to show its state after the insert operation.
SELECT * FROM Department;

EXEC UpdateDepartment 
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering Department',
    @NoOfEmployees = 60,
    @Mission = 'Innovate technology solutions for a better future.',
    @CompanyID = 1;

-- Retrieves all columns from the Department table to show its state after the update operation.
SELECT * FROM Department;

-- Items Procedures

-- Inserts a new record into the Item table using the InsertItem stored procedure.
SELECT * FROM Item;

EXEC InsertItem 
    @ItemID = 100,
    @ItemName = 'Laptop',
    @Quantity = 50,
    @Price = 1000,
    @CompanyID = 1;

-- Retrieves all columns from the Item table to show its state after the insert operation.
SELECT * FROM Item;

-- Deletes a record from the Item table using the DeleteItem stored procedure.
SELECT * FROM Item;
EXEC DeleteItem @ItemID = 100;

-- Retrieves all columns from the Item table to show its state after the delete operation.
SELECT * FROM Item;


-- Retrieves records from the Item table using the GetItem stored procedure.
SELECT * FROM Item;

-- Retrieve all items:
EXEC GetItem;

-- Retrieve a specific item:
EXEC GetItem @ItemID = 1;

-- Updates a record in the Item table using the UpdateItem stored procedure.
SELECT * FROM Item;

EXEC InsertItem 
    @ItemID = 100,
    @ItemName = 'Laptop',
    @Quantity = 50,
    @Price = 1000,
    @CompanyID = 1;

-- Retrieves all columns from the Item table to show its state after the insert operation.
SELECT * FROM Item;

EXEC UpdateItem 
    @ItemID = 100,
    @ItemName = 'Gaming Laptop',
    @Price = 1200;

-- Retrieves all columns from the Item table to show its state after the update operation.
SELECT * FROM Item;


-- Service Procedures

-- Inserts a new record into the Service table using the InsertService stored procedure.
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

-- Retrieves all columns from the Service table to show its state after the insert operation.
SELECT * FROM Service;

-- Retrieves all columns from the ServiceLog table to show the log entries created by the trigger after the insert operation.
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

-- Retrieves all columns from the Service table to show its state after the insert operation.
SELECT * FROM Service;

-- Retrieves all columns from the ServiceLog table to show the log entries created by the trigger after the insert operation.
SELECT * FROM ServiceLog;

-- Deletes a record from the Service table using the DeleteService stored procedure.
SELECT * FROM Service;
SELECT * FROM ServiceLog;

EXEC DeleteService @ServiceID = 1;

-- Retrieves all columns from the Service table to show its state after the delete operation.
SELECT * FROM Service;

-- Retrieves all columns from the ServiceLog table to show the log entries created by the trigger after the delete operation.
SELECT * FROM ServiceLog;


-- Retrieves records from the Service table using the GetService stored procedure.
SELECT * FROM Service;

-- Retrieve all services:
EXEC GetService;

-- Retrieve a specific service:
EXEC GetService @ServiceID = 2001;


-- Updates a record in the Service table using the UpdateService stored procedure.
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

-- Retrieves all columns from the Service table to show its state after the insert operation.
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

-- Retrieves all columns from the Service table to show its state after the insert operation.
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

-- Retrieves all columns from the Service table to show its state after the update operation.
SELECT * FROM Service;