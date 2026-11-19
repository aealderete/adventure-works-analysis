select year(e.HireDate) as hired_date, count(*) as n_hires
from HumanResources.Employee as e
group by year(e.HireDate)
order by hired_date;

select count(*) as no_middle
from Person.Person
where MiddleName is null;


select sum(n_share_last_name) as n_same_last_name
from (
	select count(*) as n_share_last_name
	from Person.Person
	group by LastName
	having count(*) > 1
) as mult_lst_name_tbl
