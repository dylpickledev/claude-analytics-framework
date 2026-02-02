# DA Agent Hub Devcontainer

Get started with DA Agent Hub in seconds using VS Code devcontainers.

## Quick Start

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [VS Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Launch

1. **Clone and open**:
   ```bash
   git clone https://github.com/dylpickledev/da-agent-hub.git
   cd da-agent-hub
   code .
   ```

2. **Open in container**:
   - VS Code will prompt: "Reopen in Container"
   - Click "Reopen in Container"
   - Wait for container to build (~2-3 minutes first time)

3. **Authenticate**:
   ```bash
   # In the VS Code terminal once container is ready
   gh auth login        # Authenticate with GitHub
   claude auth          # Authenticate with Claude Code
   ```

4. **Start using**:
   ```bash
   claude /capture "Build my first data pipeline"
   ```

## What's Included

The devcontainer provides:

- **Claude Code CLI**: Pre-installed and ready to use
- **Git**: Version control
- **GitHub CLI**: For GitHub operations
- **Node.js LTS**: For any JavaScript tools
- **Python 3.11**: For scripting
- **Bash**: All scripts executable and ready
- **VS Code Extensions**:
  - Claude Code extension
  - GitHub Pull Requests
  - ShellCheck for script linting

## Configuration

### Claude Code Settings
Your local `~/.config/claude-code` directory is mounted into the container, so your Claude Code authentication and settings are preserved.

### MCP Integration
To use MCP features (dbt Cloud, Snowflake), add your `.claude/mcp.json` configuration as documented in `knowledge/da-agent-hub/development/setup.md`.

## Troubleshooting

### Container Won't Build
- Ensure Docker Desktop is running
- Check you have enough disk space (~2GB for container)

### Authentication Issues
- Run `gh auth login` again
- For Claude Code: `claude auth --refresh`

### Scripts Not Executable
```bash
chmod +x scripts/*.sh
```

## Customization

To modify the devcontainer:
1. Edit `.devcontainer/devcontainer.json`
2. Rebuild container: `Cmd/Ctrl + Shift + P` → "Dev Containers: Rebuild Container"

See [VS Code devcontainer docs](https://code.visualstudio.com/docs/devcontainers/containers) for more options.
