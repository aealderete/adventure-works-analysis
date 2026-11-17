--- Exercise 6 ---
--- Products never sold ---
SELECT p.ProductID, p.Name
FROM Production.Product AS p
LEFT JOIN Sales.SalesOrderDetail AS sod
	ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL
ORDER BY p.ProductID