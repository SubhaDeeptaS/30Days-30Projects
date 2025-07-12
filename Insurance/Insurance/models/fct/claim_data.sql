with claim_raw as
(
    select * from {{source('raw_tables','claims')}}
)

select 
claim_id,
policy_id,
data:claim_date as claim_date,
data:claim_amount as claim_amount,
data:claim_status as claim_status,
data:description as description
from 
claim_raw