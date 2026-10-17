-- One row per valid order. Invalid rows are not lost: see stg_orders_rejected for each one and its reason.
select order_id, customer_id, product_id, quantity, order_date, status
from ({{ orders_checked() }}) checked
where rejection_reason is null
