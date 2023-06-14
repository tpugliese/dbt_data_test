-- Seed from subscription_cancellation.csv
select
    {{ dbt_utils.generate_surrogate_key(["customer_id", "cancellation_time"]) }}
    as subscription_cancellation_id,
    customer_id,
    cancellation_time,
    cancellation_reason
from {{ ref("subscription_cancellation") }}
