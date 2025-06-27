# Claude Integration Guide for MCP Neovim Listen Server

## Overview

This MCP server provides Claude with powerful Neovim control capabilities, enabling advanced text editing, code navigation, and development environment management. It combines the best features of terminal integration, multi-instance orchestration, and interactive development tools.

## ⚠️ IMPORTANT: Keybinding Policy

**DO NOT MODIFY OR REASSIGN ANY KEYBINDINGS**

The keybindings in this configuration have been carefully chosen to:
- Avoid conflicts with existing mappings
- Maintain consistency across different environments
- Work seamlessly with the MCP integration

When working with user configurations:
1. **NEVER** suggest changing existing keybindings
2. **NEVER** reassign keys to what you think might be "better"
3. **ALWAYS** respect the user's existing keybinding choices
4. If keybinding conflicts arise, ask the user for their preference

The only exception is when the user explicitly requests keybinding changes.

## Quick Start

### 1. Starting the Environment

To start the development environment:

```javascript
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"  // Options: "enhanced", "minimal", "orchestra"
});
```

### 2. Basic Neovim Operations

#### Opening Files
```javascript
// Open a file in the main editor (port 7001)
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/file.js",
  "line": 10  // Optional: jump to line
});

// Open in navigator pane (port 7002)
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "/path/to/reference.md"
});
```

#### Executing Neovim Commands
```javascript
// Search in files
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope live_grep<CR>"
});

// Save all buffers
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":wa<CR>"
});
```

### 3. Terminal Integration

Execute commands in the visible terminal:

```javascript
// Run tests
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});

// Git operations
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git status"
});
```

### 4. Interactive Tools

#### Command Palette
```javascript
// Open interactive command palette
await use_mcp_tool("nvimlisten", "command-palette", {});
```

#### Project Switcher
```javascript
// Navigate between projects
await use_mcp_tool("nvimlisten", "project-switcher", {});
```

## Advanced Features

### Configuration Management

#### Reading Configuration
```javascript
// Get all configurations
const config = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "all"
});

// Get specific config
const plugins = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "plugins"
});
```

#### Updating Configuration
```javascript
// Update keybindings
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "mappings",
  "content": `-- Leader key mappings
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')`,
  "backup": true
});
```

### Plugin Management

#### List Plugins
```javascript
const plugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "includeConfig": true,
  "filter": "telescope"
});
```

#### Manage Plugins
```javascript
// Install a plugin
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "nvim-treesitter/nvim-treesitter",
  "config": "{ build = ':TSUpdate' }"
});

// Update all plugins
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "sync"
});
```

### Orchestra Mode

#### Starting Orchestra
```javascript
// Start full orchestra (3 instances)
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full",
  "ports": [7777, 7778, 7779]
});

// Start dual setup
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "dual",
  "ports": [7777, 7778]
});
```

#### Broadcasting Messages
```javascript
// Send info to all instances
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Starting code review",
  "messageType": "info"
});

// Send command to all
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":source $MYVIMRC",
  "messageType": "command"
});
```

### Session Management

```javascript
// Create a session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "project-review"
});

// List sessions
const sessions = await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "list"
});

// Restore session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "restore",
  "sessionName": "project-review"
});
```

### Keybinding Management

```javascript
// Get all keybindings as markdown
const keybindings = await use_mcp_tool("nvimlisten", "get-keybindings", {
  "mode": "all",
  "format": "markdown"
});

// Get plugin-specific keybindings
const telescopeKeys = await use_mcp_tool("nvimlisten", "get-keybindings", {
  "plugin": "telescope",
  "format": "table"
});
```

## Best Practices

### 1. Environment Layout
- **Port 7001**: Main editor (primary work)
- **Port 7002**: Navigator (file browsing, references)  
- **Port 7777**: Broadcast (status, logs)
- **Pane 5**: Terminal with lsd - shows files on startup
- **Pane 6**: Interactive file explorer - fzf with bat preview
- **Pane 8**: Command history - tracks all executed commands
- **Pane 9**: Git status - auto-updates every 2 seconds

### 2. Workflow Patterns

#### Code Review Pattern
```javascript
// 1. Open file in main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/main.js"
});

// 2. Open reference in navigator
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "docs/api.md"
});

// 3. Search for usage
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope grep_string<CR>"
});
```

#### Refactoring Pattern
```javascript
// 1. Create session before starting
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "refactor-backup"
});

// 2. Open files to refactor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/components/Button.jsx"
});

// 3. Make changes and save
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":%s/oldFunction/newFunction/gc<CR>"
});
```

### 3. Error Handling

Always check if Neovim instances are running:

```javascript
try {
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":echo 'Connected'<CR>"
  });
} catch (error) {
  // Instance not running, start environment
  await use_mcp_tool("nvimlisten", "start-environment", {
    "layout": "enhanced"
  });
}
```

## Troubleshooting

### Common Issues

1. **Neovim not responding**: Check if the instance is running on the expected port
2. **Commands not executing**: Ensure proper escaping of special characters
3. **Terminal bridge not working**: Verify Zellij is installed and running

### Debug Commands

```javascript
// Check Neovim version
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":version<CR>"
});

// List buffers
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":ls<CR>"
});

// Check current file
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo expand('%:p')<CR>"
});
```

## Advanced Orchestration

### Multi-File Editing
```javascript
// Open related files in different instances
const files = ["model.js", "controller.js", "view.js"];
const ports = [7777, 7778, 7779];

for (let i = 0; i < files.length; i++) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": ports[i],
    "filepath": `src/${files[i]}`
  });
}

// Broadcast format command to all
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "gg=G",  // Format entire file
  "messageType": "command"
});
```

## Integration Tips

1. **Use broadcast pane for status**: Send progress updates to port 7777
2. **Leverage file explorer (Pane 6)**: Interactive browsing with preview
   - Navigate directories with arrow keys
   - Preview files with syntax highlighting
   - Press Enter to select/navigate
   - Ctrl+C to exit browser
3. **Monitor terminal output**: Pane 5 shows `lsd` output by default
4. **Session management**: Always create sessions before major changes
5. **Terminal visibility**: Commands executed via terminal-execute are visible to users
6. **Command history**: All executed commands appear in Pane 8

Remember: This server is designed to make Claude's interaction with Neovim seamless and powerful. Use these tools to provide an enhanced development experience!