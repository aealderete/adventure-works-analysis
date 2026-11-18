--- Exercise 9 ---
--- Finance says some order totals don't match the sum of their line items. Can you check if that's true, and how many orders are affected?" ---

select *
from Sales.SalesOrderHeader as soh
left join Sales.SalesOrderDetail as sod
	on soh.SalesOrderID = sod.SalesOrderID
order by sod.SalesOrderID desc

--- customers show up multiple times meaning there are several subtotals being added together incorrectly ---

with cte_per_order as (
	select SalesOrderID, sum(SubTotal) as order_total
	from Sales.SalesOrderHeader
	group by SalesOrderID
)


select sum(order_total)
from cte_per_order


SELECT SalesOrderID, SubTotal
FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43659;

SELECT SalesOrderID, SalesOrderDetailID, LineTotal
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43659;