with source as (

    select * from {{ source('pms', 'reservation_events') }}

),

renamed as (

    select
        -- event metadata (already proper columns)
        event_id,
        event_type,
        event_ts,
        ingested_at,

        -- business fields, pulled out of the JSON payload
        raw_payload:reservation_id::integer    as reservation_id,
        raw_payload:property_id::integer       as property_id,
        raw_payload:guest_id::integer          as guest_id,
        raw_payload:channel::string            as channel,
        raw_payload:room_type::string          as room_type_code,
        raw_payload:rate_plan::string          as rate_plan_code,
        raw_payload:check_in::date             as check_in_date,
        raw_payload:check_out::date            as check_out_date,
        raw_payload:rate::number(10,2)         as nightly_rate,
        raw_payload:adults::integer            as adults
    from source

)

select * from renamed