# Project Specification: Customer Churn Dashboard

**Created:** 2024-10-15
**GitHub Issue:** #47
**Status:** Completed

## Goal

Build a customer churn prediction dashboard that helps the customer success team identify at-risk customers before they leave.

## Requirements

### Business Requirements
- Identify customers at high/medium/low churn risk
- Show churn risk trends over time
- Enable filtering by customer segment and product line
- Refresh daily with previous day's data

### Technical Requirements
- **Data Model:** dbt incremental model for daily customer metrics
- **Warehouse:** Snowflake (existing warehouse)
- **Dashboard:** Tableau dashboard connecting to dbt mart
- **Refresh:** Daily at 6 AM via dbt Cloud scheduled job

### Success Criteria
- [ ] Model processes 500K+ customers in <10 minutes
- [ ] Dashboard loads in <5 seconds
- [ ] Churn predictions are actionable (show why customer is at risk)
- [ ] Data is current as of yesterday

## Implementation Plan

### Phase 1: Data Model (dbt)
1. Create staging model for customer transaction data
2. Build intermediate model for daily customer metrics
3. Create mart model for churn risk calculation
4. Add comprehensive tests

### Phase 2: Dashboard (Tableau)
1. Connect to Snowflake mart table
2. Build churn risk overview dashboard
3. Add filters and drill-down capabilities
4. Optimize for performance

### Phase 3: Deployment
1. Test in development environment
2. Deploy to production via PR
3. Schedule daily refresh in dbt Cloud
4. Train customer success team

## Data Sources

- `raw.salesforce.accounts` - Customer demographic data
- `raw.stripe.charges` - Transaction history
- `raw.segment.product_events` - Product usage data

## Out of Scope

- Predictive ML model (using simple heuristics for v1)
- Real-time data (daily refresh is sufficient)
- Email alerting (may add in v2)

## Timeline

- Phase 1: 2 days
- Phase 2: 1 day
- Phase 3: 1 day
- **Total:** 4 days

## Notes

- Customer success team wants this by end of Q4
- Similar to revenue dashboard project from last month
- Consider reusing patterns from that project
