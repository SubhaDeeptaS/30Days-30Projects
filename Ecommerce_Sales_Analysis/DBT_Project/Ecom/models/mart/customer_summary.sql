
SELECT
    fcs.customer_id,
    dc.city,
    dc.customer_state,
    fcs.total_spent,
    fcs.total_orders,
    fcs.first_order_date,
    fcs.last_order_date,
    DATEDIFF('day', fcs.last_order_date, CURRENT_DATE) AS days_since_last_order,
    ROUND(fcs.total_spent / NULLIF(fcs.total_orders, 0), 2) AS avg_order_value
  FROM {{ ref('fct_sales') }} fcs
  LEFT JOIN {{ ref('customers') }} dc ON fcs.customer_id = dc.customer_id

