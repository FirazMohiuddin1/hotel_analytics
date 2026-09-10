with source as (

    select * from {{ source('pms', 'reservations') }}

),

renamed as (

    select
        reservation_id,
        property_id,
        guest_id,
        booked_at,
        channel,
        room_type_code,
        rate_plan_code,
        check_in_date,
        check_out_date,
        nights,
        adults,
        nightly_rate,
        loaded_at
    from source

)

select * from renamed