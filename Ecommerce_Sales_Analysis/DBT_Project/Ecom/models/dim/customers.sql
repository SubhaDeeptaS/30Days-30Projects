with customers as
(
    select * from {{source('raw_tables','raw_customers')}}
)

select
CUSTOMER_ID,
CUSTOMER_ZIP_CODE_PREFIX as ZIP_CODE,
CUSTOMER_CITY as CITY,
CUSTOMER_STATE as CUSTOMER_STATE
from 
customers