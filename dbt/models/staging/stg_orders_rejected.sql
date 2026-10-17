-- The order rows that were kept out of stg_orders, each with the reason.
select order_id, customer_id, product_id, quantity, order_date, status, _source_file, rejection_reason
from ({{ orders_checked() }}) checked
where rejection_reason is not null
