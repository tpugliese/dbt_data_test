with

    subscription__customers as (select * from {{ ref("int_subscription__customers") }}),

    subscription__deliveries as (
        select * from {{ ref("int_subscription__customer_deliveries") }}
    -- Get latest_scheduled_delivery_date, avg_days_between_deliveries
    ),

    subscription__customer_statuses as (
        select * from {{ ref("int_subscription__customer_statuses") }}
    -- get customer_subscription_status, is_subscribed
    )

select
    subscription__customers.customer_id,
    subscription__customers.customer_full_name,
    subscription__customers.customer_first_name,
    subscription__customers.customer_last_name,
    subscription__customers.customer_zip_code,
    subscription__customers.customer_zip_5_code,
    subscription__customers.first_order_date,
    subscription__customers.latest_order_date,
    subscription__deliveries.latest_scheduled_delivery_date,
    subscription__deliveries.avg_days_between_deliveries,
    subscription__customer_statuses.customer_subscription_status,
    subscription__customer_statuses.is_subscribed

from subscription__customers
inner join
    subscription__deliveries
    on subscription__customers.customer_id = subscription__deliveries.customer_id
inner join
    subscription__customer_statuses
    on subscription__customers.customer_id
    = subscription__customer_statuses.customer_id
