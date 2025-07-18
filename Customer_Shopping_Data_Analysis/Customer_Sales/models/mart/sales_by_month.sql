with shopping as
(
    select * from {{ref('shopping_cleaned')}}
)

select 
sum(price) as total_sales, 
month_of_purchase, 
year_of_purchase from shopping_cleaned 
group by month_of_purchase, year_of_purchase
order by year_of_purchase, {{find_month('month_of_purchase')}}