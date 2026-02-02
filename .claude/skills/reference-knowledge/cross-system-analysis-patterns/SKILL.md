---
name: cross-system-analysis-patterns
description: Reference for analyzing issues spanning multiple systems (dbt, Snowflake, Orchestra, Tableau) with agent coordination strategies
user-invocable: false
---

# Cross-System Issue Analysis & Coordination Patterns

## Common Issue Categories (Multi-Tool)

### 1. Schema/Column Reference Errors
**Symptom**: Tests referencing incorrect column names vs actual model schemas

**Analysis Pattern**:
- Check dbt model schemas against test definitions
- Verify column name case sensitivity
- Look for renamed columns in recent changes
- Cross-reference with source system schemas

**Priority**: CRITICAL if blocking compilation

### 2. Data Quality Issues
**Symptom**: Uniqueness constraint violations, null constraint failures, massive duplications

**Analysis Pattern**:
- Check upstream data sources for quality
- Review recent ETL/ELT pipeline changes
- Validate data freshness and completeness
- Look for source system changes

**Priority**: HIGH if indicating upstream pipeline problems

### 3. Cross-System Validation Failures
**Symptom**: Mismatches between source systems and dbt model expectations

**Analysis Pattern**:
- Compare source schema with dbt expectations
- Check for API/integration changes
- Validate data type mismatches
- Review ingestion pipeline logs

**Priority**: MEDIUM to HIGH depending on impact

### 4. Business Logic Validation
**Symptom**: Failed reconciliation tests, metric validation errors

**Analysis Pattern**:
- Review business rules implementation
- Validate calculation logic
- Check for edge cases in data
- Consult stakeholders on expectations

**Priority**: MEDIUM unless affecting critical reports

## Architecture-Aware Analysis Approach

### Data Flow Context
Issues often span multiple layers in the data stack:

```
Orchestra (Orchestrator)
    ↓
[Prefect, dbt, Airbyte, Snowflake] (Execution Layer)
    ↓
Snowflake (Data Warehouse)
    ↓
Semantic Layer (Business Logic)
    ↓
Tableau (Visualization)
```

### Orchestra-Centric Thinking
**PATTERN**: Orchestra kicks off everything
- Prefect flows
- dbt jobs
- Airbyte syncs
- Direct Snowflake operations

**Analysis Strategy**:
1. Start with Orchestra logs to understand what triggered
2. Trace execution through triggered systems
3. Identify failure point in the chain
4. Work backwards to root cause

### Model Layer Impact
**PATTERN**: Problems cascade through layers

```
Source System Issue
    ↓
stg_* (Staging Models) - First failure point
    ↓
dm_* (Data Marts) - Downstream failures
    ↓
rpt_* (Reports) - User-facing impact
```

**Analysis Strategy**:
- Start at earliest failure point (usually staging)
- Understand cascade effects downstream
- Fix root cause, not symptoms
- Validate entire chain after fix

### Source System Dependencies
**PATTERN**: Different source systems create different data patterns

**ERP Systems**:
- Structured, transactional data
- Strong referential integrity expected
- Frequent schema changes with updates

**Customer Systems**:
- Variable data quality
- Missing/inconsistent data common
- Requires robust null handling

**Operations Systems**:
- Real-time data with lag considerations
- High volume, time-series patterns
- Deduplication often needed

**Safety Systems**:
- Regulatory compliance requirements
- Strict data retention rules
- Audit trail critical

**Tableau Data Pipeline**:
- Parse TFL flows for published extracts
- Parse TWB workbooks to validate connections
- Trace data flow issues through XML/JSON analysis
- Validate extract refresh schedules

## Cross-Tool Prioritization Framework

### CRITICAL Priority
**Schema compilation errors that block other work**

**Lead Agent**: dbt-expert

**Response Pattern**:
1. Drop everything and address immediately
2. Identify blocking compilation issues
3. Fix schema problems first
4. Validate compilation succeeds
5. Then move to data quality

### HIGH Priority
**Large-scale data quality issues indicating upstream pipeline problems**

**Lead Agents**: orchestra-expert + dlthub-expert

**Response Pattern**:
1. Check Orchestra logs for pipeline status
2. Validate source data quality with dlthub
3. Identify if pipeline or source issue
4. Coordinate fix across systems
5. Re-run pipeline to validate

### MEDIUM Priority
**Business logic and validation failures**

**Lead Agents**: dbt-expert + business-context

**Response Pattern**:
1. Review business requirements
2. Validate logic implementation
3. Check for edge cases
4. Test with sample data
5. Update tests if requirements changed

### LOW Priority
**Warning-level issues that don't break functionality**

**Response Pattern**:
1. Document for future sprint
2. Create backlog item
3. Monitor for pattern escalation
4. Address during refactoring

## Agent Coordination Strategy

### Role-Based Primary Agents

#### data-engineer-role: Pipeline & Orchestration Lead
**Role**: LEADS all workflow and pipeline analysis
**Scope**: Orchestra, Prefect, dbt pipelines, Airbyte, source integrations
**Consolidates**: orchestra-expert + dlthub-expert + prefect-expert

**When to Invoke**:
- Pipeline failures or timing issues
- Multi-system coordination problems
- Workflow dependency analysis
- Scheduling and orchestration questions
- Source system integration issues

#### analytics-engineer-role: Transformation Layer Owner
**Role**: Owns all data modeling and transformation work
**Scope**: dbt models, SQL optimization, business logic, semantic layer
**Consolidates**: dbt-expert + snowflake-expert (SQL) + tableau-expert (data layer)

**When to Invoke**:
- Model compilation errors
- Performance optimization
- Business logic implementation
- Data quality testing
- Metric definitions

#### bi-developer-role: Consumption Layer & Documentation
**Role**: Dashboard development and end-user documentation
**Scope**: Tableau visualizations, UX design, user guides
**Consolidates**: tableau-expert (viz) + ui-ux-expert + documentation-expert (end-user)

**When to Invoke**:
- Dashboard development
- Performance optimization for BI
- User training materials
- Visualization best practices

#### qa-engineer-role: Comprehensive Testing
**Role**: Enterprise-grade testing and validation
**Scope**: All user-facing changes, data quality validation

**When to Invoke**:
- After UI/UX changes
- Before marking work complete
- API/backend changes
- Data quality validation

### Tool Specialists (Consultation Layer - 20% of cases)
Available for complex edge cases requiring deep tool expertise:
- dbt-expert, snowflake-expert, tableau-expert
- dlthub-expert, orchestra-expert, prefect-expert
- documentation-expert (platform-wide standards)

**When to consult**: Role agents automatically invoke for complex scenarios
### Specialist Consultation Examples

**Example 1: Complex dbt Macro Development**
```
analytics-engineer-role handles most transformations
→ Consults dbt-expert for advanced macro patterns
→ Implements solution with expert guidance
```

**Example 2: Advanced Prefect Flow Patterns**
```
data-engineer-role sets up most pipelines
→ Consults prefect-expert for complex flow patterns
→ Implements with specialist input
```

**Example 3: Deep Snowflake Cost Optimization**
```
analytics-engineer-role handles query optimization
→ Consults snowflake-expert for warehouse-level cost analysis
→ Applies recommendations
```
#### business-analyst-role: Requirements & Stakeholder Alignment
**Role**: Business logic validation, stakeholder communication
**Scope**: Requirements gathering, metric definitions, business rules

**When to Invoke**:
- Unclear business requirements
- Metric definition questions
- Stakeholder alignment needed
- Business rule validation

#### data-architect-role: System Design & Strategy
**Role**: System design, data flow analysis, strategic platform decisions
**Scope**: Entire data stack architecture

**When to Invoke**:
- Cross-system design decisions
- Architecture pattern questions
- Strategic platform choices
- Complex integration design

## Multi-Agent Coordination Patterns

### Sequential Coordination
**Pattern**: One agent's output feeds next agent's analysis

```
orchestra-expert (identify workflow issue)
    ↓
dlthub-expert (check source data quality)
    ↓
dbt-expert (fix model logic)
    ↓
qa-coordinator (validate fix)
```

### Parallel Investigation
**Pattern**: Multiple agents investigate different aspects simultaneously

```
                    Issue Detected
                          |
        +-----------------+-----------------+
        |                 |                 |
    dbt-expert      snowflake-expert   tableau-expert
    (check models)  (check queries)    (check dashboards)
        |                 |                 |
        +-----------------+-----------------+
                          |
                   Synthesize Findings
```

### Iterative Refinement
**Pattern**: Agent collaboration with feedback loops

```
business-context (gather requirements)
    ↓
dbt-expert (implement logic)
    ↓
qa-coordinator (test functionality)
    ↓
business-context (validate with stakeholders)
    ↓ (if changes needed)
dbt-expert (refine implementation)
```

## Pattern Markers for Memory Extraction

When documenting cross-system discoveries:
- `PATTERN:` Reusable analysis approaches
- `SOLUTION:` Specific multi-system fixes
- `ERROR-FIX:` Cross-system errors and resolutions
- `ARCHITECTURE:` System integration patterns
- `INTEGRATION:` Cross-system coordination approaches
