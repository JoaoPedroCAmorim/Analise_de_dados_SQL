select 
	date_trunc('month', fun.paid_date)::date as paid_month,
	count(fun.paid_date) as paid_count,
	sum(pro.price * (1+fun.discount)) as receita
from sales.funnel as fun
	Left join sales.products as pro
			on fun.product_id = pro.product_id
where fun.paid_date is not null
group by paid_month
order by paid_month

