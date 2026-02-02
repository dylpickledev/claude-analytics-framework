# Example Patterns Library

This file demonstrates how to document reusable patterns for the memory system.

## dbt Patterns

PATTERN: Incremental model for event data
```sql
{{ config(
    materialized='incremental',
    unique_key='event_id',
    on_schema_change='fail',
    cluster_by=['event_date']
) }}

select *
from {{ source('raw', 'events') }}
{% if is_incremental() %}
    where event_timestamp > (select max(event_timestamp) from {{ this }})
{% endif %}
```

## Snowflake Optimizations

PATTERN: Query performance with clustering keys
- Identify high-cardinality filter columns
- Add clustering on date + frequently filtered dimensions
- Monitor clustering depth with SYSTEM$CLUSTERING_INFORMATION()

## Error Fixes

ERROR-FIX: "Object does not exist or not authorized" -> Check role grants and database/schema context

ERROR-FIX: "Compilation Error: 'ref' is undefined" -> Import ref macro: `from dbt import ref`

## Architecture Patterns

ARCHITECTURE: Data mart design
- Fact tables: Transactional grain, additive measures
- Dimension tables: Slowly changing dimensions (SCD Type 2)
- Bridge tables: Many-to-many relationships
- Aggregate tables: Pre-computed for dashboard performance

## Integration Patterns

INTEGRATION: dbt + Tableau workflow
- Use dbt exposures to document Tableau dependencies
- Create _sources.yml for Tableau data sources
- Implement row-level security in dbt models