-- One row per product, with clean names and a numeric price.
-- Rows with a missing id or a price that is not a positive number are dropped here.
select
    try_to_number(product_id)                   as product_id,
    trim(product_name)                          as product_name,
    initcap(trim(category))                     as category,
    try_to_number(price, 12, 2)                 as price
from {{ source('raw', 'products') }}
where try_to_number(product_id) is not null
  and try_to_number(price, 12, 2) > 0
qualify row_number() over (partition by try_to_number(product_id) order by _loaded_at desc) = 1
