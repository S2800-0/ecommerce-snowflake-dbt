-- One row per customer, with clean names and real data types.
-- A blank city becomes 'Unknown' and a blank email stays null. Duplicate ids keep the latest load.
select
    try_to_number(customer_id)                  as customer_id,
    initcap(trim(customer_name))                as customer_name,
    nullif(lower(trim(email)), '')              as email,
    coalesce(nullif(trim(city), ''), 'Unknown') as city,
    try_to_date(signup_date)                    as signup_date
from {{ source('raw', 'customers') }}
where try_to_number(customer_id) is not null
qualify row_number() over (partition by try_to_number(customer_id) order by _loaded_at desc) = 1
