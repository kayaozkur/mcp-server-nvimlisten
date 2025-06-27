# Neovim Claude Integration Environment Guide

## 🚀 Environment Overview

Your Neovim environment is running with the **enhanced** setup, which includes:

### Active Services
- **5 Neovim instances** on ports: 7001, 7002, 7003, 7004, 7777
- **Emacs daemon** (claude-server)
- **Zellij** terminal multiplexer
- **Full MCP integration** for remote control

### System Architecture
```
┌─────────────────────────────────────────────────┐
│              Claude MCP Interface               │
│                (This window)                    │
├─────────────────────────────────────────────────┤
│                     ↓ ↑                         │
│            MCP Tools & Commands                 │
│                     ↓ ↑                         │
├─────────────────────────────────────────────────┤
│           Neovim Instances (5)                  │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ │
│  │ 7001 │ │ 7002 │ │ 7003 │ │ 7004 │ │ 7777 │ │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ │
├─────────────────────────────────────────────────┤
│          Terminal & Command Interface           │
│              (Zellij/tmux)                      │
└─────────────────────────────────────────────────┘
```

## 📂 Configuration Structure

```
~/.config/nvim/
├── init.lua              # Main configuration entry
├── lua/
│   ├── options.lua       # Editor options
│   ├── mappings.lua      # Key mappings
│   ├── plugins/          # Plugin configurations
│   └── configs/          # LSP and tool configs
├── scripts/              # Automation scripts
│   ├── claude_ai_controller.py
│   ├── nvim_orchestrator.py
│   └── ultimate-orchestra.sh
└── orchestra/            # Multi-instance coordination
    ├── state.json        # Shared state
    ├── messages.log      # Communication log
    └── sync/             # Synchronized data
```

## 🛠️ Available MCP Tools

### 1. **Basic Neovim Control**
```javascript
// Connect to instance
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'Hello!'"
});

// Open file
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/file.js",
  "line": 42  // optional
});
```

### 2. **Terminal Commands**
```javascript
// Execute in terminal
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test"
});
```

### 3. **Configuration Management**
```javascript
// Get config
await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "plugins"  // init, plugins, mappings, options, all
});

// Update config
await use_mcp_tool("nvimlisten", "set-nvim-config", {
  "configType": "plugins",
  "content": "...",
  "backup": true
});
```

### 4. **Plugin Management**
```javascript
// List plugins
await use_mcp_tool("nvimlisten", "list-plugins", {
  "includeConfig": true
});

// Manage plugins
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "install",  // install, update, remove, sync
  "pluginName": "plugin-name"
});
```

### 5. **Multi-Instance Orchestration**
```javascript
// Run orchestra mode
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "full",  // full, solo, dual, dev, jupyter, performance
  "ports": [7777, 7778, 7779]
});

// Broadcast to all instances
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "sync",
  "messageType": "command"
});
```

## 🎯 Key Features

### 1. **NvChad Base Configuration**
- Modern UI with custom statusline
- Lazy loading for performance
- Integrated file tree and fuzzy finding

### 2. **Productivity Plugins**
- **Harpoon**: Quick file navigation (Leader+m)
- **Flash**: Fast cursor movement (s in normal mode)
- **Telescope**: Fuzzy finding everything
- **ToggleTerm**: Integrated terminal (Ctrl+\)
- **Trouble**: Diagnostics management
- **Todo Comments**: Task tracking

### 3. **Development Tools**
- **LSP**: Full language server support
- **DAP**: Debugging support
- **Neotest**: Test runner integration
- **Copilot**: AI code completion
- **Overseer**: Task runner

### 4. **UI Enhancements**
- **Noice**: Better notifications
- **Bufferline**: Visual buffer tabs
- **Incline**: Floating filenames
- **Rainbow Delimiters**: Colored brackets

## 🔧 Common Workflows

### 1. **Multi-File Editing**
```javascript
// Open files in different instances
const files = [
  { port: 7001, file: "src/index.js" },
  { port: 7002, file: "src/components/App.js" },
  { port: 7003, file: "src/tests/App.test.js" }
];

for (const { port, file } of files) {
  await use_mcp_tool("nvimlisten", "neovim-open-file", {
    "port": port,
    "filepath": file
  });
}
```

### 2. **Run Tests While Editing**
```javascript
// Terminal in one pane, code in another
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test -- --watch"
});
```

### 3. **Project Navigation**
```javascript
// Use project switcher
await use_mcp_tool("nvimlisten", "project-switcher", {});
```

## 📋 Keybinding Quick Reference

### Leader Key: Space

| Key | Action |
|-----|--------|
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Find buffers |
| `<Space>ma` | Mark file (Harpoon) |
| `<Space>mm` | Mark menu |
| `<Space>tn` | New terminal |
| `<Space>tt` | Toggle terminal |
| `<Space>e` | File explorer |
| `<C-\>` | Toggle floating terminal |

### Navigation
| Key | Action |
|-----|--------|
| `s` | Flash jump |
| `S` | Flash treesitter |
| `<C-h/j/k/l>` | Navigate windows |
| `<S-h/l>` | Navigate buffers |

## 🎨 Terminal Interface Notes

### Terminal Monitor Window
- Another Claude instance is available there
- Commands can be sent and monitored
- Remember to press Enter after commands
- Use for interactive debugging and monitoring

### Command Execution Flow
1. Send command via MCP tool
2. Command appears in terminal
3. Press Enter to execute (can be automated)
4. Monitor output in terminal window

## 🚨 Important Notes

1. **Port Usage**: Default ports are 7001-7004 and 7777
2. **File Paths**: Always use absolute paths for reliability
3. **Session Persistence**: Sessions are automatically saved
4. **Performance**: All instances share configuration but run independently

## 📝 Next Steps

1. Explore the file structure using the file explorer
2. Test multi-instance coordination
3. Set up your preferred workflow
4. Customize keybindings and plugins as needed

---

*This environment is fully configured and ready for advanced development workflows with Claude integration.*