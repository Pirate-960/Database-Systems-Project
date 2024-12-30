-- Database: Database-001
use [Database-001]
go
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
--=======================================================================================================================
