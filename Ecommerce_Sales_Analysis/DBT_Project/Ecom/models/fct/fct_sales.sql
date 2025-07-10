
WITH sales AS (
  SELECT
    customer_id,
    SUM(item_total_price) AS total_spent,
    COUNT(DISTINCT order_id) AS total_orders,
    MIN(purchase_date) AS first_order_date,
    MAX(purchase_date) AS last_order_date
  FROM {{ ref('fct_orders') }}
  GROUP BY customer_id
)

SELECT
  c.customer_id,
  c.zip_code,
  c.CUSTOMER_STATE as state,
  b.total_spent,
  b.total_orders,
  b.first_order_date,
  b.last_order_date
FROM sales b
LEFT JOIN {{ ref('customers') }} c
  ON b.customer_id = c.customer_id