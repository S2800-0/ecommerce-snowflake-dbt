-- Every raw order row must end up either in stg_orders or in stg_orders_rejected.
select raw_rows, kept_rows, rejected_rows
from (
    select
        (select count(*) from {{ source('raw', 'orders') }}) as raw_rows,
        (select count(*) from {{ ref('stg_orders') }})       as kept_rows,
        (select count(*) from {{ ref('stg_orders_rejected') }}) as rejected_rows
)
where raw_rows <> kept_rows + rejected_rows
