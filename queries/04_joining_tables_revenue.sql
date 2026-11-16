--- the top 5 product categories by revenue ---

SELECT TOP 5 pc.Name as category, CAST(ROUND(SUM(sod.LineTotal), 2) AS money) as revenue
FROM Sales.SalesOrderDetail AS sod
LEFT JOIN Production.Product as pr
	ON sod.ProductID = pr.ProductID
LEFT JOIN Production.ProductSubcategory as psc
	ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory as pc
	ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY revenue DESC