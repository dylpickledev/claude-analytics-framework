# 📚 Claude ADLC Framework Platform Documentation

Welcome to the platform documentation for the Claude ADLC Framework - an AI-powered Analytics Development Lifecycle platform for data and analytics teams.

## 🔄 Three-Layer ADLC Architecture

The Claude ADLC Framework implements the complete [dbt Analytics Development Lifecycle](https://www.getdbt.com/resources/the-analytics-development-lifecycle) through three integrated AI-powered layers:

### 💡 [Layer 1: Planning](planning/)
**ADLC Plan Phase** - Idea Management & Strategic Planning
- Business case validation and idea capture via GitHub issues
- Strategic planning and prioritization frameworks
- Stakeholder feedback integration
- Impact analysis and roadmap creation

### 🔧 [Layer 2: Development](development/)
**ADLC Develop/Test/Deploy Phases** - Local Development & Project Management
- **[Agent Development](development/agent-development.md)**: Creating custom specialist agents
- **[Claude Interactions](development/claude-interactions.md)**: Command reference and best practices
- **[VS Code Worktree Integration](development/vscode-worktree-integration.md)**: Multi-project workspace management
- **[Context Switching](development/context-switching-workflows.md)**: Zero-loss context management
- **[Context Optimization](development/context-optimization.md)**: Token efficiency strategies

### 🤖 [Layer 3: Operations](operations/)
**ADLC Operate/Observe/Discover/Analyze Phases** - Automated Operations
- **[Cross-Repository Architecture](operations/cross-repository-issue-architecture.md)**: Multi-repo coordination
- **[Troubleshooting Guide](operations/troubleshooting.md)**: Common problems and solutions
- **[Dashboard Troubleshooting](operations/troubleshooting-blank-dashboards.md)**: Systematic BI debugging

## 📖 Additional Documentation

### 🏗️ [Architecture](architecture/)
**System Design & Agent Architecture**
- **[Agent Capability Summary](architecture/agent-capability-summary.md)**: Complete overview of agents and MCP integrations
- **[Confidence Routing](architecture/confidence-routing.md)**: How agents decide when to delegate to specialists

### 🔌 [MCP Servers](mcp-servers/)
**Model Context Protocol Integrations**
- **[AWS Documentation MCP](mcp-servers/aws-docs-mcp-integration-guide.md)**: AWS service documentation access
- **[Slack MCP](mcp-servers/slack-mcp-capabilities.md)**: Slack workspace integration
- **[Filesystem MCP](development/filesystem-mcp-server-capabilities.md)**: Advanced file operations
- **[Sequential Thinking MCP](development/sequential-thinking-mcp-capabilities.md)**: Complex reasoning support

### 📊 [Training](training/)
**Agent Learning & Improvement**
- Chat analysis for continuous agent improvement
- Conversation effectiveness metrics
- Learning extraction from completed projects

## 🚀 Quick Navigation

### For New Users
1. Read the [main project README](../../README.md) for system overview
2. Review [Claude Interaction Guide](development/claude-interactions.md) for slash commands
3. Explore [Agent Development](development/agent-development.md) to create custom specialists

### For Daily Operations
1. Use [Claude Interaction Guide](development/claude-interactions.md) for workflow commands
2. Reference [Troubleshooting Guide](operations/troubleshooting.md) for common issues
3. Check [Dashboard Troubleshooting](operations/troubleshooting-blank-dashboards.md) for BI debugging

### For Administrators
1. Study [Agent Capability Summary](architecture/agent-capability-summary.md) for system design
2. Review [Context Optimization](development/context-optimization.md) for efficiency
3. Implement patterns from [Cross-Repository Architecture](operations/cross-repository-issue-architecture.md)

## 🎯 Documentation Goals

This documentation suite provides:

- **Complete Coverage**: Every feature and capability documented
- **Practical Examples**: Real-world usage scenarios and patterns
- **Progressive Complexity**: From basic usage to advanced configuration
- **Troubleshooting Focus**: Systematic problem-solving resources
- **Team Ready**: Professional deployment and collaboration guidance

## 💡 Getting Started Recommendations

### If You're New to AI-Powered Development
Start with the [main project README](../../README.md) to understand the system's value proposition and ADLC workflow.

### If You're Ready to Use It
Review [Claude Interaction Guide](development/claude-interactions.md) for slash commands, then start with `/capture` to manage ideas.

### If You're Experiencing Issues
Go directly to [Troubleshooting Guide](operations/troubleshooting.md) or [Dashboard Troubleshooting](operations/troubleshooting-blank-dashboards.md) for specific problems.

### If You Want to Extend the System
Study [Agent Development](development/agent-development.md) and [Agent Capability Summary](architecture/agent-capability-summary.md) to create custom specialists.

## 🔄 Documentation Maintenance

This documentation is maintained through:
- Project completion knowledge extraction (`/complete` command)
- Agent chat analysis and learning
- Real-world troubleshooting discoveries
- Best practice refinements from production use

---

**Built for data teams who want AI-powered infrastructure with comprehensive, accessible documentation.**