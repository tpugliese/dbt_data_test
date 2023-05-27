select
    customer_id,
    order_placed_at,
    scheduled_delivery_date,
    scheduled_ship_date,
    order_value,
    order_servings,
    order_recipes,
    cost_per_serving,
    cost_per_recipe,
    customer_order_sequence
from {{ ref('int_subscription__orders') }}
