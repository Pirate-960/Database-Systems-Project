-- Database: Database-001
use [Database-001]
go
-- ===========================================================
-- Company Table
-- -----------------------------------------------------------
-- This table stores information about companies, including:
-- their name, trade registration, and contact details.
-- ===========================================================

CREATE TABLE Company (
    CompanyID INT PRIMARY KEY,              -- Unique identifier for the company
    CompanyName VARCHAR(50) NOT NULL,       -- Name of the company (cannot be null)
    TradeNumber INT NOT NULL,               -- Trade registration number of the company (cannot be null)
    Street VARCHAR(50) NOT NULL,            -- Street address of the company (cannot be null)
    City VARCHAR(50) NOT NULL,              -- City where the company is located (cannot be null)
    State VARCHAR(50) NOT NULL,             -- State where the company is located (cannot be null)
    Country VARCHAR(50) NOT NULL            -- Country where the company is located (cannot be null)
);

-- ===========================================================
-- Employee Table
-- -----------------------------------------------------------
-- This table stores information about employees, including:
-- personal details, job position, salary, and computed age.
-- ===========================================================

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,             -- Unique identifier for the employee
    FirstName VARCHAR(50) NOT NULL,         -- First name of the employee (cannot be null)
    LastName VARCHAR(50) NOT NULL,          -- Last name of the employee (cannot be null)
    Birthdate DATE NOT NULL,                -- Date of birth of the employee (cannot be null)
    SsnNo VARCHAR(50) NOT NULL,             -- Social Security Number (must be unique)
    
    -- ===========================================================
    -- Computed Age Column
    -- -----------------------------------------------------------
    -- The Age is calculated based on the birthdate, considering 
    -- the current date and whether the employee has had their 
    -- birthday yet this year.
    -- ===========================================================
    Age AS (
        DATEDIFF(YEAR, Birthdate, GETDATE()) - 
        CASE WHEN MONTH(Birthdate) > MONTH(GETDATE()) OR 
                  (MONTH(Birthdate) = MONTH(GETDATE()) AND DAY(Birthdate) > DAY(GETDATE())) 
             THEN 1 
             ELSE 0 
        END
    ),
    
    Position VARCHAR(50) NOT NULL,          -- Job position of the employee (cannot be null)
    HireDate DATE NOT NULL,                 -- Date the employee was hired (cannot be null)
    Salary INT NOT NULL,                    -- Salary of the employee (cannot be null)
    DepartmentNo INT NOT NULL,              -- Department number of the employee (cannot be null)
    CompanyID INT NOT NULL,                 -- ID of the company the employee belongs to (cannot be null)

    -- ===========================================================
    -- Foreign Key Constraint to Department Table
    -- -----------------------------------------------------------
    -- Links to Department table to reference the department the employee belongs to.
    FOREIGN KEY (DepartmentNo) REFERENCES Department(DepartmentNo),

    -- ===========================================================
    -- Foreign Key Constraint to Company Table
    -- -----------------------------------------------------------
    -- Links to Company table to reference the company the employee belongs to.
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- ===========================================================
-- EmployeeSkill Table (Relation for Multivalued Attribute)
-- -----------------------------------------------------------
-- This table stores the relationship between employees and 
-- the skills they possess, linking the Employee and Skill tables.
-- ===========================================================

CREATE TABLE EmployeeSkill (
    EmployeeID INT NOT NULL,                -- ID of the employee (cannot be null)
    Skill VARCHAR(50) NOT NULL,             -- Name of the skill (cannot be null)
    
    -- ===========================================================
    -- Foreign Key Constraints
    -- -----------------------------------------------------------
    -- Links to Employee table to reference the employee with the skill.
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    
    -- Primary key constraint to ensure each combination of employee and skill is unique
    PRIMARY KEY (EmployeeID, Skill)
);

-- ===========================================================
-- Department Table
-- -----------------------------------------------------------
-- This table stores information about departments within a
-- company, including department details and the company they
-- belong to.
-- ===========================================================

CREATE TABLE Department (
    DepartmentNo INT PRIMARY KEY,           -- Unique identifier for the department
    DepartmentName VARCHAR(50) NOT NULL,    -- Name of the department (cannot be null)
    NoOfEmployees INT NOT NULL,             -- Number of employees in the department (cannot be null)
    Mission VARCHAR(100) NOT NULL,           -- Mission statement of the department (cannot be null)
    CompanyID INT NOT NULL,                 -- ID of the company the department belongs to (cannot be null)
    
    -- ===========================================================
    -- Foreign Key Constraint to Company Table
    -- -----------------------------------------------------------
    -- Links to Employee table to reference the department manager.
    -- FOREIGN KEY (ManagerID) REFERENCES Employee(EmployeeID),

    -- ===========================================================
    -- Foreign Key Constraint to Company Table
    -- -----------------------------------------------------------
    -- Links to Company table to reference the company the department belongs to.
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);


-- ===========================================================
-- Service Table
-- -----------------------------------------------------------
-- This table stores information about services provided by 
-- the company, including service details, duration, and pricing.
-- ===========================================================

CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,               -- Unique identifier for the service
    Name VARCHAR(50) NOT NULL,               -- Name of the service (cannot be null)
    StartDate DATE NOT NULL,                 -- Start date of the service (cannot be null)
    EndDate DATE NOT NULL,                   -- End date of the service (cannot be null)
    Price INT NOT NULL,                      -- Price of the service (cannot be null)
    Status VARCHAR(50) NOT NULL,             -- Status of the service (cannot be null)
    City VARCHAR(50) NOT NULL,               -- City where the service is provided (cannot be null)
    State VARCHAR(50) NOT NULL,              -- State where the service is provided (cannot be null)
    Country VARCHAR(50) NOT NULL,            -- Country where the service is provided (cannot be null)
    Cloud VARCHAR(50),                       -- Cloud Service Type
    Security VARCHAR(50),                    -- Security Service Type
    Repair VARCHAR(50),                      -- Repair Service Type
    Network VARCHAR(50),                     -- Network Service Type
    SoftwareDev VARCHAR(50),                 -- Software Development Service Type

    -- ===========================================================
    -- Computed Duration Column
    -- -----------------------------------------------------------
    -- The Duration of the service is computed as the difference 
    -- in days between the EndDate and StartDate.
    -- ===========================================================
    Duration AS (DATEDIFF(DAY, StartDate, EndDate)),

    CompanyID INT NOT NULL,                  -- ID of the company providing the service (cannot be null)
    DepartmentNo INT NOT NULL,               -- Department number associated with the service (cannot be null)

    -- ===========================================================
    -- Foreign Key Constraint to Company Table
    -- -----------------------------------------------------------
    -- Ensures the service is linked to a valid company.
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID),

    -- ===========================================================
    -- Foreign Key Constraint to Department Table
    -- -----------------------------------------------------------
    -- Ensures the service is associated with a valid department.
    FOREIGN KEY (DepartmentNo) REFERENCES Department(DepartmentNo)
);

-- ===========================================================
-- Customer Table
-- -----------------------------------------------------------
-- This table stores information about customers, including:
-- customer details, contact information, and their associated company.
-- ===========================================================

create table Customer(
    CustomerID int primary key,          -- Unique identifier for each customer
    CustomerName varchar(50) not null,   -- Name of the customer (cannot be null)
    Email varchar(50) not null,          -- Email address of the customer (cannot be null)
    TelephoneNo varchar(50) not null,    -- Telephone number of the customer (cannot be null)
    Street varchar(50) not null,         -- Street address of the customer (cannot be null)
    City varchar(50) not null,           -- City where the customer resides (cannot be null)
    State varchar(50) not null,          -- State where the customer resides (cannot be null)
    Country varchar(50) not null,        -- Country where the customer resides (cannot be null)
    CompanyID int not null,              -- ID of the company associated with the customer (cannot be null)
    
    -- ===========================================================
    -- Foreign Key Constraint to Company Table
    -- -----------------------------------------------------------
    -- References the Company table to ensure the customer is associated with a valid company.
    -- ===========================================================
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- ===========================================================
-- Item Table
-- -----------------------------------------------------------
-- This table stores information about items, including:
-- item details such as quantity, price, and the associated company.
-- ===========================================================

create table Item (
    ItemID int primary key,               -- Unique identifier for each item
    ItemName varchar(50) not null,        -- Name of the item (cannot be null)
    Quantity int not null,                -- Quantity of the item in stock (cannot be null)
    Price int not null,                   -- Price of the item (cannot be null)
    CompanyID int not null,               -- ID of the company that sells the item (cannot be null)
    
    -- ===========================================================
    -- Foreign Key Constraint
    -- -----------------------------------------------------------
    -- References the Company table to ensure the item is associated with a valid company.
    -- ===========================================================
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- ===========================================================
-- EmployeeAppliedService Table
-- -----------------------------------------------------------
-- This table tracks which employees applied specific services.
-- ===========================================================

CREATE TABLE EmployeeAppliedService (
    EmployeeID INT NOT NULL,                -- ID of the employee who applied the service
    ServiceID INT NOT NULL,                 -- ID of the applied service
    
    -- ===========================================================
    -- Foreign Key Constraint to Employee Table
    -- -----------------------------------------------------------
    -- Links to Employee table to reference the employee.
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    
    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    
    -- Primary key constraint ensures unique combination of EmployeeID and ServiceID
    PRIMARY KEY (EmployeeID, ServiceID)
);

-- ===========================================================
-- CustomerRequestedService Table
-- -----------------------------------------------------------
-- This table tracks which customers requested specific services.
-- ===========================================================

CREATE TABLE CustomerRequestedService (
    CustomerID INT NOT NULL,                -- ID of the customer requesting the service
    ServiceID INT NOT NULL,                 -- ID of the requested service
    
    -- ===========================================================
    -- Foreign Key Constraint to Customer Table
    -- -----------------------------------------------------------
    -- Links to Customer table to reference the customer.
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    
    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    
    -- Primary key constraint ensures unique combination of CustomerID and ServiceID
    PRIMARY KEY (CustomerID, ServiceID)
);

-- ===========================================================
-- CustomerPurchasedItem Table
-- -----------------------------------------------------------
-- This table tracks which customers purchased specific items.
-- ===========================================================

CREATE TABLE CustomerPurchasedItem (
    CustomerID INT NOT NULL,                -- ID of the customer purchasing the item
    ItemID INT NOT NULL,                    -- ID of the purchased item
    
    -- ===========================================================
    -- Foreign Key Constraint to Customer Table
    -- -----------------------------------------------------------
    -- Links to Customer table to reference the customer.
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    
    -- ===========================================================
    -- Foreign Key Constraint to Item Table
    -- -----------------------------------------------------------
    -- Links to Item table to reference the item.
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    
    -- Primary key constraint ensures unique combination of CustomerID and ItemID
    PRIMARY KEY (CustomerID, ItemID)
);

-- ===========================================================
-- ServiceUsedItem Table
-- -----------------------------------------------------------
-- This table tracks which items were used for specific services.
-- ===========================================================

CREATE TABLE ServiceUsedItem (
    ServiceID INT NOT NULL,                 -- ID of the service where the item was used
    ItemID INT NOT NULL,                    -- ID of the item used in the service
    
    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    
    -- ===========================================================
    -- Foreign Key Constraint to Item Table
    -- -----------------------------------------------------------
    -- Links to Item table to reference the item.
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    
    -- Primary key constraint ensures unique combination of ItemID and ServiceID
    PRIMARY KEY (ServiceID, ItemID)
);

-- ===========================================================
-- EmployeeSoldItem Table
-- -----------------------------------------------------------
-- This table tracks which employees sold specific items.
-- ===========================================================

CREATE TABLE EmployeeSoldItem (
    EmployeeID INT NOT NULL,                -- ID of the employee who sold the item
    ItemID INT NOT NULL,                    -- ID of the sold item
    
    -- ===========================================================
    -- Foreign Key Constraint to Employee Table
    -- -----------------------------------------------------------
    -- Links to Employee table to reference the employee.
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    
    -- ===========================================================
    -- Foreign Key Constraint to Item Table
    -- -----------------------------------------------------------
    -- Links to Item table to reference the item.
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    
    -- Primary key constraint ensures unique combination of EmployeeID and ItemID
    PRIMARY KEY (EmployeeID, ItemID)
);

-- ===========================================================
-- CloudSolutionService Table (Subtype of Service)
-- ===========================================================
CREATE TABLE CloudSolutionService (
    CloudServiceID INT PRIMARY KEY,          -- Unique identifier for the cloud service
    CloudServiceProvider VARCHAR(50),        -- Name of the cloud service provider
    StorageSize VARCHAR(50),                 -- Size of storage in GB

    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (CloudServiceID) REFERENCES Service(ServiceID)
);

-- ===========================================================
-- SecuritySystemService Table (Subtype of Service)
-- ===========================================================
CREATE TABLE SecuritySystemService (
    SecurityServiceID INT PRIMARY KEY,       -- Unique identifier for the security service
    SecurityApp VARCHAR(50),                 -- Name of the security application
    SecurityPackageType VARCHAR(50),         -- Type of the security package

    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (SecurityServiceID) REFERENCES Service(ServiceID)
);

-- ===========================================================
-- NetworkManagementService Table (Subtype of Service)
-- ===========================================================
CREATE TABLE NetworkManagementService (
    NetworkServiceID INT PRIMARY KEY,        -- Unique identifier for the network service
    BandwidthUsage VARCHAR(50),              -- Bandwidth usage in GBs
    NetworkType VARCHAR(50),                 -- Type of the network
    NetworkProvider VARCHAR(50),             -- Name of the network provider

    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (NetworkServiceID) REFERENCES Service(ServiceID)
);

-- ===========================================================
-- SoftwareDevelopmentService Table (Subtype of Service)
-- ===========================================================
CREATE TABLE SoftwareDevelopmentService (
    SoftwareServiceID INT PRIMARY KEY,       -- Unique identifier for the software development service
    App VARCHAR(50),                         -- Application developed
    Web VARCHAR(50),                         -- Web project developed

    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (SoftwareServiceID) REFERENCES Service(ServiceID)
);

-- ===========================================================
-- SoftwareDevelopmentTool Table (Relation for Multivalued Attribute)
-- ===========================================================
CREATE TABLE SoftwareDevelopmentTool (
    SoftwareServiceID INT NOT NULL,          -- Identifier of the software development service
    DevelopmentTool VARCHAR(50) NOT NULL,    -- Name of the development tool used

    -- ===========================================================
    -- Foreign Key Constraint to SoftwareDevelopmentService Table
    -- -----------------------------------------------------------
    -- Links to SoftwareDevelopmentService table to reference the software development service.
    FOREIGN KEY (SoftwareServiceID) REFERENCES SoftwareDevelopmentService(SoftwareServiceID),

    -- Primary key constraint ensures unique combination of SoftwareServiceID and DevelopmentTool
    PRIMARY KEY (SoftwareServiceID, DevelopmentTool)
);

-- ===========================================================
-- RepairService Table (Subtype of Service, Supertype for Repair)
-- ===========================================================
CREATE TABLE RepairService (
    RepairServiceID INT PRIMARY KEY,         -- Unique identifier for the repair service
    DeviceName VARCHAR(50),                  -- Name of the device
    DeviceType VARCHAR(50),                  -- Type of the device
    DeviceModel VARCHAR(50),                 -- Model of the device
    Hardware VARCHAR(50),                    -- Hardware specifications
    Software VARCHAR(50),                    -- Software specifications

    -- ===========================================================
    -- Foreign Key Constraint to Service Table
    -- -----------------------------------------------------------
    -- Links to Service table to reference the service.
    FOREIGN KEY (RepairServiceID) REFERENCES Service(ServiceID)
);

-- ===========================================================
-- HardwareRepairService Table (Subtype of RepairService)
-- ===========================================================
CREATE TABLE HardwareRepairService (
    HardwareRepairServiceID INT PRIMARY KEY, -- Unique identifier for the hardware repair service
    Component VARCHAR(50),                   -- Component being repaired
    ProductionYear INT,                      -- Year of production of the component

    -- ===========================================================
    -- Foreign Key Constraint to RepairService Table
    -- -----------------------------------------------------------
    -- Links to RepairService table to reference the repair service.
    FOREIGN KEY (HardwareRepairServiceID) REFERENCES RepairService(RepairServiceID)
);

-- ===========================================================
-- SoftwareRepairService Table (Subtype of RepairService)
-- ===========================================================
CREATE TABLE SoftwareRepairService (
    SoftwareRepairServiceID INT PRIMARY KEY, -- Unique identifier for the software repair service
    SoftwareType VARCHAR(50),                -- Type of software being repaired
    SoftwareVersion VARCHAR(50),             -- Version of the software

    -- ===========================================================
    -- Foreign Key Constraint to RepairService Table
    -- -----------------------------------------------------------
    -- Links to RepairService table to reference the repair service.
    FOREIGN KEY (SoftwareRepairServiceID) REFERENCES RepairService(RepairServiceID)
);

