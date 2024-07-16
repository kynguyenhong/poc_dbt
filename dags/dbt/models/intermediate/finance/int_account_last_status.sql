with account as (
    select * from {{ ref('stg_customer__account') }}
),
last_status_account as (
  select client_no, acct_no,acct_status,  acct_type, acct_type_desc, duchi_nt, duchi_qd
  from (
    select
      client_no, acct_no, acct_type, acct_status, acct_type_desc, duchi_nt, duchi_qd,
      row_number() over (partition by (client_no, acct_no) order by dlh_created_time desc) as rn
    from account
  )
  where rn = 1
)

select client_no, acct_no,acct_status,  acct_type, acct_type_desc, duchi_nt, duchi_qd
from last_status_account