-- Task 3: completed orders, units and revenue per product category.
select
    category,
    count_if(status = 'completed')                      as completed_orders,
    sum(case when status = 'completed' then quantity else 0 end) as units_sold,
    sum(recognized_revenue)                             as completed_revenue,
    count_if(status in ('pending', 'shipped'))          as open_orders,
    count_if(status = 'cancelled')                      as cancelled_orders
from {{ ref('int_orders_enriched') }}
group by category
