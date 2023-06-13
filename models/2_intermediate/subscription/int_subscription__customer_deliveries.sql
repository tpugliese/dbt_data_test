with
    subscription__customers as (select * from {{ ref("int_subscription__customers") }}),

    deliveries as (
        select
            subscription_order_id,
            customer_id,
            order_placed_at,
            scheduled_delivery_date,
            scheduled_ship_date,
            order_value,
            order_servings,
            order_recipes,
            cost_per_serving,
            cost_per_recipe,
            days_between_delivery,
            customer_order_sequence
        from {{ ref("stg_subscription__orders") }}
    )

select
    subscription__customers.customer_id,
    count(deliveries.subscription_order_id),
    avg(days_between_delivery)

from subscription__customers
left outer join
    deliveries on subscription__customers.customer_id = deliveries.customer_id
group by subscription__customers.customer_id
