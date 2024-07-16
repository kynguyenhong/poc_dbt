{{
  config(
    materialized='table',
    table_type='iceberg',
    format='parquet',
    table_properties={
      'optimize_rewrite_delete_file_threshold': '2'
    }
  )
}}

with information as (
       select * from {{ ref('int_information') }}
),
account as (
    select * from {{ ref('int_account_last_status') }}
),

customer_start as (
    select *
    from information join account on information.cif_number = account.client_no
)

select * from customer_start