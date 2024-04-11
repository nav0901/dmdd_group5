
----- Stored Procedure 1 -----

CREATE PROCEDURE ProcessOrder
    @customer_id INT,
    @order_id INT,
    @model_id INT,
    @quantity INT,
    @salesperson_id INT,
    @total_price DECIMAL(10,2)
AS
BEGIN
    -- Check if the order_id already exists in the Orders table
    IF NOT EXISTS (SELECT 1
    FROM Orders
    WHERE Order_id = @order_id)
    BEGIN
        -- Insert data into Orders table
        INSERT INTO Orders
            (Order_id, Customer_id, Salesperson_id, Order_Date, Total_Price)
        VALUES
            (@order_id, @customer_id, @salesperson_id, GETDATE(), @total_price);
    END

    -- Insert data into Order_Line table
    INSERT INTO Order_Line
        (Quantity, Model_id, Order_id)
    VALUES
        (@quantity, @model_id, @order_id);
END;

EXEC ProcessOrder 1, 14, 1, 1, 1, 25000;


----- Stored Procedure 2 -----

CREATE PROCEDURE GetOrderDetailsForASalesPerson
    @Salesperson_id INT
AS
BEGIN
    SELECT O.Order_id, O.Customer_id, C.Name AS Customer_Name, VM.Model_Name, VM.Price, OL.Quantity AS Quantity_Ordered, O.Order_Date,
        O.Total_Price
    FROM Orders O
        INNER JOIN Customers C ON O.Customer_id = C.customer_id
        INNER JOIN Order_Line OL ON O.Order_id = OL.Order_id
        INNER JOIN Vehicle_Model VM ON OL.Model_id = VM.Model_id
    WHERE O.Salesperson_id = @Salesperson_id;
END;


EXEC GetOrderDetailsForASalesPerson 2;


----- Stored Procedure 3 -----

CREATE PROCEDURE GetManagerData
    @ManagerId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ManagerName VARCHAR(20)
    DECLARE @PlantId INT
    DECLARE @Revenue DECIMAL(10, 2)
    DECLARE @QuantitySold INT

    -- Get Manager Name
    SELECT @ManagerName = Name
    FROM Manager
    WHERE Manager_id = @ManagerId;

    -- Get Plant Id
    SELECT @PlantId = Plant_id
    FROM Assembly_Plant
    WHERE Manager_id = @ManagerId;

    -- Get Revenue of that Plant
    SELECT @Revenue = SUM(Revenue)
    FROM Sales_Data sd
        JOIN Vehicle_Model vm ON sd.Model_id = vm.Model_id
    WHERE vm.Plant_id = @PlantId;

    -- Get Quantity Sold of that Plant
    SELECT @QuantitySold = SUM(Quantity_Sold)
    FROM Sales_Data sd
        JOIN Vehicle_Model vm ON sd.Model_id = vm.Model_id
    WHERE vm.Plant_id = @PlantId;

    -- Return Manager Name, Plant Id, Revenue, and Quantity Sold
    SELECT @ManagerName AS ManagerName,
        @PlantId AS PlantId,
        @Revenue AS Revenue,
        @QuantitySold AS QuantitySold;
END;

EXEC GetManagerData 3;



-------- View 1 --------

CREATE VIEW Average_Customer_Rating_Per_Model
AS
    SELECT vm.Model_Name, AVG(cf.Rating) AS Average_Rating
    FROM Vehicle_Model vm
        INNER JOIN Order_Line ol ON vm.Model_id = ol.Model_id
        INNER JOIN Orders o ON ol.Order_id = o.Order_id
        INNER JOIN Customer_Feedback cf ON o.Customer_id = cf.Customer_id
    GROUP BY vm.Model_Name;


-------- View 2 --------

CREATE VIEW UnitsSoldPerModelPerArea
AS
    SELECT
        sp.Sales_Area,
        vm.Model_id,
        vm.Model_Name,
        COALESCE(SUM(ol.Quantity), 0) AS Units_Sold
    FROM
        Salesperson sp
CROSS JOIN 
    Vehicle_Model vm
        LEFT JOIN
        Orders o ON sp.Salesperson_id = o.Salesperson_id
        LEFT JOIN
        Order_Line ol ON o.Order_id = ol.Order_id AND ol.Model_id = vm.Model_id
    GROUP BY 
    sp.Sales_Area, vm.Model_id, vm.Model_Name;


-------- View 3 --------

CREATE VIEW Salesperson_Monthly_Salary
AS
    SELECT
        YEAR(o.Order_Date) AS Year,
        MONTH(o.Order_Date) AS Month,
        s.Salesperson_id,
        s.Name AS Salesperson_Name,
        s.Base_salary + 
        SUM(o.Total_Price * s.Commission_Rate) AS TotalMonthlySalary
    FROM
        Salesperson s
        JOIN
        Orders o ON s.Salesperson_id = o.Salesperson_id
    GROUP BY 
    YEAR(o.Order_Date),
    MONTH(o.Order_Date),
    s.Salesperson_id,
    s.Name,
    s.Base_salary;


-------- View 4 --------

CREATE VIEW Supplier_Spending_By_Date
AS
    SELECT SL.Date_Supplied AS Date,
        S.Supplier_id,
        S.Supplier_Name,
        SUM(VC.Price) AS Amount_Spent
    FROM Supply_Link AS SL
        JOIN Vehicle_Components AS VC ON SL.Component_id = VC.Component_id
        JOIN Supplier AS S ON SL.Supplier_id = S.Supplier_id
    GROUP BY SL.Date_Supplied, S.Supplier_id, S.Supplier_Name;


-------- View 5 --------

CREATE VIEW Assembly_Plant_Revenue
AS
    SELECT ap.Plant_id, ap.State, COALESCE(SUM(sd.Revenue), 0) AS Total_Revenue
    FROM Assembly_Plant ap
        LEFT JOIN Sales_Data sd ON ap.Plant_id = sd.Plant_id
    GROUP BY ap.Plant_id, ap.State;



-------- DML Trigger --------

CREATE TRIGGER update_sales_data_trigger
ON Order_Line
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Update Quantity Sold in Sales_Data table
    UPDATE Sales_Data
    SET Quantity_Sold = Quantity_Sold + (SELECT Quantity
    FROM inserted
    WHERE Sales_Data.Model_id = inserted.Model_id);

    -- Update Revenue in Sales_Data table
    UPDATE Sales_Data
    SET Revenue = (SELECT Price
    FROM Vehicle_Model
    WHERE Sales_Data.Model_id = Vehicle_Model.Model_id) * 
                  (SELECT Quantity_Sold
    FROM Sales_Data
    WHERE Sales_Data.Model_id = Vehicle_Model.Model_id)
    FROM Sales_Data
        JOIN Vehicle_Model ON Sales_Data.Model_id = Vehicle_Model.Model_id
    WHERE Sales_Data.Model_id IN (SELECT Model_id
    FROM inserted);
END;



-------- UDF 1 --------

CREATE FUNCTION dbo.fn_TotalAmountSpentByCustomer (@CustomerID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalAmount DECIMAL(10, 2);

    SELECT @TotalAmount = SUM(Total_Price)
    FROM Orders
    WHERE Customer_id = @CustomerID;

    RETURN ISNULL(@TotalAmount, 0);
END;


-------- UDF 2 --------

CREATE FUNCTION CalculateGrossCommission (@salesperson_id INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @grossCommission DECIMAL(10, 2);

    SELECT @grossCommission = (o.Total_Price * s.Commission_Rate)
    FROM Orders o
        JOIN Salesperson s ON o.Salesperson_id = s.Salesperson_id
    WHERE o.Salesperson_id = @salesperson_id;

    RETURN @grossCommission;
END;



-------- 3 Non Clustered Indexes --------

CREATE NONCLUSTERED INDEX IX_OrderLine_ModelId_OrderId 
ON Order_Line (Model_id, Order_id);


CREATE NONCLUSTERED INDEX IX_SupplyLink_SupplierId_ComponentId 
ON Supply_Link (Supplier_id, Component_id);


CREATE NONCLUSTERED INDEX IX_VehicleModel_PlantId 
ON Vehicle_Model (Plant_id);



