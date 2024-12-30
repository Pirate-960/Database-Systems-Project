-- Database: Database-001
use [Database-001]
go
--=======================================================================================================================
-- -----------------------------------------------------------
-- Trigger: trg_AfterInsert_Service
-- -----------------------------------------------------------
-- This trigger fires after an INSERT operation on the Service table.
-- It logs the action in the ServiceLog table.
-- -----------------------------------------------------------
CREATE TRIGGER trg_AfterInsert_Service
ON Service
AFTER INSERT
AS
BEGIN
    -- Insert a log entry for each new service added
    INSERT INTO ServiceLog (ServiceID, Action, LogDate)
    SELECT ServiceID, 'INSERT', GETDATE()
    FROM INSERTED;
END;

-- ---------------------------------------------------------------------------
-- Example usage:
-- After inserting a new service, check the ServiceLog table for the log entry.
INSERT INTO Service (
    ServiceID, Name, StartDate, EndDate, Price, Status, City, State, Country, Repair, CompanyID, DepartmentNo
) VALUES (
    101010, 'Data Analytics Service', '2024-02-01', '2024-12-31', 8000, 'Active', 'San Francisco', 'CA', 'USA','Basic Repair', 1, 1
);

-- Check the ServiceLog table for the log entry.
SELECT * FROM ServiceLog;
-- ---------------------------------------------------------------------------
--=======================================================================================================================