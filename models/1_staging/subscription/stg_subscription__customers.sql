select
    id as customer_id,
    name as customer_full_name,
    zip_code as customer_zip_code
from {{ ref('customer') }}
