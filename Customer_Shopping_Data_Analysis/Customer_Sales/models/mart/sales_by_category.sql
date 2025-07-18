with shopping as
(
    select * from {{ref('shopping_cleaned')}}
)

select 
round(sum(price),2) as total_sales, 
category from shopping
group by category
