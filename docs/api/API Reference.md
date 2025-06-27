# API Reference - MCP Neovim Listen Server

## Table of Contents

1. [Neovim Connection Tools](#neovim-connection-tools)
2. [Terminal & Environment Tools](#terminal--environment-tools)
3. [Configuration Management](#configuration-management)
4. [Plugin Management](#plugin-management)
5. [Orchestra Functions](#orchestra-functions)
6. [Session & Keybinding Management](#session--keybinding-management)
7. [System Health Check](#system-health-check)

## Neovim Connection Tools

### `neovim-connect`

Send commands to a running Neovim instance.

**Parameters:**
- `port` (number, optional): Port number. Default: 7001
- `command` (string, required): Neovim command to execute

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":vsplit README.md<CR>"
});
```

### `neovim-open-file`

Open a file in a specific Neovim instance.

**Parameters:**
- `port` (number, optional): Port number. Default: 7001
- `filepath` (string, required): Path to the file to open
- `line` (number, optional): Line number to jump to

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/src/index.js",
  "line": 25
});
```

## Terminal & Environment Tools

### `terminal-execute`

Execute a command in the visible terminal pane.

**Parameters:**
- `command` (string, required): Command to execute

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git status"
});
```

### `command-palette`

Open the interactive command palette with fzf.

**Parameters:** None

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "command-palette", {});
```

### `project-switcher`

Navigate between projects interactively.

**Parameters:** None

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "project-switcher", {});
```

### `start-environment`

Start the Claude development environment.

**Parameters:**
- `layout` (string, optional): Layout type. Options: "enhanced", "minimal", "orchestra". Default: "enhanced"

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "orchestra"
});
```

## Configuration Management

### `get-nvim-config`

Retrieve Neovim configuration files.

**Parameters:**
- `configType` (string, optional): Type of configuration. Options: "init", "plugins", "mappings", "options", "all"
- `filePath` (string, optional): Specific file path to read

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "plugins"
});
```

### `set-nvim-config`

Update Neovim configuration files.

**Parameters:**
- `configType` (string, required): Type of configuration. Options: "init", "plugins", "mappings", "options"
- `content` (string, required): New configuration content
- `filePath` (string, optional): Specific file path to update
- `backup` (boolean, optional): Create backup before updating. Default: true

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "mappings",
  "content": "vim.keymap.set('n', '<leader>w', ':w<CR>')",
  "backup": true
});
```

## Plugin Management

### `list-plugins`

List all installed Neovim plugins.

**Parameters:**
- `filter` (string, optional): Filter plugins by name or category
- `includeConfig` (boolean, optional): Include plugin configuration details. Default: false

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "list-plugins", {
  "filter": "telescope",
  "includeConfig": true
});
```

### `manage-plugin`

Install, update, or remove plugins.

**Parameters:**
- `action` (string, required): Action to perform. Options: "install", "update", "remove", "sync"
- `pluginName` (string, optional): Name or URL of the plugin
- `config` (string, optional): Plugin configuration (for install)

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "nvim-telescope/telescope.nvim",
  "config": "{ dependencies = { 'nvim-lua/plenary.nvim' } }"
});
```

## Orchestra Functions

### `run-orchestra`

Start nvim-orchestra for multi-instance coordination.

**Parameters:**
- `mode` (string, optional): Orchestra mode. Options: "full", "solo", "dual", "dev", "jupyter", "performance". Default: "full"
- `ports` (array, optional): Custom ports to use. Default: [7777, 7778, 7779]

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "dual",
  "ports": [8001, 8002]
});
```

### `broadcast-message`

Send messages to all Neovim instances.

**Parameters:**
- `message` (string, required): Message to broadcast
- `messageType` (string, optional): Type of message. Options: "info", "warning", "error", "command". Default: "info"

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Code review started",
  "messageType": "info"
});
```

## Session & Keybinding Management

### `manage-session`

Create, restore, or manage Neovim sessions.

**Parameters:**
- `action` (string, required): Session action. Options: "create", "restore", "list", "delete"
- `sessionName` (string, optional): Name of the session (required for create/restore/delete)

**Example:**
```javascript
// Create session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "project-alpha"
});

// List sessions
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "list"
});
```

### `get-keybindings`

Retrieve keybinding documentation and mappings.

**Parameters:**
- `mode` (string, optional): Vim mode. Options: "normal", "insert", "visual", "command", "all". Default: "all"
- `plugin` (string, optional): Filter by specific plugin
- `format` (string, optional): Output format. Options: "json", "markdown", "table". Default: "json"

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "get-keybindings", {
  "mode": "normal",
  "format": "markdown"
});
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

## Best Practices

1. **Check Instance Availability**: Before sending commands, verify the Neovim instance is running
2. **Use Appropriate Ports**: Follow the port convention (7001 for main editor, 7002 for navigator, etc.)
3. **Handle Errors Gracefully**: Always wrap tool calls in try-catch blocks
4. **Create Sessions**: Before major changes, create a session for easy recovery
5. **Escape Special Characters**: Properly escape commands, especially those with quotes or backslashes

## System Health Check

### `health-check`

Check system health, dependencies, and configurations.

**Parameters:** None

**Example:**
```javascript
await use_mcp_tool("nvimlisten", "health-check", {});
```

**Returns:** A detailed health report including:
- Required dependencies status
- Optional dependencies status
- Configuration files presence
- Running services
- Recommendations for fixes

## Port Convention

- **7001**: Main editor (primary work)
- **7002**: Navigator (file browsing, search)
- **7003**: Reference/documentation viewer
- **7004**: Extra instance
- **7777**: Broadcast/logs
- **7778-7779**: Orchestra instances