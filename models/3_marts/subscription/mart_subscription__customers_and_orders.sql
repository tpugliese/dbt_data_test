with

fct_subscription__orders as (
    select * from {{ ref('fct_subscription__orders') }}
),

dim_subscription__customers as (
    select * from {{ ref('dim_subscription__customers') }}
),

joined as (

    select
        fct_subscription__orders.*,
        dim_subscription__customers.* exclude customer_id
    
    from fct_subscription__orders
    left outer join dim_subscription__customers on fct_subscription__orders.customer_id = dim_subscription__customers.customer_id

)

select *
from joined
