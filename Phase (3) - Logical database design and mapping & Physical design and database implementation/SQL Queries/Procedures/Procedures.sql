-- Database: Database-001
use [Database-001]
go
--=======================================================================================================================
-- ###########################################################################
-- PROCEDURES FOR COMPANY TABLE CRUD OPERATIONS
-- These procedures perform Create, Read, Update, and Delete (CRUD) operations 
-- on the `Company` table with appropriate error handling and transactional support.
-- ###########################################################################
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- InsertCompany: Inserts a new company into the Company table.
-- Parameters:
--   @CompanyID (INT): Unique identifier for the company.
--   @CompanyName (VARCHAR(50)): Name of the company.
--   @TradeNumber (INT): Trade number of the company.
--   @Street (VARCHAR(50)): Street address of the company.
--   @City (VARCHAR(50)): City of the company.
--   @State (VARCHAR(50)): State of the company.
--   @Country (VARCHAR(50)): Country of the company.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE InsertCompany
    @CompanyID INT,
    @CompanyName VARCHAR(50),
    @TradeNumber INT,
    @Street VARCHAR(50),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Country VARCHAR(50)
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the CompanyID already exists in the Company table.
        IF EXISTS (SELECT 1 FROM Company WHERE CompanyID = @CompanyID)
        BEGIN
            THROW 50001, 'CompanyID already exists. Insert operation aborted.', 1;
        END;

        -- Perform the insert operation.
        INSERT INTO Company (CompanyID, CompanyName, TradeNumber, Street, City, State, Country)
        VALUES (@CompanyID, @CompanyName, @TradeNumber, @Street, @City, @State, @Country);

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC InsertCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Inc.',
    @TradeNumber = 12345,
    @Street = '789 Innovation Blvd',
    @City = 'Metropolis',
    @State = 'CA',
    @Country = 'USA';
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- GetCompany: Retrieves company information.
-- Parameters:
--   @CompanyID (INT, optional): The ID of the company to retrieve.
--     If NULL, retrieves all companies.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE GetCompany
    @CompanyID INT = NULL
AS
BEGIN
    BEGIN TRY
        -- If no CompanyID is provided, select all records.
        IF @CompanyID IS NULL
        BEGIN
            SELECT * FROM Company;
        END
        ELSE
        BEGIN
            -- Check if the specified CompanyID exists.
            IF NOT EXISTS (SELECT 1 FROM Company WHERE CompanyID = @CompanyID)
            BEGIN
                THROW 50002, 'CompanyID not found. Read operation aborted.', 1;
            END;

            -- Retrieve the company record matching the provided CompanyID.
            SELECT * FROM Company WHERE CompanyID = @CompanyID;
        END;
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur during the read operation.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC GetCompany;
-- ---------------------------------------------------------------------------
-- Example usage with parameter:
EXEC GetCompany 
    @CompanyID = 201;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- UpdateCompany: Updates company information.
-- Parameters:
--   @CompanyID (INT): The ID of the company to update.
--   @CompanyName, @TradeNumber, @Street, @City, @State, @Country (optional): 
--     Fields to update. If NULL, the field remains unchanged.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE UpdateCompany
    @CompanyID INT,
    @CompanyName VARCHAR(50) = NULL,
    @TradeNumber INT = NULL,
    @Street VARCHAR(50) = NULL,
    @City VARCHAR(50) = NULL,
    @State VARCHAR(50) = NULL,
    @Country VARCHAR(50) = NULL
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified CompanyID exists.
        IF NOT EXISTS (SELECT 1 FROM Company WHERE CompanyID = @CompanyID)
        BEGIN
            THROW 50003, 'CompanyID not found. Update operation aborted.', 1;
        END;

        -- Perform the update operation, using ISNULL to retain current values for NULL parameters.
        UPDATE Company
        SET
            CompanyName = ISNULL(@CompanyName, CompanyName),
            TradeNumber = ISNULL(@TradeNumber, TradeNumber),
            Street = ISNULL(@Street, Street),
            City = ISNULL(@City, City),
            State = ISNULL(@State, State),
            Country = ISNULL(@Country, Country)
        WHERE CompanyID = @CompanyID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage with full update:
EXEC UpdateCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Innovators Limited',
    @TradeNumber = 67890,
    @Street = '456 Research Park Drive',
    @City = 'Innovation City',
    @State = 'NY',
    @Country = 'USA';
-- ---------------------------------------------------------------------------
-- Example usage with partial update:
EXEC UpdateCompany 
    @CompanyID = 201,
    @CompanyName = 'Tech Updates Co.',
    @City = 'Silicon Valley';
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- DeleteCompany: Deletes a company from the Company table.
-- Parameters:
--   @CompanyID (INT): The ID of the company to delete.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE DeleteCompany
    @CompanyID INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified CompanyID exists.
        IF NOT EXISTS (SELECT 1 FROM Company WHERE CompanyID = @CompanyID)
        BEGIN
            THROW 50004, 'CompanyID not found. Delete operation aborted.', 1;
        END;

        -- Perform the delete operation.
        DELETE FROM Company WHERE CompanyID = @CompanyID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteCompany 
    @CompanyID = 201;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ###########################################################################
-- PROCEDURES FOR CUSTOMER TABLE CRUD OPERATIONS
-- These procedures perform Create, Read, Update, and Delete (CRUD) operations 
-- on the `Customer` table with appropriate error handling and transactional support.
-- ###########################################################################
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- InsertCustomer: Inserts a new customer into the Customer table.
-- Parameters:
--   @CustomerID (INT): Unique identifier for the customer.
--   @CustomerName (VARCHAR(50)): Name of the customer.
--   @Email (VARCHAR(50)): Email address of the customer.
--   @TelephoneNo (VARCHAR(50)): Telephone number of the customer.
--   @Street (VARCHAR(50)): Street address of the customer.
--   @City (VARCHAR(50)): City of the customer.
--   @State (VARCHAR(50)): State of the customer.
--   @Country (VARCHAR(50)): Country of the customer.
--   @CompanyID (INT): The ID of the company associated with the customer.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE InsertCustomer
    @CustomerID INT,
    @CustomerName VARCHAR(50),
    @Email VARCHAR(50),
    @TelephoneNo VARCHAR(50),
    @Street VARCHAR(50),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Country VARCHAR(50),
    @CompanyID INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the CustomerID already exists in the Customer table.
        IF EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 50005, 'CustomerID already exists. Insert operation aborted.', 1;
        END;

        -- Perform the insert operation.
        INSERT INTO Customer (CustomerID, CustomerName, Email, TelephoneNo, Street, City, State, Country, CompanyID)
        VALUES (@CustomerID, @CustomerName, @Email, @TelephoneNo, @Street, @City, @State, @Country, @CompanyID);

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
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
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- GetCustomer: Retrieves customer information.
-- Parameters:
--   @CustomerID (INT, optional): The ID of the customer to retrieve.
--     If NULL, retrieves all customers.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE GetCustomer
    @CustomerID INT = NULL
AS
BEGIN
    BEGIN TRY
        -- If no CustomerID is provided, select all records.
        IF @CustomerID IS NULL
        BEGIN
            SELECT * FROM Customer;
        END
        ELSE
        BEGIN
            -- Check if the specified CustomerID exists.
            IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @CustomerID)
            BEGIN
                THROW 50006, 'CustomerID not found. Read operation aborted.', 1;
            END;

            -- Retrieve the customer record matching the provided CustomerID.
            SELECT * FROM Customer WHERE CustomerID = @CustomerID;
        END;
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur during the read operation.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC GetCustomer;
-- ---------------------------------------------------------------------------
-- Example usage with parameter:
EXEC GetCustomer 
    @CustomerID = 101;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- UpdateCustomer: Updates customer information.
-- Parameters:
--   @CustomerID (INT): The ID of the customer to update.
--   @CustomerName, @Email, @TelephoneNo, @Street, @City, @State, @Country, 
--   @CompanyID (optional): Fields to update. If NULL, the field remains unchanged.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE UpdateCustomer
    @CustomerID INT,
    @CustomerName VARCHAR(50) = NULL,
    @Email VARCHAR(50) = NULL,
    @TelephoneNo VARCHAR(50) = NULL,
    @Street VARCHAR(50) = NULL,
    @City VARCHAR(50) = NULL,
    @State VARCHAR(50) = NULL,
    @Country VARCHAR(50) = NULL,
    @CompanyID INT = NULL
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified CustomerID exists.
        IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 50007, 'CustomerID not found. Update operation aborted.', 1;
        END;

        -- Perform the update operation, using ISNULL to retain current values for NULL parameters.
        UPDATE Customer
        SET
            CustomerName = ISNULL(@CustomerName, CustomerName),
            Email = ISNULL(@Email, Email),
            TelephoneNo = ISNULL(@TelephoneNo, TelephoneNo),
            Street = ISNULL(@Street, Street),
            City = ISNULL(@City, City),
            State = ISNULL(@State, State),
            Country = ISNULL(@Country, Country),
            CompanyID = ISNULL(@CompanyID, CompanyID)
        WHERE CustomerID = @CustomerID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage with full update:
EXEC UpdateCustomer 
    @CustomerID = 101,
    @CustomerName = 'John A. Doe',
    @Email = 'john.adam.doe@example.com',
    @TelephoneNo = '987-654-3210',
    @Street = '456 Oak Street',
    @City = 'Shelbyville',
    @State = 'MO',
    @Country = 'USA',
    @CompanyID = 2;
-- ---------------------------------------------------------------------------
-- Example usage with partial update:
EXEC UpdateCustomer 
    @CustomerID = 101,
    @CustomerName = 'John Updated',
    @Email = 'john.updated@example.com';
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- DeleteCustomer: Deletes a customer from the Customer table.
-- Parameters:
--   @CustomerID (INT): The ID of the customer to delete.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE DeleteCustomer
    @CustomerID INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified CustomerID exists.
        IF NOT EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 50008, 'CustomerID not found. Delete operation aborted.', 1;
        END;

        -- Perform the delete operation.
        DELETE FROM Customer WHERE CustomerID = @CustomerID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteCustomer 
    @CustomerID = 101;
-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteCustomer 
    @CustomerID = 102;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
-- ======================================================================================================================
-- ###########################################################################
-- PROCEDURES FOR DEPARTMENT TABLE CRUD OPERATIONS
-- These procedures perform Create, Read, Update, and Delete (CRUD) operations
-- on the `Department` table with appropriate error handling and transactional support.
-- ###########################################################################
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- InsertDepartment: Inserts a new department into the Department table.
-- Parameters:
--   @DepartmentNo (INT): Unique identifier for the department.
--   @DepartmentName (VARCHAR(50)): Name of the department.
--   @NoOfEmployees (INT): Number of employees in the department.
--   @Mission (VARCHAR(100)): Mission statement of the department.
--   @CompanyID (INT): ID of the company the department belongs to.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE InsertDepartment
    @DepartmentNo INT,                  -- Unique identifier for the department
    @DepartmentName VARCHAR(50),        -- Name of the department
    @NoOfEmployees INT,                 -- Number of employees in the department
    @Mission VARCHAR(100),              -- Mission statement of the department
    @CompanyID INT                      -- ID of the company the department belongs to
AS
BEGIN
    -- Start a database transaction to ensure atomicity.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the DepartmentNo already exists in the table.
        IF EXISTS (SELECT 1 FROM Department WHERE DepartmentNo = @DepartmentNo)
        BEGIN
            THROW 51001, 'DepartmentNo already exists. Insert operation aborted.', 1;
        END;

        -- Insert a new record into the Department table.
        INSERT INTO Department (DepartmentNo, DepartmentName, NoOfEmployees, Mission, CompanyID)
        VALUES (@DepartmentNo, @DepartmentName, @NoOfEmployees, @Mission, @CompanyID);

        -- Commit the transaction after successful insertion.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of any errors.
        ROLLBACK TRANSACTION;
        THROW;  -- Re-throw the caught error for the caller to handle.
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC InsertDepartment 
    @DepartmentNo = 301,
    @DepartmentName = 'Research and Development',
    @NoOfEmployees = 25,
    @Mission = 'Drive innovation through research and development.',
    @CompanyID = 201;
-- ---------------------------------------------------------------------------
-- Example usage:
EXEC InsertDepartment
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering',
    @NoOfEmployees = 50,
    @Mission = 'Innovate technology solutions.',
    @CompanyID = 1;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- GetDepartment: Retrieves department information.
-- Parameters:
--   @DepartmentNo (INT, optional): The ID of the department to retrieve.
--     If NULL, retrieves all departments.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE GetDepartment
    @DepartmentNo INT = NULL           -- Optional parameter to fetch specific department details
AS
BEGIN
    BEGIN TRY
        -- If no DepartmentNo is provided, fetch all departments.
        IF @DepartmentNo IS NULL
        BEGIN
            SELECT * FROM Department;
        END
        ELSE
        BEGIN
            -- Validate if the provided DepartmentNo exists.
            IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentNo = @DepartmentNo)
            BEGIN
                THROW 51002, 'DepartmentNo not found. Read operation aborted.', 1;
            END;

            -- Fetch the details of the specified department.
            SELECT * FROM Department WHERE DepartmentNo = @DepartmentNo;
        END;
    END TRY
    BEGIN CATCH
        -- Re-throw the caught error for the caller to handle.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC GetDepartment;
-- ---------------------------------------------------------------------------
-- Example usage with parameter:
EXEC GetDepartment 
    @DepartmentNo = 101;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- UpdateDepartment: Updates the details of an existing department.
-- Parameters:
--   @DepartmentNo (INT): Unique identifier for the department to update.
--   @DepartmentName (VARCHAR(50), optional): New name of the department.
--   @NoOfEmployees (INT, optional): New number of employees in the department.
--   @Mission (VARCHAR(100), optional): New mission statement of the department.
--   @CompanyID (INT, optional): New company ID associated with the department.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE UpdateDepartment
    @DepartmentNo INT,
    @DepartmentName VARCHAR(50) = NULL,
    @NoOfEmployees INT = NULL,
    @Mission VARCHAR(100) = NULL,
    @CompanyID INT = NULL
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified DepartmentNo exists in the Department table.
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentNo = @DepartmentNo)
        BEGIN
            THROW 51003, 'DepartmentNo not found. Update operation aborted.', 1;
        END;

        -- Perform the update operation, using existing values if no new values are provided.
        UPDATE Department
        SET
            DepartmentName = ISNULL(@DepartmentName, DepartmentName),
            NoOfEmployees = ISNULL(@NoOfEmployees, NoOfEmployees),
            Mission = ISNULL(@Mission, Mission),
            CompanyID = ISNULL(@CompanyID, CompanyID)
        WHERE DepartmentNo = @DepartmentNo;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage with full update:
EXEC UpdateDepartment 
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering Department',
    @NoOfEmployees = 60,
    @Mission = 'Innovate technology solutions for a better future.',
    @CompanyID = 2;
-- ---------------------------------------------------------------------------
-- Example usage with partial update:
EXEC UpdateDepartment 
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering Department 2';
-- ---------------------------------------------------------------------------
-- Example usage with partial update:
EXEC UpdateDepartment 
    @DepartmentNo = 101,
    @DepartmentName = 'Engineering Department',
    @Mission = 'Drive technical innovation.';
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- DeleteDepartment: Deletes a department from the Department table.
-- Parameters:
--   @DepartmentNo (INT): The ID of the department to delete.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE DeleteDepartment
    @DepartmentNo INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified DepartmentNo exists in the Department table.
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentNo = @DepartmentNo)
        BEGIN
            THROW 51004, 'DepartmentNo not found. Delete operation aborted.', 1;
        END;

        -- Perform the delete operation.
        DELETE FROM Department WHERE DepartmentNo = @DepartmentNo;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteDepartment 
    @DepartmentNo = 101;
-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteDepartment 
    @DepartmentNo = 301;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ###########################################################################
-- PROCEDURES FOR ITEM TABLE CRUD OPERATIONS
-- These procedures perform Create, Read, Update, and Delete (CRUD) operations 
-- on the `Item` table with appropriate error handling and transactional support.
-- ###########################################################################
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- InsertItem: Inserts a new item into the Item table.
-- Parameters:
--   @ItemID (INT): Unique identifier for the item.
--   @ItemName (VARCHAR(50)): Name of the item.
--   @Quantity (INT): Quantity of the item in stock.
--   @Price (INT): Price of the item.
--   @CompanyID (INT): ID of the company associated with the item.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE InsertItem
    @ItemID INT,
    @ItemName VARCHAR(50),
    @Quantity INT,
    @Price INT,
    @CompanyID INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the ItemID already exists in the Item table.
        IF EXISTS (SELECT 1 FROM Item WHERE ItemID = @ItemID)
        BEGIN
            THROW 52001, 'ItemID already exists. Insert operation aborted.', 1;
        END;

        -- Perform the insert operation.
        INSERT INTO Item (ItemID, ItemName, Quantity, Price, CompanyID)
        VALUES (@ItemID, @ItemName, @Quantity, @Price, @CompanyID);

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC InsertItem 
    @ItemID = 1,
    @ItemName = 'Laptop',
    @Quantity = 50,
    @Price = 1000,
    @CompanyID = 1;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- GetItem: Retrieves item details from the Item table.
-- Parameters:
--   @ItemID (INT, optional): Unique identifier for a specific item. 
--                            If NULL, retrieves all items.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE GetItem
    @ItemID INT = NULL
AS
BEGIN
    BEGIN TRY
        -- If no ItemID is provided, fetch all items.
        IF @ItemID IS NULL
        BEGIN
            SELECT * FROM Item;
        END
        ELSE
        BEGIN
            -- Check if the specified ItemID exists.
            IF NOT EXISTS (SELECT 1 FROM Item WHERE ItemID = @ItemID)
            BEGIN
                THROW 52002, 'ItemID not found. Read operation aborted.', 1;
            END;

            -- Retrieve details of the specified item.
            SELECT * FROM Item WHERE ItemID = @ItemID;
        END;
    END TRY
    BEGIN CATCH
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
-- Retrieve all items:
EXEC GetItem;

-- Retrieve a specific item:
EXEC GetItem @ItemID = 1;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- UpdateItem: Updates the details of an existing item.
-- Parameters:
--   @ItemID (INT): Unique identifier for the item to update.
--   @ItemName (VARCHAR(50), optional): New name of the item.
--   @Quantity (INT, optional): New quantity of the item.
--   @Price (INT, optional): New price of the item.
--   @CompanyID (INT, optional): New company ID associated with the item.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE UpdateItem
    @ItemID INT,
    @ItemName VARCHAR(50) = NULL,
    @Quantity INT = NULL,
    @Price INT = NULL,
    @CompanyID INT = NULL
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified ItemID exists in the Item table.
        IF NOT EXISTS (SELECT 1 FROM Item WHERE ItemID = @ItemID)
        BEGIN
            THROW 52003, 'ItemID not found. Update operation aborted.', 1;
        END;

        -- Perform the update operation, using existing values if no new values are provided.
        UPDATE Item
        SET
            ItemName = ISNULL(@ItemName, ItemName),
            Quantity = ISNULL(@Quantity, Quantity),
            Price = ISNULL(@Price, Price),
            CompanyID = ISNULL(@CompanyID, CompanyID)
        WHERE ItemID = @ItemID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC UpdateItem 
    @ItemID = 1,
    @ItemName = 'Gaming Laptop',
    @Price = 1200;
-- ---------------------------------------------------------------------------
-- Example usage:
EXEC UpdateItem 
    @ItemID = 1,
    @Quantity = 45;
--=======================================================================================================================
--=======================================================================================================================   
-- ---------------------------------------------------------------------------
-- DeleteItem: Deletes an item from the Item table.
-- Parameters:
--   @ItemID (INT): Unique identifier for the item to delete.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE DeleteItem
    @ItemID INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified ItemID exists in the Item table.
        IF NOT EXISTS (SELECT 1 FROM Item WHERE ItemID = @ItemID)
        BEGIN
            THROW 52004, 'ItemID not found. Delete operation aborted.', 1;
        END;

        -- Perform the delete operation.
        DELETE FROM Item WHERE ItemID = @ItemID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteItem @ItemID = 1;
-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteItem @ItemID = 2;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ###########################################################################
-- PROCEDURES FOR SERVICE TABLE CRUD OPERATIONS
-- These procedures perform Create, Read, Update, and Delete (CRUD) operations 
-- on the `Service` table with appropriate error handling and transactional support.
-- ###########################################################################
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- InsertService: Inserts a new service into the Service table.
-- Parameters:
--   @ServiceID (INT): Unique identifier for the service.
--   @Name (VARCHAR(50)): Name of the service.
--   @StartDate (DATE): Start date of the service.
--   @EndDate (DATE): End date of the service.
--   @Price (INT): Price of the service.
--   @Status (VARCHAR(50)): Status of the service.
--   @City (VARCHAR(50)): City where the service is provided.
--   @State (VARCHAR(50)): State where the service is provided.
--   @Country (VARCHAR(50)): Country where the service is provided.
--   @Cloud (VARCHAR(50)): Cloud service type (optional).
--   @Security (VARCHAR(50)): Security service type (optional).
--   @Repair (VARCHAR(50)): Repair service type (optional).
--   @Network (VARCHAR(50)): Network service type (optional).
--   @SoftwareDev (VARCHAR(50)): Software development service type (optional).
--   @CompanyID (INT): ID of the company providing the service.
--   @DepartmentNo (INT): Department number associated with the service.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE InsertService
    @ServiceID INT,
    @Name VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @Price INT,
    @Status VARCHAR(50),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Country VARCHAR(50),
    @Cloud VARCHAR(50) = NULL,
    @Security VARCHAR(50) = NULL,
    @Repair VARCHAR(50) = NULL,
    @Network VARCHAR(50) = NULL,
    @SoftwareDev VARCHAR(50) = NULL,
    @CompanyID INT,
    @DepartmentNo INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the ServiceID already exists in the Service table.
        IF EXISTS (SELECT 1 FROM Service WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 53001, 'ServiceID already exists. Insert operation aborted.', 1;
        END;

        -- Perform the insert operation.
        INSERT INTO Service (
            ServiceID, Name, StartDate, EndDate, Price, Status, City, State, Country, Cloud, Security, Repair, Network, SoftwareDev, CompanyID, DepartmentNo
        )
        VALUES (
            @ServiceID, @Name, @StartDate, @EndDate, @Price, @Status, @City, @State, @Country, @Cloud, @Security, @Repair, @Network, @SoftwareDev, @CompanyID, @DepartmentNo
        );

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
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
-- ---------------------------------------------------------------------------
-- Example usage:
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
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- GetService: Retrieves service details from the Service table.
-- Parameters:
--   @ServiceID (INT, optional): Unique identifier for a specific service.
--                               If NULL, retrieves all services.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE GetService
    @ServiceID INT = NULL
AS
BEGIN
    BEGIN TRY
        -- If no ServiceID is provided, fetch all services.
        IF @ServiceID IS NULL
        BEGIN
            SELECT * FROM Service;
        END
        ELSE
        BEGIN
            -- Check if the specified ServiceID exists.
            IF NOT EXISTS (SELECT 1 FROM Service WHERE ServiceID = @ServiceID)
            BEGIN
                THROW 53002, 'ServiceID not found. Read operation aborted.', 1;
            END;

            -- Retrieve details of the specified service.
            SELECT * FROM Service WHERE ServiceID = @ServiceID;
        END;
    END TRY
    BEGIN CATCH
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
-- Retrieve all services:
EXEC GetService;
-- ---------------------------------------------------------------------------
-- Example usage with parameter:
-- Retrieve a specific service:
EXEC GetService @ServiceID = 1;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- UpdateService: Updates the details of an existing service.
-- Parameters:
--   @ServiceID (INT): Unique identifier for the service to update.
--   @Name (VARCHAR(50), optional): New name of the service.
--   @StartDate (DATE, optional): New start date of the service.
--   @EndDate (DATE, optional): New end date of the service.
--   @Price (INT, optional): New price of the service.
--   @Status (VARCHAR(50), optional): New status of the service.
--   @City (VARCHAR(50), optional): New city where the service is provided.
--   @State (VARCHAR(50), optional): New state where the service is provided.
--   @Country (VARCHAR(50), optional): New country where the service is provided.
--   @Cloud (VARCHAR(50), optional): New cloud service type.
--   @Security (VARCHAR(50), optional): New security service type.
--   @Repair (VARCHAR(50), optional): New repair service type.
--   @Network (VARCHAR(50), optional): New network service type.
--   @SoftwareDev (VARCHAR(50), optional): New software development service type.
--   @CompanyID (INT, optional): New company ID associated with the service.
--   @DepartmentNo (INT, optional): New department number associated with the service.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE UpdateService
    @ServiceID INT,
    @Name VARCHAR(50) = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @Price INT = NULL,
    @Status VARCHAR(50) = NULL,
    @City VARCHAR(50) = NULL,
    @State VARCHAR(50) = NULL,
    @Country VARCHAR(50) = NULL,
    @Cloud VARCHAR(50) = NULL,
    @Security VARCHAR(50) = NULL,
    @Repair VARCHAR(50) = NULL,
    @Network VARCHAR(50) = NULL,
    @SoftwareDev VARCHAR(50) = NULL,
    @CompanyID INT = NULL,
    @DepartmentNo INT = NULL
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified ServiceID exists in the Service table.
        IF NOT EXISTS (SELECT 1 FROM Service WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 53003, 'ServiceID not found. Update operation aborted.', 1;
        END;

        -- Perform the update operation, using existing values if no new values are provided.
        UPDATE Service
        SET
            Name = ISNULL(@Name, Name),
            StartDate = ISNULL(@StartDate, StartDate),
            EndDate = ISNULL(@EndDate, EndDate),
            Price = ISNULL(@Price, Price),
            Status = ISNULL(@Status, Status),
            City = ISNULL(@City, City),
            State = ISNULL(@State, State),
            Country = ISNULL(@Country, Country),
            Cloud = ISNULL(@Cloud, Cloud),
            Security = ISNULL(@Security, Security),
            Repair = ISNULL(@Repair, Repair),
            Network = ISNULL(@Network, Network),
            SoftwareDev = ISNULL(@SoftwareDev, SoftwareDev),
            CompanyID = ISNULL(@CompanyID, CompanyID),
            DepartmentNo = ISNULL(@DepartmentNo, DepartmentNo)
        WHERE ServiceID = @ServiceID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC UpdateService 
    @ServiceID = 1,
    @Name = 'Advanced Cloud Hosting',
    @Price = 6000;
-- ---------------------------------------------------------------------------
-- Example usage:
EXEC UpdateService 
    @ServiceID = 1,
    @Status = 'Inactive';
-- ---------------------------------------------------------------------------
--=======================================================================================================================
--=======================================================================================================================
-- ---------------------------------------------------------------------------
-- DeleteService: Deletes a service from the Service table.
-- Parameters:
--   @ServiceID (INT): Unique identifier for the service to delete.
-- ---------------------------------------------------------------------------
CREATE PROCEDURE DeleteService
    @ServiceID INT
AS
BEGIN
    -- Start a transaction to ensure atomicity of the operation.
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the specified ServiceID exists in the Service table.
        IF NOT EXISTS (SELECT 1 FROM Service WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 53004, 'ServiceID not found. Delete operation aborted.', 1;
        END;

        -- Delete related records in ServiceLog.
        DELETE FROM ServiceLog WHERE ServiceID = @ServiceID;

        -- Perform the delete operation on the Service table.
        DELETE FROM Service WHERE ServiceID = @ServiceID;

        -- Commit the transaction if no errors occurred.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error.
        ROLLBACK TRANSACTION;
        -- Re-throw the error for higher-level handling.
        THROW;
    END CATCH;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
EXEC DeleteService @ServiceID = 1;
-- ---------------------------------------------------------------------------
--=======================================================================================================================
