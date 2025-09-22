/* Gênero dos leads
Colunas: gênero, leads(#)*/
CREATE VIEW genero_leads_view AS
select
	case
		when ibge.gender = 'male' then 'homem'
		when ibge.gender = 'female' then 'mulher'
		end as "genero",
	count(*) as "leads (#)"
from sales.customers as cus
left join temp_tables.ibge_genders as ibge
	on lower(cus.first_name) = lower(ibge.first_name)
group by ibge.gender