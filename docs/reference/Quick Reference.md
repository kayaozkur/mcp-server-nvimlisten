# Quick Reference - MCP Neovim Listen Server

## 🚀 Quick Start

### Start Enhanced Environment
```bash
# Using the MCP tool
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});

# Or directly via shell
~/scripts/start-claude-dev-enhanced.sh
```

## 📊 Environment Layouts

### Enhanced Layout (9 Panes)
```
┌───────────┬────────────┬─────────────┐
│ 1 Editor  │ 2 Navigate │ 3 Reference │
│ :7001     │ :7002      │ :7003       │
├───────────┼────────────┼─────────────┤
│ 4 Extra   │ 5 Terminal │ 6 Explorer  │
│ :7004     │ (lsd/fzf)  │ (fzf+lsd)   │
├───────────┼────────────┼─────────────┤
│ 7 Logs    │ 8 History  │ 9 Git       │
│ :7777     │ (commands) │ (status)    │
└───────────┴────────────┴─────────────┘
```

### Orchestra Layout
- Port 7777: Primary instance
- Port 7778: Secondary instance  
- Port 7779: Tertiary instance

## ⌨️ Keyboard Shortcuts

### Zellij Navigation
- `Ctrl+p` → Pane mode
  - Arrow keys → Navigate between panes
  - `f` → Toggle fullscreen
  - `x` → Close pane
  - `n` → New pane
- `Ctrl+t` → Tab mode
- `Ctrl+s` → Scroll mode
- `Ctrl+o` → Session mode
- `Ctrl+q` → Quit

### Neovim Shortcuts (in each instance)
- `<leader>ff` → Find files (if Telescope installed)
- `<leader>fg` → Live grep
- `<leader>fb` → Browse buffers
- `:wa` → Save all buffers
- `:qa` → Quit all

## 🔧 Common MCP Commands

### Opening Files
```javascript
// Main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/file.js"
});

// With line number
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/file.js",
  "line": 42
});
```

### Executing Commands
```javascript
// Neovim command
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Telescope find_files<CR>"
});

// Terminal command
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});
```

### Interactive Tools
```javascript
// Command palette
await use_mcp_tool("nvimlisten", "command-palette", {});

// Project switcher
await use_mcp_tool("nvimlisten", "project-switcher", {});
```

## 🛠 Advanced MCP Commands

### Configuration Management
```javascript
// Get config
await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "plugins"
});

// Update config
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "mappings",
  "content": "vim.keymap.set('n', '<leader>q', ':q<CR>')"
});
```

### Plugin Management
```javascript
// List plugins
await use_mcp_tool("nvimlisten", "list-plugins", {
  "includeConfig": true
});

// Install plugin
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",
  "pluginName": "tpope/vim-fugitive"
});
```

### Orchestra Mode
```javascript
// Start orchestra
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full"
});

// Broadcast message
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Starting review",
  "messageType": "info"
});
```

## 💡 Pro Tips

1. **Port Assignment**:
   - 7001: Main editor
   - 7002: File navigator
   - 7777: Logs/broadcast
   - 7778-7779: Orchestra instances

2. **Pane Functions**:
   - Pane 5 (Terminal): Shows `lsd` on startup, ready for commands
   - Pane 6 (File Explorer): Interactive file browser with fzf and preview
   - Pane 8 (History): Live command history from all executions
   - Pane 9 (Git): Auto-updating git status every 2 seconds

3. **Terminal Visibility**: Commands executed via `terminal-execute` are visible to users

4. **Session Management**: Always create sessions before major changes

5. **File Navigation**: Use Pane 6 for visual file browsing with preview

## 🚨 Troubleshooting

### Check Instance Status
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'alive'<CR>"
});
```

### Restart Environment
```javascript
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});
```

### Common Issues
- **Port already in use**: Kill existing nvim processes
- **Commands not executing**: Check for proper escaping
- **Terminal not responding**: Verify Zellij is running