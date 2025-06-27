# MCP Neovim Listen Server - Tutorial

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Basic Operations](#basic-operations)
4. [Intermediate Workflows](#intermediate-workflows)
5. [Advanced Techniques](#advanced-techniques)
6. [Real-World Scenarios](#real-world-scenarios)
7. [Tips and Best Practices](#tips-and-best-practices)

## Introduction

This tutorial will guide you through using the MCP Neovim Listen Server, from basic file editing to advanced multi-instance orchestration. Each section builds upon the previous one, so it's recommended to follow along in order.

### Prerequisites

Before starting, ensure you have:
- MCP Neovim Listen Server installed and configured
- Basic familiarity with Neovim commands
- Claude Code with MCP support

## Getting Started

### Step 1: Starting Your First Environment

Let's begin by starting the enhanced development environment:

```javascript
// Start the enhanced environment with all features
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});
```

This creates a 9-pane layout with:
- Main editor (port 7001)
- Navigator (port 7002)
- Broadcast pane (port 7777)
- Terminal with file listing
- Interactive file explorer
- Command history tracker
- Git status monitor

### Step 2: Verify the Setup

Check that Neovim instances are running:

```javascript
// Test connection to main editor
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'Hello from Main Editor!'<CR>"
});

// Test connection to navigator
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":echo 'Hello from Navigator!'<CR>"
});
```

### Step 3: Perform a Health Check

Ensure all dependencies are properly installed:

```javascript
await use_mcp_tool("nvimlisten", "health-check", {});
```

## Basic Operations

### Opening and Editing Files

#### Example 1: Open a Single File

```javascript
// Open a JavaScript file in the main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/src/components/Button.js",
  "line": 15  // Jump to line 15
});
```

#### Example 2: Split Windows

```javascript
// Open file in vertical split
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":vsplit /src/components/Input.js<CR>"
});

// Open file in horizontal split
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":split /src/styles/button.css<CR>"
});
```

### Using the Terminal

#### Example 3: Run Commands

```javascript
// Run npm install
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm install"
});

// Check git status
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git status"
});

// Run tests
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test -- --coverage"
});
```

### File Navigation

#### Example 4: Using Telescope

```javascript
// Find files by name
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope find_files<CR>"
});

// Search content in files
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope live_grep<CR>"
});

// Browse open buffers
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope buffers<CR>"
});
```

#### Example 5: Interactive Tools

```javascript
// Open command palette
await use_mcp_tool("nvimlisten", "command-palette", {});

// Switch between projects
await use_mcp_tool("nvimlisten", "project-switcher", {});
```

## Intermediate Workflows

### Configuration Management

#### Example 6: Reading Configuration

```javascript
// Get all configuration files
const allConfig = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "all"
});

// Get specific configuration
const plugins = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "plugins"
});

const mappings = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "mappings"
});
```

#### Example 7: Updating Configuration

```javascript
// Add new keybindings
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "mappings",
  "content": `-- Custom keybindings
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' })
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>xx', ':TroubleToggle<CR>', { desc = 'Toggle diagnostics' })`,
  "backup": true
});

// Reload configuration
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":source $MYVIMRC<CR>"
});
```

### Plugin Management

#### Example 8: Working with Plugins

```javascript
// List all plugins
const plugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "includeConfig": true
});

// Search for specific plugins
const telescopePlugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "filter": "telescope",
  "includeConfig": true
});

// Install a new plugin
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "folke/todo-comments.nvim",
  "config": `{
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end
  }`
});

// Update all plugins
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "sync"
});
```

### Session Management

#### Example 9: Working with Sessions

```javascript
// Create a session before starting work
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "feature-user-auth"
});

// List available sessions
const sessions = await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "list"
});

// Restore a previous session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "restore",
  "sessionName": "feature-user-auth"
});
```

## Advanced Techniques

### Multi-Instance Orchestration

#### Example 10: Starting Orchestra Mode

```javascript
// Start full orchestra with 3 instances
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full",
  "ports": [7777, 7778, 7779]
});

// Broadcast a welcome message
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Orchestra mode active - ready for multi-file editing",
  "messageType": "info"
});
```

#### Example 11: Coordinated Editing

```javascript
// Open related files in different instances
const mvc = {
  model: { port: 7777, file: "/src/models/User.js" },
  view: { port: 7778, file: "/src/views/UserProfile.jsx" },
  controller: { port: 7779, file: "/src/controllers/UserController.js" }
};

// Open each file
for (const [component, config] of Object.entries(mvc)) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": config.port,
    "filepath": config.file
  });
  
  // Add a comment identifying the component
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": config.port,
    "command": `ggO// ${component.toUpperCase()} Component<ESC>:w<CR>`
  });
}

// Format all files simultaneously
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "gg=G",
  "messageType": "command"
});
```

### Advanced Navigation Patterns

#### Example 12: Reference and Implementation

```javascript
// Open implementation in main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/src/services/AuthService.js"
});

// Open documentation in navigator
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "/docs/auth-api.md"
});

// Search for usage in main editor
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "/authenticate<CR>"
});

// Jump to corresponding section in docs
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": "/Authentication Flow<CR>"
});
```

### Keybinding Documentation

#### Example 13: Exploring Keybindings

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

// Get normal mode keybindings
const normalKeys = await use_mcp_tool("nvimlisten", "get-keybindings", {
  "mode": "normal",
  "format": "markdown"
});
```

## Real-World Scenarios

### Scenario 1: Code Review Workflow

```javascript
// 1. Start enhanced environment
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

// 2. Create a session for the review
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "code-review-pr-123"
});

// 3. Check out the PR branch
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git checkout feature/user-authentication"
});

// 4. Open the main changed file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/src/auth/login.js"
});

// 5. Open the test file in navigator
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "/tests/auth/login.test.js"
});

// 6. Run tests
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test -- login.test.js"
});

// 7. Search for TODO comments
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope grep_string search=TODO<CR>"
});

// 8. Add review comments
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "gg/function login<CR>O// REVIEW: Consider adding rate limiting here<ESC>:w<CR>"
});
```

### Scenario 2: Refactoring Workflow

```javascript
// 1. Start orchestra mode for multi-file refactoring
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full"
});

// 2. Create backup session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "refactor-backup-" + new Date().toISOString()
});

// 3. Open files to refactor
const filesToRefactor = [
  { port: 7777, file: "/src/utils/stringHelpers.js" },
  { port: 7778, file: "/src/components/TextInput.js" },
  { port: 7779, file: "/src/pages/ProfilePage.js" }
];

for (const { port, file } of filesToRefactor) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": port,
    "filepath": file
  });
}

// 4. Broadcast search for old function name
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "/formatString<CR>",
  "messageType": "command"
});

// 5. Perform replacement in all files
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":%s/formatString/formatText/gc<CR>",
  "messageType": "command"
});

// 6. Save all files
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":wa<CR>",
  "messageType": "command"
});

// 7. Run tests to verify
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});
```

### Scenario 3: Debugging Session

```javascript
// 1. Start environment
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

// 2. Open the problematic file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/src/api/userApi.js",
  "line": 45  // Error line from stack trace
});

// 3. Set up log monitoring in terminal
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "tail -f logs/app.log | grep ERROR"
});

// 4. Open related test file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "/tests/api/userApi.test.js"
});

// 5. Add debug logging
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "45GIconsole.log('DEBUG: userId =', userId);<ESC>:w<CR>"
});

// 6. Run specific test
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test -- --testNamePattern='should fetch user by id'"
});

// 7. Search for similar patterns
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope grep_string search=userId<CR>"
});
```

## Tips and Best Practices

### 1. Environment Management

**Always start with the right layout:**
- Use `enhanced` for full-featured development
- Use `minimal` for quick edits
- Use `orchestra` for multi-file operations

**Example:**
```javascript
// For complex development work
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

// For quick configuration changes
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "minimal"
});
```

### 2. Session Management

**Create sessions before major changes:**
```javascript
// Before refactoring
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "before-refactor-" + Date.now()
});

// Before experimenting with configuration
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "config-experiment"
});
```

### 3. Error Recovery

**Always implement error handling:**
```javascript
try {
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":echo 'Test connection'<CR>"
  });
} catch (error) {
  // Instance not running, restart environment
  await use_mcp_tool("nvimlisten", "start-environment", {
    "layout": "enhanced"
  });
}
```

### 4. Efficient Navigation

**Use the right tool for the job:**
- Telescope for fuzzy finding
- Navigator pane for reference material
- Command palette for quick commands
- Terminal for git operations

### 5. Configuration Best Practices

**Always backup before changes:**
```javascript
// Backup current config
const currentConfig = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "all"
});

// Make changes with backup enabled
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "plugins",
  "content": newPluginConfig,
  "backup": true
});
```

### 6. Performance Optimization

**Batch related operations:**
```javascript
// Instead of multiple individual commands
// Do this:
const commands = [
  ":set number",
  ":set relativenumber",
  ":set wrap",
  ":set cursorline"
];

await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": commands.join("<CR>") + "<CR>"
});
```

### 7. Multi-Instance Coordination

**Use broadcast for synchronized operations:**
```javascript
// Format all files at once
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "gg=G",
  "messageType": "command"
});

// Save all files
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":wa<CR>",
  "messageType": "command"
});
```

## Conclusion

This tutorial has covered the essential workflows and patterns for using the MCP Neovim Listen Server effectively. As you become more comfortable with these tools, you'll discover even more powerful ways to enhance your development workflow.

Remember:
- Start simple and build complexity gradually
- Use sessions to protect your work
- Leverage the multi-instance capabilities for complex tasks
- Keep your configurations backed up
- Explore the interactive tools for enhanced productivity

Happy coding with MCP Neovim Listen Server!