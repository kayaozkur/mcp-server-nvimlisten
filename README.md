# MCP Server for Neovim Listen

A powerful Model Context Protocol (MCP) server that provides comprehensive Neovim integration for Claude Code. This server combines the functionality of both `mcp-server-nvimlisten` and `mcp-server-nvim` to offer advanced Neovim control, orchestration, and development environment management.

## 🚀 Part of the Extended MCP Ecosystem

This server is now part of an expanded ecosystem of **16 MCP servers** that work together to provide Claude with unprecedented capabilities:

- **7 New Servers Added**: Enhanced time operations, HTTP requests, persistent memory, sequential thinking, ultra-fast search, web scraping, and remote function calls
- **Seamless Integration**: All servers work together to enable complex workflows
- **Comprehensive Documentation**: See [MCP Ecosystem Guide](docs/MCP_ECOSYSTEM.md) and [New MCP Servers](docs/NEW_MCP_SERVERS.md)

With this expanded ecosystem, Claude can now handle everything from advanced development workflows to distributed system management, data pipelines, and intelligent automation.

## Documentation

### 📚 Comprehensive Guides

**[View All Documentation](docs/)** - Complete documentation index

#### Essential Guides
- **[Complete API Reference](docs/api/API.md)** - Detailed documentation of all available MCP tools
- **[Step-by-Step Tutorial](docs/getting-started/tutorial.md)** - Learn how to use the server effectively
- **[Troubleshooting Guide](docs/troubleshooting/TROUBLESHOOTING_GUIDE.md)** - Solutions to common issues

#### Quick References
- **[API Reference](docs/api/API%20Reference.md)** - Quick reference for all tools
- **[Setup Guide](docs/getting-started/Setup%20Guide.md)** - Detailed installation instructions
- **[Keybindings Reference](docs/reference/Keybindings%20Reference.md)** - Keyboard shortcuts
- **[Quick Reference](docs/reference/Quick%20Reference.md)** - Common commands

#### Advanced Topics
- **[Multi-Instance Guide](docs/advanced/Multi-Instance%20Guide.md)** - Advanced orchestration patterns
- **[Port Configuration](docs/reference/Port%20Configuration.md)** - Port usage and conventions
- **[Testing Guide](docs/guides/Testing%20Guide.md)** - How to test the server
- **[CLAUDE Integration](CLAUDE.md)** - Claude-specific features

## Features

### 🎯 Core Capabilities

- **Multi-Instance Neovim Control**: Connect to and control multiple Neovim instances running on different ports
- **Terminal Integration**: Execute commands in visible terminal panes using Zellij
- **Interactive Tools**: Command palette and project switcher with fzf integration
- **Configuration Management**: Read and update Neovim configurations programmatically
- **Plugin Management**: List, install, update, and remove Neovim plugins
- **Orchestra Mode**: Coordinate multiple Neovim instances for advanced workflows
- **Session Management**: Create, restore, and manage Neovim sessions
- **Keybinding Management**: View and update keybindings with documentation

### 🛠️ Available Tools

#### Neovim Connection Tools
- `neovim-connect`: Send commands to specific Neovim instances
- `neovim-open-file`: Open files in Neovim with optional line navigation

#### Terminal & Environment Tools
- `terminal-execute`: Execute commands in the visible terminal
- `command-palette`: Open interactive command palette with fzf
- `project-switcher`: Navigate between projects interactively
- `start-environment`: Launch the development environment

#### Configuration Management
- `get-nvim-config`: Retrieve Neovim configuration files
- `set-nvim-config`: Update Neovim configuration

#### Plugin Management
- `list-plugins`: List installed plugins with status
- `manage-plugin`: Install, update, or remove plugins

#### Orchestra Functions
- `run-orchestra`: Start multi-instance orchestration
- `broadcast-message`: Send messages to all instances

#### Session & Keybinding Management
- `manage-session`: Create and restore Neovim sessions
- `get-keybindings`: View current keybindings

## Installation

### Prerequisites

Required:
- Node.js 18+
- Neovim 0.9+

Optional (for full functionality):
- Zellij (terminal multiplexer)
- tmux (alternative to Zellij)
- Python 3 with pynvim
- fzf (fuzzy finder)
- ripgrep (rg)
- fd (find alternative)
- lsd (ls with icons)
- atuin (shell history)

### Install via npm

```bash
npm install -g @mcp/server-nvimlisten
```

### Install from source

```bash
git clone https://github.com/yourusername/mcp-server-nvimlisten
cd mcp-server-nvimlisten
npm install
npm run build
npm link
```

## Configuration

Add to your Claude Code MCP settings:

```json
{
  "mcpServers": {
    "nvimlisten": {
      "command": "mcp-server-nvimlisten",
      "args": []
    }
  }
}
```

## Quick Start

1. **Install the server**: `npm install -g @mcp/server-nvimlisten`
2. **Configure Claude Code** (add to MCP settings)
3. **Start the environment**:
   ```javascript
   await use_mcp_tool("nvimlisten", "start-environment", {
     "layout": "enhanced"
   });
   ```
4. **Open a file**:
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-open-file", {
     "port": 7001,
     "filepath": "your-file.js"
   });
   ```

For detailed instructions, see the [Tutorial](docs/TUTORIAL.md).

## Usage Examples

### Basic Neovim Control

```javascript
// Connect to Neovim and execute a command
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'Hello from Claude!'<CR>"
});

// Open a file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/file.js",
  "line": 42
});
```

### Terminal Execution

```javascript
// Execute command in visible terminal
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});
```

### Configuration Management

```javascript
// Get current configuration
await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "plugins"
});

// Update configuration
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "mappings",
  "content": "-- New keybindings\nvim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>')",
  "backup": true
});
```

### Orchestra Mode

```javascript
// Start full orchestra with 3 instances
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full",
  "ports": [7777, 7778, 7779]
});

// Broadcast to all instances
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Syncing all instances...",
  "messageType": "info"
});
```

## Development Environment Layouts

### Enhanced Layout (Default)
- 9 panes with specialized roles
- Main editor, navigator, and broadcast instances
- Integrated terminal with lsd file listing
- Interactive file explorer with fzf and preview
- Live command history and git status monitoring

### Orchestra Layout
- Multiple coordinated Neovim instances
- Synchronized editing across instances
- AI-powered orchestration

### Minimal Layout
- Single Neovim instance with terminal
- Lightweight for simple tasks

## Shell Scripts

The server includes several powerful shell scripts:

- `claude-terminal-bridge.sh`: Terminal command execution
- `claude-command-palette.sh`: Interactive command selection
- `claude-project-switcher.sh`: Project navigation
- `claude-dev-aliases.sh`: Useful shell aliases
- `start-claude-dev-enhanced.sh`: Environment launcher
- `ultimate-orchestra.sh`: Multi-instance orchestration

## Architecture

```
mcp-server-nvimlisten/
├── src/
│   ├── index.ts              # Main server entry
│   └── handlers/             # Tool handlers
│       ├── config-handler.ts
│       ├── plugin-handler.ts
│       ├── orchestra-handler.ts
│       ├── keybinding-handler.ts
│       └── session-handler.ts
├── scripts/                  # Shell scripts
├── templates/               # Config templates
└── package.json
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

## License

MIT

## Acknowledgments

This project combines the best features of:
- `mcp-server-nvimlisten` - Enhanced development environment
- `mcp-server-nvim` - Advanced Neovim control and orchestration

Special thanks to the Neovim and MCP communities for making this integration possible.