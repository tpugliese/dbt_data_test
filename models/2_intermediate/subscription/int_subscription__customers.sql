with orders as (
    select
        customer_id,
        cast(min(order_placed_at) as date) as first_order_date,
        cast(max(order_placed_at) as date) as latest_order_date
    from {{ ref('stg_subscription__orders') }}
    group by 1
)

select
    c.customer_id,
    c.customer_full_name,
    c.customer_zip_code,
    ord.first_order_date,
    ord.latest_order_date

from {{ ref('stg_subscription__customers') }} as c
left outer join orders as ord
    on c.customer_id = ord.customer_id
