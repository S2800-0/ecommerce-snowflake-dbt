-- Task 3: join each valid order with its customer and product, and calculate the order revenue.
--   order_revenue     = quantity x product price, for every order whatever its status
--   recognized_revenue = the same amount, but only for completed orders (0 for the others)
select
    o.order_id,
    o.order_date,
    o.status,
    o.status = 'completed'                              as is_completed,
    o.customer_id,
    c.customer_name,
    c.city                                              as customer_city,
    o.product_id,
    p.product_name,
    p.category,
    p.price                                             as unit_price,
    o.quantity,
    o.quantity * p.price                                as order_revenue,
    case when o.status = 'completed' then o.quantity * p.price else 0 end as recognized_revenue
from {{ ref('stg_orders') }} o
join {{ ref('stg_customers') }} c on c.customer_id = o.customer_id
join {{ ref('stg_products') }}  p on p.product_id  = o.product_id
