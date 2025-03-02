
USE eCommerceDB;
GO


-- Insert Countries
INSERT INTO Countries (CountryCode, CountryName) VALUES
('NL', 'Netherlands'),
('DE', 'Germany'),
('FR', 'France');

-- Insert Categories
INSERT INTO Categories (CategoryID, CategoryName) VALUES
('C10001', 'Electronics'),
('C10002', 'Clothing'),
('C10003', 'Home Appliances');

-- Insert Suppliers
INSERT INTO Suppliers (SupplierID, SupplierName, ContactPerson, Email, Phone, Address) VALUES
('S20001', 'Tech Distributors', 'John Doe', 'contact@techdistributors.com', '+31000000001', '123 Tech Lane'),
('S20002', 'Fashion Hub', 'Jane Smith', 'info@fashionhub.com', '+31000000002', '456 Fashion Ave'),
('S20003', 'Home Goods Inc.', 'Albert Johnson', 'support@homegoods.com', '+31000000003', '789 Home St');

-- Insert Selling Entities
INSERT INTO SellingEntities (SellingEntityID, EntityName, CountryCode) VALUES
('SE001', 'Amazon NL', 'NL'),
('SE002', 'Amazon DE', 'DE'),
('SE003', 'Amazon FR', 'FR');

-- Insert Customers
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, CreatedAt) VALUES
('A12456', 'Alice', 'Johnson', 'alice@example.com', '+111223344', '789 Maple Drive', GETDATE()),
('A12457', 'Bob', 'Smith', 'bob@example.com', '+222334455', '456 Oak Street', GETDATE());

-- Insert Products
INSERT INTO Products (ProductID, ProductName, CategoryID, SupplierID, Price, Stock, CreatedAt) VALUES
('P30001', 'Smartphone', 'C10001', 'S20001', 699.99, 50, GETDATE()),
('P30002', 'Laptop', 'C10001', 'S20001', 1099.99, 30, GETDATE()),
('P30003', 'T-Shirt', 'C10002', 'S20002', 19.99, 100, GETDATE()),
('P30004', 'Microwave Oven', 'C10003', 'S20003', 199.99, 20, GETDATE());

-- Insert Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status, TotalAmount, PaymentStatus, OrderCountryCode, SellingEntityID) VALUES
('O45678', 'A12456', GETDATE(), 'Shipped', 719.98, 'Paid', 'NL', 'SE001'),
('O45679', 'A12457', GETDATE(), 'Pending', 1099.99, 'Pending', 'DE', 'SE002');

-- Insert Order Items
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, Price) VALUES
('OI60001', 'O45678', 'P30001', 1, 699.99),
('OI60002', 'O45678', 'P30003', 1, 19.99),
('OI60003', 'O45679', 'P30002', 1, 1099.99);

-- Insert Payments
INSERT INTO Payments (PaymentID, OrderID, Amount, PaymentMethod, Status, PaymentDate) VALUES
('PAY70001', 'O45678', 719.98, 'Credit Card', 'Success', GETDATE());

-- Insert Shipping
INSERT INTO Shipping (ShippingID, OrderID, Address, Status, EstimatedDelivery) VALUES
('SHP80001', 'O45678', '789 Maple Drive', 'Shipped', DATEADD(DAY, 5, GETDATE()));

-- Insert Inventory
INSERT INTO Inventory (InventoryID, ProductID, Stock, LastUpdated) VALUES
('I90001', 'P30001', 49, GETDATE()),
('I90002', 'P30002', 29, GETDATE()),
('I90003', 'P30003', 99, GETDATE());

-- Insert Country Taxes
INSERT INTO CountryTaxes (CountryCode, TaxRate, EffectiveFrom, EffectiveTo) VALUES
('NL', 21.00, '2024-01-01', NULL),
('DE', 19.00, '2024-01-01', NULL);

-- Insert Invoice
INSERT INTO Invoice (InvoiceID, OrderID, InvoiceDate, OrderTotal, TaxAmount, DiscountAmount, FinalInvoiceAmount) VALUES
('INV001', 'O45678', GETDATE(), 719.98, 151.20, 0.00, 871.18),
('INV002', 'O45679', GETDATE(), 1099.99, 209.00, 0.00, 1308.99);
