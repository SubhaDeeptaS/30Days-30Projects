with policy_raw as
(
    select * from {{source('raw_tables','policy')}}
)

select 
policy_id,
customer_id,
event,
data:policy_type policy_type,
data:start_date start_date,
data:end_date end_date,
data:premium_amount premium_amount,
data:coverage_amount coverage_amount,
data:status status
from policy_raw