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