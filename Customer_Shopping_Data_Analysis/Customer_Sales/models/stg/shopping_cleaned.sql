with raw as 
(
    select * from {{ref('shopping')}}
)

select
invoice_no as invoice_id,
customer_id,
gender,
age, 
category,
quantity,
price,
payment_method,
{{change_date('invoice_date')}} as order_date,
monthname(order_date) as month_of_purchase,
year(order_date) as year_of_purchase
from 
raw