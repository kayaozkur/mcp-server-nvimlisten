# MCP Neovim Listen Server - Complete Environment Notes

## 🏗️ Architecture Overview

### System Layers
```
┌─────────────────────────────────────────────────────────┐
│                  Layer 1: MCP Interface                  │
│         Claude Desktop with MCP Tool Access              │
├─────────────────────────────────────────────────────────┤
│              Layer 2: Orchestration Layer                │
│    Zellij Session with Enhanced Layout & Services       │
├─────────────────────────────────────────────────────────┤
│            Layer 3: Direct Terminal Access               │
│     Separate Claude Code Instances (s019, s023)         │
└─────────────────────────────────────────────────────────┘
```

### Directory Structure
```
/Users/kayaozkur/Desktop/lepion/mcp-repos/mcp-server-nvimlisten/
├── src/                    # TypeScript MCP server implementation
│   ├── index.ts           # Main server entry point
│   └── handlers/          # Tool implementations
│       ├── config-handler.ts
│       ├── health-handler.ts
│       ├── keybinding-handler.ts
│       ├── orchestra-handler.ts
│       ├── plugin-handler.ts
│       └── session-handler.ts
├── scripts/               # Shell scripts for automation
│   ├── start-claude-dev-enhanced.sh    # Main launcher
│   ├── claude-terminal-bridge.sh       # Terminal command injection
│   ├── claude-command-palette.sh       # Interactive tool menu
│   ├── claude-project-switcher.sh      # Project navigation
│   ├── nvim-broadcast.sh              # Multi-instance messaging
│   ├── ultimate-orchestra.sh          # Full orchestration
│   └── installers/                    # Setup scripts
├── templates/             # Configuration templates
│   ├── nvchad/           # NvChad configurations
│   ├── emacs/            # Emacs configurations
│   └── zellij/           # Zellij layouts
├── docs/                  # Documentation
│   ├── Multi-Instance Guide.md
│   └── Port Configuration.md
└── Test scripts
    ├── test_mcp_features.py
    ├── test_nvim_connection.py
    └── test_advanced_features.py
```

## 🚀 Enhanced Zellij Layout

### Claude-Dev-Enhanced Layout (9 Panes)
```
┌─────────────────────┬─────────────────────┬─────────────────────┐
│   main-editor       │    navigator        │   diff-viewer       │
│   nvim :7001        │    nvim :7002       │   nvim :7003        │
├─────────────────────├─────────────────────├─────────────────────┤
│   emacs             │  terminal-main      │ terminal-monitor    │
│ emacsclient -nw     │    (focus)          │     btop            │
├─────────────────────├─────────────────────├─────────────────────┤
│   broadcast         │  command-history    │   git-status        │
│   nvim :7777        │    nvim :7004       │  watch git status   │
└─────────────────────┴─────────────────────┴─────────────────────┘
```

### Port Assignments
- **7001**: Main editor (primary development)
- **7002**: Navigator (file browsing, references)
- **7003**: Diff viewer (git changes)
- **7004**: Command history logger
- **7777**: Broadcast log (multi-instance communication)

## 🛠️ Available MCP Tools

### Core Neovim Control
1. **neovim-connect** - Send commands to any instance
2. **neovim-open-file** - Open files with optional line numbers
3. **terminal-execute** - Execute commands in visible terminal
4. **command-palette** - Interactive tool selector
5. **project-switcher** - Navigate between projects
6. **start-environment** - Launch complete environment

### Configuration Management
1. **get-nvim-config** - Retrieve configurations (init, plugins, mappings, options)
2. **set-nvim-config** - Update configurations with backup
3. **list-plugins** - List all installed plugins
4. **manage-plugin** - Install/update/remove plugins

### Orchestration Tools
1. **run-orchestra** - Multi-instance coordination modes
2. **broadcast-message** - Send to all instances
3. **manage-session** - Create/restore/list sessions
4. **health-check** - System dependency verification

### Advanced Features
1. **get-keybindings** - Export keybinding documentation
2. **Terminal bridge** - Inject commands into visible terminal
3. **Command history logging** - Track all executed commands
4. **Git integration** - Auto-refreshing git status

## 📝 Key Scripts & Tools

### Terminal Bridge (`claude-terminal-bridge.sh`)
- Sends commands to visible terminal using Zellij actions
- Logs to command history (port 7004)
- Broadcasts execution to port 7777
- Persists to `/tmp/claude-commands.log`

### Command Palette (`claude-command-palette.sh`)
Interactive menu with:
- 🔍 File Explorer (lsd)
- 📜 Command History (atuin)
- 🔎 Fuzzy Find Files
- 📊 Directory Tree
- 🚀 Recent Projects
- 📝 Open in Editor
- 🔄 Git Operations
- 💻 System Info
- 🗂️ Yazi File Manager
- 🌐 Network Tools

### Broadcast System (`nvim-broadcast.sh`)
- Sends messages to all Neovim instances
- Logs to orchestra state
- Updates broadcast log (port 7777)

## 🔧 Environment Variables & Configuration

### Key Paths
```bash
CLAUDE_TERMINAL_BRIDGE="/Users/kayaozkur/Desktop/claude-terminal-bridge.sh"
CLAUDE_ALIASES="/Users/kayaozkur/Desktop/claude-dev-aliases.sh"
```

### Tool Dependencies
**Required:**
- nvim (Neovim)
- node (Node.js)
- npm

**Optional (Enhanced Features):**
- zellij (Terminal multiplexer)
- tmux (Alternative multiplexer)
- python3 (Testing & scripting)
- fzf (Fuzzy finder)
- rg (Ripgrep)
- fd (Fast find)
- lsd (Better ls)
- bat (Better cat)
- btop (System monitor)
- emacs (Alternative editor)
- atuin (Shell history)

## 🌟 Workflow Patterns

### Multi-File Editing
```javascript
// Open related files in different panes
const files = {
  7001: "src/main.ts",      // Main implementation
  7002: "src/tests.ts",     // Tests
  7003: "README.md"         // Documentation
};

for (const [port, file] of Object.entries(files)) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    port: parseInt(port),
    filepath: file
  });
}
```

### Command Execution with Logging
```javascript
// Execute and log command
await use_mcp_tool("nvimlisten", "terminal-execute", {
  command: "npm test"
});
// Command appears in:
// - Terminal (executes)
// - Port 7004 (command history)
// - Port 7777 (broadcast log)
// - /tmp/claude-commands.log (file)
```

### Project Navigation
```javascript
// Use project switcher
await use_mcp_tool("nvimlisten", "project-switcher", {});
// Or use command palette for interactive selection
```

## 🔍 Communication Patterns

### Inter-Instance Communication
1. **File-based**: Write to shared files
2. **Broadcast**: Use nvim-broadcast.sh
3. **Direct commands**: Send to specific ports
4. **Orchestra state**: Shared JSON state file

### Terminal Monitoring
- **btop**: System resources (CPU, memory, network)
- **git watch**: Auto-refreshing git status
- **Command history**: Real-time command logging

## 💡 Best Practices

### Development Flow
1. **Main editor (7001)**: Primary code editing
2. **Navigator (7002)**: Browse files, find references
3. **Diff viewer (7003)**: Review changes
4. **Terminal**: Run tests, build commands
5. **Monitor pane**: Watch system resources

### Session Management
- Sessions auto-save on exit
- Restore with `manage-session` tool
- Named sessions for different projects

### Plugin Management
- Use `list-plugins` to audit
- `manage-plugin` for updates
- Config backups before changes

## 🚨 Important Notes

1. **Process Management**: Scripts kill existing processes before starting
2. **Port Conflicts**: Check ports with `check-ports.sh`
3. **Logging**: Commands logged to multiple locations
4. **Performance**: Each Neovim instance uses ~30-50MB RAM
5. **Cleanup**: Processes cleaned up on exit

## 📊 Testing Infrastructure

### Python Test Scripts
- `test_mcp_features.py`: MCP protocol testing
- `test_nvim_connection.py`: Connection verification
- `test_advanced_features.py`: Complex workflows

### Msgpack-RPC Protocol
- Direct socket communication
- Binary protocol for speed
- Full Neovim API access

## 🎯 Advanced Capabilities

### Orchestra Modes
- **full**: All features enabled
- **solo**: Single instance focus
- **dual**: Two-instance setup
- **dev**: Development mode
- **jupyter**: Data science mode
- **performance**: Optimized setup

### Emacs Integration
- Daemon mode for speed
- Client connections
- Shared kill ring
- Org-mode support

---

*This environment represents a sophisticated development setup combining the power of Neovim, modern CLI tools, and Claude AI integration through MCP.*