-- ==============================
-- eCommerceDB Schema - Version 1.2
-- ==============================

CREATE DATABASE eCommerceDB;
GO

USE eCommerceDB;
GO

-- Countries
CREATE TABLE Countries (
    CountryCode CHAR(2) PRIMARY KEY,
    CountryName VARCHAR(50) NOT NULL
);

-- SellingEntities
CREATE TABLE SellingEntities (
    SellingEntityID VARCHAR(10) PRIMARY KEY,
    EntityName VARCHAR(100) NOT NULL,
    CountryCode CHAR(2) NOT NULL,
    FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)
);

-- Categories
CREATE TABLE Categories (
    CategoryID VARCHAR(36) PRIMARY KEY,
    CategoryName VARCHAR(100) UNIQUE NOT NULL
);

-- Suppliers
CREATE TABLE Suppliers (
    SupplierID VARCHAR(36) PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    ContactPerson VARCHAR(100),
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

-- Customers
CREATE TABLE Customers (
    CustomerID VARCHAR(36) PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    CreatedAt DATETIME NOT NULL
);

-- Products
CREATE TABLE Products (
    ProductID VARCHAR(36) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    CategoryID VARCHAR(36) NOT NULL,
    SupplierID VARCHAR(36) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    CreatedAt DATETIME NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Orders
CREATE TABLE Orders (
    OrderID VARCHAR(36) PRIMARY KEY,
    CustomerID VARCHAR(36) NOT NULL,
    OrderDate DATETIME NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Cancelled', 'Delivered', 'Shipped', 'Pending')) NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(50) CHECK (PaymentStatus IN ('Failed', 'Pending', 'Paid')) NOT NULL,
    OrderCountryCode CHAR(2) NOT NULL,
    SellingEntityID VARCHAR(10) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (OrderCountryCode) REFERENCES Countries(CountryCode),
    FOREIGN KEY (SellingEntityID) REFERENCES SellingEntities(SellingEntityID)
);

-- OrderItems
CREATE TABLE OrderItems (
    OrderItemID VARCHAR(36) PRIMARY KEY,
    OrderID VARCHAR(36) NOT NULL,
    ProductID VARCHAR(36) NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Payments
CREATE TABLE Payments (
    PaymentID VARCHAR(36) PRIMARY KEY,
    OrderID VARCHAR(36) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50) CHECK (PaymentMethod IN ('Cash On Delivery', 'Bank Transfer', 'PayPal', 'Credit Card')) NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Refunded', 'Failed', 'Success')) NOT NULL,
    PaymentDate DATETIME NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Shipping
CREATE TABLE Shipping (
    ShippingID VARCHAR(36) PRIMARY KEY,
    OrderID VARCHAR(36) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Delivered', 'Shipped', 'Processing')) NOT NULL,
    EstimatedDelivery DATE NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Discounts (To be deprecated in future)
CREATE TABLE Discounts (
    DiscountID VARCHAR(36) PRIMARY KEY,
    ProductID VARCHAR(36) NOT NULL,
    DiscountPercentage DECIMAL(5,2) CHECK (DiscountPercentage BETWEEN 0 AND 100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- CountryTaxes
CREATE TABLE CountryTaxes (
    CountryCode CHAR(2) PRIMARY KEY,
    TaxRate DECIMAL(5,2) NOT NULL,
    EffectiveFrom DATE NOT NULL,
    EffectiveTo DATE
);

-- Invoice
CREATE TABLE Invoice (
    InvoiceID VARCHAR(10) PRIMARY KEY,
    OrderID VARCHAR(36) UNIQUE NOT NULL,
    InvoiceDate DATETIME NOT NULL,
    OrderTotal DECIMAL(10,2) NOT NULL,
    TaxAmount DECIMAL(10,2) NOT NULL,
    DiscountAmount DECIMAL(10,2) NOT NULL,
    FinalInvoiceAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- InvoiceDiscounts
CREATE TABLE InvoiceDiscounts (
    DiscountID VARCHAR(36) PRIMARY KEY,
    InvoiceID VARCHAR(10) NOT NULL,
    DiscountAmount DECIMAL(10,2) NOT NULL,
    Description VARCHAR(255),
    FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID)
);

-- UserRoles
CREATE TABLE UserRoles (
    RoleID VARCHAR(36) PRIMARY KEY,
    RoleName VARCHAR(50) UNIQUE NOT NULL
);

-- Users
CREATE TABLE Users (
    UserID VARCHAR(36) PRIMARY KEY,
    CustomerID VARCHAR(36),
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    RoleID VARCHAR(36) NOT NULL,
    CreatedAt DATETIME NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RoleID) REFERENCES UserRoles(RoleID)
);

-- Inventory
CREATE TABLE Inventory (
    InventoryID VARCHAR(36) PRIMARY KEY,
    ProductID VARCHAR(36) NOT NULL,
    Stock INT NOT NULL,
    LastUpdated DATETIME NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Reviews
CREATE TABLE Reviews (
    ReviewID VARCHAR(36) PRIMARY KEY,
    CustomerID VARCHAR(36) NOT NULL,
    ProductID VARCHAR(36) NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    CreatedAt DATETIME NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- AuditLogs
CREATE TABLE AuditLogs (
    LogID VARCHAR(36) PRIMARY KEY,
    TableName VARCHAR(100) NOT NULL,
    OperationType VARCHAR(50) CHECK (OperationType IN ('DELETE', 'UPDATE', 'INSERT')) NOT NULL,
    ChangedBy VARCHAR(100) NOT NULL,
    ChangedAt DATETIME NOT NULL,
    OldValues TEXT,
    NewValues TEXT
);

-- END OF SCHEMA v1.2
