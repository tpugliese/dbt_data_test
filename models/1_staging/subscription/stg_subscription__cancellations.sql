select
    customer_id,
    cancellation_time,
    cancellation_reason
from {{ ref('subscription_cancellation') }}
