
WITH orders AS (
  SELECT * FROM {{ ref('orders') }}
),

order_items AS (
  SELECT * FROM {{ ref('orderitems') }}
),

payments AS (
  SELECT
    ORDER_ID,
    SUM(TOTAL_PAYMENT_VALUE) AS total_payment
  FROM {{ ref('payments') }}
  GROUP BY order_id
)

  SELECT
    o.order_id,
    o.customer_id,
    o.purchase_timestamp::date as purchase_date,
    o.delivery_date,
    o.order_status,
    oi.product_id,
    p.category,
    p.WEIGHT_IN_KG,
    oi.price,
    oi.CHARGES,
    oi.price + oi.CHARGES AS item_total_price,
    pay.total_payment
  FROM orders o
  LEFT JOIN order_items oi ON o.order_id = oi.order_id
  LEFT JOIN {{ ref('products') }} p ON oi.product_id = p.product_id
  LEFT JOIN payments pay ON o.order_id = pay.order_id
