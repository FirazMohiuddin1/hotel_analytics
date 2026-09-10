with properties as (

    select * from {{ ref('stg_pms__properties') }}

),

final as (

    select
        property_id,
        property_code,
        property_name,
        brand,
        brand_tier,
        city,
        region,
        country_code,
        room_count,
        opened_date,
        datediff('year', opened_date, current_date())   as years_open
    from properties

)

select * from final