--- Exercise 9 ---
--- each customer's most recent order ---

WITH ranked AS (
    SELECT
        CustomerID,
        SalesOrderID,
        OrderDate,
        TotalDue,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate DESC, SalesOrderID DESC
        ) AS rn
    FROM Sales.SalesOrderHeader
)
SELECT CustomerID, SalesOrderID, OrderDate, TotalDue
FROM ranked
WHERE rn = 1;