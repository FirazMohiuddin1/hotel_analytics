with source as (

    select * from {{ source('pms', 'properties') }}

),

renamed as (

    select
        property_id,
        property_code,
        property_name,
        brand,
        brand_tier,
        city,
        region,
        country         as country_code,
        room_count,
        opened_date,
        loaded_at
    from source

)

select * from renamed