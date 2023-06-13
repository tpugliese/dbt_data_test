--Seed from customer.csv

select
    id as customer_id,
    name as customer_full_name,
    {{ get_first_name('name') }} as customer_first_name,
    {{ get_last_name('name') }} as customer_last_name,
    zip_code as customer_zip_code,
    {{ get_zip_5('zip_code') }} as customer_zip_5_code
from {{ ref('customer') }}
