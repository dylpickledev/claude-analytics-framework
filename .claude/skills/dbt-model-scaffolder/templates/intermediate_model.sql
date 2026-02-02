{{
    config(
        materialized='ephemeral',
        tags=['intermediate']
    )
}}

with upstream_model_a as (

    select * from {{ ref('stg_{source}__{table}') }}

),

upstream_model_b as (

    select * from {{ ref('stg_{source}__{table}') }}

),

joined as (

    select
        upstream_model_a.*,
        upstream_model_b.additional_column

    from upstream_model_a
    left join upstream_model_b
        on upstream_model_a.join_key = upstream_model_b.join_key

),

transformed as (

    select
        -- TODO: Add business logic transformations
        join_key,
        additional_column

    from joined

),

final as (

    select * from transformed

)

select * from final
