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
    Salary INT NOT NULL                     -- Salary of the employee (cannot be null)
);

-- ===========================================================
-- EmployeeSkill Table
-- -----------------------------------------------------------
-- This table stores the relationship between employees and 
-- the skills they possess, linking the Employee and Skill tables.
-- ===========================================================

CREATE TABLE EmployeeSkill (
    EmployeeID INT NOT NULL,                -- ID of the employee (cannot be null)
    SkillID INT NOT NULL,                   -- ID of the skill (cannot be null)
    
    -- ===========================================================
    -- Foreign Key Constraints
    -- -----------------------------------------------------------
    -- Links to Employee table to reference the employee with the skill.
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    
    -- Links to Skill table to reference the specific skill.
    FOREIGN KEY (SkillID) REFERENCES Skill(SkillID),
    
    -- Primary key constraint to ensure each combination of employee and skill is unique
    PRIMARY KEY (EmployeeID, SkillID)
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
    ServiceType VARCHAR(50) NOT NULL,        -- Type of the service (cannot be null)
    
    -- ===========================================================
    -- Foreign Key Constraint to Company Table
    -- -----------------------------------------------------------
    -- Ensures the service is linked to a valid company.
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID),
    
    -- ===========================================================
    -- Computed Duration Column
    -- -----------------------------------------------------------
    -- The Duration of the service is computed as the difference 
    -- in days between the EndDate and StartDate.
    -- ===========================================================
    Duration AS (DATEDIFF(DAY, StartDate, EndDate))
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
    -- Foreign Key Constraint
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
