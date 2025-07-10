-- models/marts/mart_customer_lifetime_value.sql

WITH base AS (
  SELECT
    fo.customer_id,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    SUM(fo.item_total_price) AS total_revenue,
    MIN(fo.purchase_date) AS first_order_date,
    MAX(fo.purchase_date) AS last_order_date
  FROM {{ ref('fct_orders') }} fo
  GROUP BY fo.customer_id
),
 customer_sales as (
  SELECT
    b.customer_id,
    dc.city,
    dc.CUSTOMER_STATE,
    b.total_orders,
    b.total_revenue,
    ROUND(b.total_revenue / NULLIF(b.total_orders, 0), 2) AS avg_order_value
  FROM base b
  LEFT JOIN {{ ref('customers') }} dc ON b.customer_id = dc.customer_id)

  select
  customer_state,
  sum(avg_order_value) as avg_order_value_per_state
  from
  customer_sales
  group by customer_state


