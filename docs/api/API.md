# MCP Neovim Listen Server - Complete API Reference

## Overview

The MCP Neovim Listen Server provides a comprehensive set of tools for controlling Neovim instances, managing configurations, orchestrating multiple editors, and integrating with development environments through the Model Context Protocol (MCP).

## Table of Contents

- [Core Concepts](#core-concepts)
- [Tool Categories](#tool-categories)
- [API Reference](#api-reference)
  - [Neovim Connection Tools](#neovim-connection-tools)
  - [Terminal & Environment Tools](#terminal--environment-tools)
  - [Configuration Management Tools](#configuration-management-tools)
  - [Plugin Management Tools](#plugin-management-tools)
  - [Orchestra Tools](#orchestra-tools)
  - [Session Management Tools](#session-management-tools)
  - [Keybinding Management Tools](#keybinding-management-tools)
  - [System Health Tools](#system-health-tools)
- [Error Handling](#error-handling)
- [Response Formats](#response-formats)
- [Rate Limiting & Performance](#rate-limiting--performance)

## Core Concepts

### Port Convention

The server uses a standardized port convention for different Neovim instances:

| Port | Purpose | Description |
|------|---------|-------------|
| 7001 | Main Editor | Primary development workspace |
| 7002 | Navigator | File browsing and search operations |
| 7003 | Reference | Documentation and reference viewing |
| 7004 | Extra | Additional instance for specific tasks |
| 7777 | Broadcast | Log viewing and status monitoring |
| 7778-7779 | Orchestra | Multi-instance coordination |

### Environment Layouts

- **Enhanced**: 9-pane layout with specialized tools
- **Minimal**: Single Neovim instance with terminal
- **Orchestra**: Multiple coordinated instances

## Tool Categories

1. **Neovim Connection**: Direct control of Neovim instances
2. **Terminal & Environment**: Terminal execution and environment management
3. **Configuration Management**: Read/write Neovim configurations
4. **Plugin Management**: Install, update, remove plugins
5. **Orchestra**: Multi-instance coordination
6. **Session Management**: Save and restore editing sessions
7. **Keybinding Management**: View and manage key mappings
8. **System Health**: Diagnostic and health checks

## API Reference

### Neovim Connection Tools

#### `neovim-connect`

Send commands directly to a Neovim instance.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| port | number | No | 7001 | Neovim instance port |
| command | string | Yes | - | Neovim command to execute |

**Example Request:**
```javascript
{
  "tool": "neovim-connect",
  "arguments": {
    "port": 7001,
    "command": ":vsplit README.md<CR>"
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Command executed successfully"
  }]
}
```

**Common Commands:**
- `:w<CR>` - Save current buffer
- `:q<CR>` - Quit current window
- `:vsplit file.txt<CR>` - Open file in vertical split
- `:Telescope find_files<CR>` - Open file finder
- `gg=G` - Format entire file

#### `neovim-open-file`

Open a file in a specific Neovim instance with optional line navigation.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| port | number | No | 7001 | Neovim instance port |
| filepath | string | Yes | - | Absolute or relative file path |
| line | number | No | - | Line number to jump to |

**Example Request:**
```javascript
{
  "tool": "neovim-open-file",
  "arguments": {
    "port": 7001,
    "filepath": "/src/components/Button.jsx",
    "line": 42
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Opened /src/components/Button.jsx at line 42"
  }]
}
```

### Terminal & Environment Tools

#### `terminal-execute`

Execute commands in the visible terminal pane using Zellij integration.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| command | string | Yes | - | Shell command to execute |

**Example Request:**
```javascript
{
  "tool": "terminal-execute",
  "arguments": {
    "command": "npm test -- --watch"
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Command executed in terminal pane"
  }]
}
```

**Note:** Commands are visible to the user in the terminal pane.

#### `command-palette`

Open an interactive command palette using fzf for quick command execution.

**Parameters:** None

**Example Request:**
```javascript
{
  "tool": "command-palette",
  "arguments": {}
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Command palette opened. User can now select commands interactively."
  }]
}
```

#### `project-switcher`

Navigate between projects using an interactive fuzzy finder.

**Parameters:** None

**Example Request:**
```javascript
{
  "tool": "project-switcher",
  "arguments": {}
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Project switcher opened. User can navigate between projects."
  }]
}
```

#### `start-environment`

Start the Claude development environment with specified layout.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| layout | string | No | "enhanced" | Layout type: "enhanced", "minimal", "orchestra" |

**Example Request:**
```javascript
{
  "tool": "start-environment",
  "arguments": {
    "layout": "orchestra"
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Started orchestra environment with 3 Neovim instances"
  }]
}
```

### Configuration Management Tools

#### `get-nvim-config`

Retrieve Neovim configuration files.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| configType | string | No | "all" | Config type: "init", "plugins", "mappings", "options", "all" |
| filePath | string | No | - | Specific file path to read |

**Example Request:**
```javascript
{
  "tool": "get-nvim-config",
  "arguments": {
    "configType": "plugins"
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "-- Plugin configuration\nreturn {\n  {\n    'nvim-telescope/telescope.nvim',\n    dependencies = { 'nvim-lua/plenary.nvim' },\n    config = function()\n      require('telescope').setup({})\n    end\n  }\n}"
  }]
}
```

#### `set-nvim-config`

Update Neovim configuration files with automatic backup.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| configType | string | Yes | - | Config type: "init", "plugins", "mappings", "options" |
| content | string | Yes | - | New configuration content |
| filePath | string | No | - | Specific file path to update |
| backup | boolean | No | true | Create backup before updating |

**Example Request:**
```javascript
{
  "tool": "set-nvim-config",
  "arguments": {
    "configType": "mappings",
    "content": "-- Leader mappings\nvim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')\nvim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')",
    "backup": true
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Configuration updated successfully. Backup created at ~/.config/nvim/mappings.lua.backup"
  }]
}
```

### Plugin Management Tools

#### `list-plugins`

List all installed Neovim plugins with optional filtering.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| filter | string | No | - | Filter plugins by name or category |
| includeConfig | boolean | No | false | Include plugin configuration details |

**Example Request:**
```javascript
{
  "tool": "list-plugins",
  "arguments": {
    "filter": "telescope",
    "includeConfig": true
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Found 3 plugins matching 'telescope':\n\n1. telescope.nvim - Fuzzy finder\n   Status: Loaded\n   Config: { dependencies = { 'plenary.nvim' } }\n\n2. telescope-fzf-native.nvim - FZF sorter\n   Status: Loaded\n\n3. telescope-ui-select.nvim - UI selector\n   Status: Loaded"
  }]
}
```

#### `manage-plugin`

Install, update, or remove Neovim plugins.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| action | string | Yes | - | Action: "install", "update", "remove", "sync" |
| pluginName | string | No* | - | Plugin name/URL (required for install/remove) |
| config | string | No | - | Plugin configuration (for install) |

**Example Request:**
```javascript
{
  "tool": "manage-plugin",
  "arguments": {
    "action": "install",
    "pluginName": "folke/trouble.nvim",
    "config": "{ dependencies = { 'nvim-tree/nvim-web-devicons' } }"
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Plugin 'folke/trouble.nvim' installed successfully"
  }]
}
```

### Orchestra Tools

#### `run-orchestra`

Start nvim-orchestra for multi-instance coordination.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| mode | string | No | "full" | Mode: "full", "solo", "dual", "dev", "jupyter", "performance" |
| ports | array | No | [7777, 7778, 7779] | Custom ports for instances |

**Orchestra Modes:**
- **full**: 3 instances for comprehensive development
- **solo**: Single enhanced instance
- **dual**: 2 instances for paired work
- **dev**: Development-focused setup
- **jupyter**: Jupyter notebook integration
- **performance**: Optimized for large files

**Example Request:**
```javascript
{
  "tool": "run-orchestra",
  "arguments": {
    "mode": "dual",
    "ports": [8001, 8002]
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Orchestra started in dual mode on ports 8001, 8002"
  }]
}
```

#### `broadcast-message`

Send messages to all running Neovim instances.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| message | string | Yes | - | Message to broadcast |
| messageType | string | No | "info" | Type: "info", "warning", "error", "command" |

**Example Request:**
```javascript
{
  "tool": "broadcast-message",
  "arguments": {
    "message": "Starting code review - please save all changes",
    "messageType": "warning"
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Message broadcast to 3 instances"
  }]
}
```

### Session Management Tools

#### `manage-session`

Create, restore, list, or delete Neovim sessions.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| action | string | Yes | - | Action: "create", "restore", "list", "delete" |
| sessionName | string | No* | - | Session name (required for create/restore/delete) |

**Example Requests:**

Create session:
```javascript
{
  "tool": "manage-session",
  "arguments": {
    "action": "create",
    "sessionName": "feature-auth"
  }
}
```

List sessions:
```javascript
{
  "tool": "manage-session",
  "arguments": {
    "action": "list"
  }
}
```

**Example Response (list):**
```javascript
{
  "content": [{
    "type": "text",
    "text": "Available sessions:\n1. feature-auth (created: 2024-01-15)\n2. bugfix-ui (created: 2024-01-14)\n3. refactor-api (created: 2024-01-13)"
  }]
}
```

### Keybinding Management Tools

#### `get-keybindings`

Retrieve current keybinding mappings with documentation.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| mode | string | No | "all" | Vim mode: "normal", "insert", "visual", "command", "all" |
| plugin | string | No | - | Filter by specific plugin |
| format | string | No | "json" | Output format: "json", "markdown", "table" |

**Example Request:**
```javascript
{
  "tool": "get-keybindings",
  "arguments": {
    "mode": "normal",
    "plugin": "telescope",
    "format": "markdown"
  }
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "# Telescope Keybindings (Normal Mode)\n\n| Key | Command | Description |\n|-----|---------|-------------|\n| `<leader>ff` | `:Telescope find_files` | Find files |\n| `<leader>fg` | `:Telescope live_grep` | Search in files |\n| `<leader>fb` | `:Telescope buffers` | List buffers |"
  }]
}
```

### System Health Tools

#### `health-check`

Perform comprehensive system health check.

**Parameters:** None

**Example Request:**
```javascript
{
  "tool": "health-check",
  "arguments": {}
}
```

**Example Response:**
```javascript
{
  "content": [{
    "type": "text",
    "text": "System Health Report\n\nRequired Dependencies:\n✓ Node.js 18.0+ (found: 20.5.0)\n✓ Neovim 0.9+ (found: 0.10.0)\n✓ Python 3 (found: 3.11.5)\n✓ pynvim (installed)\n\nOptional Dependencies:\n✓ Zellij (found: 0.39.0)\n✗ tmux (not found)\n✓ fzf (found: 0.45.0)\n✓ ripgrep (found: 14.0.0)\n\nConfiguration:\n✓ ~/.config/nvim exists\n✓ MCP server configured\n\nRunning Services:\n✓ Neovim on port 7001\n✗ Neovim on port 7002 (not running)\n\nRecommendations:\n- Install tmux for alternative terminal multiplexing\n- Start Neovim on port 7002 for navigator functionality"
  }]
}
```

## Error Handling

All tools return errors in a consistent format:

```javascript
{
  "content": [{
    "type": "text",
    "text": "Error executing [tool-name]: [error message]"
  }],
  "isError": true
}
```

### Common Error Codes

| Error | Description | Resolution |
|-------|-------------|------------|
| `ECONNREFUSED` | Neovim instance not running | Start Neovim on the specified port |
| `ENOENT` | File not found | Verify file path exists |
| `EACCES` | Permission denied | Check file permissions |
| `TIMEOUT` | Command timed out | Increase timeout or simplify command |
| `INVALID_PARAM` | Invalid parameter | Check parameter types and values |

## Response Formats

### Success Response
```javascript
{
  "content": [{
    "type": "text",
    "text": "Success message with details"
  }]
}
```

### Error Response
```javascript
{
  "content": [{
    "type": "text",
    "text": "Error message with details"
  }],
  "isError": true
}
```

### Multi-part Response
```javascript
{
  "content": [
    {
      "type": "text",
      "text": "Part 1 of response"
    },
    {
      "type": "text",
      "text": "Part 2 of response"
    }
  ]
}
```

## Rate Limiting & Performance

### Guidelines

1. **Command Batching**: Group related commands when possible
2. **Port Reuse**: Stick to established port conventions
3. **Session Management**: Create sessions before major operations
4. **Error Recovery**: Implement retry logic for transient failures

### Performance Tips

- Use `broadcast-message` for multi-instance operations
- Cache configuration reads when possible
- Avoid rapid successive commands to the same instance
- Use appropriate timeouts for long-running operations

### Resource Limits

- Maximum concurrent Neovim instances: 10
- Command timeout: 30 seconds (configurable)
- Maximum file size for config operations: 10MB
- Session name length: 255 characters

## Examples

### Complete Workflow Example

```javascript
// 1. Start environment
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

// 2. Open main file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/src/app.js"
});

// 3. Open reference in navigator
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "/docs/api.md"
});

// 4. Create session before changes
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "refactor-2024-01-15"
});

// 5. Run tests in terminal
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});

// 6. Search for function usage
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope grep_string<CR>"
});
```

### Multi-Instance Coordination

```javascript
// Start orchestra
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full"
});

// Open different files in each instance
const files = ["model.js", "view.js", "controller.js"];
const ports = [7777, 7778, 7779];

for (let i = 0; i < files.length; i++) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": ports[i],
    "filepath": `/src/${files[i]}`
  });
}

// Broadcast format command
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "gg=G",
  "messageType": "command"
});
```