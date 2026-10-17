-- Task 4: one row per customer. Customers with no valid orders are kept, with zeros.
-- total_spent counts completed orders only.
select
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    c.signup_date,
    coalesce(o.total_orders, 0)                         as total_orders,
    coalesce(o.completed_orders, 0)                     as completed_orders,
    coalesce(o.open_orders, 0)                          as open_orders,
    coalesce(o.cancelled_orders, 0)                     as cancelled_orders,
    coalesce(o.completed_revenue, 0)                    as total_spent,
    case when o.completed_orders > 0 then round(o.completed_revenue / o.completed_orders, 2) end as avg_completed_order_value,
    o.first_order_date,
    o.last_order_date
from {{ ref('stg_customers') }} c
left join {{ ref('int_customer_orders') }} o on o.customer_id = c.customer_id
