-- Database: Database-001
use [Database-001]
go
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