# MCP Neovim Listen Server - Troubleshooting Guide

## Table of Contents

1. [Common Issues](#common-issues)
2. [Connection Problems](#connection-problems)
3. [Configuration Issues](#configuration-issues)
4. [Plugin Problems](#plugin-problems)
5. [Terminal Integration Issues](#terminal-integration-issues)
6. [Performance Problems](#performance-problems)
7. [Environment Setup Issues](#environment-setup-issues)
8. [Debugging Techniques](#debugging-techniques)
9. [Error Messages Reference](#error-messages-reference)
10. [FAQ](#faq)

## Common Issues

### Issue: MCP Server Not Starting

**Symptoms:**
- Claude Code shows "MCP server failed to start"
- No response from any tools

**Solutions:**

1. **Check Node.js version:**
```bash
node --version  # Should be 18.0 or higher
```

2. **Verify installation:**
```bash
npm list -g @mcp/server-nvimlisten
```

3. **Check MCP configuration in Claude Code:**
```json
{
  "mcpServers": {
    "nvimlisten": {
      "command": "mcp-server-nvimlisten",
      "args": []
    }
  }
}
```

4. **Reinstall if necessary:**
```bash
npm uninstall -g @mcp/server-nvimlisten
npm install -g @mcp/server-nvimlisten
```

### Issue: "Command not found" Errors

**Symptoms:**
- Tools return "command not found" errors
- Scripts fail to execute

**Solutions:**

1. **Add npm global bin to PATH:**
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:$(npm config get prefix)/bin"
```

2. **Use absolute paths in MCP config:**
```json
{
  "mcpServers": {
    "nvimlisten": {
      "command": "/usr/local/bin/mcp-server-nvimlisten",
      "args": []
    }
  }
}
```

## Connection Problems

### Issue: Cannot Connect to Neovim Instance

**Symptoms:**
- `ECONNREFUSED` errors
- "Failed to connect to Neovim" messages

**Solutions:**

1. **Check if Neovim is running on the expected port:**
```javascript
// Use health check first
await use_mcp_tool("nvimlisten", "health-check", {});
```

2. **Verify port availability:**
```bash
# Check if port is in use
lsof -i :7001
# or
netstat -an | grep 7001
```

3. **Start Neovim manually with correct port:**
```bash
nvim --listen localhost:7001
```

4. **Start environment properly:**
```javascript
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});
```

### Issue: Multiple Neovim Instances Conflict

**Symptoms:**
- Commands sent to wrong instance
- Unexpected behavior in orchestration

**Solutions:**

1. **Kill all Neovim instances:**
```bash
pkill nvim
```

2. **Use the port checking script:**
```bash
./scripts/check-ports.sh
```

3. **Restart with clean environment:**
```javascript
// First, ensure all instances are closed
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "pkill nvim"
});

// Wait a moment
await new Promise(resolve => setTimeout(resolve, 2000));

// Start fresh
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"
});
```

## Configuration Issues

### Issue: Configuration Changes Not Taking Effect

**Symptoms:**
- Updated configs don't work
- Old settings persist

**Solutions:**

1. **Reload configuration explicitly:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":source $MYVIMRC<CR>"
});
```

2. **Check for syntax errors:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":checkhealth<CR>"
});
```

3. **Verify file was actually updated:**
```javascript
const config = await use_mcp_tool("nvimlisten", "get-nvim-config", {
  "configType": "all"
});
// Review the returned configuration
```

### Issue: Lost Configuration After Update

**Symptoms:**
- Custom settings disappeared
- Plugins not loading

**Solutions:**

1. **Check for backup files:**
```bash
ls ~/.config/nvim/*.backup
```

2. **Restore from backup:**
```bash
cp ~/.config/nvim/init.lua.backup ~/.config/nvim/init.lua
```

3. **Use session restore:**
```javascript
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "list"
});

// Restore appropriate session
await use_mcp_tool("nvimlisten", "manage-session", {
  "action": "restore",
  "sessionName": "your-session-name"
});
```

## Plugin Problems

### Issue: Plugin Installation Fails

**Symptoms:**
- "Failed to install plugin" errors
- Lazy.nvim errors

**Solutions:**

1. **Check plugin manager health:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Lazy health<CR>"
});
```

2. **Clear plugin cache:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Lazy clear<CR>"
});
```

3. **Sync plugins:**
```javascript
await use_mcp_tool("nvimlisten", "manage-plugin", {
  "action": "sync"
});
```

4. **Check Git access:**
```javascript
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "git ls-remote https://github.com/nvim-telescope/telescope.nvim"
});
```

### Issue: Plugin Conflicts

**Symptoms:**
- Keybinding conflicts
- Features not working as expected

**Solutions:**

1. **List all plugins:**
```javascript
const plugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "includeConfig": true
});
```

2. **Check keybinding conflicts:**
```javascript
const keybindings = await use_mcp_tool("nvimlisten", "get-keybindings", {
  "mode": "all",
  "format": "markdown"
});
```

3. **Disable conflicting plugin temporarily:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":Lazy disable plugin-name<CR>"
});
```

## Terminal Integration Issues

### Issue: Terminal Commands Not Executing

**Symptoms:**
- `terminal-execute` returns success but nothing happens
- Commands don't appear in terminal

**Solutions:**

1. **Verify Zellij is installed:**
```bash
which zellij
zellij --version
```

2. **Check if running inside Zellij:**
```bash
echo $ZELLIJ
```

3. **Use alternative terminal multiplexer:**
```bash
# If Zellij not available, use tmux
tmux new-session -d -s mcp-nvim
tmux send-keys -t mcp-nvim "your command" Enter
```

4. **Start environment with terminal:**
```javascript
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "enhanced"  // Includes terminal setup
});
```

### Issue: Terminal Output Not Visible

**Symptoms:**
- Commands execute but output is hidden
- Can't see command results

**Solutions:**

1. **Check terminal pane visibility:**
   - Enhanced layout: Pane 5 shows terminal
   - Use Ctrl+h/j/k/l to navigate panes

2. **Clear terminal and retry:**
```javascript
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "clear"
});
```

3. **Use output redirection:**
```javascript
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "npm test 2>&1 | tee test-output.log"
});
```

## Performance Problems

### Issue: Slow Command Execution

**Symptoms:**
- Commands take long time to execute
- UI feels sluggish

**Solutions:**

1. **Check system resources:**
```javascript
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "top -b -n 1 | head -20"
});
```

2. **Reduce plugin count:**
```javascript
// List heavy plugins
const plugins = await use_mcp_tool("nvimlisten", "list-plugins", {
  "filter": "treesitter|lsp"
});
```

3. **Use minimal layout for simple tasks:**
```javascript
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "minimal"
});
```

4. **Disable syntax highlighting for large files:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":syntax off<CR>"
});
```

### Issue: High Memory Usage

**Symptoms:**
- System becomes unresponsive
- Out of memory errors

**Solutions:**

1. **Limit LSP servers:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":LspStop<CR>"
});
```

2. **Close unused buffers:**
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":bufdo bd<CR>"
});
```

3. **Restart specific instances:**
```bash
# Kill specific instance
kill $(lsof -t -i:7002)
# Restart it
nvim --listen localhost:7002
```

## Environment Setup Issues

### Issue: Enhanced Layout Not Starting Properly

**Symptoms:**
- Missing panes
- Layout looks wrong

**Solutions:**

1. **Check Zellij layout file:**
```bash
ls ~/.config/zellij/layouts/claude-dev-enhanced.kdl
```

2. **Copy template if missing:**
```bash
cp templates/zellij/layouts/claude-dev-enhanced.kdl ~/.config/zellij/layouts/
```

3. **Start with fallback:**
```javascript
// Try minimal first
await use_mcp_tool("nvimlisten", "start-environment", {
  "layout": "minimal"
});
```

### Issue: Orchestra Mode Fails

**Symptoms:**
- Not all instances start
- Broadcast doesn't work

**Solutions:**

1. **Check available ports:**
```javascript
await use_mcp_tool("nvimlisten", "terminal-execute", {
  "command": "for p in 7777 7778 7779; do lsof -i :$p; done"
});
```

2. **Use custom ports:**
```javascript
await use_mcp_tool("nvimlisten", "run-orchestra", {
  "mode": "dual",
  "ports": [8001, 8002]  // Use different ports
});
```

## Debugging Techniques

### Enable Debug Logging

1. **Set debug environment variable:**
```bash
export MCP_DEBUG=true
```

2. **Check MCP logs:**
```bash
# Location varies by system
tail -f ~/.mcp/logs/nvimlisten.log
```

### Use Health Check Tool

```javascript
// Always start debugging with health check
const health = await use_mcp_tool("nvimlisten", "health-check", {});
// Review the output for missing dependencies or issues
```

### Test Individual Components

```javascript
// Test Neovim connection
try {
  await use_mcp_tool("nvimlisten", "neovim-connect", {
    "port": 7001,
    "command": ":echo 'test'<CR>"
  });
  console.log("Neovim connection: OK");
} catch (e) {
  console.log("Neovim connection: FAILED", e);
}

// Test terminal
try {
  await use_mcp_tool("nvimlisten", "terminal-execute", {
    "command": "echo 'test'"
  });
  console.log("Terminal integration: OK");
} catch (e) {
  console.log("Terminal integration: FAILED", e);
}
```

## Error Messages Reference

### Common Error Messages and Solutions

| Error Message | Cause | Solution |
|--------------|-------|----------|
| `ECONNREFUSED` | Neovim not running on port | Start Neovim or use start-environment |
| `ENOENT` | File not found | Check file path exists |
| `EACCES` | Permission denied | Check file permissions |
| `TIMEOUT` | Command took too long | Simplify command or increase timeout |
| `spawn ENOENT` | Command not found | Install missing dependency |
| `EPIPE` | Connection closed | Restart Neovim instance |
| `Invalid port` | Port out of range | Use port between 1024-65535 |
| `Plugin not found` | Wrong plugin name | Check exact plugin name/URL |

### MCP-Specific Errors

| Error | Meaning | Fix |
|-------|---------|-----|
| `Tool not found` | Wrong tool name | Check exact tool name in API docs |
| `Invalid arguments` | Wrong parameter format | Review parameter types in API |
| `MCP server not responding` | Server crashed | Restart Claude Code |
| `Rate limit exceeded` | Too many requests | Add delays between commands |

## FAQ

### Q: Can I use this with vanilla Vim?
**A:** No, this server requires Neovim 0.9+ with RPC support.

### Q: Why are my commands not visible in the terminal?
**A:** Ensure you're using the `terminal-execute` tool and that Zellij is properly configured.

### Q: How do I reset everything to defaults?
**A:** 
```bash
# Backup current config
mv ~/.config/nvim ~/.config/nvim.backup
# Remove MCP data
rm -rf ~/.mcp/nvimlisten
# Reinstall
npm install -g @mcp/server-nvimlisten
```

### Q: Can I use custom Neovim distributions?
**A:** Yes, but some features may not work. The server is tested with NvChad configuration.

### Q: How do I use this with WSL?
**A:** 
1. Install in WSL: `npm install -g @mcp/server-nvimlisten`
2. Configure Claude Code to use WSL path
3. Ensure X11 forwarding for GUI features

### Q: Why is broadcasting not working?
**A:** 
1. Check all instances are running: `lsof -i :7777,7778,7779`
2. Verify orchestra mode started correctly
3. Use health-check to diagnose

### Q: Can I change the default ports?
**A:** Yes, use custom ports in tool parameters:
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 8080,  // Custom port
  "command": ":echo 'custom port'<CR>"
});
```

### Q: How do I handle special characters in commands?
**A:** Escape special characters properly:
- Use `<CR>` for Enter
- Use `<ESC>` for Escape
- Quote strings with spaces
- Escape backslashes: `\\`

### Q: What's the difference between layouts?
**A:** 
- **Enhanced**: Full 9-pane setup with all features
- **Minimal**: Single Neovim + terminal
- **Orchestra**: Multiple Neovim instances for coordination

### Q: How do I update the server?
**A:** 
```bash
npm update -g @mcp/server-nvimlisten
# Or reinstall
npm uninstall -g @mcp/server-nvimlisten
npm install -g @mcp/server-nvimlisten
```

## Getting Help

If you're still experiencing issues:

1. Run the health check and save output
2. Check the [GitHub Issues](https://github.com/yourusername/mcp-server-nvimlisten/issues)
3. Enable debug logging and collect logs
4. Create a minimal reproduction case
5. File a detailed bug report with:
   - System information
   - Error messages
   - Steps to reproduce
   - Expected vs actual behavior

Remember: Most issues can be resolved by:
- Running health-check
- Restarting the environment
- Checking dependencies
- Using correct ports
- Following the error message guidance