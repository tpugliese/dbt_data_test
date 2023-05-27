select
    ord.customer_id,
    ord.order_placed_at,
    ord.scheduled_delivery_date,
    ord.scheduled_ship_date,
    ord.order_value,
    ord.order_servings,
    ord.order_recipes,
    ord.cost_per_serving,
    ord.cost_per_recipe,
    ord.customer_order_sequence
from {{ ref('stg_subscription__orders') }} as ord
