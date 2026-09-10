with events as (

    select * from {{ ref('stg_pms__reservation_events') }}

),

ranked as (

    select
        *,
        row_number() over (
            partition by reservation_id
            order by event_ts desc, ingested_at desc
        ) as event_rank
    from events

),

current_state as (

    select
        reservation_id,
        property_id,
        guest_id,
        channel,
        room_type_code,
        rate_plan_code,
        check_in_date,
        check_out_date,
        datediff('day', check_in_date, check_out_date)  as nights,
        nightly_rate,
        adults,
        event_type                                      as last_event_type,
        event_ts                                        as last_event_ts,
        case event_type
            when 'CREATED'     then 'BOOKED'
            when 'MODIFIED'    then 'BOOKED'
            when 'CHECKED_IN'  then 'IN_HOUSE'
            when 'CHECKED_OUT' then 'COMPLETED'
            when 'CANCELLED'   then 'CANCELLED'
            when 'NO_SHOW'     then 'NO_SHOW'
        end                                             as reservation_status
    from ranked
    where event_rank = 1

)

select * from current_state