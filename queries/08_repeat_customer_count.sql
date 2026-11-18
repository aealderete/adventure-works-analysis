--- Exercise 7 ---
--- How many customers have ordered more than once? ---

WITH multi_order_customers AS (
	select CustomerID, count(CustomerID) as n_orders
	from sales.SalesOrderHeader
	group by CustomerID
)

select
	count(*) as n_customers,
	sum(case when n_orders > 1 then 1 else 0 end) as n_repeats,
	cast(round(sum(case when n_orders > 1 then 1 else 0 end) * 100.0 / count(*), 2) as decimal(5, 2)) as repeat_percentage
from multi_order_customers