-- Business rule: pending, shipped and cancelled orders must add no revenue.
select order_id, status, recognized_revenue
from {{ ref('fct_orders') }}
where status <> 'completed' and recognized_revenue <> 0
