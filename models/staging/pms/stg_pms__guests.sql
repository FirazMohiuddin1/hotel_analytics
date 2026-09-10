with source as (

    select * from {{ source('pms', 'guests') }}

),

renamed as (

    select
        guest_id,
        trim(first_name)        as first_name,
        trim(last_name)         as last_name,
        lower(email)            as email,
        phone,
        loyalty_tier,
        country                 as country_code,
        created_at,
        updated_at,
        loaded_at
    from source

)

select * from renamed