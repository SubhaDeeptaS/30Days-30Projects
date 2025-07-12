with fct_policy as (select * from {{ref('policy_data')}}),
fct_payment as (select * from {{ref('payment_data')}}),
fct_claim as (select * from {{ref('claim_data')}}),
dim_customer as (select * from {{ref('customer_data')}}),
dim_address as (select * from {{ref('address_data')}})

SELECT
  pol.policy_id,
  cust.customer_id,
  cust.first_name,
  cust.last_name,
  cust.gender,
  cust.date_of_birth,
  addr.city,
  addr.state,
  pol.policy_type,
  pol.start_date,
  pol.end_date,
  pol.premium_amount,
  pol.coverage_amount,
  pol.status AS policy_status,
  pay.payment_date,
  pay.payment_amount,
  pay.payment_method,
  pay.payment_status,
  cl.claim_date,
  cl.claim_amount,
  cl.claim_status
FROM fct_policy pol
LEFT JOIN dim_customer cust ON pol.customer_id = cust.customer_id
LEFT JOIN dim_address addr ON cust.address_id = addr.address_id
LEFT JOIN fct_payment pay ON pol.policy_id = pay.policy_id
LEFT JOIN fct_claim cl ON pol.policy_id = cl.policy_id
