
WITH base AS (
  SELECT
    product_id,
    SUM(item_total_price) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders
  FROM {{ ref('fct_orders') }}
  GROUP BY product_id
),

product_sales as (
SELECT
  b.product_id,
  dp.category,
  b.total_sales,
  b.total_orders,
  ROUND(b.total_sales / NULLIF(b.total_orders, 0), 2) AS avg_order_value_per_product
FROM base b
LEFT JOIN {{ ref('products') }} dp ON b.product_id = dp.product_id)

select 
category,
roound(sum(total_sales)/sum(total_orders),2) as avg_sales_per_category
from
product_sales
group by category