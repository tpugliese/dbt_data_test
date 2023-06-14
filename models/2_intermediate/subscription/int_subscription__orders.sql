with

orders as (
    select * from {{ ref('stg_subscription__orders')}}
)

select
    orders.subscription_order_id,
    orders.customer_id,
    orders.order_placed_at,
    orders.scheduled_delivery_date,
    orders.scheduled_ship_date,
    orders.order_value,
    orders.order_servings,
    orders.order_recipes,
    orders.cost_per_serving,
    orders.cost_per_recipe,
    orders.days_between_delivery,
    orders.customer_order_sequence
from orders
