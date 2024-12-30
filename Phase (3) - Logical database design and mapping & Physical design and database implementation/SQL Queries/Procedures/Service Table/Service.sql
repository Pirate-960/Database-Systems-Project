-- Database: Database-001
use [Database-001]
go
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