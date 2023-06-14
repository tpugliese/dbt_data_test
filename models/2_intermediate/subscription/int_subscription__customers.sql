with

    subscription_customers as (select * from {{ ref("stg_subscription__customers") }}),

    orders as (
        select
            customer_id,
            count(subscription_order_id) as order_count,
            sum(order_value) as total_order_value,
            to_varchar(
                cast(min(order_placed_at) as date), 'YYYY-MM'
            ) as customer_cohort,
            cast(min(order_placed_at) as date) as first_order_date,
            cast(max(order_placed_at) as date) as latest_order_date
        from {{ ref("stg_subscription__orders") }}
        group by customer_id
    )

select
    subscription_customers.customer_id,
    subscription_customers.customer_full_name,
    subscription_customers.customer_first_name,
    subscription_customers.customer_last_name,
    subscription_customers.customer_zip_code,
    subscription_customers.customer_zip_5_code,
    orders.order_count,
    orders.total_order_value,
    orders.customer_cohort,
    orders.first_order_date,
    orders.latest_order_date

from subscription_customers
left outer join orders on subscription_customers.customer_id = orders.customer_id
