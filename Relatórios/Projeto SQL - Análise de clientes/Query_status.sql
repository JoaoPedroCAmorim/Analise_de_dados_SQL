/* Status profissional dos leads
-- Colunas: status profissional, leads (%)*/
CREATE VIEW status_profissional_view AS
Select
	case
		when professional_status = 'freelancer' then 'freelancer'
		when professional_status = 'retired' then 'aposentado'
		when professional_status = 'clt' then 'clt'
		when professional_status = 'self_employed' then 'autônomo'
		when professional_status = 'oher' then 'outro'
		when professional_status = 'businessman' then 'empresário'
		when professional_status = 'civil_servant' then 'funcionário público'
		when professional_status = 'student' then 'estudante'
		end as "status professional",
	(Count(*)::float)/(select count(*) from sales.customers) as "leads (%)"
from sales.customers
group by professional_status
order by "leads (%)"