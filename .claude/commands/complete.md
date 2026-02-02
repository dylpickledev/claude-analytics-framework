# /complete Command Protocol (Progressive Disclosure)

## Purpose
Complete and archive projects with automated knowledge extraction and intelligent knowledge dissemination. Supports lean default mode for speed, plus optional deep ACE analysis for continuous improvement insights.

## Usage
```bash
# Default: Fast, action-focused completion
claude /complete [project-name]

# Deep Analysis: Full ACE learning with detailed reflection
claude /complete [project-name] --deep
```

## Progressive Disclosure Modes

### Default Mode (Recommended)
**Fast, action-focused completion:**
- Extract key learnings and patterns
- Update relevant agent knowledge
- Archive project efficiently
- **Time**: ~30-60 seconds

### Deep Mode (`--deep` flag)
**Comprehensive ACE learning analysis:**
- All default mode features PLUS:
- Delegation effectiveness deep-dive
- Project execution reflection (what worked/failed)
- Skill discovery from repetitive workflows
- Pattern confidence evolution tracking
- **Time**: ~2-4 minutes
- **Use when**: Major project completion, quarterly reviews, establishing new patterns

## Protocol Overview

```
🔍 Analysis Phase:
   DEFAULT: Project knowledge + basic metrics
   --deep: + Delegation analysis + ACE reflection + Skill discovery

💬 Approval Phase:
   - User reviews and approves proposed changes

✅ Execution Phase:
   - Execute approved knowledge updates
   - Archive project with patterns
   - Git workflow guidance
   - GitHub issue closure
```

---

## Analysis Phase

### DEFAULT MODE: Steps 1-1.5 (Core Analysis)

#### Step 1: Project Analysis & Knowledge Extraction

**Claude analyzes completed project for:**
- **Technical Documentation**: Architecture patterns, implementation strategies
- **Agent Knowledge**: Tool-specific learnings and best practices
- **Process Insights**: Workflow improvements and organizational patterns
- **Integration Patterns**: Cross-system coordination strategies

**Actions**:
1. **Read project files**: `spec.md`, `context.md`, `tasks/`, `README.md`
2. **Identify extractable knowledge**:
   - Architecture patterns and technical decisions
   - Tool-specific insights for specialist agents
   - Process improvements and workflow learnings
   - Integration strategies and coordination patterns

---

#### Step 1.5: Basic Performance Metrics

**Track essential metrics for knowledge extraction:**

- **Agent invocations**: Count by type (dbt-expert: 3, snowflake-expert: 2, etc.)
- **Success patterns**: Completed without retries vs total attempts
- **Key learnings**: What worked, what patterns emerged
- **Confidence updates**: Which agent patterns validated (+0.05 to +0.15)

---

### DEEP MODE ONLY (`--deep` flag): Steps 1.6-1.9 (ACE Analysis)

**Note**: The following analysis steps are ONLY executed when user runs `/complete [project] --deep`

---

#### Step 1.6: Delegation Effectiveness Deep-Dive

**Quantitative + qualitative analysis of agent delegation decisions:**

For each specialist agent invoked:
- Assess value delivered vs token cost
- Evaluate delegation necessity (necessary/marginal/unnecessary)
- Validate 0.60 confidence threshold effectiveness
- Calculate ROI (business impact / token cost)

**Outputs**:
- Delegation necessity breakdown (% necessary vs marginal)
- Token cost vs value analysis
- Threshold optimization recommendations

---

#### Step 1.7: Project Execution Reflection (ACE Learning)

**Systematic analysis of what worked, what failed, and why:**

**Key reflection areas**:
1. **Approach Effectiveness**: What patterns worked (rank by effectiveness)
2. **Error Patterns**: What errors occurred, root causes, resolutions
3. **Skill Performance**: If skills used, did they deliver expected outcomes?
4. **Decision Quality**: Were major technical decisions validated?
5. **Knowledge Gaps**: What information was missing that slowed progress?

**Critical ACE questions**:
- What would you do differently if starting this project again?
- Were there alternative approaches? Which was chosen and why?
- What approaches didn't work or were inefficient?

**Outputs**:
- Ranked list of effective approaches with reuse guidance
- Error pattern documentation (error → resolution → prevention)
- Knowledge gap identification for agent updates
- Decision validation (what worked, what needs refinement)

---

#### Step 1.8: Skill Discovery Analysis (Automation Opportunities)

**Identify repetitive workflows worth automating:**

**Analysis process**:
1. Review project files for procedural patterns ("Step A → Step B → Step C")
2. Count repetitions: How many times executed in this + past projects?
3. Score automation value (HIGH/MEDIUM/LOW)
4. Extract reusable templates (documents, code, config)

**Scoring criteria**:
- **HIGH VALUE**: 3+ occurrences, 15+ min each, clear reusable pattern → Propose skill
- **MEDIUM VALUE**: 2-3 occurrences, 10-15 min each → Track as candidate
- **LOW VALUE**: 1-2 occurrences, <10 min each → Skip

**Outputs**:
- Workflow frequency table (this project + historical)
- HIGH VALUE skill candidates with time savings calculations
- Extracted templates ready for skill creation

---

#### Step 1.9: Knowledge Dissemination Strategy

**Determine optimal knowledge placement and updates:**

**Claude analyzes**:
- Which agent files need updates (tool-specific insights)
- Whether new patterns warrant pattern library additions
- If application knowledge requires three-tier documentation
- Configuration quality (follows Anthropic best practices)

**Present unified proposal to user** with all recommended changes:

```markdown
🔍 Analyzing project: [project-name]

📈 Project Summary:
   • Agents invoked: [X] (agent-1: Y, agent-2: Z)
   • Success rate: [X]% ([Y] retries needed)
   • Task complexity: [Simple/Medium/Complex]
   • Key patterns discovered: [X]

🎯 Confidence Updates:
   ↗️ [agent-name]: +0.10 ([pattern name validated])
   ↗️ [agent-name]: +0.05 ([successful pattern application])

💡 Proposed Knowledge Updates:

### Agent Files to Update:
📝 .claude/agents/[agent-name].md
   + [Pattern name] section
   + Confidence: +0.XX ([reason])
   + [show exact content additions]

### New Knowledge Documents (if applicable):
📄 knowledge/applications/[app-name]/ (if deploying new app)
   + architecture/ - System design, data flows
   + deployment/ - Deployment runbooks
   + operations/ - Monitoring, troubleshooting

📄 .claude/skills/reference-knowledge/[new-pattern]/SKILL.md (if new pattern discovered)
   + [Pattern purpose and key content]

### Memory Extraction (Automatic):
🤖 finish.sh will automatically extract:
   - [X] PATTERN markers from task findings
   - [Y] SOLUTION markers
   - [Z] ERROR-FIX markers
   → Saved to memory/recent/YYYY-MM.md

--- DEEP MODE ADDITIONS (if --deep flag used) ---

## 🔬 Delegation Effectiveness Analysis

**[agent-name] ([X] invocations)**:
- Necessity: ✅ Necessary ([X]/[Y]), ⚠️ Marginal ([Z]/[Y])
- Token ROI: [X]x ([tokens] → [business value])
- Unique contribution: [What specialist provided]

## 💭 Project Execution Reflection

### Effective Approaches ✅
[Ranked list of what worked with reuse guidance]

### Ineffective Approaches ⚠️
[What didn't work, root causes, better alternatives]

### Error Patterns 🔧
[Error → Resolution → Prevention pattern]

### Knowledge Gaps Identified 📚
[What information was missing that slowed progress]

## 🤖 Skill Discovery

**HIGH VALUE Automation Opportunities**:
[Table showing workflows, frequency, time savings]

**Skill Candidate: [proposed-skill-name]**
- Trigger: [workflow executed X times]
- Expected savings: [Y] min/month
- Should I create this skill? (yes/defer/no)

--- END DEEP MODE ADDITIONS ---

🤔 **Should I proceed with these knowledge updates?**
   - Type 'yes' to execute all proposed changes
   - Type 'modify' to adjust specific updates
   - Type 'skip' to complete project without knowledge updates
```

---

## Approval Phase

### WAIT for User Approval

User options:
- **yes**: Execute all proposed changes
- **modify**: Adjust specific updates (Claude asks which to modify)
- **skip**: Complete project without knowledge updates

---

## Execution Phase: Steps 2-5

### Step 2: Execute Approved Knowledge Updates

**Only after user approval, Claude executes:**

#### 2.1 Agent Knowledge Updates

Update agent files with:
- Tool-specific insights and best practices
- Confidence score adjustments based on outcomes
- Integration patterns and coordination strategies
- Performance metrics updates

**For each agent file updated**:
- Add new pattern sections with evidence
- Update confidence scores with validation counts
- Add contextual guidance (when to use, when to avoid)
- Update routing recommendations

#### 2.2 Technical Documentation

**Production Application Knowledge** → `knowledge/applications/<app-name>/`:
- **When**: Deploying new apps or major app updates
- **Structure**: Three-tier pattern (Tier 2 - comprehensive docs)
  - `architecture/` - System design, data flows, infrastructure details
  - `deployment/` - Complete deployment runbooks, Docker builds, AWS configuration
  - `operations/` - Monitoring, troubleshooting guides, incident response
- **Updates Required**:
  1. Create/update knowledge base docs for the application
  2. Update agent pattern index (e.g., aws-expert.md with confidence scores)
  3. Add to "Known Applications" in relevant role agents
  4. Create lightweight README in actual repo (Tier 1) linking to knowledge base

**Platform/Tool Patterns** → `knowledge/da-agent-hub/`:
- **When**: Discovering reusable patterns for ADLC workflow
- **Structure**: Organized by ADLC phase (planning/, development/, operations/)
- **Examples**: Testing frameworks, git workflows, cross-system analysis patterns

#### 2.3 Pattern Library Updates

- Create new patterns based on project learnings
- Update existing patterns with new validations and confidence scores
- Add contextual guidance to patterns (when to use, when to avoid)
- Deprecate superseded patterns with links to better approaches

#### 2.4 Skill Creation (If Proposed)

If HIGH VALUE skill candidates identified:
- Create `.claude/skills/[skill-name]/skill.md` with workflow
- Add templates to `.claude/skills/[skill-name]/templates/`
- Update `.claude/skills/README.md` catalog
- Document trigger phrases and expected outcomes

#### 2.5 Memory System Updates

**Note**: Pattern extraction happens automatically via `finish.sh`:
- Extracts patterns marked with PATTERN:, SOLUTION:, ERROR-FIX:, etc.
- Saves to project documentation for review
- No manual action needed - automatic during archival

---

### Step 3: Archive Project

1. **Create archive directory**: `projects/completed/YYYY-MM/[project-name]/`
2. **Move project files**: Complete project structure with full history
3. **Remove from active**: Clean up `projects/active/[project-name]/`
4. **Execute finish.sh**: Automatic pattern extraction and GitHub issue closure

---

### Step 4: Git Workflow Guidance

**Provide branch-aware options:**
- **Feature branch**: Recommend PR creation for review
- **Main branch**: Confirm direct merge readiness
- **Stay on branch**: Option to continue working

**Git workflow commands**:
```bash
# Create PR (recommended for feature branches)
gh pr create --title "Complete [project-name]" --body "[description]"

# Or merge to main
git checkout main && git merge [branch]
```

---

### Step 5: Handle Related Ideas

- **Search for source ideas**: Look for original idea that led to this project
- **Handle based on what's found**:
  - **If source idea exists**: Move to archive and update with completion status
  - **If no source idea**: Note as ad-hoc project (no idea cleanup needed)
  - **If orphaned ideas found**: Clean up any related unarchived ideas
- **Cross-reference completion**: Maintain idea → project → completion traceability
- **Clean up workflow**: Ensure no orphaned ideas remain

---

## Response Format

### Phase 1: Analysis and Proposal
```markdown
🔍 Analyzing project: [project-name]
📊 Extracting performance metrics...
[Complete analysis output as shown in Step 1.10]

🤔 **Should I proceed with these knowledge updates?**
```

### Phase 2: Execution (After Approval)
```markdown
✅ Executing approved knowledge updates...

💡 Knowledge Updates Applied:
   ✅ Updated: agents/[agent-name].md (pattern + confidence: +0.XX)
   ✅ Updated: agents/[agent-name].md (confidence: +0.XX)
   ✅ Created: .claude/skills/reference-knowledge/[new-pattern]/SKILL.md
   ✅ Created: knowledge/applications/[app-name]/ (three-tier docs)
   ✅ Created: .claude/skills/[skill-name]/ (automation opportunity)

📦 Archiving project...
   ✅ Moved to: projects/completed/YYYY-MM/[project-name]/
   🧹 Pattern extraction: [X] patterns saved to memory/recent/

🔀 Git workflow options:
   1. Create PR: gh pr create --title "Complete [project-name]"
   2. Merge to main: git checkout main && git merge [branch]
   3. Stay on branch: Continue working

🤖 Routing Recommendations for Future Projects:
   • For [task type]: Prefer [agent] (confidence: 0.XX)
   • For [coordination pattern]: [agent-1] + [agent-2] (proven sequence)

✅ Project '[project-name]' completed with ACE learning and skill discovery!

🎉 Next steps:
   - Review performance metrics and confidence updates
   - Review extracted knowledge and new skills
   - Create PR if on feature branch
   - Plan next project
```

---

## Knowledge Extraction Criteria

### Agent Knowledge Updates
**Update agent files when project contains:**
- New tool patterns specific to each tool
- Best practices for tool configuration/usage
- Integration patterns with other systems
- Troubleshooting insights and resolution patterns
- Performance optimizations and cost management
- Confidence adjustments based on success/failure patterns

### Technical Documentation
**Add to knowledge/ when project demonstrates:**
- **Production applications** (`knowledge/applications/<app-name>/`): New deployments or major updates
- System architecture: Novel integration or design patterns
- Process improvements: Workflow enhancements worth preserving
- Standards evolution: Updated team practices
- Cross-system coordination: Multi-tool orchestration patterns

### Pattern Confidence Evolution
**Track and update when project reveals:**
- Pattern validation (successful usage increases confidence)
- Pattern edge cases (scenarios where pattern struggles)
- Pattern supersession (better approaches discovered)
- Contextual guidance (when to use, when to avoid)

### Skill Discovery
**Create skills when analysis shows:**
- Workflow repeated 3+ times (frequency threshold)
- 15+ minutes per execution (time savings threshold)
- Clear procedural steps (automation feasibility)
- Reusable templates identified (template extraction)

### Delegation Effectiveness
**Update delegation strategy when revealing:**
- Agent effectiveness patterns (which agents excel at specific tasks)
- Coordination strategies (successful multi-agent workflows)
- Threshold optimization (adjust 0.60 threshold based on decisions)
- Token ROI measurements (cost vs business value delivered)

---

## Integration with ADLC & ACE Learning

- **ADLC Deploy Completion**: Final deployment with knowledge preservation
- **ADLC Operate Transition**: Project ready for operations with documented patterns
- **ACE Context Evolution**: Patterns, confidence scores, and skills evolve based on outcomes
- **ACE Self-Reflection**: Systematic analysis of what worked, what failed, why
- **ACE Skill Acquisition**: Automated discovery of workflows to automate
- **Cross-layer Context**: Full traceability from idea to operations with preserved learnings
- **Knowledge System**: Automatic pattern extraction creates reference skills in `.claude/skills/reference-knowledge/`
- **Confidence Routing**: Performance metrics inform future agent selection

---

## Success Criteria

### Default Mode
- [ ] Project knowledge automatically extracted and preserved
- [ ] Basic performance metrics tracked (agent invocations, success rate)
- [ ] Agent confidence scores updated based on outcomes
- [ ] Relevant agent files updated with new insights + confidence adjustments
- [ ] Technical documentation created when warranted (three-tier pattern)
- [ ] Memory system populated with patterns (automatic via finish.sh)
- [ ] Project successfully archived to completed directory
- [ ] Git workflow guidance provided based on current branch
- [ ] Related ideas updated with completion status
- [ ] Clear next steps for continued development cycle

### Deep Mode (`--deep` flag)
All default mode criteria PLUS:
- [ ] Delegation effectiveness measured (qualitative + quantitative ROI)
- [ ] ACE self-reflection completed (approaches, errors, decisions)
- [ ] Skill discovery analysis performed (automation opportunities identified)
- [ ] Pattern validation and confidence evolution documented
- [ ] Routing recommendations generated for future projects
- [ ] Threshold optimization proposals (delegation confidence tuning)

---

*ADLC project completion with progressive disclosure: lean default for speed, deep ACE analysis for continuous improvement - from active development to operational wisdom with compound intelligence.*
