-- Database: Database-001
use [Database-001]
go
--=======================================================================================================================
-- Non-clustered indexing for the CompanyID column in the Employee, Department, Service, and Item tables.
--=======================================================================================================================
-- Index on CompanyID in the Employee table
CREATE NONCLUSTERED INDEX idx_Employee_CompanyID ON Employee (CompanyID);

-- Index on CompanyID in the Department table
CREATE NONCLUSTERED INDEX idx_Department_CompanyID ON Department (CompanyID);

-- Index on CompanyID in the Service table
CREATE NONCLUSTERED INDEX idx_Service_CompanyID ON Service (CompanyID);

-- Index on CompanyID in the Item table
CREATE NONCLUSTERED INDEX idx_Item_CompanyID ON Item (CompanyID);