{{
    config(
        materialized='view',
        tags=['staging', 'source:{source_system}']
    )
}}

with source as (

    select * from {{ source('{source_name}', '{table_name}') }}

),

renamed as (

    select
        -- IDs
        id as {entity}_id,

        -- Strings
        -- TODO: Add string columns

        -- Numerics
        -- TODO: Add numeric columns

        -- Booleans
        -- TODO: Add boolean columns

        -- Dates
        created_at,
        updated_at,

        -- Metadata
        _fivetran_synced as source_synced_at

    from source

)

select * from renamed
