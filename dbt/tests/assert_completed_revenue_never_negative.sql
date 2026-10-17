-- Business rule: completed-order revenue can never be negative. The test fails if any rows come back.
select order_id, recognized_revenue
from {{ ref('fct_orders') }}
where recognized_revenue < 0
