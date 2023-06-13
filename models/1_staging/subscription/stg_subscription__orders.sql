select
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'order_placed_at']) }} as subscription_order_id,
    customer_id,
    order_placed_at,
    scheduled_delivery_date,
    scheduled_ship_date,
    order_value,
    order_servings,
    order_recipes,
    order_value / order_servings as cost_per_serving,
    order_value / order_recipes as cost_per_recipe,
    datediff(day, scheduled_ship_date, scheduled_delivery_date) AS date_between_delivery,
    row_number() over (partition by customer_id order by order_placed_at) as customer_order_sequence
from {{ ref('subscription_order') }}
