with subscription_customers as (select * from {{ ref("int_subscription__customers") }})

select
    customer_cohort,
    count(distinct customer_id),
    sum(order_count),
    sum(total_order_value)

from subscription_customers
group by customer_cohort
