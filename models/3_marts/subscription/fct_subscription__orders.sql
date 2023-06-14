with

int_subscription__orders as (
    select * from {{ ref('int_subscription__orders') }}
)

select
* 
from int_subscription__orders
