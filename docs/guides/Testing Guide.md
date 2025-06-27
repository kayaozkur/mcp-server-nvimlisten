# Testing Guide - MCP Neovim Listen Server

## Pre-Test Setup

### 1. Install Dependencies
```bash
cd /Users/kayaozkur/Desktop/lepion/mcp-repos/mcp-server-nvimlisten

# Make installer executable (if not already)
chmod +x scripts/installers/install-dependencies.sh

# Run health check first
./scripts/installers/install-dependencies.sh --check-only

# Install missing dependencies if needed
./scripts/installers/install-dependencies.sh --all
```

### 2. Build the TypeScript Project
```bash
# Install npm dependencies
npm install

# Build the project
npm run build

# Verify build output
ls -la dist/
```

### 3. Test the MCP Server Locally
```bash
# Run the server directly
node dist/index.js

# You should see: "Neovim Listen MCP Server running on stdio"
# Press Ctrl+C to stop
```

## Testing with Claude Desktop

### 1. Configure Claude Desktop
Add to your Claude Desktop configuration file:
```json
{
  "mcpServers": {
    "nvimlisten": {
      "command": "node",
      "args": ["/Users/kayaozkur/Desktop/lepion/mcp-repos/mcp-server-nvimlisten/dist/index.js"]
    }
  }
}
```

### 2. Restart Claude Desktop
After adding the configuration, restart Claude Desktop to load the MCP server.

### 3. Test Basic Commands
In Claude Desktop, test these commands:

```javascript
// 1. Check system health
await use_mcp_tool("nvimlisten", "health-check", {});

// 2. Start a Neovim instance manually first
// In a terminal: nvim --listen 127.0.0.1:7001

// 3. Test connection
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'Hello from Claude!'<CR>"
});

// 4. Test file opening
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/tmp/test.txt"
});
```

## Manual Testing Steps

### 1. Test Script Execution
```bash
# Test individual scripts
cd scripts

# Test terminal bridge (requires Zellij running)
./claude-terminal-bridge.sh "echo 'Test command'"

# Test command palette (requires fzf)
./claude-command-palette.sh

# Test project switcher
./claude-project-switcher.sh
```

### 2. Test Neovim Communication
```bash
# Start Neovim with listener
nvim --listen 127.0.0.1:7001

# In another terminal, test remote commands
nvim --server 127.0.0.1:7001 --remote-send ':echo "Connected"<CR>'
```

### 3. Test Environment Launch
```bash
# Test the full environment (requires Zellij)
./scripts/start-claude-dev-enhanced.sh
```

## Validation Checklist

Before publishing, ensure:

- [ ] `npm run build` completes without errors
- [ ] `node dist/index.js` starts without errors
- [ ] Health check reports all required dependencies
- [ ] Basic neovim-connect command works
- [ ] Terminal bridge executes commands (if Zellij installed)
- [ ] Scripts have executable permissions
- [ ] TypeScript types are properly compiled

## Common Issues

### "Cannot find module" Error
```bash
# Rebuild the project
npm run clean
npm install
npm run build
```

### "Permission denied" for Scripts
```bash
# Make all scripts executable
chmod +x scripts/*.sh
chmod +x scripts/installers/*.sh
```

### "Neovim not found"
```bash
# Install Neovim
brew install neovim  # macOS
sudo apt install neovim  # Ubuntu/Debian
```

## Next Steps

Once all tests pass:
1. Commit changes to git
2. Push to GitHub repository
3. Publish to npm registry

For npm publishing:
```bash
# Login to npm (first time only)
npm login

# Publish the package
npm publish --access public
```