# Unified Port Configuration

## Standard Port Assignments

Both `mcp-server-nvim` and `mcp-server-nvimlisten` should use these standard ports:

### Primary Instances
- **Port 7001**: Main Editor (primary development work)
- **Port 7002**: Navigator/Explorer (file browsing, references, documentation)
- **Port 7777**: Broadcast/Status (logging, status messages, orchestration)

### Orchestra Mode (Multi-Instance)
- **Port 7003**: Additional editor instance
- **Port 7004**: Additional editor instance 
- **Port 7778**: Secondary broadcast
- **Port 7779**: Tertiary broadcast

### Testing/Development
- **Port 8001-8003**: Reserved for testing instances

## Usage Examples

### Basic Setup (3 instances)
```bash
nvim --listen 127.0.0.1:7001  # Main editor
nvim --listen 127.0.0.1:7002  # Navigator
nvim --listen 127.0.0.1:7777  # Broadcast
```

### Orchestra Setup (5+ instances)
```bash
nvim --listen 127.0.0.1:7001  # Main editor
nvim --listen 127.0.0.1:7002  # Navigator
nvim --listen 127.0.0.1:7003  # Secondary editor
nvim --listen 127.0.0.1:7004  # Tertiary editor
nvim --listen 127.0.0.1:7777  # Primary broadcast
nvim --listen 127.0.0.1:7778  # Secondary broadcast
nvim --listen 127.0.0.1:7779  # Tertiary broadcast
```

## MCP Tool Usage

### For mcp-server-nvimlisten
```javascript
// Main editor
await use_mcp_tool("nvimlisten", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/file.js"
});

// Navigator
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7002,
  "command": ":NvimTreeToggle<CR>"
});

// Broadcast
await use_mcp_tool("nvimlisten", "broadcast-message", {
  "message": "Status update",
  "port": 7777  // Optional, defaults to 7777
});
```

### For mcp-server-nvim
```javascript
// Main editor operations
await use_mcp_tool("nvim", "neovim-open-file", {
  "port": 7001,
  "filepath": "/path/to/file.js"
});

// Orchestra broadcast
await use_mcp_tool("nvim", "broadcast-message", {
  "message": "Sync all instances",
  "messageType": "command"
});
```

## Checking Port Availability

Before starting instances:
```bash
# Check if ports are in use
lsof -i :7001
lsof -i :7002
lsof -i :7777

# Or check all at once
for port in 7001 7002 7777; do
  echo -n "Port $port: "
  lsof -i :$port >/dev/null 2>&1 && echo "IN USE" || echo "FREE"
done
```

## Configuration Files to Update

To ensure consistency, these files should use the standard ports:

1. **Zellij Layouts**:
   - `/templates/zellij/layouts/claude-dev-enhanced.kdl`
   - Should spawn instances on 7001, 7002, 7777

2. **Scripts**:
   - All scripts in `/scripts/` should reference these ports
   - Orchestra scripts can use extended port range

3. **Documentation**:
   - CLAUDE.md
   - README.md
   - API Reference.md

4. **Handler Defaults**:
   - Handler files should default to port 7001 for main operations
   - Broadcast operations should default to 7777

## Port Conflicts

If you encounter port conflicts:
1. Kill existing processes: `pkill -f "nvim.*--listen"`
2. Use alternative ports: 8001-8003
3. Update your MCP calls to use the alternative ports