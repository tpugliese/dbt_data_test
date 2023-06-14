-- Number 8
-- get customer zip 5
-- get delivery count
-- get at least 3 counts
-- get avg wait time
-- wait time rank
with

    zip_codes as (select * from {{ ref("int_subscription__customers") }}),

    orders as (select * from {{ ref("int_subscription__orders") }}),

    joined as (
        select
            zip_codes.customer_id,
            zip_codes.customer_zip_5_code,
            orders.subscription_order_id,
            orders.days_between_delivery

        from zip_codes
        left outer join orders on zip_codes.customer_id = orders.customer_id
    ),

    ranked_zip_codes as (
        select
            customer_zip_5_code,
            avg(days_between_delivery) as avg_wait_time,
            dense_rank() over (
                order by avg(days_between_delivery) desc
            ) as wait_time_rank
        from joined
        where 1 = 1
            and days_between_delivery is not null
        group by customer_zip_5_code
    ),

    counts_zip_codes as (
        select
            customer_zip_5_code,
            count(distinct customer_id) as customer_count,
            count(distinct subscription_order_id) as delivery_count,
            (
                case
                    when count(distinct subscription_order_id) >= 3 then true else false
                end
            ) as is_at_least_3
        from joined
        group by customer_zip_5_code
    )

select
    distinct joined.customer_zip_5_code,
    counts_zip_codes.customer_count,
    counts_zip_codes.delivery_count,
    counts_zip_codes.is_at_least_3,
    ranked_zip_codes.avg_wait_time,
    ranked_zip_codes.wait_time_rank

from joined
left outer join
    ranked_zip_codes
    on joined.customer_zip_5_code = ranked_zip_codes.customer_zip_5_code
left outer join
    counts_zip_codes
    on joined.customer_zip_5_code = counts_zip_codes.customer_zip_5_code
order by ranked_zip_codes.wait_time_rank
