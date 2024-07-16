with source as (
      select * from {{ source('gold', 'deposit_balance') }}
),
renamed as (
    select *
    from source
)
select * from renamed