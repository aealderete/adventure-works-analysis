--- Exercise 2 ---
SELECT COUNT(*) as n_orders
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2024
GROUP BY MONTH(OrderDate);

--- Exercise 3 ---
SELECT ShipDate, DueDate
FROM Sales.SalesOrderHeader
WHERE ShipDate > DueDate;

--- Exercise 4 ---
WITH line_items_cte AS (
	SELECT SalesOrderID, COUNT(*) as line_items
	FROM Sales.SalesOrderDetail
	GROUP BY SalesOrderID
	HAVING COUNT(*) > 5
)

SELECT COUNT(*) as occurences_of_multiple_sales_orders
FROM line_items_cte