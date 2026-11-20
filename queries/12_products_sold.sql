--- Exercise 12 Products Sold ---
SELECT TOP 5 *
FROM Sales.SalesOrderHeader AS soh
LEFT JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
LEFT JOIN Production.Product as p
	ON sod.ProductID = p.ProductID

SELECT COUNT(DISTINCT ProductID)
FROM Production.Product
--- 504 Products in total ---

SELECT COUNT(DISTINCT ProductID)
FROM Sales.SalesOrderDetail
--- 266 Unique ProductID's indicating 266 unique products out of the 504 products were purchased ---

SELECT SUM(OrderQty)
FROM Sales.SalesOrderDetail
--- 274914 units have been sold in total ---

SELECT COUNT(LineTotal)
FROM Sales.SalesOrderDetail
--- 121317 Line Totals exist ---