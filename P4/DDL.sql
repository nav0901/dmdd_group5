CREATE DATABASE AutomobileDB;
GO
USE AutomobileDB;
GO

CREATE TABLE Salesperson (
    Salesperson_id INT PRIMARY KEY CHECK (Salesperson_id > 0),
    Password VARCHAR(100) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Commission_Rate DECIMAL(3, 1) CHECK (Commission_Rate > 0.1),
    Sales_Area VARCHAR(2) CHECK (
        Sales_Area IN (
            'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE',
            'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
            'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO',
            'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
            'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI',
            'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA',
            'WV', 'WI', 'WY'
        )
    ),
    Base_salary DECIMAL(6, 2) CHECK (Base_salary > 1000.00)
); 


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY CHECK (customer_id > 0),
    Name VARCHAR(20) NOT NULL,
    City VARCHAR(20) NOT NULL,
    State VARCHAR(2) CHECK ( State IN (
            'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE',
            'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
            'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO',
            'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
            'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI',
            'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA',
            'WV', 'WI', 'WY'
        )
    ),
    Country VARCHAR(20) NOT NULL,
    Phone_Number VARCHAR(10) CHECK (Phone_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE Customer_Feedback (
    feedback_id INT PRIMARY KEY CHECK (feedback_id > 0), 
    Date DATE CHECK (Date <= GETDATE()),
    Feedback_Description VARCHAR(500),
    Rating INT CHECK (Rating >= 1 AND Rating<=5),
    Customer_id INT NOT NULL,
    FOREIGN KEY (Customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Orders (
    Order_id INT PRIMARY KEY CHECK (Order_id > 0),
    Customer_id INT NOT NULL,
    Salesperson_id INT NOT NULL,
    Order_Date DATE CHECK (Order_Date <= GETDATE()), 
    Total_Price DECIMAL(10, 2) CHECK (Total_Price > 0),
    FOREIGN KEY (Customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (Salesperson_id) REFERENCES Salesperson(Salesperson_id)
);

CREATE TABLE Manager (
    Manager_id INT PRIMARY KEY CHECK (Manager_id > 0),
    Name VARCHAR(20) NOT NULL,
    Phone_Number VARCHAR(10) CHECK (Phone_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE Assembly_Plant (
    Plant_id INT PRIMARY KEY CHECK (Plant_id > 0),
    Manager_id INT NOT NULL,
    State VARCHAR(2) CHECK ( State IN (
            'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE',
            'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
            'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO',
            'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
            'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI',
            'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA',
            'WV', 'WI', 'WY'
        )
    ),
    Capacity INT CHECK(Capacity >0),
    FOREIGN KEY (Manager_id) REFERENCES Manager(Manager_id)
);

CREATE TABLE Vehicle_Model (
    Model_id INT PRIMARY KEY CHECK(Model_id > 0),
    Plant_id INT NOT NULL,
    Model_Name VARCHAR(10) NOT NULL,
    Release_Year DATE CHECK (Release_Year <= GETDATE()),
    Price DECIMAL(10, 2) CHECK (Price > 0),
    FOREIGN KEY (Plant_id) REFERENCES Assembly_Plant(Plant_id)
);

CREATE TABLE Supplier (
    Supplier_id INT PRIMARY KEY CHECK (Supplier_id>0),
    Supplier_Name VARCHAR(50) NOT NULL,
    City VARCHAR(20) NOT NULL,
    State VARCHAR(2) CHECK ( State IN (
            'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE',
            'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
            'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO',
            'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
            'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI',
            'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA',
            'WV', 'WI', 'WY'
        )
    ),
    Country VARCHAR(20) NOT NULL,
    Phone_Number VARCHAR(10) CHECK (Phone_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE Vehicle_Components (
    Component_id INT PRIMARY KEY CHECK (Component_id > 0), -- Ensure Component_id is positive
    Component_Name VARCHAR(50) NOT NULL, -- Ensure Component_Name is not empty
    Component_Description VARCHAR(255),
    Price DECIMAL(10, 2) CHECK (Price > 0) -- Ensure Price is non-negative
);

CREATE TABLE Sales_Data (
    Sales_id INT PRIMARY KEY CHECK (Sales_id > 0), -- Ensure Sales_id is positive
    Quantity_Sold INT CHECK (Quantity_Sold > 0), -- Ensure Quantity_Sold is non-negative
    Revenue DECIMAL(10, 2) CHECK (Revenue >= 0), -- Ensure Revenue is non-negative
    Model_id INT NOT NULL,
    Plant_id INT NOT NULL,
    FOREIGN KEY (Model_id) REFERENCES Vehicle_Model(Model_id),
    FOREIGN KEY (Plant_id) REFERENCES Assembly_Plant(Plant_id)
);

CREATE TABLE Supply_Link (
    Date_Supplied DATE CHECK (Date_Supplied <= GETDATE()), -- Ensure Date_Supplied is not in the future,
    Delivery_Status VARCHAR(20) CHECK (Delivery_Status IN ('Pending', 'In Progress', 'Delivered')), -- Ensure valid Delivery_Status values,
    Supplier_id INT NOT NULL,
    Component_id INT NOT NULL,
    FOREIGN KEY (Supplier_id) REFERENCES Supplier(Supplier_id),
    FOREIGN KEY (Component_id) REFERENCES Vehicle_Components(Component_id),
    PRIMARY KEY (Supplier_id, Component_id)    
);

CREATE TABLE Model_Component (
    Quantity INT CHECK (Quantity >= 0), -- Quantity must be non-negative
    Model_id INT NOT NULL,
    Component_id INT NOT NULL,
    FOREIGN KEY (Model_id) REFERENCES Vehicle_Model(Model_id),
    FOREIGN KEY (Component_id) REFERENCES Vehicle_Components(Component_id),
    PRIMARY KEY (Model_id, Component_id)
);

CREATE TABLE Order_Line (
    Quantity INT CHECK (Quantity >= 0), -- Quantity must be non-negative
    Model_id INT NOT NULL,
    Order_id INT NOT NULL,
    FOREIGN KEY (Model_id) REFERENCES Vehicle_Model(Model_id),
    FOREIGN KEY (Order_id) REFERENCES Orders(Order_id),
    PRIMARY KEY (Model_id, Order_id),
    --CHECK (Quantity <= (SELECT Quantity FROM Vehicle_Model WHERE Model_id = Order_Line.Model_id)) -- Check if the quantity ordered does not exceed available quantity
);