SELECT COUNT(*) as n_orders
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
--- 0 ---

SELECT COUNT(DISTINCT CustomerID)
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2023
--- 3155 ---

SELECT CustomerID, COUNT(*) AS n_orders
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2023
GROUP BY CustomerID
HAVING COUNT(*) > 2
ORDER BY n_orders DESC