with information as (
       select * from {{ ref('stg_customer__information') }}
),
last_information as (
    select cif_number, partner_cif, religion, registered_date, first_name_vn, first_name_en, 
    full_name_vn, full_name_en, sector_code, lob, gender, marital_status, birth_date, identity_type, 
    identity_number, identity_issued_place, identity_issued_date, identity_expired_date, passport_number, email, phone_number, 
    status, nationality_code, first_contact_date, ex_identity_number, ex_passport_number, ex_email, ex_phone_number, c_add_country, 
    c_add_province, c_add_district, c_add_ward, c_add_street, c_add_detail, c_add_full, r_add_country, r_add_province, 
    r_add_district, r_add_ward, r_add_street, r_add_detail, r_add_full, tax_code, industry_code, customer_status, customer_segment, 
    priority_class, occupation, work_position, post_code, payroll_company
    from (
        select *, row_number() over (partition by cif_number order by dlh_created_time desc) as rn
        from information
    )
    where rn = 1
  
)

select * from last_information