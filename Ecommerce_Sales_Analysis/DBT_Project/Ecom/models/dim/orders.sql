with orders as
(
    select * from {{source('raw_tables','raw_orders')}}
)

select order_id,
customer_id,
order_status,
order_purchase_timestamp as purchase_timestamp,
ORDER_APPROVED_AT as Approved_Timestamp,
ORDER_DELIVERED_TIMESTAMP as DELIVERED_TIMESTAMP,
ORDER_ESTIMATED_DELIVERY_DATE as DELIVERY_DATE
from orders
