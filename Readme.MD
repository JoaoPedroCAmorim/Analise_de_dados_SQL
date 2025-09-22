# Análise de Vendas com SQL: Extraindo Insights do Negócio
Este repositório contém um conjunto de **queries SQL** desenvolvidas para analisar dados de vendas e extrair insights estratégicos para um negócio. O projeto demonstra a capacidade de manipular, filtrar e agregar dados para responder a perguntas-chave sobre o desempenho comercial de uma empresa. Este projeto foi desenvolvido no curso SQL para análise de dados.
## Análises Realizadas

O projeto vendas inclui queries para as seguintes análises:

* **Top 5 Lojas com Mais Vendas:** Identifica as lojas de melhor desempenho, permitindo focar esforços e recursos em estratégias de sucesso comprovadas.
     ```sql
        CREATE VIEW lojas_com_mais_vendas_view AS
        select
            sto.store_name as loja,
            count(fun.paid_date) as "vendas (#)"            
        from sales.funnel as fun
        left join sales.stores as sto
            on fun.store_id = sto.store_id
        where paid_date between '2021-08-01' and '2021-08-31'
        group by loja
        order by "vendas (#)" desc
        limit 5
     ```
* **Top 5 Marcas Mais Vendidas:** Aponta quais marcas estão gerando mais receita, ajudando a tomar decisões de estoque, marketing e negociação com fornecedores.
     ```sql
        CREATE VIEW top_5_marcas_view AS
        select
            pro.brand as marca,
            count(fun.paid_date) as "vendas (#)" 
        from sales.funnel as fun
        left join sales.products as pro
            on fun.product_id = pro.product_id
        where paid_date between '2021-08-01' and '2021-08-31'
        group by marca
        order by "vendas (#)" desc
        limit 5
     ```
* **Top 5 Estados com Mais Vendas:** Fornece uma visão geográfica do faturamento, crucial para otimizar a logística e planejar a expansão regional.
     ```sql
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
     ```
* **Vendas por Dia da Semana:** Revela padrões de sazonalidade, auxiliando na otimização de horários de funcionamento e alocação de equipe.
     ```sql
        CREATE VIEW visitas_ao_site_view AS
        Select
            extract('dow' from visit_page_date) as dia_semana,
            case 
                when extract('dow' from visit_page_date) = 0 then 'domingo'
                when extract('dow' from visit_page_date) = 1 then 'segunda'
                when extract('dow' from visit_page_date) = 2 then 'terça'
                when extract('dow' from visit_page_date) = 3 then 'quarta'
                when extract('dow' from visit_page_date) = 4 then 'quinta'
                when extract('dow' from visit_page_date) = 5 then 'sexta'
                when extract('dow' from visit_page_date) = 6 then 'sabado'
                else null end as "dia da semana",
            count(*) as "visitas (#)"
        from sales.funnel
        where visit_page_date between '2021-08-01' and '2021-08-31'
        group by dia_semana
        order by dia_semana
     ```
* **Receita Mensal:** Permite o acompanhamento da saúde financeira do negócio ao longo do tempo, identificando tendências de crescimento ou queda.
     ```sql
        CREATE VIEW acompanhamento_leads_view AS
        With
        leads as (
                select
                    date_trunc('month', visit_page_date)::date as visit_page_month,
                    count(*) as visit_page_count
                from sales.funnel
                group by visit_page_month
                order by visit_page_month
                ),
        payments as (
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
        )
        select
            leads.visit_page_month as "mês",
            leads.visit_page_count as "leads (#)",
            payments.paid_count as "vendas (#)",
            (payments.receita/1000) as "receitas (k,R$)",
            (payments.paid_count::float/leads.visit_page_count::float) as "conversão(%)",
            (payments.receita/payments.paid_count/1000) as "Ticket médio (k,R$)"
            from leads
            Left join payments
            on leads.visit_page_month = paid_month
     ```
O projeto análise de clientes inclui queries para as seguintes análises:
* **Análise de Veículos: Identifica as marcas de veículos mais visitadas, além de classificar os veículos entre "novo" e "seminovo" e analisar a idade dos veículos que geram mais visitas.
     ```sql
        CREATE VIEW veiculos_visitados_view AS
        With
            classificacao_veiculos as (
                select 
                    fun.visit_page_date,
                    pro.model_year,
                    extract('year' from visit_page_date) - pro.model_year::int as idade_veiculo,
                    case
                        when (extract('year' from visit_page_date) - pro.model_year::int)<=2 then 'novo'
                        else 'seminovo'
                        end as "classificação do veículo"
                from sales.funnel as fun
                left join sales.products as pro
                    on fun.product_id = pro.product_id	
            )
        select
            "classificação do veículo",
            count(*) as "veículos visitados (#)"
        from classificacao_veiculos
        group by "classificação do veículo"	
     ```
* **Perfil do Cliente e Comportamento de Compra: Uma análise detalhada sobre o público que mais compra, incluindo a faixa salarial, gênero e status profissional dos clientes mais frequentes.
     ```sql
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
     ```


* ## Tecnologias e Ferramentas

* **Linguagem de Consulta:** SQL
* **Banco de Dados:** PostgreSQL
* **RDBMS:** DBeaver