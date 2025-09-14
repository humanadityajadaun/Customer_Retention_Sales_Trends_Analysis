/*
Project: Customer Retention & Sales Trends Analysis
Author: Aditya Jadaun
Description: 
This script performs data validation, integrity checks, data aggregation, and generates key analytics for the Customer Retention and Sales Trends project.
Technologies: SQL, Power BI
Purpose: Cross-check dataset consistency, calculate repeated customers, sales by region/category, top products, and more.
*/


create database customer_retention;
USE customer_retention;
SELECT * FROM customers LIMIT 20;
SELECT * FROM orders LIMIT 10;
SELECT * FROM products LIMIT 10;

-- 1. Check Row Counts
SELECT 'customers' AS TableName, COUNT(*) AS TotalRows FROM customers;
SELECT 'products' AS TableName, COUNT(*) AS TotalRows FROM products;
SELECT 'orders' AS TableName, COUNT(*) AS TotalRows FROM orders;

-- 2. Check for Null Values
SELECT * FROM customers WHERE CustomerID IS NULL OR CustomerName IS NULL OR Region IS NULL;
SELECT * FROM products WHERE ProductID IS NULL OR ProductName IS NULL;
SELECT * FROM orders WHERE OrderID IS NULL OR CustomerID IS NULL OR ProductID IS NULL;

-- 3. Check for Duplicate Rows
SELECT OrderID, COUNT(*) AS DuplicateCount FROM Orders GROUP BY OrderID HAVING COUNT(*) > 1; 

SELECT IFNULL(COUNT(*), 0) AS DuplicateCount
FROM (
    SELECT OrderID
    FROM Orders
    GROUP BY OrderID
    HAVING COUNT(*) > 1
) AS Duplicates;


SELECT ProductID, COUNT(*) AS DuplicateCount FROM Products GROUP BY ProductID HAVING COUNT(*) > 1;
SELECT CustomerID, COUNT(*) AS DuplicateCount FROM Customers GROUP BY CustomerID HAVING COUNT(*) > 1;

-- 4. Validate Aggregated Sales
SELECT SUM(Quantity * UnitPrice) AS CalculatedTotalSales, SUM(TotalSales) AS ReportedTotalSales FROM Orders;

-- 5. Referential Integrity Check
SELECT o.* FROM orders o LEFT JOIN Customers c ON o.CustomerID = c.CustomerID WHERE c.CustomerID IS NULL;
SELECT o.* FROM Orders o LEFT JOIN Products p ON o.ProductID = p.ProductID WHERE p.ProductID IS NULL;

-- 6. Unique Customer & Product Count
SELECT COUNT(DISTINCT CustomerID) AS UniqueCustomers FROM Orders;
SELECT COUNT(DISTINCT ProductID) AS UniqueProducts FROM Orders;

-- 7. Top 5 Products by Sales
SELECT p.ProductName, SUM(o.TotalSales) AS TotalSales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSales DESC
LIMIT 5;

-- 8. Customer Order Frequency
SELECT CustomerID, COUNT(DISTINCT OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
ORDER BY TotalOrders DESC;

-- 9. Repeat Customers Count
SELECT COUNT(*) AS RepeatedCustomerCount
FROM (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING COUNT(OrderID) > 1
) AS RepeatedCustomers;

-- 10. Total Sales by Region

SELECT c.Region, SUM(o.TotalSales) AS TotalSales
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.Region
ORDER BY TotalSales DESC;

-- 11. Total Sales by Product Category

SELECT p.Category, SUM(o.TotalSales) AS TotalSales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;

-- Completed --