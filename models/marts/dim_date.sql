with calendar as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2024-01-01' as date)",
        end_date="dateadd('day', 400, current_date())"
    ) }}

),

final as (

    select
        date_day,
        year(date_day)                              as year,
        quarter(date_day)                           as quarter,
        month(date_day)                             as month,
        monthname(date_day)                         as month_name,
        dayofweekiso(date_day)                      as day_of_week,
        dayname(date_day)                           as day_name,
        dayofweekiso(date_day) in (5, 6)            as is_weekend_night,
        date_trunc('month', date_day)::date         as month_start_date
    from calendar

)

select * from final