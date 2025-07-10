with orderitems as
(
    select * from {{source('raw_tables','raw_orderitems')}}
)

select
ORDER_ID,
PRODUCT_ID,
SELLER_ID,
PRICE,
SHIPPING_CHARGES as CHARGES
from 
orderitems