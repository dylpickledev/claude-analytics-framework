---
name: dbt-model-scaffolder
description: Generate dbt model boilerplate with tests, documentation, and best practices
version: 1.0.0
---

# dbt Model Scaffolder Skill

Automatically generates dbt model files with proper structure, tests, documentation, and metadata.

## Purpose

Save 15-20 minutes per model by:
- Creating model SQL file with best-practice structure
- Generating schema.yml with tests and documentation
- Adding appropriate sources/refs based on layer
- Including common tests and meta tags
- Following dbt style guide conventions

## Usage

This skill is invoked when creating new dbt models.

**Trigger phrases**:
- "Create new dbt model [name]"
- "Scaffold dbt model"
- "Generate dbt staging/intermediate/mart model"

## Workflow Steps

### 1. Gather Model Information

**Required inputs**:
- `model_name`: Model name (lowercase_snake_case)
- `model_layer`: Layer (staging, intermediate, mart)
- `source_table`: Source table or upstream model (if staging)
- `description`: Brief model description
- `business_owner`: (optional) Team or person responsible

**Ask user if not provided**:
```
I need information about the dbt model:
- Model name (e.g., stg_salesforce__accounts):
- Layer (staging/intermediate/mart):
- Source or upstream model:
- Brief description:
```

### 2. Determine Model Type and Structure

**By layer**:

**Staging (stg_)**:
- Single source table
- Light transformations only
- Standard column renaming
- Type casting
- No business logic

**Intermediate (int_)**:
- Joins multiple sources
- Complex transformations
- Ephemeral or table materialization
- Internal documentation

**Mart (mart_)** or **Dimension/Fact (dim_/fct_)**:
- Final business layer
- Optimized for BI tools
- Comprehensive documentation
- Extensive testing

### 3. Generate Model SQL File

**Template selection** based on layer:
- Staging: `templates/staging_model.sql`
- Intermediate: `templates/intermediate_model.sql`
- Mart: `templates/mart_model.sql`

**File location**:
```
models/{layer}/{model_name}.sql
```

**Template variables**:
- `{model_name}`
- `{source_or_ref}` - Source table or ref() to upstream model
- `{description}`
- `{materialization}` - table, view, incremental, ephemeral

### 4. Generate schema.yml Entry

**Create or append** to `models/{layer}/schema.yml`

**Structure**:
```yaml
version: 2

models:
  - name: {model_name}
    description: {description}

    config:
      materialized: {materialization}
      tags: [{layer}, {tags}]

    meta:
      owner: {business_owner}
      layer: {layer}

    columns:
      {column_definitions}
```

### 5. Add Standard Tests

**By layer**:

**Staging models**:
- Primary key: `unique`, `not_null`
- Standard columns: `not_null` for required fields
- Relationships to source (if applicable)

**Intermediate models**:
- Grain test on key columns
- Referential integrity to upstream models
- `not_null` on join keys

**Mart models**:
- Full test suite: unique, not_null, relationships
- Accepted values for categorical columns
- Custom business logic tests
- Data quality assertions

### 6. Generate Column Documentation

**Extract from source** (if staging):
```sql
-- Query source for column names
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = '{source_table}'
```

**Generate column entries**:
```yaml
columns:
  - name: {column_name}
    description: {description or TBD}
    tests:
      - {appropriate tests}
```

### 7. Add Model Configuration

**Common configs by layer**:

**Staging**:
```yaml
config:
  materialized: view
  tags: ['staging', 'source:{source_system}']
```

**Intermediate**:
```yaml
config:
  materialized: ephemeral  # or table for large models
  tags: ['intermediate']
```

**Mart**:
```yaml
config:
  materialized: table
  tags: ['mart', '{domain}']
  partition_by: {date_column}  # if applicable
  cluster_by: [{key_columns}]   # if applicable
```

### 8. Create Model SQL Content

**Staging model template**:
```sql
{{
    config(
        materialized='view',
        tags=['staging']
    )
}}

with source as (

    select * from {{ source('{source}', '{table}') }}

),

renamed as (

    select
        -- IDs
        id as {model}_id,

        -- Strings
        name,

        -- Numerics
        amount,

        -- Booleans
        is_active,

        -- Dates
        created_at,
        updated_at,

        -- Metadata
        _fivetran_synced as source_synced_at

    from source

)

select * from renamed
```

**Intermediate model template**:
```sql
{{
    config(
        materialized='ephemeral',
        tags=['intermediate']
    )
}}

with model_a as (

    select * from {{ ref('stg_source__table_a') }}

),

model_b as (

    select * from {{ ref('stg_source__table_b') }}

),

joined as (

    select
        model_a.*,
        model_b.additional_field

    from model_a
    left join model_b
        on model_a.join_key = model_b.join_key

),

final as (

    select
        -- Add business logic here

    from joined

)

select * from final
```

**Mart model template**:
```sql
{{
    config(
        materialized='table',
        tags=['mart']
    )
}}

with upstream as (

    select * from {{ ref('int_model') }}

),

aggregated as (

    select
        dimension_column,
        count(*) as record_count,
        sum(metric_column) as total_metric

    from upstream
    group by 1

),

final as (

    select
        -- Final transformations

    from aggregated

)

select * from final
```

### 9. Output File Summary

**Display to user**:
```
✅ dbt Model Scaffolded: {model_name}

📁 Files created/updated:
- models/{layer}/{model_name}.sql
- models/{layer}/schema.yml

📋 Next steps:
1. Review and customize SQL logic in {model_name}.sql
2. Update column descriptions in schema.yml
3. Add business-specific tests if needed
4. Run: dbt run --select {model_name}
5. Run: dbt test --select {model_name}

🧪 Standard tests included:
- Primary key validation (unique + not_null)
- Required field checks
{additional layer-specific tests}

📚 Documentation template added - update with business context
```

## Error Handling

### Model Already Exists
**Check**: File `models/{layer}/{model_name}.sql` exists
**Action**: Ask user to confirm overwrite or choose different name

### Invalid Layer
**Check**: Layer is one of: staging, intermediate, mart
**Action**: Ask user to select valid layer

### Missing Source
**Check**: Source exists in sources.yml (for staging models)
**Action**: Warn user and include TODO in generated SQL

### Schema.yml Conflicts
**Check**: Model already in schema.yml
**Action**: Update existing entry or create new if not found

## Quality Standards

**Every generated model must**:
- ✅ Follow dbt SQL style guide (CTEs, final select)
- ✅ Include appropriate materialization config
- ✅ Have column-level documentation (even if TBD)
- ✅ Include standard tests for layer
- ✅ Use proper source() or ref() functions
- ✅ Include metadata (owner, tags, layer)

## Template Customization

### Staging Models
```sql
-- Naming: stg_{source}__{table}
-- Purpose: 1:1 with source, light transformations only
-- Materialization: view
-- Tests: Primary key, not_null on required fields
```

### Intermediate Models
```sql
-- Naming: int_{entity}_{verb}
-- Purpose: Business logic, joins, calculations
-- Materialization: ephemeral or table (if large)
-- Tests: Grain, referential integrity
```

### Mart Models
```sql
-- Naming: mart_{domain}_{entity} or dim_/fct_
-- Purpose: Final analytics layer, BI-ready
-- Materialization: table (with partitioning if large)
-- Tests: Comprehensive data quality
```

## Integration with ADLC Workflow

### Called by analytics-engineer-role
```
analytics-engineer: "Need new staging model for Salesforce accounts"
→ Invokes dbt-model-scaffolder skill
→ Gathers requirements
→ Generates model files
→ Returns summary
```

### Standalone usage
```
User: "Create dbt staging model for stg_salesforce__accounts"
→ Invokes dbt-model-scaffolder skill
→ Generates files
→ User customizes generated code
```

## Best Practices

### Model Naming
- **Staging**: `stg_{source}__{table}` (double underscore)
- **Intermediate**: `int_{entity}_{verb}` (e.g., int_customers_joined)
- **Mart**: `{dim|fct}_{entity}` or `mart_{domain}_{entity}`

### SQL Style
- Use CTEs with descriptive names
- One transformation per CTE
- Final CTE named `final`
- End with `select * from final`
- Group columns by type (IDs, strings, numerics, dates)

### Documentation
- Describe the "why", not the "what"
- Include business context
- Note any assumptions or caveats
- Document grain explicitly for marts

### Testing
- At minimum: unique + not_null on primary key
- Add relationships tests to upstream models
- Test business rules (accepted_values, custom)
- Consider dbt_expectations for advanced tests

## Success Metrics

**Time savings**: 15-20 minutes per model
**Consistency**: 100% models follow style guide
**Quality**: All models have tests and documentation from start

---

**Version**: 1.0.0
**Last Updated**: 2025-10-21
**Maintainer**: ADLC Platform Team
