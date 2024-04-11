USE AutomobileDB;

create MASTER KEY
ENCRYPTION BY PASSWORD = 'N@v900322';
 
SELECT NAME KeyName,
symmetric_key_id KeyID,
key_length KeyLength,
algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
 
CREATE CERTIFICATE SalespersonPass
WITH SUBJECT = 'Salesperson Password';
 
CREATE SYMMETRIC KEY SalespersonPass_SM
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE SalespersonPass;
 
OPEN SYMMETRIC KEY SalespersonPass_SM
DECRYPTION BY CERTIFICATE SalespersonPass;
 
INSERT INTO Salesperson (Salesperson_id, Password, Name, Commission_Rate, Sales_Area, Base_salary)
VALUES
    (1,  EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass111')), 'John batra', 0.2, 'CA', 5000.00),
    (2, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass222')), 'agash Smith', 0.3, 'AZ', 4500.00),
    (3, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass333')), 'rachana Johnson', 0.25, 'TX', 4800.00),
    (4, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass444')), 'Emily Clark', 0.25, 'NY', 5200.00),
    (5, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass555')), 'Michael Brown', 0.3, 'FL', 4800.00),
    (6, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass666')), 'Sophia Wilson', 0.2, 'IL', 5000.00),
    (7, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass777')), 'Ethan Lee', 0.35, 'TX', 5500.00),
    (8, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass888')), 'Olivia Taylor', 0.25, 'CA', 5100.00),
    (9, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass999')), 'Daniel Martinez', 0.3, 'FL', 4900.00),
    (10, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass101010')), 'Ava Garcia', 0.2, 'NY', 5300.00),
    (11, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass111111')), 'William Rodriguez', 0.35, 'TX', 5600.00),
    (12, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass121212')), 'Mia Hernandez', 0.25, 'CA', 5200.00),
    (13, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass131313')), 'James Gonzalez', 0.3, 'FL', 5000.00),
    (14, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass141414')), 'Isabella Perez', 0.2, 'NY', 5400.00),
    (15, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass151515')), 'Alexander Sanchez', 0.35, 'TX', 5700.00),
    (16, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass161616')), 'Charlotte Rivera', 0.25, 'CA', 5300.00),
    (17, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass171717')), 'Benjamin Moore', 0.3, 'FL', 5100.00),
    (18, EncryptByKey(Key_GUID('SalespersonPass_SM'), CONVERT(VARBINARY, 'Pass181818')), 'Amelia Lewis', 0.2, 'NY', 5500.00);

-- Customers table
INSERT INTO Customers (customer_id, Name, City, State, Country, Phone_Number)
VALUES
    (1, 'Customer1', 'Los Angeles', 'CA', 'USA', '1234567890'),
    (2, 'Customer2', 'Phoenix', 'AZ', 'USA', '2345678901'),
    (3, 'Customer3', 'Dallas', 'TX', 'USA', '3456789012'),
    (4, 'Customer4', 'New York', 'NY', 'USA', '4567890123'),
    (5, 'Customer5', 'Miami', 'FL', 'USA', '5678901234'),
    (6, 'Customer6', 'Chicago', 'IL', 'USA', '6789012345'),
    (7, 'Customer7', 'Houston', 'TX', 'USA', '7890123456'),
    (8, 'Customer8', 'Los Angeles', 'CA', 'USA', '8901234567'),
    (9, 'Customer9', 'Orlando', 'FL', 'USA', '9012345678'),
    (10, 'Customer10', 'Albany', 'NY', 'USA', '0123456789'),
    (11, 'Customer11', 'Dallas', 'TX', 'USA', '1234567890'),
    (12, 'Customer12', 'San Francisco', 'CA', 'USA', '2345678901'),
    (13, 'Customer13', 'Jacksonville', 'FL', 'USA', '3456789012'),
    (14, 'Customer14', 'Buffalo', 'NY', 'USA', '4567890123'),
    (15, 'Customer15', 'Austin', 'TX', 'USA', '5678901234'),
    (16, 'Customer16', 'San Diego', 'CA', 'USA', '6789012345'),
    (17, 'Customer17', 'Tampa', 'FL', 'USA', '7890123456'),
    (18, 'Customer18', 'Syracuse', 'NY', 'USA', '8901234567');

-- Inserting feedback for each customer
INSERT INTO Customer_Feedback (feedback_id, Date, Feedback_Description, Rating, Customer_id)
VALUES
    (1, '2024-04-10', 'Good service', 5, 1),
    (2, '2024-04-10', 'Prompt delivery', 4, 2),
    (3, '2024-04-10', 'Product quality could be improved', 3, 3),
    (4, '2024-04-10', 'Very satisfied with the purchase', 5, 4),
    (5, '2024-04-10', 'Great customer service', 4, 5),
    (6, '2024-04-10', 'Product exceeded expectations', 5, 6),
    (7, '2024-04-10', 'Smooth transaction', 4, 7),
    (8, '2024-04-10', 'Excellent quality', 5, 8),
    (9, '2024-04-10', 'Quick delivery', 4, 9),
    (10, '2024-04-10', 'Good value for money', 5, 10),
    (11, '2024-04-10', 'Professional staff', 4, 11),
    (12, '2024-04-10', 'Impressed with the service', 5, 12),
    (13, '2024-04-10', 'Responsive customer support', 4, 13),
    (14, '2024-04-10', 'Highly recommend', 5, 14),
    (15, '2024-04-10', 'Satisfied with the purchase', 4, 15),
    (16, '2024-04-10', 'Good experience overall', 5, 16),
    (17, '2024-04-10', 'Excellent product', 4, 17),
    (18, '2024-04-10', 'Friendly staff', 5, 18);

-- Orders table
INSERT INTO Orders (Order_id, Customer_id, Salesperson_id, Order_Date, Total_Price)
VALUES
    (1, 1, 1, '2024-04-01', 10000.00),
    (2, 2, 2, '2024-02-10', 12000.00),
    (3, 3, 3, '2024-03-10', 8000.00),
    (4, 1, 2, '2024-01-09', 8000.00),
    (5, 2, 1, '2024-02-19', 12000.00),
    (6, 3, 3, '2024-03-09', 10000.00),
    (7, 4, 4, '2024-04-05', 7000.00),
    (8, 5, 5, '2024-04-06', 8000.00),
    (9, 6, 6, '2024-04-07', 6000.00),
    (10, 7, 7, '2024-04-08', 8500.00),
    (11, 8, 8, '2024-04-09', 7500.00),
    (12, 9, 9, '2024-04-10', 7000.00),
    (13, 10, 10, '2024-04-01', 9000.00),
    (14, 11, 11, '2024-04-2', 9500.00),
    (15, 12, 12, '2024-04-03', 7300.00),
    (16, 13, 13, '2024-04-04', 7200.00),
    (17, 14, 14, '2024-04-05', 8500.00),
    (18, 15, 15, '2024-04-06', 8900.00),
    (19, 16, 16, '2024-04-07', 7500.00),
    (20, 17, 17, '2024-04-08', 8000.00),
    (21, 18, 18, '2024-04-09', 9300.00);

INSERT INTO Manager (Manager_id, Name, Phone_Number)
VALUES
    (1, 'Manager1', '1111111111'),
    (2, 'Manager2', '2222222222'),
    (3, 'Manager3', '3333333333'),
    (4, 'Manager4', '4444444444'),
    (5, 'Manager5', '5555555555'),
    (6, 'Manager6', '6666666666'),
    (7, 'Manager7', '7777777777'),
    (8, 'Manager8', '8888888888'),
    (9, 'Manager9', '9999999999'),
    (10, 'Manager10', '1010101010'),
    (11, 'Manager11', '1111111111'),
    (12, 'Manager12', '1212121212'),
    (13, 'Manager13', '1313131313'),
    (14, 'Manager14', '1414141414'),
    (15, 'Manager15', '1515151515'),
    (16, 'Manager16', '1616161616'),
    (17, 'Manager17', '1717171717'),
    (18, 'Manager18', '1818181818');

-- Assembly_Plant table
INSERT INTO Assembly_Plant (Plant_id, Manager_id, State, Capacity)
VALUES
    (1, 1, 'CA', 1000),
    (2, 2, 'AZ', 800),
    (3, 3, 'TX', 1200),
    (4, 4, 'NY', 1100),
    (5, 5, 'FL', 950),
    (6, 6, 'IL', 1300),
    (7, 7, 'TX', 1200),
    (8, 8, 'CA', 1050),
    (9, 9, 'FL', 900),
    (10, 10, 'NY', 1150),
    (11, 11, 'TX', 1250),
    (12, 12, 'CA', 1100),
    (13, 13, 'FL', 950),
    (14, 14, 'NY', 1200),
    (15, 15, 'TX', 1300),
    (16, 16, 'CA', 1150),
    (17, 17, 'FL', 1000),
    (18, 18, 'NY', 1250);

INSERT INTO Vehicle_Model (Model_id, Plant_id, Model_Name, Release_Year, Price)
VALUES
    (1, 1, 'Sedan', '2020-01-01', 6000.00),
    (2, 2, 'Hatchback', '2019-01-01', 2000.00),
    (3, 3, 'SUV', '2021-01-01', 4000.00),
    (4, 4, 'SUV', '2022-01-01', 5500.00),
    (5, 5, 'Coupe', '2023-01-01', 7500.00),
    (6, 6, 'Truck', '2022-01-01', 8000.00),
    (7, 7, 'Sedan', '2023-01-01', 6000.00),
    (8, 8, 'Hatchback', '2022-01-01', 4500.00),
    (9, 9, 'SUV', '2023-01-01', 6500.00),
    (10, 10, 'Coupe', '2022-01-01', 7200.00),
    (11, 11, 'Truck', '2023-01-01', 8500.00),
    (12, 12, 'Sedan', '2022-01-01', 6200.00),
    (13, 13, 'Hatchback', '2023-01-01', 4800.00),
    (14, 14, 'SUV', '2022-01-01', 7000.00),
    (15, 15, 'Coupe', '2023-01-01', 7800.00),
    (16, 16, 'Truck', '2022-01-01', 8200.00),
    (17, 17, 'Sedan', '2023-01-01', 6300.00),
    (18, 18, 'Hatchback', '2022-01-01', 4600.00);

INSERT INTO Supplier (Supplier_id, Supplier_Name, City, State, Country, Phone_Number)
VALUES
    (1, 'Supplier1', 'Los Angeles', 'CA', 'USA', '4444444444'),
    (2, 'Supplier2', 'Phoenix', 'AZ', 'USA', '5555555555'),
    (3, 'Supplier3', 'Dallas', 'TX', 'USA', '6666666666'),
    (4, 'Supplier4', 'New York', 'NY', 'USA', '7777777777'),
    (5, 'Supplier5', 'Miami', 'FL', 'USA', '8888888888'),
    (6, 'Supplier6', 'Chicago', 'IL', 'USA', '9999999999'),
    (7, 'Supplier7', 'Houston', 'TX', 'USA', '1010101010'),
    (8, 'Supplier8', 'Los Angeles', 'CA', 'USA', '1111111111'),
    (9, 'Supplier9', 'Orlando', 'FL', 'USA', '1212121212'),
    (10, 'Supplier10', 'Albany', 'NY', 'USA', '1313131313'),
    (11, 'Supplier11', 'Dallas', 'TX', 'USA', '1414141414'),
    (12, 'Supplier12', 'San Francisco', 'CA', 'USA', '1515151515'),
    (13, 'Supplier13', 'Jacksonville', 'FL', 'USA', '1616161616'),
    (14, 'Supplier14', 'Buffalo', 'NY', 'USA', '1717171717'),
    (15, 'Supplier15', 'Austin', 'TX', 'USA', '1818181818'),
    (16, 'Supplier16', 'San Diego', 'CA', 'USA', '1919191919'),
    (17, 'Supplier17', 'Tampa', 'FL', 'USA', '2020202020'),
    (18, 'Supplier18', 'Syracuse', 'NY', 'USA', '2121212121');

INSERT INTO Vehicle_Components (Component_id, Component_Name, Component_Description, Price)
VALUES
    (1, 'Component1', 'Description1', 100.00),
    (2, 'Component2', 'Description2', 150.00),
    (3, 'Component3', 'Description3', 200.00);

INSERT INTO Supply_Link (Date_Supplied, Delivery_Status, Supplier_id, Component_id)
VALUES
    ('2024-04-10', 'Delivered', 1, 1),
    ('2024-04-10', 'Delivered', 2, 2),
    ('2024-04-10', 'Delivered', 3, 3);

INSERT INTO Model_Component (Quantity, Model_id, Component_id)
VALUES
    (10, 1, 1),
    (8, 2, 2),
    (6, 3, 3),
    (20, 4, 1), 
    (21, 5, 2),  
    (22, 6, 3),  
    (23, 7, 1), 
    (24, 8, 2),  
    (25, 9, 3),  
    (26, 10, 1), 
    (27, 11, 2), 
    (28, 12, 3),  
    (29, 13, 1),  
    (30, 14, 2), 
    (31, 15, 3),  
    (32, 16, 1),  
    (33, 17, 2),  
    (34, 18, 3);

INSERT INTO Order_Line (Quantity, Model_id, Order_id)
VALUES
    (1, 1, 1),
    (1, 2, 1), 
    (2, 1, 2),
    (1, 1, 3),
    (1, 3, 3),
    (2, 2, 4),
    (3, 2, 5),
    (5, 3, 6),
    (2, 3, 7),
    (3, 4, 8),
    (2, 5, 9),
    (4, 6, 10),
    (1, 7, 11),
    (3, 8, 12),
    (2, 9, 13),
    (4, 10, 14),
    (3, 11, 15),
    (2, 12, 16),
    (1, 13, 17),
    (4, 14, 18),
    (3, 15, 19),
    (2, 16, 20),
    (1, 17, 21);

INSERT INTO Sales_Data (Sales_id, Sales_Date, Quantity_Sold, Revenue, Model_id, Plant_id)
VALUES
    (1, '2024-04-10', 5, 50000.00, 1, 1),
    (2, '2024-04-10', 4, 80000.00, 2, 2),
    (3, '2024-04-10', 3, 90000.00, 3, 3);