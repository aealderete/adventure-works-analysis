--- Exercise 2 ---
SELECT MONTH(OrderDate) AS month_col, COUNT(*) as n_orders
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2024
GROUP BY MONTH(OrderDate)
ORDER BY month_col ASC;

--- Exercise 3 ---
SELECT
    COUNT(*)                                             AS n_orders,
    COUNT(*) - COUNT(ShipDate)                           AS n_unshipped,
    SUM(CASE WHEN ShipDate > DueDate THEN 1 ELSE 0 END)  AS n_late,
    CAST(
        SUM(CASE WHEN ShipDate > DueDate THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
        AS decimal(5,2)
    )                                                    AS pct_late
FROM Sales.SalesOrderHeader;

--- Exercise 4 ---
WITH line_items_cte AS (
	SELECT SalesOrderID, COUNT(*) as line_items
	FROM Sales.SalesOrderDetail
	GROUP BY SalesOrderID
	HAVING COUNT(*) > 5
)

SELECT COUNT(*) as occurences_of_multiple_sales_orders
FROM line_items_cte