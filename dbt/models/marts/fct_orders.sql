-- Task 4: one row per valid order, with customer and product details and the calculated revenue.
select
    order_id,
    order_date,
    date_trunc('month', order_date)::date               as order_month,
    status,
    is_completed,
    customer_id,
    customer_name,
    customer_city,
    product_id,
    product_name,
    category,
    unit_price,
    quantity,
    order_revenue,
    recognized_revenue
from {{ ref('int_orders_enriched') }}
