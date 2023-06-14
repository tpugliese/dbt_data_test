-- larger case statement
-- need join of all activations & cancellations by customer table
with
    int_subscription__customers as (
        select * from {{ ref("int_subscription__customers") }}
    ),
    stg_subscription__activations as (
        select * from {{ ref("stg_subscription__activations") }}
    ),
    stg_subscription__cancellations as (
        select * from {{ ref("stg_subscription__cancellations") }}
    ),
    joined as (
        select
            int_subscription__customers.customer_id,
            int_subscription__customers.customer_full_name,
            int_subscription__customers.order_count,
            stg_subscription__activations.subscription_activation_id,
            stg_subscription__activations.activation_time,
            stg_subscription__activations.is_first_activation,
            stg_subscription__cancellations.subscription_cancellation_id,
            stg_subscription__cancellations.cancellation_time

        from int_subscription__customers
        left outer join
            stg_subscription__activations
            on int_subscription__customers.customer_id
            = stg_subscription__activations.customer_id
        left outer join
            stg_subscription__cancellations
            on int_subscription__customers.customer_id
            = stg_subscription__cancellations.customer_id
    ),
    initial_subscribers as (
        select
            customer_id,
            customer_full_name,
            order_count,
            subscription_activation_id,
            activation_time,
            subscription_cancellation_id,
            cancellation_time,
            case
                when order_count = null
                then 'never-ordered'
                when subscription_cancellation_id = null and cancellation_time = null
                then 'subscribed'
                when subscription_cancellation_id != null and cancellation_time != null
                then 'canceled'
            end as customer_subscription_status
        from joined
        where 1 = 1 and is_first_activation = true

    ),
    customer_subscription_status as (
        select
            customer_id,
            customer_full_name,
            coalesce(max(order_count), 0) as order_count,
            count(
                distinct subscription_activation_id
            ) as distinct_subscription_activations,
            max(activation_time) as max_act_time,
            count(
                distinct subscription_cancellation_id
            ) as distinct_subscription_cancellations,
            max(cancellation_time) as max_can_time,
            timediff(second, max(cancellation_time), max(activation_time)) as time_diff,
            case
                when coalesce(max(order_count), 0) = 0
                then 'never-ordered'
                when
                    coalesce(max(order_count), 0) > 0
                    and count(distinct subscription_activation_id) = null
                then 'never-activated'
                when timediff(second, max(cancellation_time), max(activation_time)) < 0
                then 'canceled'
                when timediff(second, max(cancellation_time), max(activation_time)) > 0
                then 'subscribed'
                when
                    count(distinct subscription_activation_id)
                    - count(distinct subscription_cancellation_id)
                    = count(distinct subscription_activation_id)
                then 'subscribed'
                when
                    count(distinct subscription_activation_id)
                    - count(distinct subscription_cancellation_id)
                    < 0
                then 'canceled'
                else 'logic-needs-help'
            end as customer_subscription_status
        from joined

        group by customer_id, customer_full_name
    )

select
    customer_id,
    customer_full_name,
    customer_subscription_status,
    case
        when customer_subscription_status = 'subscribed' then true 
        else false
    end as is_subscribed
from customer_subscription_status
