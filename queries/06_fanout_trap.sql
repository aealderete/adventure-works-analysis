--- Exercise 8 ---
--- Fan-out trap ---
/*
n_rows = one row per sales order
n_orders = one row per order
*/

--- INITIAL COUNT ---
SELECT
    COUNT(*)                       AS n_rows,
    COUNT(DISTINCT SalesOrderID) AS n_orders,
    SUM(SubTotal)                AS total_after_join
FROM Sales.SalesOrderHeader AS sod;

--- INCORRECT QUERY ---
SELECT
    COUNT(*)                       AS n_rows,
    COUNT(DISTINCT h.SalesOrderID) AS n_orders,
    SUM(h.SubTotal)                AS total_after_join
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d
    ON h.SalesOrderID = d.SalesOrderID;

--- TESTING ---
SELECT
    COUNT(h.SalesOrderID)                       AS n_rows,
    COUNT(d.SalesOrderID)                       AS n_rows,
    COUNT(DISTINCT h.SalesOrderID) AS n_orders,
    SUM(d.LineTotal)                AS total_after_join
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d
    ON h.SalesOrderID = d.SalesOrderID;

 --- TESTING 2 ---
SELECT
    h.SalesOrderID,
    h.SubTotal,
    d.SalesOrderDetailID,
    d.LineTotal
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d
    ON h.SalesOrderID = d.SalesOrderID
WHERE h.SalesOrderID = (SELECT TOP 1 SalesOrderID
                        FROM Sales.SalesOrderDetail
                        GROUP BY SalesOrderID
                        ORDER BY COUNT(*) DESC);