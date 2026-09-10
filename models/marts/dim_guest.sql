with guests as (

    select * from {{ ref('stg_pms__guests') }}

),

final as (

    select
        guest_id,
        first_name,
        last_name,
        first_name || ' ' || last_name     as full_name,
        email,
        phone,
        loyalty_tier,
        country_code,
        created_at                          as member_since_at
    from guests

)

select * from final