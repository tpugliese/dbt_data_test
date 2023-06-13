with

subscription_customers as (
    select * from {{ ref('int_subscription__customers') }}
)

select
    customer_id,
    customer_full_name,
    customer_zip_code,
    first_order_date,
    latest_order_date
from subscription_customers
