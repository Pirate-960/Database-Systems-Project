-- Database: Database-001
use [Database-001]
go
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
