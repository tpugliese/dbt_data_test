select
    id as customer_id,
    name as customer_full_name,
    'placeholder_' as customer_first_name,
    '_placeholder' as customer_last_name,
    zip_code as customer_zip_code,
    '12345' as customer_zip_5_code

from {{ ref('customer') }}
