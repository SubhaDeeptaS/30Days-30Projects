with customer_raw as
(
    select * from {{source('raw_tables','customer')}}
)

select 
customer_id,
address_id,
event,
data:first_name as first_name,
data:last_name as last_name,
data:date_of_birth date_of_birth,
data:gender gender,
data:phone phone,
data:email email
from customer_raw