with

subscription__customers as (
    select * from {{ ref('int_subscription__customers') }}
),

subscription__deliveries as (
    select * from {{ ref('int_subscription__customer_deliveries') }}
),

subscription__customer_statuses as (
    select * from {{ ref('int_subscription__customer_statuses') }}
)

select
/*    customer_id,
    customer_full_name,
    customer_first_name,
    customer_last_name,
    customer_zip_code,
    customer_zip_5_code,
    first_order_date,
    latest_order_date */
*
from subscription_customers
