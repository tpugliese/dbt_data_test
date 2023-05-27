select
    customer_id,
    activation_time,
    is_first_activation
from {{ ref('subscription_activation') }}
