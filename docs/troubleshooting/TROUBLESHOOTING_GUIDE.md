# MCP Server Neovim Listen - Troubleshooting Guide

This guide helps you diagnose and resolve common issues with the MCP Server Neovim Listen.

## Table of Contents

1. [Quick Diagnostics](#quick-diagnostics)
2. [Connection Issues](#connection-issues)
3. [Environment Setup Issues](#environment-setup-issues)
4. [Terminal Bridge Issues](#terminal-bridge-issues)
5. [Plugin Issues](#plugin-issues)
6. [Performance Issues](#performance-issues)
7. [Configuration Issues](#configuration-issues)
8. [Session Management Issues](#session-management-issues)
9. [Common Error Messages](#common-error-messages)
10. [Debug Commands](#debug-commands)

---

## Quick Diagnostics

Run this diagnostic sequence to quickly identify issues:

```javascript
// 1. Check system health
const health = await use_mcp_tool("nvimlisten", "health-check", {});

// 2. Test Neovim connection
try {
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":echo 'Connected'<CR>"
  });
  console.log("✅ Neovim connection working");
} catch (error) {
  console.log("❌ Neovim connection failed:", error);
}

// 3. Test terminal bridge
try {
  await use_mcp_tool("nvimlisten", "terminal-execute", {
    "command": "echo 'Terminal bridge working'"
  });
  console.log("✅ Terminal bridge working");
} catch (error) {
  console.log("❌ Terminal bridge failed:", error);
}
```

---

## Connection Issues

### Issue: "Connection refused" when connecting to Neovim

**Symptoms:**
- Error: `Failed to connect to Neovim instance on port 7001`
- Commands don't execute
- File opening fails

**Solutions:**

1. **Check if Neovim is running on the port:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "ps aux | grep 'nvim.*7001'"
   });
   ```

2. **Start the environment if not running:**
   ```javascript
   await use_mcp_tool("nvimlisten", "start-environment", {
     "layout": "enhanced"
   });
   ```

3. **Verify port availability:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "lsof -i :7001"
   });
   ```

4. **Restart Neovim instance:**
   ```javascript
   // Kill existing instance
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "pkill -f 'nvim.*7001'"
   });
   
   // Start new instance
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "nvim --listen 127.0.0.1:7001 &"
   });
   ```

### Issue: Multiple instances conflicting

**Symptoms:**
- Commands go to wrong instance
- Unexpected behavior
- Port already in use errors

**Solutions:**

1. **List all Neovim processes:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "ps aux | grep nvim | grep -v grep"
   });
   ```

2. **Kill all instances and restart:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "pkill -f nvim"
   });
   
   await use_mcp_tool("nvimlisten", "start-environment", {
     "layout": "enhanced"
   });
   ```

---

## Environment Setup Issues

### Issue: Zellij not found

**Symptoms:**
- Error: `zellij: command not found`
- Environment fails to start
- Terminal bridge not working

**Solutions:**

1. **Install Zellij:**
   ```javascript
   // macOS
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "brew install zellij"
   });
   
   // Linux
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "cargo install zellij"
   });
   ```

2. **Use alternative terminal multiplexer:**
   ```javascript
   // Check if tmux is available
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "which tmux"
   });
   ```

### Issue: Scripts not executable

**Symptoms:**
- Permission denied errors
- Scripts fail to run
- Environment doesn't start

**Solutions:**

1. **Make scripts executable:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "chmod +x scripts/*.sh"
   });
   ```

2. **Check script permissions:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "ls -la scripts/"
   });
   ```

---

## Terminal Bridge Issues

### Issue: Commands not appearing in terminal

**Symptoms:**
- Terminal-execute runs but nothing visible
- No output returned
- Commands seem to hang

**Solutions:**

1. **Check Zellij session:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "zellij list-sessions"
   });
   ```

2. **Verify terminal pane:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "zellij action write-chars 'test'"
   });
   ```

3. **Restart terminal bridge:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "pkill -f claude-terminal-bridge"
   });
   ```

### Issue: Output not captured

**Symptoms:**
- Commands execute but no output returned
- Partial output only
- Encoding issues

**Solutions:**

1. **Use output redirection:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "ls -la 2>&1"
   });
   ```

2. **Check terminal encoding:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "locale"
   });
   ```

---

## Plugin Issues

### Issue: Plugins not loading

**Symptoms:**
- Plugin commands not available
- Lazy.nvim errors
- Missing functionality

**Solutions:**

1. **Sync plugins:**
   ```javascript
   await use_mcp_tool("nvimlisten", "manage-plugin", {
     "action": "sync"
   });
   ```

2. **Check plugin status:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":Lazy<CR>"
   });
   ```

3. **Clear plugin cache:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "rm -rf ~/.local/share/nvim/lazy"
   });
   
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":Lazy sync<CR>"
   });
   ```

### Issue: Plugin conflicts

**Symptoms:**
- Keybinding conflicts
- Features not working
- Error messages on startup

**Solutions:**

1. **Identify conflicts:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":checkhealth<CR>"
   });
   ```

2. **Disable conflicting plugins:**
   ```javascript
   await use_mcp_tool("nvimlisten", "set-nvim-config", {
     "configType": "plugins",
     "content": "-- Temporarily disable plugin\n-- { 'plugin-name', enabled = false }",
     "backup": true
   });
   ```

---

## Performance Issues

### Issue: Neovim running slowly

**Symptoms:**
- Lag when typing
- Slow file opening
- High CPU usage

**Solutions:**

1. **Profile startup:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":StartupTime<CR>"
   });
   ```

2. **Check plugin performance:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":Lazy profile<CR>"
   });
   ```

3. **Disable syntax highlighting temporarily:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":syntax off<CR>"
   });
   ```

4. **Clear swap files:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "rm -f ~/.local/state/nvim/swap/*"
   });
   ```

### Issue: Memory usage high

**Symptoms:**
- System slowdown
- Out of memory errors
- Neovim crashes

**Solutions:**

1. **Check buffer count:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":ls<CR>"
   });
   ```

2. **Close unused buffers:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":bufdo bd<CR>"
   });
   ```

3. **Limit undo history:**
   ```javascript
   await use_mcp_tool("nvimlisten", "set-nvim-config", {
     "configType": "options",
     "content": "vim.opt.undolevels = 1000\nvim.opt.undoreload = 10000",
     "backup": true
   });
   ```

---

## Configuration Issues

### Issue: Configuration not applying

**Symptoms:**
- Settings don't take effect
- Old configuration persists
- Errors on reload

**Solutions:**

1. **Source configuration:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":source $MYVIMRC<CR>"
   });
   ```

2. **Check for syntax errors:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "nvim -u NONE -c 'source ~/.config/nvim/init.lua' -c 'qa'"
   });
   ```

3. **Restore from backup:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "cp ~/.config/nvim/init.lua.backup ~/.config/nvim/init.lua"
   });
   ```

### Issue: Keybindings not working

**Symptoms:**
- Custom keybindings ignored
- Default bindings take precedence
- Conflicts with plugins

**Solutions:**

1. **Check existing mappings:**
   ```javascript
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":verbose map <leader>ff<CR>"
   });
   ```

2. **Force mapping:**
   ```javascript
   await use_mcp_tool("nvimlisten", "set-nvim-config", {
     "configType": "mappings",
     "content": "vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })",
     "backup": true
   });
   ```

---

## Session Management Issues

### Issue: Sessions not saving properly

**Symptoms:**
- Session restore fails
- Missing buffers after restore
- Corrupted session files

**Solutions:**

1. **Check session directory:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "ls -la ~/.local/share/nvim/sessions/"
   });
   ```

2. **Clean corrupted sessions:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "find ~/.local/share/nvim/sessions -name '*.vim' -size 0 -delete"
   });
   ```

3. **Create new session:**
   ```javascript
   await use_mcp_tool("nvimlisten", "manage-session", {
     "action": "create",
     "sessionName": "fresh-session"
   });
   ```

---

## Common Error Messages

### "E492: Not an editor command"

**Cause:** Command not available or plugin not loaded

**Solution:**
```javascript
// Check if plugin is loaded
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Lazy show telescope<CR>"
});
```

### "E5108: Error executing lua"

**Cause:** Lua syntax error or missing module

**Solution:**
```javascript
// Check Lua syntax
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "nvim -c 'lua print(\"test\")' -c 'qa'"
});
```

### "Connection refused"

**Cause:** Neovim not listening on port

**Solution:**
```javascript
// Restart with proper listen argument
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "nvim --listen 127.0.0.1:7001"
});
```

---

## Debug Commands

### Essential debug commands to run:

```javascript
// 1. System information
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "uname -a && nvim --version"
});

// 2. Check all processes
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "ps aux | grep -E '(nvim|zellij|node)' | grep -v grep"
});

// 3. Network connections
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "netstat -an | grep -E '(7001|7002|7777)'"
});

// 4. Neovim health check
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":checkhealth<CR>"
});

// 5. Plugin status
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Lazy check<CR>"
});

// 6. Error logs
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":messages<CR>"
});
```

### Creating a debug report:

```javascript
// Generate comprehensive debug report
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "mkdir -p ~/mcp-debug && cd ~/mcp-debug"
});

await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "nvim --version > nvim-version.txt"
});

await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "ps aux > processes.txt"
});

await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "env > environment.txt"
});

await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Debug report created in ~/mcp-debug/",
  "messageType": "info"
});
```

---

## Getting Help

If you're still experiencing issues:

1. **Check the logs:**
   ```javascript
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "tail -n 50 ~/.local/state/nvim/log"
   });
   ```

2. **Create a minimal reproduction:**
   ```javascript
   // Start with minimal config
   await use_mcp_tool("nvimlisten", "terminal-execute", {
     "command": "nvim -u NONE"
   });
   ```

3. **Report the issue:**
   - Include the debug report
   - Describe steps to reproduce
   - Include error messages
   - Specify your environment (OS, Neovim version, etc.)

Remember: Most issues can be resolved by:
- Restarting the environment
- Updating plugins
- Checking dependencies
- Clearing cache files