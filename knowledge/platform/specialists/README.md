# Specialist Agent Documentation

## Overview
This directory contains comprehensive documentation for tool specialist agents. Specialists provide deep domain expertise in specific platforms, tools, and technologies, supporting role-based agents through the delegation pattern.

## Available Specialist Documentation

### Data Platform
- **dbt Expert** - dbt Cloud patterns, SQL transformations, semantic layer
- **Snowflake Expert** - Warehouse optimization, cost analysis, performance tuning
- **Orchestra Expert** - Workflow orchestration across multiple platforms
- **Prefect Expert** - Python-based workflow patterns
- **dlthub Expert** - Data ingestion and pipeline patterns

### BI & Visualization
- **Tableau Expert** - Dashboard optimization, Tableau Server/Cloud patterns

### Development
- **React Expert** - React.js applications, cloud deployment patterns
- **Streamlit Expert** - Data applications and dashboards
- **UI/UX Expert** - User experience design, prototyping

### Cross-Functional
- **Documentation Expert** - Standards enforcement and documentation patterns
- **GitHub Sleuth Expert** - Repository analysis, issue investigation
- **Business Context** - Requirements gathering, stakeholder alignment
- **Cost Optimization Specialist** - Cross-platform cost analysis
- **Data Quality Specialist** - Testing architecture, validation strategies

### Cloud & Infrastructure
- **AWS Expert** - AWS infrastructure, security, deployment patterns
- **Azure Expert** - Azure infrastructure, authentication, cross-cloud integration
- **Multi-Cloud Expert** - Cross-cloud architectures and integrations

---

## Documentation Standards

### Structure for New Specialist Docs

Each specialist documentation file should include:

1. **Overview** - Agent purpose, core competencies, MCP integrations
2. **Research Summary** - Domains covered, best practices, key findings
3. **Key Capabilities** - Production-validated patterns with confidence scores
4. **Documentation Structure** - Agent definition and patterns library
5. **Integration Guidelines** - How to work with other agents
6. **Usage Guidelines** - When to use, coordination patterns
7. **Best Practices Summary** - Current year recommendations
8. **Learning Resources** - Primary sources, staying current
9. **Example Scenarios** - Real-world use cases with solutions
10. **Continuous Improvement** - Enhancement process, feedback loop

### Quick Reference Structure

Quick reference guides should provide:

1. **Common Commands** - Frequently used operations
2. **Troubleshooting Guide** - Error codes and resolutions
3. **Configuration Patterns** - Standard setups
4. **Decision Trees** - When to use which approach
5. **Cross-References** - Links to comprehensive docs

---

## Using Specialist Documentation

### For Role-Based Agents
- Review specialist docs when delegating tasks
- Reference confidence scores for pattern selection
- Use quick reference for fast lookups during execution

### For Users
- Start with quick reference for immediate needs
- Read comprehensive docs for architecture planning
- Reference example scenarios for implementation guidance

### For Agent Development
- Use as templates when creating new specialists
- Extract patterns for `.claude/skills/reference-knowledge/`
- Update with production learnings via `/complete`

---

## Related Documentation

- **[Agent Capability Summary](../architecture/agent-capability-summary.md)** - Complete system capabilities
- **[Confidence Routing](../architecture/confidence-routing.md)** - Delegation decision framework
- **[Agent Development](../development/agent-development.md)** - Creating custom specialists
- **[Agent Definitions](../../../.claude/agents/specialists/)** - Actual specialist agent files

---

## Contributing Specialist Documentation

When completing projects with specialist agents:

1. **Extract Production Patterns** - Document what worked in production
2. **Update Confidence Scores** - Validate patterns with real deployments
3. **Add Example Scenarios** - Capture real-world problem → solution flows
4. **Document Integrations** - How specialists coordinate with each other
5. **Create Quick References** - Fast lookup guides for common operations

Use the `/complete` command to automatically identify documentation improvements.

---

## Documentation Maintenance

### Review Schedule
- **Quarterly**: Update best practices with platform changes
- **After Major Projects**: Extract new patterns and learnings
- **Platform Updates**: Document deprecations and migrations
- **Agent Enhancements**: Reflect new capabilities and MCP integrations

### Quality Standards
- Production-validated patterns preferred (confidence ≥ 0.80)
- Clear separation: comprehensive docs vs quick reference
- Cross-references to related agents and documentation
- Real-world examples with concrete code/configuration
- Current year best practices prominently featured

---

*Last Updated: 2025-10-09*
*Version: 1.0*
