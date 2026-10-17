-- Task 3: order counts and completed revenue per customer, only for customers who have orders.
select
    customer_id,
    count(*)                                            as total_orders,
    count_if(status = 'completed')                      as completed_orders,
    count_if(status in ('pending', 'shipped'))          as open_orders,
    count_if(status = 'cancelled')                      as cancelled_orders,
    sum(recognized_revenue)                             as completed_revenue,
    min(order_date)                                     as first_order_date,
    max(order_date)                                     as last_order_date
from {{ ref('int_orders_enriched') }}
group by customer_id
