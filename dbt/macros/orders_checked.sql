{#
  Every raw order row, cleaned and checked. A row with a problem gets a rejection_reason.
  stg_orders keeps the rows without one, stg_orders_rejected keeps the rest, so nothing disappears silently.

  Reasons, in the order they are checked:
    invalid_order_id       the id is missing or not a number
    duplicate_order        the same order_id appeared more than once (the first copy is kept)
    invalid_quantity       the quantity is missing, not a number, or zero or negative
    unknown_customer       the customer_id does not exist in stg_customers
    unknown_product        the product_id does not exist in stg_products
    unknown_status         the status is not one of completed, pending, shipped, cancelled
#}
{% macro orders_checked() %}
with typed as (

    select
        try_to_number(order_id)                         as order_id,
        try_to_number(customer_id)                      as customer_id,
        try_to_number(product_id)                       as product_id,
        try_to_number(quantity, 12, 2)                  as quantity,
        try_to_date(order_date)                         as order_date,
        case lower(trim(status))
            when 'completed' then 'completed'
            when 'complete'  then 'completed'
            when 'pending'   then 'pending'
            when 'shipped'   then 'shipped'
            when 'cancelled' then 'cancelled'
            when 'canceled'  then 'cancelled'
            else 'unknown'
        end                                             as status,
        _source_file,
        _loaded_at
    from {{ source('raw', 'orders') }}

),

numbered as (

    select
        *,
        row_number() over (partition by order_id order by _loaded_at, _source_file) as copy_number
    from typed

)

select
    n.order_id,
    n.customer_id,
    n.product_id,
    n.quantity::number(12, 0)                           as quantity,
    n.order_date,
    n.status,
    n._source_file,
    case
        when n.order_id is null                          then 'invalid_order_id'
        when n.copy_number > 1                           then 'duplicate_order'
        when n.quantity is null or n.quantity <= 0       then 'invalid_quantity'
        when c.customer_id is null                       then 'unknown_customer'
        when p.product_id is null                        then 'unknown_product'
        when n.status = 'unknown' or n.order_date is null then 'unknown_status'
    end                                                 as rejection_reason
from numbered n
left join {{ ref('stg_customers') }} c on c.customer_id = n.customer_id
left join {{ ref('stg_products') }}  p on p.product_id  = n.product_id
{% endmacro %}
