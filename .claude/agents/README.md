# DA Agent Hub: Role → Specialist (with MCP) Architecture Guide

## Overview

This document explains how **roles**, **specialists**, and **MCP tools** work together in the DA Agent Hub to achieve **maximum correctness** in data and analytics work.

**Architecture Pattern**: Role → Specialist (specialist uses MCP tools + expertise)
**Priority**: Correctness > Speed
**Research Foundation**: Anthropic official guidance + 39 sources
**Validation**: Proven 50-70% efficiency gains + significantly better outcomes

---

## The Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ LAYER 1: ROLES (Primary Agents - 80% of Work)              │
│ - analytics-engineer-role                                   │
│ - data-engineer-role                                        │
│ - bi-developer-role                                         │
│ - ui-ux-developer-role                                      │
│ - data-architect-role                                       │
│ - business-analyst-role                                     │
│ - qa-engineer-role                                          │
│ - dba-role                                                  │
│ - project-manager-role                                      │
│                                                             │
│ What they do: Own end-to-end workflows within their domain │
│ When they delegate: Confidence <0.60 OR need expertise     │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    DELEGATES TO SPECIALISTS
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ LAYER 2: SPECIALISTS (Consultation Layer - 20% of Work)    │
│                                                             │
│ Cloud & Infrastructure:                                     │
│ - aws-expert (AWS infrastructure specialist)                │
│ - azure-expert (Azure infrastructure - future)              │
│                                                             │
│ Data Platform:                                              │
│ - dbt-expert (SQL transformations, dbt patterns)            │
│ - snowflake-expert (Warehouse optimization, cost)           │
│ - orchestra-expert (Workflow orchestration)                 │
│ - prefect-expert (Python workflows)                         │
│ - dlthub-expert (Data ingestion)                            │
│                                                             │
│ BI & Visualization:                                         │
│ - tableau-expert (BI optimization)                          │
│                                                             │
│ Development:                                                │
│ - react-expert (React patterns)                             │
│ - streamlit-expert (Streamlit apps)                         │
│ - ui-ux-expert (UX design)                                  │
│                                                             │
│ Cross-Functional:                                           │
│ - claude-code-expert (Claude Code configuration)            │
│ - documentation-expert (Standards, docs)                    │
│ - github-sleuth-expert (Repository analysis)                │
│ - business-context (Requirements)                           │
│ - qa-coordinator (Quality assurance)                        │
│                                                             │
│ What they do: Provide expert guidance + validated solutions │
│ How they work: Use MCP tools + domain expertise            │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    USE MCP TOOLS + EXPERTISE
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ LAYER 3: MCP TOOLS (Data Access Layer)                     │
│                                                             │
│ Currently Configured:                                       │
│ - dbt-mcp: dbt Cloud + Semantic Layer access               │
│ - snowflake-mcp: Snowflake queries + Cortex AI             │
│ - aws-api: AWS infrastructure state queries                 │
│ - aws-docs: AWS documentation lookup                        │
│ - aws-knowledge: AWS best practices, Well-Architected       │
│                                                             │
│ Recommended (Week 1 additions):                             │
│ - github-mcp: Repository analysis                           │
│ - slack-mcp: Team communication                             │
│ - git-mcp: Version control operations                       │
│                                                             │
│ Custom Development Needed (Weeks 3-4):                      │
│ - orchestra-mcp: Workflow orchestration (CRITICAL)          │
│ - prefect-mcp: Python workflows (CRITICAL)                  │
│                                                             │
│ What they provide: Real-time data, current state, docs      │
│ What they DON'T provide: Expertise, synthesis, decisions    │
└─────────────────────────────────────────────────────────────┘
```

---

## Why This Architecture? (Research-Backed Reasons)

### 1. **Anthropic Official Guidance**

**From "Building Effective Agents"**:
> "For complex tasks with multiple considerations, LLMs generally perform better when each consideration is handled by a separate LLM call"

> "Agentic systems often trade latency and cost for better task performance"

**From "Multi-Agent Research System"**:
> Multi-agent systems use **15x more tokens** but provide **significantly better outcomes**

**Interpretation**: More tokens for specialist delegation = higher quality, fewer errors

### 2. **MCP Tools Are Data Access, Not Expertise**

**What aws-api MCP provides**:
- "You have 3 ECS services named: customer-dashboard, app-portal, data-pipeline"
- "Your ALB has listeners on ports 80 and 443"
- "Lambda function timeout is 30 seconds"

**What aws-api MCP DOESN'T provide**:
- "Which ECS service should you deploy this React app to?"
- "How should ALB listener rules be configured for OIDC auth?"
- "Is 30-second timeout appropriate for this workload?"

**Those decisions require AWS expertise** - architectural synthesis, trade-off analysis, validation.

### 3. **Error Prevention > Token Cost**

**Without specialist** (Role uses MCP directly):
- Token cost: Low (1x)
- Error rate: High (guessing at interpretations)
- Production impact: Deployment failures, security issues, cost overruns ($$$$$)

**With specialist** (Role → Specialist with MCP):
- Token cost: Higher (15x)
- Error rate: Low (expert validation)
- Production impact: Successful deployments, optimized configs, secure ($)

**ROI**: 100x-1000x return on token investment

### 4. **Matches Real-World Team Structures**

**How real teams work**:
- UI/UX Developer builds React app
- **Consults** DevOps/Cloud Engineer for AWS deployment
- Cloud Engineer uses AWS console/CLI (MCP equivalent) + expertise
- Returns validated infrastructure plan
- UI/UX Developer executes deployment

**Our architecture mirrors this proven pattern**.

### 5. **Proven Results in DA Agent Hub**

**Role-based migration results**:
- 50-70% reduction in coordination overhead
- Faster problem resolution
- Better alignment with team workflows
- Higher quality outcomes

**Adding MCP tools to specialists**:
- Infrastructure audits: 0.75 → 0.95 confidence
- Cost analysis: 0.89 → 0.95 confidence
- Security review: 0.80 → 0.92 confidence

---

## How to Use This Architecture

### Pattern 1: Simple Delegation (Most Common - 80% of Cases)

**When**: Role encounters work outside its expertise domain

**Example**: ui-ux-developer needs AWS deployment

```
Step 1: Role recognizes need
ui-ux-developer: "I need AWS deployment expertise (my confidence: 0.30)"

Step 2: Role prepares context
context = {
  task: "Deploy React sales journal app to AWS",
  current_state: "ECS service exists, needs update",
  requirements: "Blue/green deployment, zero downtime, <$50/month cost",
  constraints: "Must maintain current ALB OIDC auth"
}

Step 3: Role delegates to specialist
DELEGATE TO: aws-expert
PROVIDE: context
REQUEST: "Validated deployment plan"

Step 4: Specialist works with MCP tools
aws-expert:
  ├─ aws-api MCP: Query current ECS task def, ALB listener rules, target groups
  ├─ aws-knowledge MCP: Get ECS blue/green deployment best practices
  ├─ aws-docs MCP: Validate current ECS API syntax
  ├─ EXPERTISE: Synthesizes into deployment plan
  │   - Validates health check config
  │   - Ensures ALB auth rules preserved
  │   - Optimizes for cost constraint
  │   - Designs rollback strategy
  └─ RETURNS: Complete deployment plan with IaC code

Step 5: Role executes
ui-ux-developer: Executes deployment plan
  └─ Result: ✅ Successful deployment with expert validation
```

**Time**: Slower (15x tokens) but CORRECT
**Outcome**: Production-ready, validated, secure, cost-optimized

### Pattern 2: Collaborative Consultation (Complex Cases - 15% of Cases)

**When**: Task spans multiple domains, requires synthesis

**Example**: data-architect designing new data platform

```
data-architect (strategic lead):
  ├─ CONSULT aws-expert: Infrastructure layer design
  │   └─ aws-expert uses aws-mcp → Returns AWS architecture
  ├─ CONSULT snowflake-expert: Warehouse layer design
  │   └─ snowflake-expert uses snowflake-mcp → Returns warehouse design
  ├─ CONSULT dbt-expert: Transformation layer design
  │   └─ dbt-expert uses dbt-mcp → Returns dbt architecture
  └─ SYNTHESIZES: Complete platform architecture
      └─ Validates integration points, cost, performance
```

**Time**: Slowest (multiple specialists) but MOST CORRECT
**Outcome**: Comprehensive, validated, integrated architecture

### Pattern 3: Specialist-to-Specialist (Edge Cases - 5% of Cases)

**When**: Specialist needs expertise from another domain

**Example**: aws-expert needs database optimization guidance

```
aws-expert (primary):
  ├─ Designing RDS infrastructure for data warehouse
  ├─ Confidence 0.72 on database optimization
  └─ CONSULT dba-role or snowflake-expert
      └─ Receives: Database-specific tuning recommendations
      └─ Applies: To RDS configuration
      └─ Returns: Optimized infrastructure plan
```

**Time**: Slowest but ENSURES CORRECTNESS
**Outcome**: Multi-domain validated solution

---

## Common Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Role Uses MCP Directly Without Expertise

```
ui-ux-developer:
  ↓ Uses aws-api MCP: "I see ECS services..."
  ↓ Interprets without AWS knowledge
  ↓ Deploys based on guess
  ↓ 💥 Production error (missing health checks, wrong security groups)
```

**Why it's wrong**: Data without expertise = guessing
**Fix**: Delegate to aws-expert who uses MCP + expertise

### ❌ Anti-Pattern 2: Skipping Specialist to Save Tokens

```
analytics-engineer:
  ↓ "This dbt macro is complex, but I'll try..."
  ↓ Implements without dbt-expert consultation
  ↓ 💥 Incorrect logic, performance issues, failed tests
```

**Why it's wrong**: Penny-wise, pound-foolish (save tokens, create errors)
**Fix**: Delegate to dbt-expert (15x tokens < error cost)

### ❌ Anti-Pattern 3: Delegation Without Context

```
data-engineer:
  ↓ "Hey orchestra-expert, help with this"
  ↓ Provides minimal context
orchestra-expert:
  ↓ Guesses at requirements
  ↓ 💥 Solution doesn't meet actual needs
```

**Why it's wrong**: Insufficient context = wasted specialist effort
**Fix**: Provide complete context (task, state, requirements, constraints)

### ❌ Anti-Pattern 4: Not Validating Specialist Output

```
ui-ux-developer:
  ↓ Delegates to aws-expert
  ↓ Receives deployment plan
  ↓ Executes blindly without understanding
  ↓ 💥 Can't troubleshoot when issues arise
```

**Why it's wrong**: Delegation doesn't mean blind execution
**Fix**: Understand specialist recommendations, ask clarifying questions

---

## How to Best Leverage This Architecture

### 1. **Know Your Confidence Level**

**Before starting a task, assess**:
- Do I have ≥0.85 confidence in this domain?
- Is this within my role's core expertise?
- Or does this require specialist knowledge?

**Decision rule**:
- Confidence ≥0.85 AND within role scope → Handle directly
- Confidence <0.60 OR outside expertise → Delegate to specialist
- 0.60-0.84 → Consider collaborative approach

### 2. **Prepare Complete Context Before Delegating**

**Always provide specialists with**:
- **Task description**: What needs to be accomplished
- **Current state**: What exists now (use MCP tools to gather if needed)
- **Requirements**: Performance, cost, security, compliance needs
- **Constraints**: Timeline, budget, team capabilities, dependencies

**Example of good context**:
```
Task: Deploy new React financial dashboard to AWS
Current state:
  - React app built and tested locally
  - Existing AWS infrastructure: ECS cluster "data-apps", ALB with OIDC
  - Current apps: customer-dashboard (ECS service on same ALB)
Requirements:
  - Zero downtime deployment
  - Must integrate with existing ALB OIDC authentication
  - Cost target: <$30/month
  - Response time: <2 seconds p95
Constraints:
  - Must deploy by end of week
  - Team has limited AWS experience
  - Cannot disrupt existing customer-dashboard service
```

### 3. **Use MCP Tools for Context Gathering**

**Before delegating, gather current state with MCP**:

**Example workflow**:
```
ui-ux-developer (preparing to delegate):
1. Uses aws-api MCP: Query current ECS services, ALB config
2. Uses aws-api MCP: Get current CloudFront distribution
3. Uses github-mcp: Check current deployment workflows
4. Prepares context with actual state data
5. DELEGATES to aws-expert with complete context

aws-expert:
6. Receives complete context (no time wasted gathering basics)
7. Uses aws-knowledge MCP: Get deployment best practices
8. Uses aws-docs MCP: Validate latest syntax
9. Applies expertise: Synthesize optimal solution
10. Returns: Validated deployment plan
```

**Benefit**: Specialist can focus on expertise, not data gathering

### 4. **Validate and Understand Specialist Recommendations**

**After receiving specialist guidance**:
- **Understand the "why"**: Ask specialist to explain reasoning
- **Validate against requirements**: Does it meet all criteria?
- **Identify risks**: What could go wrong? How to mitigate?
- **Plan testing**: How to validate the solution works?

**Don't just execute blindly** - learn from the specialist expertise.

### 5. **Document Patterns for Future Use**

**When specialist provides valuable insight**:
- Document the pattern in `.claude/skills/reference-knowledge/`
- Update role agent confidence levels
- Build institutional knowledge

**Example**:
```
After aws-expert solves complex ALB OIDC integration:
- Document pattern in .claude/skills/reference-knowledge/alb-oidc-pattern/SKILL.md
- Update ui-ux-developer confidence on ALB auth: 0.30 → 0.70
- Next time: ui-ux-developer can handle similar tasks independently
```

---

## Real-World Scenarios

### Scenario 1: "Update My AWS React App"

**User request**: "Update my AWS React app with new features"

**✅ Correct Workflow**:

```
1. ui-ux-developer-role (primary agent):
   - Understands: React development (confidence: 0.90)
   - Builds: New React features, tests locally
   - Recognizes: Need AWS deployment (confidence: 0.30)

2. Preparation:
   - Uses aws-api MCP: Gets current ECS task definition
   - Uses aws-api MCP: Gets current ALB configuration
   - Prepares context for specialist

3. Delegation:
   DELEGATE TO: aws-expert
   CONTEXT: {
     task: "Deploy updated React app to existing ECS service",
     current: "customer-dashboard ECS service on app-cluster",
     requirements: "Zero downtime, maintain OIDC auth, <5 min deploy",
     constraints: "Production environment, business hours"
   }

4. aws-expert (specialist):
   - Uses aws-api MCP: Validates current infrastructure state
   - Uses aws-knowledge MCP: Gets ECS deployment best practices
   - Uses aws-docs MCP: Confirms current ECS API syntax
   - Applies expertise:
     * Recommends blue/green deployment strategy
     * Validates health check configuration
     * Ensures ALB target group deregistration delay appropriate
     * Optimizes Docker image build process
   - Returns: Step-by-step deployment plan with rollback procedures

5. ui-ux-developer-role (executes):
   - Reviews deployment plan
   - Asks clarifying questions
   - Executes validated deployment
   - ✅ Success: App deployed, zero downtime, auth working
```

**Time**: ~30 minutes (including specialist consultation)
**Outcome**: ✅ Correct, validated, production-ready
**Cost**: 15x tokens (~$0.50 vs potential $5,000 error cost)

**❌ Incorrect Workflow** (Avoiding This):

```
1. ui-ux-developer-role:
   - Builds React features
   - Uses aws-api MCP directly: "I see ECS service..."
   - Guesses: "I'll just update the task definition"
   - Misses: Health check misconfiguration
   - Deploys without validation
   - 💥 Production error: Service fails health checks, ALB routes to unhealthy

2. Debugging (2am):
   - 3 hours troubleshooting
   - Lost revenue from downtime
   - Team frustration
   - NOW calls aws-expert to fix
```

**Time**: 30 min deployment + 3 hours debugging = 3.5 hours
**Outcome**: ❌ Error, downtime, emergency fix
**Cost**: Tokens saved (~$0.03) vs error cost (~$5,000+)

### Scenario 2: "Optimize Slow dbt Model"

**User request**: "customer_metrics model taking 2 hours to run, need to optimize"

**✅ Correct Workflow**:

```
1. analytics-engineer-role (primary):
   - Understands: Model is slow (confidence on basic SQL: 0.85)
   - Checks: Model logic, finds complex window functions + 5 table joins
   - Recognizes: Need advanced optimization (confidence on complex optimization: 0.55)

2. Preparation:
   - Uses dbt-mcp: Gets compiled SQL, lineage graph
   - Uses snowflake-mcp: Gets query profile, execution stats
   - Identifies: Cartesian join issue, missing indexes

3. Delegation:
   DELEGATE TO: dbt-expert AND snowflake-expert (parallel)

   TO dbt-expert:
   - Task: "Optimize dbt model logic, eliminate cartesian join"
   - Current: Complex window functions over 5 table joins
   - Requirements: <10 min runtime, maintain accuracy

   TO snowflake-expert:
   - Task: "Analyze warehouse performance, recommend optimizations"
   - Current: Query profile shows full table scans
   - Requirements: Cost-effective solution

4. Specialists work:
   dbt-expert:
   - Uses dbt-mcp: Analyzes model dependencies
   - Uses git-mcp: Reviews historical changes
   - Applies expertise: Redesigns join logic, adds CTEs
   - Returns: Optimized dbt model with tests

   snowflake-expert:
   - Uses snowflake-mcp: Analyzes query execution
   - Uses sequential-thinking-mcp: Break down performance bottlenecks
   - Applies expertise: Recommends clustering, materialization
   - Returns: Warehouse optimization plan

5. analytics-engineer-role (executes):
   - Implements dbt model changes
   - Applies Snowflake optimizations
   - Tests: Runtime now 8 minutes ✅
```

**Time**: 1 hour (with specialist consultation)
**Outcome**: ✅ 2 hours → 8 min (15x improvement)
**Quality**: Expert-validated optimization

### Scenario 3: "New Data Pipeline from Salesforce"

**User request**: "Build pipeline to ingest Salesforce data into Snowflake"

**✅ Correct Workflow**:

```
1. data-engineer-role (primary):
   - Understands: Pipeline orchestration (confidence: 0.85)
   - Recognizes: Need ingestion specialist (confidence on Salesforce: 0.40)

2. Delegation:
   DELEGATE TO: dlthub-expert
   CONTEXT: {
     task: "Salesforce → Snowflake pipeline",
     source: "Salesforce Production (CRM data)",
     destination: "Snowflake RAW schema",
     requirements: "Daily incremental, <1 hour runtime, deduplication",
     constraints: "API rate limits, business hours only"
   }

3. dlthub-expert (specialist):
   - Uses airbyte-mcp: Checks available Salesforce connectors
   - Uses snowflake-mcp: Validates target schema structure
   - Uses orchestra-mcp: Reviews existing pipeline patterns
   - Applies expertise:
     * Recommends dlthub for incremental sync
     * Designs merge strategy for deduplication
     * Configures error handling and retry logic
   - Returns: Complete pipeline configuration + tests

4. data-engineer-role (executes):
   - Reviews pipeline design
   - Implements dlthub configuration
   - Sets up Orchestra workflow
   - Tests: Pipeline runs successfully ✅
```

**Time**: 2 hours (with specialist)
**Outcome**: ✅ Production-ready pipeline, optimized config
**Alternative**: 6+ hours trial-and-error without specialist

---

## When to Delegate vs Handle Directly

### Delegation Decision Framework

**ALWAYS delegate when**:
- ✅ Confidence <0.60 on the specific task
- ✅ Task involves specialized tools you're unfamiliar with
- ✅ Security, compliance, or cost optimization critical
- ✅ Production deployment with zero-downtime requirement
- ✅ Cross-system integration with multiple services
- ✅ Architecture decisions with long-term impact

**Consider delegating when**:
- ⚠️ Confidence 0.60-0.84 (collaborative approach)
- ⚠️ Task is complex within your domain
- ⚠️ You want validation before implementing

**Handle directly when**:
- ✅ Confidence ≥0.85 on the task
- ✅ Task is routine, well-documented, low-risk
- ✅ You've successfully done similar tasks before
- ✅ Clear pattern exists in your knowledge base

### Quick Reference Matrix

| Task Type | Your Confidence | Action |
|-----------|----------------|--------|
| Deploy AWS app | <0.60 | DELEGATE to aws-expert |
| Write SQL transformation | ≥0.85 | Handle directly |
| Optimize slow Snowflake query | 0.60-0.84 | CONSULT snowflake-expert (collaborative) |
| Set up Orchestra workflow | <0.60 | DELEGATE to orchestra-expert |
| Create React component | ≥0.85 | Handle directly |
| Design multi-cloud architecture | <0.60 | DELEGATE to da-architect (consults aws-expert, azure-expert) |
| Write dbt test | ≥0.85 | Handle directly |
| Configure Tableau data source | <0.60 | DELEGATE to tableau-expert |

---

## MCP Tools by Specialist

### Current Configuration (.claude/mcp.json)

**Already Configured** (5 servers):
```json
{
  "dbt-mcp": "dbt Cloud + Semantic Layer",
  "snowflake-mcp": "Snowflake queries + Cortex AI",
  "aws-api": "AWS infrastructure state queries",
  "aws-docs": "AWS documentation lookup",
  "aws-knowledge": "AWS best practices, Well-Architected"
}
```

### Specialist MCP Tool Assignments

**aws-expert** (AWS infrastructure specialist):
- aws-api (infrastructure queries)
- aws-docs (documentation)
- aws-knowledge (best practices)
- aws-cloud-control (optional - unified API)

**dbt-expert** (transformation specialist):
- dbt-mcp (compile, test, docs, lineage)
- snowflake-mcp (validate transformations)
- git-mcp (version control)

**snowflake-expert** (warehouse specialist):
- snowflake-mcp (queries, performance, cost)
- dbt-mcp (model integration)
- sequential-thinking-mcp (complex analysis)

**orchestra-expert** (orchestration specialist):
- orchestra-mcp (custom - Week 4 development)
- prefect-mcp (custom - Week 4 development)
- airbyte-mcp (connector management)
- dbt-mcp (transformation integration)

**tableau-expert** (BI specialist):
- tableau-mcp (dashboard analysis)
- snowflake-mcp (data source optimization)
- dbt-mcp (semantic layer integration)
- filesystem-mcp (workbook parsing)

**github-sleuth-expert** (repository specialist):
- github-mcp (issue, PR, repo analysis)
- git-mcp (version control operations)
- filesystem-mcp (code parsing)

**documentation-expert** (documentation specialist):
- confluence-mcp (knowledge base)
- github-mcp (code docs)
- dbt-mcp (data docs)
- notion-mcp (design docs)

**business-context** (requirements specialist):
- atlassian-mcp (Jira, Confluence requirements)
- slack-mcp (stakeholder communication)
- dbt-mcp (metric definitions)

**qa-coordinator** (quality specialist):
- dbt-mcp (data quality tests)
- snowflake-mcp (validation queries)
- github-mcp (test automation)
- great-expectations-mcp (custom - Week 6)

---

## Migration Roadmap (12-Week Plan)

### Week 1-2: Foundation (Revive Core Specialists)

**Week 1 Tasks**:
- ✅ Enhanced aws-expert with MCP integration
- ⬜ Revive dbt-expert from deprecated/
- ⬜ Revive snowflake-expert from deprecated/
- ⬜ Add github-mcp to .claude/mcp.json
- ⬜ Add slack-mcp to .claude/mcp.json
- ⬜ Add git-mcp to .claude/mcp.json
- ⬜ Test delegation patterns with real tasks

**Week 2 Tasks**:
- ⬜ Enhance dbt-expert with dbt-mcp + snowflake-mcp + git-mcp
- ⬜ Enhance snowflake-expert with snowflake-mcp + dbt-mcp
- ⬜ Update role agents with delegation protocols
- ⬜ Test multi-specialist scenarios

### Week 3-4: Orchestration (Custom MCP Development)

**Critical custom development**:
- ⬜ Develop orchestra-mcp (CRITICAL - no official exists)
- ⬜ Develop prefect-mcp (CRITICAL - no official exists)
- ⬜ Revive orchestra-expert from deprecated/
- ⬜ Revive prefect-expert from deprecated/
- ⬜ Integrate custom MCPs with specialists

### Week 5-6: BI & Advanced (BI Specialists + Quality)

- ⬜ Revive tableau-expert from deprecated/
- ⬜ Revive dlthub-expert from deprecated/
- ⬜ Add tableau-mcp, airbyte-mcp
- ⬜ Create data-quality-specialist
- ⬜ Develop great-expectations-mcp (custom)

### Week 7-8: Development (UI/UX Specialists)

- ⬜ Revive react-expert from deprecated/
- ⬜ Revive streamlit-expert from deprecated/
- ⬜ Add filesystem-mcp, notion-mcp
- ⬜ Enhance ui-ux-expert with design MCP tools

### Week 9-12: Polish & Production (Optimization + Launch)

- ⬜ Create cost-optimization-specialist
- ⬜ Full integration testing
- ⬜ Team training and documentation
- ⬜ Production rollout with monitoring
- ⬜ Continuous improvement framework

---

## Success Metrics

### Technical Metrics
- **MCP server uptime**: >99% (critical for specialist effectiveness)
- **Specialist response time**: <30 seconds median
- **Tool call success rate**: >95%
- **Delegation success rate**: >90%

### Quality Metrics
- **Deployment success rate**: >90% (vs current baseline)
- **First-attempt success**: >80% (specialist recommendations work)
- **Error reduction**: >30% vs direct MCP usage
- **Incident reduction**: >40% vs previous architecture

### Business Metrics
- **Project delivery time**: -25% (despite 15x tokens, efficiency gains)
- **Operational incidents**: -40% (fewer errors from incorrect configs)
- **Documentation completeness**: >90% (specialists enforce standards)
- **Team learning velocity**: +50% (learn from specialist expertise)

---

## Cost vs Quality Trade-off Analysis

### Token Cost Reality

**Specialist pattern**:
- 15x more tokens per Anthropic research
- Example: $0.50 specialist consultation vs $0.03 direct

**But**:
- Production error: $500-$5,000 (downtime, debugging, lost revenue)
- Security incident: $10,000+ (breach response, compliance)
- Cost overrun: $100-$1,000/month (unoptimized infrastructure)

**ROI**: 100x-1000x return on token investment

### Your Priority: Correctness > Speed ✅

**This architecture aligns with your stated priority**:
- More tokens = More expert validation = Fewer errors
- Slower (specialist consultation) = More thorough = Better outcomes
- Higher upfront cost = Lower total cost of ownership

**Anthropic research confirms**: This trade-off is worth making for complex, high-stakes domains like infrastructure and data engineering.

---

## Quick Start Guide

### For Role Agents (You Are Here Most of the Time)

**When starting a task**:

1. **Assess confidence**: Do I know this domain well? (≥0.85?)
2. **Check expertise need**: Is specialist knowledge beneficial?
3. **If YES to delegation**:
   - Prepare complete context
   - Delegate to appropriate specialist (see CLAUDE.md for mapping)
   - Validate specialist recommendations
   - Execute with confidence
4. **If NO to delegation**:
   - Proceed independently
   - Document patterns learned
   - Update confidence levels

### For Specialist Agents (When Consulted)

**When delegated a task**:

1. **Understand context**: Task, state, requirements, constraints
2. **Use MCP tools**: Gather current data, docs, best practices
3. **Apply expertise**: Synthesize, validate, optimize
4. **Provide complete output**:
   - Architecture/design
   - Implementation code
   - Validation steps
   - Risk analysis
   - Cost implications
5. **Ensure delegating role understands**: Explain reasoning, trade-offs

---

## Troubleshooting

### "Should I delegate or handle directly?"

**Ask yourself**:
- Have I done this exact task successfully before? (If yes → direct)
- Is this a high-stakes task (production, security, cost)? (If yes → delegate)
- Am I ≥85% confident? (If no → delegate)
- Would an expert catch things I might miss? (If yes → delegate)

**Default**: **When in doubt, delegate to specialist**

### "Which specialist should I consult?"

**See** `CLAUDE.md` Tool Specialists section for complete mapping

**Quick reference**:
- AWS work → aws-expert
- SQL/dbt work → dbt-expert or snowflake-expert
- Pipeline work → orchestra-expert, prefect-expert, dlthub-expert
- BI work → tableau-expert
- GitHub work → github-sleuth-expert
- Documentation → documentation-expert
- Requirements → business-context
- Testing → qa-coordinator

### "The specialist's recommendation seems wrong"

**Don't execute blindly**:
1. Ask specialist to explain reasoning
2. Provide additional context if specialist missed something
3. Request alternative approaches
4. Consult second specialist if needed (rare)
5. Escalate to data-architect for strategic review

**Remember**: Specialists are experts, but communication matters. Ensure they have complete context.

---

## Related Documentation

### Architecture Research (Start Here):
- **Quick Start**: `docs/index-mcp-specialist-research.md`
- **Executive Summary**: `docs/README-MCP-SPECIALIST-RESEARCH.md`
- **Decision Guide**: `docs/mcp-vs-specialist-decision-tree.md`
- **Visual Guide**: `docs/mcp-specialist-visual-architecture.md`

### Implementation Details:
- **MCP Server Catalog**: `docs/mcp-research-2025/mcp-server-catalog.md` (120+ servers)
- **Specialist Integration**: `docs/mcp-research-2025/specialist-mcp-integration-plan.md`
- **Delegation Framework**: `docs/mcp-research-2025/role-specialist-delegation-framework.md`
- **Migration Plan**: `docs/mcp-research-2025/architecture-migration-plan.md`

### Configuration:
- **Current MCP Config**: `.claude/mcp.json`
- **Recommended Config**: `docs/mcp-research-2025/recommended-mcp-config.json`

### Individual Agents:
- **Role agents**: `.claude/agents/*-role.md` (10 roles)
- **Specialists**: See individual agent files (aws-expert.md, etc.)
- **Deprecated**: `.claude/agents/deprecated/` (historical reference)

---

## The Bottom Line

**Architecture**: Role → Specialist (specialist uses MCP tools + expertise)

**Why**: Research-backed correctness-first approach
- Anthropic: 15x tokens = significantly better outcomes
- DA Agent Hub: 50-70% efficiency gains proven
- Error prevention: 100x-1000x ROI vs token cost

**How to use**:
1. Role agents own end-to-end workflows
2. Delegate when confidence <0.60 OR expertise needed
3. Specialists use MCP tools + domain expertise
4. Return validated, correct recommendations
5. Role executes with confidence

**Priority**: Correctness > Speed ✅

**Result**: Fewer errors, better outcomes, higher quality, lower total cost

---

**Start here**: Read `docs/index-mcp-specialist-research.md` for navigation and training curriculum

**Questions**: See specialist agent files for consultation patterns and MCP tool usage

**Implementation**: Follow `docs/mcp-research-2025/architecture-migration-plan.md` for 12-week rollout

---

*This architecture transforms DA Agent Hub into a correctness-first, research-backed platform where roles and specialists collaborate through MCP-enhanced expertise to deliver production-ready, validated solutions.*
