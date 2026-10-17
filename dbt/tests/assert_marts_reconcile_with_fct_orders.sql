-- Business rule: the customer summary and the category sales must both add up to the completed revenue in fct_orders.
with parts as (
    select
        (select sum(recognized_revenue) from {{ ref('fct_orders') }})        as fct_total,
        (select sum(total_spent) from {{ ref('mart_customer_summary') }})    as customer_total,
        (select sum(revenue) from {{ ref('mart_category_sales') }})          as category_total
)
select * from parts
where fct_total <> customer_total or fct_total <> category_total
