with payment_raw as
(
    select * from {{source('raw_tables','payment')}}
)

select
payment_id,
policy_id,
event,
data:payment_date payment_date,
data:payment_amount payment_amount,
data:payment_method payment_method,
data:payment_status payment_status
from 
payment_raw