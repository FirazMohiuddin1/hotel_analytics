with reservations as (

    -- only stays that did or will occupy a room
    select * from {{ ref('int_reservations__current_state') }}
    where reservation_status in ('BOOKED', 'IN_HOUSE', 'COMPLETED')

),

calendar as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2024-01-01' as date)",
        end_date="dateadd('day', 400, current_date())"
    ) }}

),

stay_nights as (

    select
        r.reservation_id,
        r.property_id,
        r.guest_id,
        r.room_type_code,
        r.rate_plan_code,
        r.channel,
        r.reservation_status,
        c.date_day                                          as stay_date,
        r.nightly_rate,
        row_number() over (
            partition by r.reservation_id
            order by c.date_day
        )                                                   as night_number
    from reservations r
    join calendar c
      on c.date_day >= r.check_in_date
     and c.date_day <  r.check_out_date

)

select * from stay_nights