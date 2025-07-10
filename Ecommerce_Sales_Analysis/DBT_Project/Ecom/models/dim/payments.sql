with payments as
(
    select * from {{source('raw_tables','raw_payments')}}
)

select
ORDER_ID,
PAYMENT_SEQUENTIAL,
PAYMENT_TYPE,
PAYMENT_INSTALLMENTS as INSTALLMENT,
PAYMENT_VALUE as TOTAL_PAYMENT_VALUE
from
payments