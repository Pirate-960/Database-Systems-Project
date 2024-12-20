-- Company Table
-- This table stores information about companies.
CREATE TABLE Company (
    CompanyID INT PRIMARY KEY,              -- Unique identifier for the company
    CompanyName VARCHAR(50) NOT NULL,       -- Name of the company
    TradeNumber INT NOT NULL,               -- Trade registration number of the company
    Street VARCHAR(50) NOT NULL,            -- Street address of the company
    City VARCHAR(50) NOT NULL,              -- City where the company is located
    State VARCHAR(50) NOT NULL,             -- State where the company is located
    Country VARCHAR(50) NOT NULL            -- Country where the company is located
);

-- Employee Table
-- This table stores information about employees.
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,             -- Unique identifier for the employee
    FirstName VARCHAR(50) NOT NULL,         -- First name of the employee
    LastName VARCHAR(50) NOT NULL,          -- Last name of the employee
    Birthdate DATE NOT NULL,                -- Date of birth of the employee
    SsnNo VARCHAR(50) NOT NULL,             -- Social Security Number of the employee (must be unique)
    Age AS (
        DATEDIFF(YEAR, Birthdate, GETDATE()) - 
        CASE WHEN MONTH(Birthdate) > MONTH(GETDATE()) OR 
                  (MONTH(Birthdate) = MONTH(GETDATE()) AND DAY(Birthdate) > DAY(GETDATE())) 
             THEN 1 
             ELSE 0 
        END
    ),                                      -- Accurate computed age considering the birthdate
    Position VARCHAR(50) NOT NULL,          -- Job position of the employee
    HireDate DATE NOT NULL,                 -- Date the employee was hired
    Salary INT NOT NULL                     -- Salary of the employee
);

-- EmployeeSkill Table
-- This table stores information about employee skills.
create table EmployeeSkill (
    EmployeeID int not null,
    SkillID int not null,
    -- Foreign key constraint to Employee table
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    -- Foreign key constraint to Skill table
    FOREIGN KEY (SkillID) REFERENCES Skill(SkillID),
    primary key (EmployeeID, SkillID)
);

-- Service Table
-- This table stores information about services provided by the company.
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,               -- Unique identifier for the service
    Name VARCHAR(50) NOT NULL,               -- Name of the service
    StartDate DATE NOT NULL,                 -- Start date of the service
    EndDate DATE NOT NULL,                   -- End date of the service
    Price INT NOT NULL,                      -- Price of the service
    Status VARCHAR(50) NOT NULL,             -- Status of the service
    City VARCHAR(50) NOT NULL,               -- City where the service is provided
    State VARCHAR(50) NOT NULL,              -- State where the service is provided
    Country VARCHAR(50) NOT NULL,            -- Country where the service is provided
    ServiceType VARCHAR(50) NOT NULL,        -- Type of the service
    CompanyID INT NOT NULL,                  -- Foreign key reference to Company table
    -- Computed column: Difference in days between EndDate and StartDate
    Duration AS (DATEDIFF(DAY, StartDate, EndDate)),
    -- Foreign key constraint to Company table
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- Customer Table
-- This table stores information about customers.
create table Customer(
    CustomerID int primary key,
    CustomerName varchar(50) not null,
    Email varchar(50) not null,
    TelephoneNo varchar(50) not null,
    Street varchar(50) not null,
    City varchar(50) not null,
    State varchar(50) not null,
    Country varchar(50) not null,
    CompanyID int not null,
    -- Foreign key constraint to Company table
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- Item Table
-- This table stores information about items.
create table Item (
    ItemID int primary key,
    ItemName varchar(50) not null,
    Quantity int not null,
    Price int not null,
    CompanyID int not null,
    -- Foreign key constraint to Company table
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);