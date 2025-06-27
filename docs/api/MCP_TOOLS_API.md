# MCP Server Neovim Listen - Complete API Documentation

## Overview

The MCP Server Neovim Listen provides comprehensive control over Neovim instances, terminal environments, and development workflows. This document provides detailed API documentation for all available MCP tools.

## Table of Contents

1. [Neovim Connection Tools](#neovim-connection-tools)
2. [Terminal & Environment Tools](#terminal--environment-tools)
3. [Configuration Management Tools](#configuration-management-tools)
4. [Plugin Management Tools](#plugin-management-tools)
5. [Orchestra Tools](#orchestra-tools)
6. [Keybinding Management](#keybinding-management)
7. [Session Management](#session-management)
8. [Health Check](#health-check)

---

## Neovim Connection Tools

### `neovim-connect`

Connect to a running Neovim instance and execute commands.

**Parameters:**
- `port` (number, optional): Port number to connect to. Default: 7001
  - Common ports: 7001 (main editor), 7002 (navigator), 7777 (broadcast)
- `command` (string, required): Neovim command to execute
  - Must include proper escaping and `<CR>` for command execution

**Returns:** Confirmation message indicating command was sent

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope find_files<CR>"
});
```

**Common Commands:**
- `:w<CR>` - Save current file
- `:wa<CR>` - Save all files
- `:q<CR>` - Quit current buffer
- `:vsplit<CR>` - Vertical split
- `:Telescope live_grep<CR>` - Search in files
- `gg=G` - Format entire file
- `:set number<CR>` - Show line numbers

### `neovim-open-file`

Open a file in a specific Neovim instance with optional line navigation.

**Parameters:**
- `port` (number, optional): Port number to connect to. Default: 7001
- `filepath` (string, required): Absolute or relative path to the file
- `line` (number, optional): Line number to jump to after opening

**Returns:** Confirmation message with file and line details

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/src/main.js",
  "line": 42
});
```

---

## Terminal & Environment Tools

### `terminal-execute`

Execute commands in the visible terminal pane through the Zellij bridge.

**Parameters:**
- `command` (string, required): Shell command to execute

**Returns:** Command execution output or confirmation

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});
```

**Features:**
- Commands are visible to the user in real-time
- Output is captured and logged
- Commands are recorded in history pane
- Supports all shell commands and features

### `command-palette`

Open an interactive command palette powered by fzf for quick command selection.

**Parameters:** None

**Returns:** Selected command result or confirmation

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "command-palette", {});
```

**Available Commands in Palette:**
- File operations (open, save, close)
- Search functions (grep, find files)
- Git commands
- Plugin management
- Configuration options

### `project-switcher`

Navigate between different projects using an interactive selector.

**Parameters:** None

**Returns:** Selected project information or confirmation

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "project-switcher", {});
```

### `start-environment`

Start the Claude development environment with Zellij layouts.

**Parameters:**
- `layout` (string, optional): Layout type to use. Default: "enhanced"
  - `"enhanced"`: Full environment with terminals, file browser, git status
  - `"minimal"`: Basic setup with editor and terminal
  - `"orchestra"`: Multi-instance setup for complex workflows

**Returns:** Environment startup confirmation

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});
```

---

## Configuration Management Tools

### `get-nvim-config`

Retrieve Neovim configuration files and settings.

**Parameters:**
- `configType` (string, optional): Type of configuration to retrieve
  - `"init"`: Main init.lua configuration
  - `"plugins"`: Plugin configurations
  - `"mappings"`: Keybinding configurations
  - `"options"`: Neovim options and settings
  - `"all"`: All configuration files
- `filePath` (string, optional): Specific file path to retrieve

**Returns:** Configuration content as text

**Example:**
```javascript
const config = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "plugins"
});
```

### `set-nvim-config`

Update Neovim configuration files with automatic backup.

**Parameters:**
- `configType` (string, required): Type of configuration to update
  - `"init"`, `"plugins"`, `"mappings"`, `"options"`
- `content` (string, required): New configuration content
- `filePath` (string, optional): Specific file path to update
- `backup` (boolean, optional): Create backup before updating. Default: true

**Returns:** Update confirmation with backup details

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "mappings",
  "content": "vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')",
  "backup": true
});
```

---

## Plugin Management Tools

### `list-plugins`

List all installed Neovim plugins with their status and configuration.

**Parameters:**
- `filter` (string, optional): Filter plugins by name or category
- `includeConfig` (boolean, optional): Include plugin configuration details. Default: false

**Returns:** List of plugins with details

**Example:**
```javascript
const plugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "filter": "telescope",
  "includeConfig": true
});
```

### `manage-plugin`

Install, update, or remove Neovim plugins.

**Parameters:**
- `action` (string, required): Action to perform
  - `"install"`: Install a new plugin
  - `"update"`: Update specific plugin
  - `"remove"`: Remove a plugin
  - `"sync"`: Sync all plugins (update + clean)
- `pluginName` (string, optional): Plugin name or GitHub URL (required for install/update/remove)
- `config` (string, optional): Plugin configuration for installation

**Returns:** Action result and plugin status

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "nvim-treesitter/nvim-treesitter",
  "config": "{ build = ':TSUpdate' }"
});
```

---

## Orchestra Tools

### `run-orchestra`

Launch multiple coordinated Neovim instances for complex workflows.

**Parameters:**
- `mode` (string, optional): Orchestra mode. Default: "full"
  - `"full"`: Three instances (7777, 7778, 7779)
  - `"solo"`: Single instance (7777)
  - `"dual"`: Two instances (7777, 7778)
  - `"dev"`: Development setup with specific configurations
  - `"jupyter"`: Jupyter notebook integration
  - `"performance"`: Performance monitoring setup
- `ports` (array of numbers, optional): Custom ports to use. Default: [7777, 7778, 7779]

**Returns:** Orchestra startup confirmation with port details

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "dual",
  "ports": [8001, 8002]
});
```

### `broadcast-message`

Send messages to all running Neovim instances simultaneously.

**Parameters:**
- `message` (string, required): Message content to broadcast
- `messageType` (string, optional): Type of message. Default: "info"
  - `"info"`: Informational message
  - `"warning"`: Warning message
  - `"error"`: Error message
  - `"command"`: Neovim command to execute

**Returns:** Broadcast confirmation

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Starting code review process",
  "messageType": "info"
});
```

---

## Keybinding Management

### `get-keybindings`

Retrieve keybinding documentation and current mappings.

**Parameters:**
- `mode` (string, optional): Vim mode for keybindings. Default: "all"
  - `"normal"`, `"insert"`, `"visual"`, `"command"`, `"all"`
- `plugin` (string, optional): Filter by specific plugin
- `format` (string, optional): Output format. Default: "json"
  - `"json"`: Structured JSON format
  - `"markdown"`: Formatted markdown documentation
  - `"table"`: ASCII table format

**Returns:** Keybinding information in requested format

**Example:**
```javascript
const keybindings = await use_mcp_tool("nvimlisten", "get-keybindings", {
  "mode": "normal",
  "plugin": "telescope",
  "format": "markdown"
});
```

---

## Session Management

### `manage-session`

Create, restore, or manage Neovim sessions for workspace persistence.

**Parameters:**
- `action` (string, required): Session action
  - `"create"`: Create new session
  - `"restore"`: Restore existing session
  - `"list"`: List all sessions
  - `"delete"`: Delete a session
- `sessionName` (string, optional): Name of the session (required for create/restore/delete)

**Returns:** Session operation result

**Example:**
```javascript
// Create session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "project-refactor"
});

// List sessions
const sessions = await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "list"
});

// Restore session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "restore",
  "sessionName": "project-refactor"
});
```

---

## Health Check

### `health-check`

Check system health, dependencies, and configuration status.

**Parameters:** None

**Returns:** Comprehensive health report including:
- Dependency status (required and optional tools)
- Neovim version and configuration
- Plugin status
- Active instances
- System resources

**Example:**
```javascript
const health = await use_mcp_tool("nvimlisten", "health-check", {});
```

---

## Error Handling

All tools follow consistent error handling patterns:

1. **Connection Errors**: When Neovim instance is not running
   - Solution: Start the environment or check port availability

2. **Command Errors**: Invalid commands or syntax
   - Solution: Verify command syntax and escaping

3. **Permission Errors**: File access or modification issues
   - Solution: Check file permissions and paths

4. **Dependency Errors**: Missing required tools
   - Solution: Install missing dependencies

**Error Response Format:**
```javascript
{
  "error": {
    "code": "ErrorCode",
    "message": "Detailed error description"
  }
}
```

---

## Best Practices

1. **Port Usage**:
   - 7001: Primary editor for main work
   - 7002: Secondary editor for references
   - 7777: Broadcast instance for status/logs

2. **Command Execution**:
   - Always include `<CR>` for Ex commands
   - Properly escape special characters
   - Use normal mode commands without `<CR>`

3. **Session Management**:
   - Create sessions before major changes
   - Name sessions descriptively
   - Clean up old sessions regularly

4. **Performance**:
   - Use broadcast for status updates
   - Batch operations when possible
   - Monitor resource usage with health-check

5. **Error Recovery**:
   - Always check instance availability
   - Implement retry logic for transient failures
   - Use health-check for diagnostics