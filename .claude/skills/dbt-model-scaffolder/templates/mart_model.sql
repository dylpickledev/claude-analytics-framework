{{
    config(
        materialized='table',
        tags=['mart', '{domain}']
    )
}}

with upstream as (

    select * from {{ ref('int_{entity}_{verb}') }}

),

aggregated as (

    select
        dimension_column,
        count(*) as record_count,
        sum(metric_column) as total_metric,
        max(date_column) as latest_date

    from upstream
    group by 1

),

final as (

    select
        -- Dimension columns
        dimension_column,

        -- Metrics
        record_count,
        total_metric,
        latest_date,

        -- Metadata
        current_timestamp() as dbt_updated_at

    from aggregated

)

select * from final
