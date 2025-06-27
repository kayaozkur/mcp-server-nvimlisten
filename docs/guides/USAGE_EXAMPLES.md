# MCP Server Neovim Listen - Usage Examples & Code Snippets

This document provides practical examples and code snippets for common use cases with the MCP Server Neovim Listen.

## Table of Contents

1. [Getting Started](#getting-started)
2. [File Operations](#file-operations)
3. [Search and Navigation](#search-and-navigation)
4. [Code Editing Workflows](#code-editing-workflows)
5. [Terminal Integration](#terminal-integration)
6. [Multi-Instance Workflows](#multi-instance-workflows)
7. [Plugin Management](#plugin-management)
8. [Configuration Management](#configuration-management)
9. [Session Workflows](#session-workflows)
10. [Advanced Patterns](#advanced-patterns)

---

## Getting Started

### Basic Environment Setup

```javascript
// Start the enhanced development environment
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

// Verify connection to main editor
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'Connected to Neovim!'<CR>"
});

// Check system health
const health = await use_mcp_tool("nvimlisten", "health-check", {});
```

### First File Operations

```javascript
// Open a file in the main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/index.js"
});

// Save the file
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":w<CR>"
});
```

---

## File Operations

### Opening Multiple Files

```javascript
// Open main file in editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/components/Button.jsx"
});

// Open documentation in navigator pane
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7002,
  "filepath": "docs/components.md"
});

// Open test file in broadcast instance
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7777,
  "filepath": "tests/Button.test.jsx"
});
```

### File Navigation with Line Numbers

```javascript
// Jump to specific line in file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/utils/validation.js",
  "line": 45
});

// Go to function definition
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "gg/function validateEmail<CR>"
});
```

### Buffer Management

```javascript
// List all open buffers
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":ls<CR>"
});

// Switch between buffers
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":bnext<CR>"
});

// Close current buffer
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":bd<CR>"
});

// Save all open buffers
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":wa<CR>"
});
```

---

## Search and Navigation

### Using Telescope

```javascript
// Find files by name
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope find_files<CR>"
});

// Search for text in all files
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope live_grep<CR>"
});

// Search for word under cursor
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope grep_string<CR>"
});

// Browse git files
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope git_files<CR>"
});
```

### Quick Navigation

```javascript
// Go to definition
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "gd"
});

// Go to references
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "gr"
});

// Navigate to file explorer
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":NvimTreeToggle<CR>"
});
```

---

## Code Editing Workflows

### Refactoring Example

```javascript
// 1. Create a backup session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "pre-refactor-backup"
});

// 2. Open the file to refactor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "src/services/api.js"
});

// 3. Search and replace function name
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":%s/fetchData/fetchApiData/gc<CR>"
});

// 4. Format the file
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "gg=G"
});

// 5. Save changes
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":w<CR>"
});

// 6. Run tests to verify
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test src/services/api.test.js"
});
```

### Multi-Cursor Editing

```javascript
// Select all occurrences of a word
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "viw"  // Select word
});

// Add multiple cursors
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "<C-n>"  // Add next occurrence
});

// Change all occurrences
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "c"  // Change
});
```

### Code Formatting

```javascript
// Format entire file
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "gg=G"
});

// Format current paragraph
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": "=ap"
});

// Use LSP formatter
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":lua vim.lsp.buf.format()<CR>"
});
```

---

## Terminal Integration

### Running Commands

```javascript
// Run npm commands
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm install axios"
});

// Git operations
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git add -A && git commit -m 'Add new feature'"
});

// Run build process
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run build"
});

// Start development server
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm run dev"
});
```

### Interactive Terminal Usage

```javascript
// Clear terminal
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "clear"
});

// Check running processes
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "ps aux | grep node"
});

// Navigate directories
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "cd src && ls -la"
});
```

---

## Multi-Instance Workflows

### Code Review Setup

```javascript
// Start orchestra mode for code review
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full",
  "ports": [7777, 7778, 7779]
});

// Open current version in first instance
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7777,
  "filepath": "src/components/Header.jsx"
});

// Open previous version in second instance
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git show HEAD~1:src/components/Header.jsx > /tmp/header-old.jsx"
});

await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7778,
  "filepath": "/tmp/header-old.jsx"
});

// Open review notes in third instance
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7779,
  "filepath": "reviews/header-review.md"
});

// Broadcast start of review
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Starting code review for Header component",
  "messageType": "info"
});
```

### Parallel File Editing

```javascript
// Open related files in different instances
const files = [
  "src/models/User.js",
  "src/controllers/UserController.js",
  "src/views/UserView.jsx"
];

const ports = [7777, 7778, 7779];

// Open each file in its own instance
for (let i = 0; i < files.length; i++) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": ports[i],
    "filepath": files[i]
  });
}

// Apply formatting to all files
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "gg=G",
  "messageType": "command"
});

// Save all files
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": ":wa",
  "messageType": "command"
});
```

---

## Plugin Management

### Installing Plugins

```javascript
// Install a color scheme
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "folke/tokyonight.nvim",
  "config": "{ priority = 1000 }"
});

// Install file explorer
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "nvim-tree/nvim-tree.lua",
  "config": "{ disable_netrw = true }"
});

// Sync all plugins
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "sync"
});
```

### Plugin Discovery

```javascript
// List all plugins
const allPlugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "includeConfig": false
});

// Find specific plugins
const telescopePlugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "filter": "telescope",
  "includeConfig": true
});

// Check LSP plugins
const lspPlugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "filter": "lsp",
  "includeConfig": true
});
```

---

## Configuration Management

### Updating Keybindings

```javascript
// Get current keybindings
const currentBindings = await use_mcp_tool("nvimlisten", "get-keybindings", {
  "mode": "normal",
  "format": "json"
});

// Add new keybindings
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "mappings",
  "content": `-- Custom keybindings
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>')
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>')

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')`,
  "backup": true
});
```

### Managing Options

```javascript
// Update Neovim options
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "options",
  "content": `-- Editor options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true`,
  "backup": true
});
```

---

## Session Workflows

### Project-Based Sessions

```javascript
// Create session for feature development
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "create",
  "sessionName": "feature-user-auth"
});

// Work on files...

// List available sessions
const sessions = await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "list"
});

// Switch to different project
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "restore",
  "sessionName": "bugfix-payment"
});

// Clean up old session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "delete",
  "sessionName": "feature-user-auth-old"
});
```

---

## Advanced Patterns

### Automated Testing Workflow

```javascript
// Function to run tests when files change
async function runTestsOnSave(filepath) {
  // Save the file
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":w<CR>"
  });
  
  // Determine test file
  const testFile = filepath.replace('/src/', '/tests/').replace('.js', '.test.js');
  
  // Run tests
  await use_mcp_tool("nvimlisten", "terminal-execute", {
    "command": `npm test ${testFile}`
  });
  
  // Show results in broadcast pane
  await use_mcp_tool("nvimlisten", "broadcast-message", {
    "message": `Tests completed for ${filepath}`,
    "messageType": "info"
  });
}
```

### Git Integration Workflow

```javascript
// Function for git workflow
async function gitWorkflow(commitMessage) {
  // Check git status
  await use_mcp_tool("nvimlisten", "terminal-execute", {
    "command": "git status"
  });
  
  // Show diff in navigator
  await use_mcp_tool("nvimlisten", "terminal-execute", {
    "command": "git diff > /tmp/git-diff.txt"
  });
  
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": 7002,
    "filepath": "/tmp/git-diff.txt"
  });
  
  // Stage and commit
  await use_mcp_tool("nvimlisten", "terminal-execute", {
    "command": `git add -A && git commit -m "${commitMessage}"`
  });
  
  // Push to remote
  await use_mcp_tool("nvimlisten", "terminal-execute", {
    "command": "git push origin main"
  });
}
```

### Debugging Setup

```javascript
// Configure debugging environment
async function setupDebugging(language) {
  if (language === "javascript") {
    // Install DAP plugins
    await use_mcp_tool("nvimlisten", "manage-plugin", {
      "action": "install",
      "pluginName": "mfussenegger/nvim-dap"
    });
    
    // Configure breakpoints
    await use_mcp_tool("nvimlisten", "neovim-connect", {
      "port": 7001,
      "command": ":lua require('dap').toggle_breakpoint()<CR>"
    });
    
    // Start debugging
    await use_mcp_tool("nvimlisten", "neovim-connect", {
      "port": 7001,
      "command": ":lua require('dap').continue()<CR>"
    });
  }
}
```

### Performance Monitoring

```javascript
// Monitor and optimize performance
async function performanceCheck() {
  // Check health
  const health = await use_mcp_tool("nvimlisten", "health-check", {});
  
  // Profile startup time
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":StartupTime<CR>"
  });
  
  // Check plugin load times
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":Lazy profile<CR>"
  });
  
  // Broadcast results
  await use_mcp_tool("nvimlisten", "broadcast-message", {
    "message": "Performance check completed - see results above",
    "messageType": "info"
  });
}
```

---

## Tips and Tricks

1. **Quick Save All**: Use `:wa<CR>` to save all open buffers
2. **Format on Save**: Configure autocommands for automatic formatting
3. **Use Broadcast Pane**: Send status updates to port 7777 for visibility
4. **Session Names**: Use descriptive names like `feature-xyz` or `bugfix-123`
5. **Terminal History**: Commands are logged in the history pane (Pane 8)
6. **Git Status**: Pane 9 auto-updates every 2 seconds
7. **File Browser**: Pane 6 provides interactive file browsing with preview

Remember to check the health status regularly and keep your plugins updated for the best experience!