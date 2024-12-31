from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Company(db.Model):
    __tablename__ = 'Company'
    CompanyID = db.Column(db.Integer, primary_key=True)
    CompanyName = db.Column(db.String(50), nullable=False)
    TradeNumber = db.Column(db.Integer, nullable=False)
    Street = db.Column(db.String(50), nullable=False)
    City = db.Column(db.String(50), nullable=False)
    State = db.Column(db.String(50), nullable=False)
    Country = db.Column(db.String(50), nullable=False)


class Employee(db.Model):
    __tablename__ = 'Employee'
    EmployeeID = db.Column(db.Integer, primary_key=True)
    FirstName = db.Column(db.String(50), nullable=False)
    LastName = db.Column(db.String(50), nullable=False)
    Birthdate = db.Column(db.Date, nullable=False)
    SsnNo = db.Column(db.String(50), nullable=False, unique=True)
    Position = db.Column(db.String(50), nullable=False)
    HireDate = db.Column(db.Date, nullable=False)
    Salary = db.Column(db.Integer, nullable=False)
    DepartmentNo = db.Column(db.Integer, db.ForeignKey('Department.DepartmentNo'), nullable=False)
    CompanyID = db.Column(db.Integer, db.ForeignKey('Company.CompanyID'), nullable=False)


class Department(db.Model):
    __tablename__ = 'Department'
    DepartmentNo = db.Column(db.Integer, primary_key=True)
    DepartmentName = db.Column(db.String(50), nullable=False)
    NoOfEmployees = db.Column(db.Integer, nullable=False)
    Mission = db.Column(db.String(100), nullable=False)
    CompanyID = db.Column(db.Integer, db.ForeignKey('Company.CompanyID'), nullable=False)


class Service(db.Model):
    __tablename__ = 'Service'
    ServiceID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String(50), nullable=False)
    StartDate = db.Column(db.Date, nullable=False)
    EndDate = db.Column(db.Date, nullable=False)
    Price = db.Column(db.Integer, nullable=False)
    Status = db.Column(db.String(50), nullable=False)
    City = db.Column(db.String(50), nullable=False)
    State = db.Column(db.String(50), nullable=False)
    Country = db.Column(db.String(50), nullable=False)
    Cloud = db.Column(db.String(50))
    Security = db.Column(db.String(50))
    Repair = db.Column(db.String(50))
    Network = db.Column(db.String(50))
    SoftwareDev = db.Column(db.String(50))
    CompanyID = db.Column(db.Integer, db.ForeignKey('Company.CompanyID'), nullable=False)
    DepartmentNo = db.Column(db.Integer, db.ForeignKey('Department.DepartmentNo'), nullable=False)


class Customer(db.Model):
    __tablename__ = 'Customer'
    CustomerID = db.Column(db.Integer, primary_key=True)
    CustomerName = db.Column(db.String(50), nullable=False)
    Email = db.Column(db.String(50), nullable=False)
    TelephoneNo = db.Column(db.String(50), nullable=False)
    Street = db.Column(db.String(50), nullable=False)
    City = db.Column(db.String(50), nullable=False)
    State = db.Column(db.String(50), nullable=False)
    Country = db.Column(db.String(50), nullable=False)
    CompanyID = db.Column(db.Integer, db.ForeignKey('Company.CompanyID'), nullable=False)


class Item(db.Model):
    __tablename__ = 'Item'
    ItemID = db.Column(db.Integer, primary_key=True)
    ItemName = db.Column(db.String(50), nullable=False)
    Quantity = db.Column(db.Integer, nullable=False)
    Price = db.Column(db.Integer, nullable=False)
    CompanyID = db.Column(db.Integer, db.ForeignKey('Company.CompanyID'), nullable=False)


class EmployeeSkill(db.Model):
    __tablename__ = 'EmployeeSkill'
    EmployeeID = db.Column(db.Integer, db.ForeignKey('Employee.EmployeeID'), primary_key=True)
    Skill = db.Column(db.String(50), primary_key=True)


class EmployeeAppliedService(db.Model):
    __tablename__ = 'EmployeeAppliedService'
    EmployeeID = db.Column(db.Integer, db.ForeignKey('Employee.EmployeeID'), primary_key=True)
    ServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)


class CustomerRequestedService(db.Model):
    __tablename__ = 'CustomerRequestedService'
    CustomerID = db.Column(db.Integer, db.ForeignKey('Customer.CustomerID'), primary_key=True)
    ServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)


class CustomerPurchasedItem(db.Model):
    __tablename__ = 'CustomerPurchasedItem'
    CustomerID = db.Column(db.Integer, db.ForeignKey('Customer.CustomerID'), primary_key=True)
    ItemID = db.Column(db.Integer, db.ForeignKey('Item.ItemID'), primary_key=True)


class ServiceUsedItem(db.Model):
    __tablename__ = 'ServiceUsedItem'
    ServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)
    ItemID = db.Column(db.Integer, db.ForeignKey('Item.ItemID'), primary_key=True)


class EmployeeSoldItem(db.Model):
    __tablename__ = 'EmployeeSoldItem'
    EmployeeID = db.Column(db.Integer, db.ForeignKey('Employee.EmployeeID'), primary_key=True)
    ItemID = db.Column(db.Integer, db.ForeignKey('Item.ItemID'), primary_key=True)


class CloudSolutionService(db.Model):
    __tablename__ = 'CloudSolutionService'
    CloudServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)
    CloudServiceProvider = db.Column(db.String(50))
    StorageSize = db.Column(db.String(50))


class SecuritySystemService(db.Model):
    __tablename__ = 'SecuritySystemService'
    SecurityServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)
    SecurityApp = db.Column(db.String(50))
    SecurityPackageType = db.Column(db.String(50))


class NetworkManagementService(db.Model):
    __tablename__ = 'NetworkManagementService'
    NetworkServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)
    BandwidthUsage = db.Column(db.String(50))
    NetworkType = db.Column(db.String(50))
    NetworkProvider = db.Column(db.String(50))


class SoftwareDevelopmentService(db.Model):
    __tablename__ = 'SoftwareDevelopmentService'
    SoftwareServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)
    App = db.Column(db.String(50))
    Web = db.Column(db.String(50))


class SoftwareDevelopmentTool(db.Model):
    __tablename__ = 'SoftwareDevelopmentTool'
    SoftwareServiceID = db.Column(db.Integer, db.ForeignKey('SoftwareDevelopmentService.SoftwareServiceID'), primary_key=True)
    DevelopmentTool = db.Column(db.String(50), primary_key=True)


class RepairService(db.Model):
    __tablename__ = 'RepairService'
    RepairServiceID = db.Column(db.Integer, db.ForeignKey('Service.ServiceID'), primary_key=True)
    DeviceName = db.Column(db.String(50))
    DeviceType = db.Column(db.String(50))
    DeviceModel = db.Column(db.String(50))
    Hardware = db.Column(db.String(50))
    Software = db.Column(db.String(50))


class HardwareRepairService(db.Model):
    __tablename__ = 'HardwareRepairService'
    HardwareRepairServiceID = db.Column(db.Integer, db.ForeignKey('RepairService.RepairServiceID'), primary_key=True)
    Component = db.Column(db.String(50))
    ProductionYear = db.Column(db.Integer)


class SoftwareRepairService(db.Model):
    __tablename__ = 'SoftwareRepairService'
    SoftwareRepairServiceID = db.Column(db.Integer, db.ForeignKey('RepairService.RepairServiceID'), primary_key=True)
    SoftwareType = db.Column(db.String(50))
    SoftwareVersion = db.Column(db.String(50))
