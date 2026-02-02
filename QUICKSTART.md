# Quick Start - Get Running in 5 Minutes

**Just want to try this without reading 900 lines of docs?** Start here.

## Minimum Viable Setup

### 1. Prerequisites Check (30 seconds)

```bash
# Do you have these?
claude --version  # Required - Install: https://docs.claude.com/en/docs/claude-code/installation
git --version     # Required - You already have this
gh --version      # Optional - Only needed for /idea command
```

**Don't have Claude Code?** Install it first, then come back.

### 2. Clone and Run Setup (2 minutes)

```bash
git clone https://github.com/dylpickledev/claude-analytics-framework.git
cd claude-analytics-framework
./setup.sh
```

**What setup.sh does:**
- Asks 4 questions about your data stack
- Copies relevant agent files to `.claude/agents/`
- Updates `.claude/config/tech-stack.json`
- **That's it.** No system changes, no breaking anything.

**Can I undo it?** Yes. Just delete this directory.

### 3. Start Your First Project (2 minutes)

```bash
# Create a project
claude /start "test project to see how this works"

# You now have:
# - projects/active/feature-test-project/ folder
# - Git branch: feature/test-project
# - README, spec.md, context.md templates ready
```

### 4. Try the AI Agents

```bash
# Just ask Claude questions - it uses the right agents automatically
claude "What agents are available?"
claude "Help me design a dbt staging model for customer data"
claude "Show me what a project looks like when complete"
```

**That's it. You're using the framework.**

---

## What You Can Ignore (For Now)

You do NOT need to:
- ❌ Understand the agent architecture
- ❌ Configure MCP servers (this is optional advanced stuff)
- ❌ Learn all 5 commands
- ❌ Read specialist agent definitions
- ❌ Set up GitHub issues (works without them)
- ❌ Use VS Code worktrees (nice-to-have, not required)

**Start simple. Expand later when you need more.**

---

## The 5 Commands (Learn As You Go)

**Essential:**
- `/start "project"` - Create project structure + git branch

**Helpful:**
- `/idea "description"` - Create GitHub issue (requires `gh` CLI)
- `/complete project-name` - Archive project when done
- `/switch` - Switch between projects without losing context

**Advanced:**
- `/research topic` - Deep exploration before starting

---

## Common Questions

**"What if my stack isn't dbt/Snowflake/Tableau?"**
→ Setup asks about YOUR stack. If it's not listed, choose "Other" and the framework learns from your work.

**"Will this break my existing Claude Code setup?"**
→ No. This is just a directory with `.claude/` configuration. Your other projects are unaffected.

**"Do I need to use GitHub issues?"**
→ No. `/idea` and `/start` commands work with or without GitHub. Issues are just convenient for tracking.

**"What's MCP and do I need it?"**
→ MCP = Model Context Protocol. It connects Claude to live systems (dbt Cloud API, Snowflake, etc.). **You don't need it to start.** Skip that part of setup.

**"Can I customize the branch naming / project structure?"**
→ Yes. Edit `scripts/start.sh` for branch naming, `scripts/work-init.sh` for project structure.

**"Is this overkill for my simple projects?"**
→ Probably! This framework adds value when:
- Working on 3+ projects per month
- Using multiple tools (dbt + warehouse + orchestration + BI)
- Building similar things repeatedly
- Working in a team that needs to share patterns

For one-off quick fixes, just use Claude Code normally.

---

## Next Steps

**After your first test project:**
1. Check out `examples/sample-project/` to see what a real project looks like
2. Read `README.md` section "The 5 Commands" for full workflow
3. Explore `.claude/agents/` to see what agents do
4. Consider setting up MCP for live system access (optional)

**Got questions?**
- Check the main `README.md`
- Read `CONTRIBUTING.md` if you want to extend this
- Open an issue on GitHub

---

## Troubleshooting

**"Permission denied on scripts"**
```bash
chmod +x scripts/*.sh
```

**"Claude command not found"**
You need to install Claude Code first: https://docs.claude.com/en/docs/claude-code/installation

**"Setup failed with error"**
- Make sure you're in the `claude-analytics-framework` directory
- Check that git is installed
- Try re-running `./setup.sh`

**"I don't want to answer setup questions"**
Skip setup entirely. Just copy one of the agent files from `.claude/agents/specialists/` and ask Claude to use it. The framework is just organized prompts - nothing magical.

---

**Ready to dive deeper?** Read the full [README.md](README.md)
