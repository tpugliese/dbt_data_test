-- Seed from subscription_activation.csv
select
    {{ dbt_utils.generate_surrogate_key(["customer_id", "activation_time"]) }}
    as subscription_activation_id,
    customer_id,
    activation_time,
    is_first_activation
from {{ ref("subscription_activation") }}
