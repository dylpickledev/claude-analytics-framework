---
name: knowledge-organization-strategy
description: Framework for when to use Skills, Agents, or Patterns for organizing knowledge in the ADLC platform with decision criteria and migration strategies
user-invocable: false
---

# Knowledge Organization Strategy: Skills vs Agents vs Patterns

**Created**: 2025-10-20
**Status**: Production guidance
**Purpose**: Define when to use Skills, Agents, or Patterns for organizing knowledge in the ADLC platform

---

## Quick Decision Framework

### Use **Skills** When You Need:
- ✅ **Repeatable workflows** - Same steps executed frequently
- ✅ **Tool orchestration** - Coordinating multiple Claude tools in sequence
- ✅ **Document generation** - Creating structured outputs from templates
- ✅ **User-triggered actions** - Workflows invoked by specific commands
- ✅ **Process automation** - Reducing manual repetitive work

### Use **Agents** When You Need:
- ✅ **Domain expertise** - Deep specialized knowledge (dbt, Snowflake, AWS)
- ✅ **MCP tool integration** - Real-time data access via MCP servers
- ✅ **Complex problem-solving** - Analysis, root cause investigation, optimization
- ✅ **Consultation model** - Role agents delegating to specialists
- ✅ **Research & recommendations** - Expert guidance with validation

### Use **Patterns** When You Need:
- ✅ **Reusable solutions** - Proven technical implementations
- ✅ **Decision frameworks** - Guidelines for "when to use what"
- ✅ **Best practices** - Documented conventions and standards
- ✅ **Reference documentation** - Quick lookup for common scenarios
- ✅ **Historical learnings** - Patterns extracted from completed projects

---

## Three-Layer Knowledge Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  SKILLS (.claude/skills/)                                    │
│  "HOW to execute workflows"                                  │
│  • Procedural automation                                     │
│  • Tool orchestration                                        │
│  • Template-driven generation                                │
└─────────────────────────────────────────────────────────────┘
                           ↓ Uses
┌─────────────────────────────────────────────────────────────┐
│  AGENTS (.claude/agents/)                                    │
│  "WHO to consult for expertise"                              │
│  • Domain specialists (dbt, Snowflake, AWS)                  │
│  • Role agents (Analytics Engineer, Data Engineer)           │
│  • MCP-enhanced analysis                                     │
└─────────────────────────────────────────────────────────────┘
                           ↓ References
┌─────────────────────────────────────────────────────────────┐
│  PATTERNS (.claude/rules/ + .claude/skills/reference-knowledge/) │
│  "WHAT solutions work"                                       │
│  • Technical implementations                                 │
│  • Decision frameworks                                       │
│  • Best practices                                            │
└─────────────────────────────────────────────────────────────┘
```

---

## Detailed Comparison

### Skills: Procedural Workflow Automation

**What They Are**:
- Folders in `.claude/skills/` containing `skill.md` (instructions) + optional scripts/resources
- Invoked via Skill tool: `<invoke name="Skill"><parameter name="command">skill-name</parameter></invoke>`
- Execute multi-step procedures with Claude tool orchestration

**Characteristics**:
- **Procedural**: Step-by-step execution
- **Stateless**: Each invocation is independent
- **Tool-driven**: Orchestrate Read, Write, Bash, Task, etc.
- **User-triggered**: Explicit invocation by user or main Claude
- **Reusable**: Same workflow applied to different contexts

**Best Use Cases**:
1. **Project initialization workflows**
   - Create directory structure
   - Generate README, spec.md, context.md
   - Set up git branch and PR template

2. **Document generation patterns**
   - PR description from project context
   - Release notes from git history
   - API documentation from code

3. **Quality assurance workflows**
   - Pre-commit validation checks
   - Test coverage analysis
   - Documentation completeness audit

4. **Data pipeline templates**
   - Generate dbt model boilerplate
   - Create Prefect flow from template
   - Set up Orchestra pipeline structure

**Example Skill Structure**:
```
.claude/skills/project-setup/
├── skill.md              # Workflow instructions
├── templates/
│   ├── README.template.md
│   ├── spec.template.md
│   └── context.template.md
└── scripts/
    └── validate-structure.sh
```

**When NOT to Use Skills**:
- ❌ Complex domain-specific analysis (use Agents)
- ❌ Storing reference information (use Patterns)
- ❌ One-off custom workflows (direct tool use)
- ❌ Requiring real-time MCP data (use Agents with MCP)

---

### Agents: Domain Expertise + MCP Integration

**What They Are**:
- Markdown files in `.claude/agents/roles/` (generalists) or `.claude/agents/specialists/` (experts)
- Invoked via Task tool with subagent_type parameter
- Combine deep domain knowledge with MCP server access for real-time data

**Characteristics**:
- **Expert-driven**: Domain-specific knowledge and experience
- **MCP-enhanced**: Access to dbt-mcp, snowflake-mcp, github-mcp, etc.
- **Consultative**: Research → Analysis → Recommendations
- **Stateful**: Build context through conversation
- **Delegation-aware**: Know when to consult other specialists

**Agent Types**:

#### Role Agents (Generalists)
- **analytics-engineer-role**: Transformation layer ownership (dbt + Snowflake + BI)
- **data-engineer-role**: Ingestion layer ownership (Orchestra + dlthub + Prefect)
- **data-architect-role**: Platform decisions and system design
- Handle 80% of work independently, delegate 20% to specialists

#### Specialist Agents (Experts)
- **dbt-expert**: SQL transformations, model optimization, testing (with dbt-mcp)
- **snowflake-expert**: Warehouse optimization, cost analysis (with snowflake-mcp)
- **orchestra-expert**: Pipeline orchestration, workflow design (with orchestra-mcp)
- **aws-expert**: Cloud architecture, deployment patterns (with aws-api + aws-docs)
- **github-sleuth-expert**: Repository analysis, issue investigation (with github-mcp)

**Consultation Pattern**:
```
User Request → Role Agent (80% independent work)
                    ↓
              Confidence < 0.60 OR deep expertise needed?
                    ↓ YES
              Specialist Agent (MCP + Expertise)
                    ↓
              Validated Recommendations → Role Agent
                    ↓
              Implementation by Main Claude
```

**Best Use Cases**:
1. **Performance optimization requiring investigation**
   - dbt model slow → dbt-expert analyzes with dbt-mcp + snowflake-mcp
   - Warehouse costs high → snowflake-expert investigates with query history

2. **Architecture decisions with trade-offs**
   - Technology selection → data-architect-role with sequential-thinking-mcp
   - Integration patterns → Multiple specialists coordinated

3. **Production incident investigation**
   - Pipeline failures → orchestra-expert analyzes run logs via orchestra-mcp
   - Data quality issues → dbt-expert checks test results via dbt-mcp

4. **Quality assurance and testing strategies**
   - Test coverage analysis → dbt-expert designs comprehensive test framework
   - Cross-system validation → Multiple specialists provide domain-specific checks

**When NOT to Use Agents**:
- ❌ Simple procedural workflows (use Skills)
- ❌ Quick reference lookups (use Patterns)
- ❌ Highly repetitive tasks (use Skills)
- ❌ Documentation generation (use Skills with templates)

---

### Patterns: Reusable Solution Documentation

**What They Are**:
- Rules in `.claude/rules/` and reference skills in `.claude/skills/reference-knowledge/`
- Reference documentation for proven solutions and best practices
- Extracted from completed projects via `/complete` command

**Characteristics**:
- **Reference-focused**: Quick lookup documentation
- **Production-validated**: Patterns that worked in real projects
- **Decision-oriented**: "When to use X vs Y" frameworks
- **Cross-cutting**: Applicable across multiple domains
- **Evolving**: Updated as new patterns emerge

**Pattern Categories**:

#### 1. Process Patterns
- `delegation-best-practices.md` - Role → Specialist consultation protocols
- `git-workflow-patterns.md` - Branch strategies, PR workflows
- `testing-patterns.md` - ADLC testing framework
- `project-completion-knowledge-extraction.md` - /complete learnings capture

#### 2. Technical Patterns
- `dbt-incremental-optimization-pattern.md` - Incremental model best practices
- `dbt-cloud-multi-tenant-host-pattern.md` - Multi-tenant dbt Cloud configuration
- `github-repo-context-resolution.md` - Auto-resolving GitHub owner/repo

#### 3. Integration Patterns
- `agent-mcp-integration-guide.md` - Adding MCP servers to agents
- `mcp-server-specialist-mapping.md` - Which agents use which MCP servers
- `cross-system-analysis-patterns.md` - Multi-specialist coordination

#### 4. Decision Frameworks
- `sequential-thinking-usage-pattern.md` - When to use sequential-thinking-mcp
- `mcp-delegation-enforcement.md` - MCP usage in delegation
- `anthropic-best-practices-alignment.md` - Claude Code best practices

**Best Use Cases**:
1. **Quick decision support**
   - "Should I use sequential thinking for this task?" → Check usage pattern
   - "Which agent handles dbt optimization?" → Check specialist mapping

2. **Implementation reference**
   - "How do I configure multi-tenant dbt Cloud?" → Follow host pattern
   - "What's the delegation protocol?" → Follow best practices doc

3. **Onboarding new team members**
   - Read patterns to understand proven approaches
   - Reference when creating new agents or skills

4. **Knowledge preservation**
   - Extract learnings from `/complete`
   - Document "gotchas" discovered in production

**When NOT to Use Patterns**:
- ❌ Executable workflows (use Skills)
- ❌ Domain-specific deep expertise (use Agents)
- ❌ One-off unique solutions (may not be reusable)
- ❌ Incomplete or unvalidated approaches

---

## Knowledge Distribution Guidelines

### Creating New Knowledge Artifacts

#### When to Create a Skill
**Trigger**: You've executed the same workflow 3+ times manually
**Process**:
1. Document the workflow steps
2. Identify reusable templates/scripts
3. Create `.claude/skills/[skill-name]/skill.md`
4. Add to skill catalog documentation
5. Test with diverse contexts

**Example**:
- Manual workflow: Project setup (create dirs, README, git branch) → 3+ times
- → Create `project-setup` skill with templates
- Result: 5-minute manual process → 30-second skill invocation

#### When to Create an Agent
**Trigger**: Need domain expertise not covered by existing specialists
**Process**:
1. Identify expertise domain and MCP tools needed
2. Copy appropriate template (role or specialist)
3. Define consultation patterns and delegation triggers
4. Document MCP tool integration
5. Add to agent ecosystem documentation

**Example**:
- Gap: No specialist for Tableau optimization
- → Create `tableau-expert` specialist agent
- MCP: (future) tableau-mcp, (current) manual analysis
- Result: BI optimization expertise available for delegation

#### When to Create a Pattern
**Trigger**: Solved a problem with a reusable solution
**Process**:
1. Extract solution from completed project
2. Generalize for broader applicability
3. Document decision criteria ("when to use")
4. Validate with 2+ production uses
5. Add to pattern library

**Example**:
- Project: Discovered dbt Cloud multi-tenant host issue
- → Extract pattern: How to configure non-standard dbt Cloud hosts
- Validation: Works for all multi-tenant instances
- Result: Pattern prevents future configuration errors

---

## Migration Strategy: Adding Skills to ADLC

### Current State
- ✅ **Agents**: Mature architecture with 30+ specialists and roles
- ✅ **Patterns**: 18 proven patterns documented
- ❌ **Skills**: Not yet implemented

### Proposed Skill Candidates

#### High-Value Skills (Implement First)

**1. project-setup**
- **Workflow**: Initialize new project structure
- **Steps**: Create dirs, generate README/spec/context, create git branch
- **Value**: Saves 10-15 minutes per project
- **Frequency**: 2-4x per month

**2. pr-description-generator**
- **Workflow**: Generate PR description from project context
- **Steps**: Read project files, git diff, generate structured description
- **Value**: Consistent PR quality, saves 5-10 minutes
- **Frequency**: Every PR (10-20x per month)

**3. dbt-model-scaffolder**
- **Workflow**: Generate dbt model boilerplate
- **Steps**: Create staging/intermediate/mart model with tests + docs
- **Value**: Consistent model structure, saves 15-20 minutes
- **Frequency**: 5-10x per month

**4. documentation-validator**
- **Workflow**: Check documentation completeness
- **Steps**: Validate README exists, all required sections present, links work
- **Value**: Prevents incomplete documentation
- **Frequency**: Every project completion

#### Medium-Value Skills (Implement Later)

**5. agent-performance-reporter**
- **Workflow**: Analyze specialist agent usage and success rates
- **Steps**: Parse completed project logs, calculate metrics, generate report
- **Value**: Data-driven agent improvements
- **Frequency**: Monthly

**6. pattern-extractor**
- **Workflow**: Extract reusable patterns from project findings
- **Steps**: Parse task files, identify PATTERN: markers, generate pattern docs
- **Value**: Automate knowledge capture
- **Frequency**: Every project completion (via /complete)

### Implementation Plan

**Phase 1: Foundation (Week 1-2)**
1. Create `.claude/skills/` directory structure
2. Document skills vs agents vs patterns (this file)
3. Update CLAUDE.md with skills guidance
4. Create skill catalog documentation

**Phase 2: High-Value Skills (Week 3-4)**
1. Implement `project-setup` skill
2. Implement `pr-description-generator` skill
3. Test with 3+ real projects
4. Refine based on usage

**Phase 3: Expansion (Week 5-8)**
1. Implement `dbt-model-scaffolder` skill
2. Implement `documentation-validator` skill
3. Create skill templates for future development
4. Train team on skill usage

**Phase 4: Integration (Week 9-12)**
1. Integrate skills with `/idea`, `/start`, `/complete` workflows
2. Add skill invocations to agent recommendations
3. Measure time savings and quality improvements
4. Iterate based on feedback

---

## Cross-Reference Architecture

### Skills → Agents → Patterns Flow

**Example: dbt Model Optimization**

```
1. USER: "Optimize the slow dbt model"
   ↓
2. MAIN CLAUDE: Consults analytics-engineer-role agent
   ↓
3. AGENT: Uses dbt-mcp to analyze model
   - References PATTERN: dbt-incremental-optimization-pattern.md
   - References PATTERN: delegation-best-practices.md (if delegating)
   ↓
4. AGENT: Returns recommendations
   ↓
5. MAIN CLAUDE: Implements recommendations
   - May invoke SKILL: dbt-model-scaffolder (if creating new model)
   ↓
6. RESULT: Optimized model with patterns applied
   ↓
7. /COMPLETE: Extracts learnings
   - Updates PATTERN: dbt-incremental-optimization-pattern.md
   - Updates AGENT: dbt-expert.md (confidence levels)
```

### Skill Can Invoke Agent

**Example: project-setup Skill**

```yaml
# .claude/skills/project-setup/skill.md

## Steps
1. Create project directory structure
2. Invoke business-analyst-role agent to generate project spec
3. Generate README from template + agent recommendations
4. Create git branch with appropriate naming
5. Initialize context.md with agent insights
```

**Benefit**: Skills orchestrate high-level workflows, agents provide domain expertise

### Agent References Patterns

**Example: dbt-expert Agent**

```markdown
# dbt-expert.md

## Incremental Model Optimization

When optimizing incremental models, reference:
- `.claude/skills/reference-knowledge/dbt-snowflake-optimization-pattern/SKILL.md`
- Production-validated approaches with confidence scores
- Known gotchas and solutions

Use pattern as starting point, enhance with MCP tool analysis.
```

**Benefit**: Agents leverage proven patterns, avoid reinventing solutions

### Pattern Informs Skill Design

**Example: Creating New Skill**

```markdown
# Pattern: delegation-best-practices.md
"Skills orchestrate workflows, agents provide expertise"

↓ Applied to

# Skill: pr-description-generator
Step 2: Invoke github-sleuth-expert to analyze git history
Step 3: Invoke documentation-expert to ensure quality standards
Step 4: Synthesize agent outputs into PR description
```

**Benefit**: Patterns guide skill architecture decisions

---

## Quality Standards

### Skills
- ✅ **Clear workflow steps**: Each step well-documented
- ✅ **Error handling**: Graceful failures with rollback
- ✅ **Reusability**: Works across different contexts
- ✅ **Testing**: Validated with 3+ diverse scenarios
- ✅ **Documentation**: User-facing usage guide

### Agents
- ✅ **Domain expertise**: Clear specialization and scope
- ✅ **MCP integration**: Uses appropriate MCP servers
- ✅ **Consultation protocol**: Input/output formats defined
- ✅ **Confidence levels**: Capabilities documented with scores
- ✅ **Quality validation**: Recommendations tested before returning

### Patterns
- ✅ **Production-validated**: Used in 2+ real projects successfully
- ✅ **Decision criteria**: "When to use" clearly documented
- ✅ **Examples included**: Real-world usage demonstrated
- ✅ **References**: Links to related patterns, agents, skills
- ✅ **Maintenance**: Updated as patterns evolve

---

## Maintenance Protocol

### Continuous Improvement

**After Every Project Completion** (via `/complete`):
1. **Skills**: Did workflows feel repetitive? Create skill candidate
2. **Agents**: Did agent recommendations work? Update confidence levels
3. **Patterns**: Was solution reusable? Extract and document pattern

**Monthly Review**:
1. **Skills usage audit**: Which skills used most? Optimize top 5
2. **Agent performance**: Success rates, time-to-recommendation, quality
3. **Pattern relevance**: Which patterns referenced? Archive unused

**Quarterly Strategy**:
1. **Knowledge gaps**: What expertise is missing? Create agents
2. **Automation opportunities**: What's still manual? Create skills
3. **Pattern evolution**: Update patterns with new learnings

---

## Summary: When to Use What

| Need | Use This | Example |
|------|----------|---------|
| **Repeatable workflow** | Skill | Project setup, PR generation |
| **Domain expertise** | Agent | dbt optimization, AWS architecture |
| **Quick reference** | Pattern | Git workflow, delegation protocol |
| **Tool orchestration** | Skill | Multi-step automation |
| **MCP-enhanced analysis** | Agent | Real-time data investigation |
| **Best practice lookup** | Pattern | Sequential thinking usage, MCP mapping |
| **Complex problem-solving** | Agent | Root cause analysis, architecture decisions |
| **Template generation** | Skill | Document scaffolding, code boilerplate |
| **Decision framework** | Pattern | When to delegate, when to use MCP |

---

## References

### Claude Code Documentation
- **Skills**: https://docs.claude.com/en/docs/claude-code/skills
- **Agent Skills Engineering**: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- **Skills Repository**: https://github.com/anthropics/skills

### ADLC Documentation
- **Agent Architecture**: `.claude/agents/README.md`
- **Pattern Library**: `.claude/rules/` and `.claude/skills/reference-knowledge/`
- **Delegation Best Practices**: `.claude/skills/reference-knowledge/delegation-best-practices/SKILL.md`

---

**Last Updated**: 2025-10-20
**Next Review**: 2025-11-20 (monthly cadence)
**Owner**: ADLC Platform Team
