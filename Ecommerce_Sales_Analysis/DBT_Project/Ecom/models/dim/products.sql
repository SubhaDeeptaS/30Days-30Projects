with products as
(
    select * from {{source('raw_tables','raw_products')}}
)

select 
PRODUCT_ID,
PRODUCT_CATEGORY_NAME as CATEGORY,
PRODUCT_WEIGHT_G/1000 as WEIGHT_IN_KG,
PRODUCT_LENGTH_CM/100 as LENGTH_IN_METER,
PRODUCT_HEIGHT_CM/100 as HEIGHT_IN_METER,
PRODUCT_WIDTH_CM/100 as WIDTH_IN_METER
from products