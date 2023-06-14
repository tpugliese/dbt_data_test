with
    subscription__customers as (select * from {{ ref("int_subscription__customers") }}),

    deliveries as (select * from {{ ref("int_subscription__orders") }})

select
    subscription__customers.customer_id,
    subscription__customers.customer_full_name,
    max(deliveries.scheduled_delivery_date) as latest_scheduled_delivery_date,
    avg(deliveries.days_between_delivery) as avg_days_between_deliveries

from subscription__customers
left outer join
    deliveries on subscription__customers.customer_id = deliveries.customer_id
group by subscription__customers.customer_id, subscription__customers.customer_full_name
