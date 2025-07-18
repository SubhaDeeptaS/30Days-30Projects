with shopping as
(
    select * from {{ref('shopping_cleaned')}}
)

select 
sum(price) as total_sales, 
payment_method from shopping
group by payment_method