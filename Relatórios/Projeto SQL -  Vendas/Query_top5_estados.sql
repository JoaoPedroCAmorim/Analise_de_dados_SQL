/* Estados que mais venderam
Colunas: Pais, estado, vendas (#)*/
CREATE VIEW estados_com_mais_vendas_view AS
select
	'Brazil' as pais,
	cus.state as estado,
	count(fun.paid_date) as "vendas (#)"
From sales.funnel as fun
left join sales.customers as cus
	on fun.customer_id = cus.customer_id
where paid_date between '2021-08-01' and '2021-08-31'
group by pais, estado
order by "vendas (#)" desc
limit 5