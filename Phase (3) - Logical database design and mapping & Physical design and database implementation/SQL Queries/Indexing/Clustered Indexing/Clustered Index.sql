-- Database: Database-001
use [Database-001]
go
--=======================================================================================================================
-- Clustered indexing for the SsnNo column in the Employee table.
--=======================================================================================================================
-- Index on SsnNo in the Employee table
CREATE CLUSTERED INDEX idx_Employee_SsnNo ON Employee (SsnNo);
--=======================================================================================================================
-- Clustered indexing for the ServiceName column in the Service table.
CREATE CLUSTERED INDEX idx_Service_ServiceName ON Service (ServiceName);
-- =======================================================================================================================