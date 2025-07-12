with address_raw as
(
    select * from {{source('raw_tables','address')}}
)

select 
address_id,
event,
data:street street,
data:city city,
data:state state,
data:zipcode zipcode,
data:country country
from address_raw