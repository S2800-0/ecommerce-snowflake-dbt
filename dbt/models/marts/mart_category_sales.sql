-- Task 4: one row per product category. Orders and revenue count completed orders only.
-- Pending and shipped orders are shown as open_orders, cancelled ones as cancelled_orders, and neither adds revenue.
select
    category,
    completed_orders,
    units_sold,
    completed_revenue                                   as revenue,
    case when completed_orders > 0 then round(completed_revenue / completed_orders, 2) end as avg_completed_order_value,
    round(100.0 * completed_revenue / nullif(sum(completed_revenue) over (), 0), 1)       as revenue_share_pct,
    open_orders,
    cancelled_orders
from {{ ref('int_category_revenue') }}
