# Multi-Instance Claude Code Guide

## Overview

This guide explains how to use multiple Claude Code instances to collaborate on the same Neovim environment. It includes observation tools that allow monitoring and controlling Neovim sessions from different Claude instances, working around the single-client limitation of Zellij.

## Observation Tools

The following tools enable visibility and control across Claude instances:

### 1. Session Monitor (`nvim-session-monitor.sh`)
Real-time monitoring of all Neovim instances:
```bash
# Single run with JSON output
./scripts/nvim-session-monitor.sh

# Continuous monitoring (updates every 2 seconds)
./scripts/nvim-session-monitor.sh --watch

# JSON only output (for programmatic access)
./scripts/nvim-session-monitor.sh --json
```

### 2. Command Logger (`nvim-command.sh`)
Execute and log commands for audit trail:
```bash
# Set your instance identifier
export CLAUDE_INSTANCE="A"  # or "B"

# Execute commands with logging
./scripts/nvim-command.sh 7001 ':w<CR>'
./scripts/nvim-command.sh 7002 ':Telescope find_files<CR>'
```

### 3. Status Broadcaster (`nvim-broadcast.sh`)
Send status messages to all instances:
```bash
# Broadcast status updates
./scripts/nvim-broadcast.sh "Starting code review"
./scripts/nvim-broadcast.sh "Build failed" error
./scripts/nvim-broadcast.sh "All tests passed" success
```

### 4. Query All Instances (`nvim-query-all.sh`)
Get a complete snapshot of all instances:
```bash
# Query all instances and save snapshot
./scripts/nvim-query-all.sh

# View the JSON snapshot
cat /tmp/nvim-mcp-state/snapshot.json | jq .
```

### 5. Observer Dashboard (`nvim-observer-dashboard.sh`)
A tmux-based dashboard for complete visibility:
```bash
# Start the dashboard
./scripts/nvim-observer-dashboard.sh start

# Attach to dashboard
./scripts/nvim-observer-dashboard.sh attach

# Attach read-only (for Instance B)
READONLY=1 ./scripts/nvim-observer-dashboard.sh attach

# Check status
./scripts/nvim-observer-dashboard.sh status

# Stop dashboard
./scripts/nvim-observer-dashboard.sh stop
```

The dashboard provides:
- **Window 0**: Main observer with 4 panes
  - Session monitor (live updates)
  - Command history log
  - Status message log
  - Interactive command panel
- **Window 1**: File monitoring
  - Broadcast log viewer
  - JSON state viewer

## Setup

### Instance A (Launcher)

1. **Start the environment**:
   ```bash
   cd /Users/kayaozkur/Desktop/lepion/mcp-repos/mcp-server-nvimlisten
   ./scripts/start-claude-dev-enhanced.sh
   ```

2. **Note the session name** (if using Zellij):
   ```bash
   zellij list-sessions
   ```

3. **Verify Neovim instances are running**:
   ```bash
   lsof -i :7001
   lsof -i :7002
   lsof -i :7777
   ```

### Instance B (Observer/Controller)

1. **Option A - Direct Control** (without MCP):
   ```bash
   # Send commands directly
   nvim --server 127.0.0.1:7001 --remote-send ':echo "Hello from Instance B"<CR>'
   
   # Open files
   nvim --server 127.0.0.1:7001 --remote-send ':e /path/to/file<CR>'
   
   # Execute searches
   nvim --server 127.0.0.1:7001 --remote-send ':Telescope find_files<CR>'
   ```

2. **Option B - With MCP** (requires Claude Desktop config):
   ```javascript
   // Check connection
   await use_mcp_tool("nvimlisten", "neovim-connect", {
     "port": 7001,
     "command": ":echo 'Connected from Instance B'<CR>"
   });
   
   // Open files
   await use_mcp_tool("nvimlisten", "neovim-open-file", {
     "port": 7001,
     "filepath": "/path/to/file.js"
   });
   ```

## Visibility Options

### 1. Terminal Output Monitoring

From Instance B, monitor what's happening:

```bash
# Watch terminal output (if redirected to file)
tail -f ~/.local/share/nvim/terminal.log

# Monitor Neovim server activity
lsof -i :7001 -r 1
```

### 2. Shared State via Files

Create a state file that both instances can read/write:

```bash
# Instance A writes state
echo "Editing: main.js at line 42" > /tmp/nvim-state.txt

# Instance B reads state
cat /tmp/nvim-state.txt
```

### 3. Zellij Session Attachment

To actually SEE the visual layout:

```bash
# Attach to existing session
zellij attach <session-name>

# Or resurrect an exited session
zellij attach <session-name> --force
```

## Communication Patterns

### 1. Command Broadcasting
```bash
# From Instance B to all Neovim instances
for port in 7001 7002 7777; do
  nvim --server 127.0.0.1:$port --remote-send ':echo "Broadcast message"<CR>'
done
```

### 2. Status Checking
```bash
# Create a status check script
cat > check-nvim-status.sh << 'EOF'
#!/bin/bash
for port in 7001 7002 7777; do
  echo "Checking port $port..."
  nvim --server 127.0.0.1:$port --remote-expr 'expand("%:p")' 2>/dev/null || echo "Not connected"
done
EOF
chmod +x check-nvim-status.sh
```

### 3. File Synchronization
```bash
# Instance A opens file
nvim --server 127.0.0.1:7001 --remote-send ':e shared-file.js<CR>'

# Instance B can query current file
nvim --server 127.0.0.1:7001 --remote-expr 'expand("%:p")'
```

## Limitations

1. **Visual Feedback**: Without attaching to the Zellij session, Instance B cannot see the visual state
2. **Terminal Output**: Terminal commands executed in panes are not directly visible to Instance B
3. **Plugin State**: Some plugin states may not be queryable remotely

## Best Practices

1. **Use Port 7777 for Status**: This is the broadcast instance - use it for status messages
2. **Create Log Files**: Have Instance A log actions to files that Instance B can monitor
3. **Use MCP Tools**: When both instances have MCP configured, use the tools for consistency
4. **Session Names**: Use predictable session names for easier discovery

## Example Workflow

### Instance A
```bash
# Start environment
./scripts/start-claude-dev-enhanced.sh

# Create a marker file
echo "Session started at $(date)" > /tmp/nvim-session.log
```

### Instance B
```bash
# Check if session is running
if lsof -i :7001 >/dev/null 2>&1; then
  echo "Neovim session found!"
  
  # Send a greeting
  nvim --server 127.0.0.1:7777 --remote-send ':echo "Instance B connected"<CR>'
  
  # Open a file in main editor
  nvim --server 127.0.0.1:7001 --remote-send ':e README.md<CR>'
  
  # Check what's open
  nvim --server 127.0.0.1:7001 --remote-expr 'expand("%:p")'
fi
```

## Enhanced Observation Workflow

### Recommended Setup for Two Claude Instances

#### Instance A (Primary Controller)
1. Start the Neovim environment:
   ```bash
   cd /Users/kayaozkur/Desktop/lepion/mcp-repos/mcp-server-nvimlisten
   export CLAUDE_INSTANCE="A"
   ./scripts/start-claude-dev-enhanced.sh
   ```

2. Start broadcasting status:
   ```bash
   ./scripts/nvim-broadcast.sh "Environment started, ready for collaboration"
   ```

#### Instance B (Observer/Secondary Controller)
1. Start the observer dashboard:
   ```bash
   cd /Users/kayaozkur/Desktop/lepion/mcp-repos/mcp-server-nvimlisten
   export CLAUDE_INSTANCE="B"
   ./scripts/nvim-observer-dashboard.sh start
   ```

2. Attach to the dashboard (read-only recommended):
   ```bash
   READONLY=1 ./scripts/nvim-observer-dashboard.sh attach
   ```

3. From the dashboard's interactive pane, you can:
   - Monitor all instances in real-time
   - See command history from Instance A
   - Execute commands with full logging
   - View status broadcasts

### Collaborative Patterns

#### Pattern 1: Code Review
```bash
# Instance A: Open file for review
./scripts/nvim-command.sh 7001 ':e src/main.js<CR>'
./scripts/nvim-broadcast.sh "Reviewing main.js - checking error handling"

# Instance B: Can see the file being reviewed and add notes
./scripts/nvim-command.sh 7002 ':e notes/review.md<CR>'
./scripts/nvim-broadcast.sh "Found potential issue at line 42" warning
```

#### Pattern 2: Debugging Session
```bash
# Instance A: Start debugging
./scripts/nvim-broadcast.sh "Starting debug session" info
./scripts/nvim-command.sh 7001 ':Telescope live_grep<CR>'

# Instance B: Monitor and assist
./scripts/nvim-query-all.sh  # Get current state
./scripts/nvim-broadcast.sh "Check the error log at /var/log/app.log" info
```

#### Pattern 3: Parallel Development
```bash
# Both instances work on different files but stay synchronized
# Instance A
./scripts/nvim-command.sh 7001 ':e frontend/App.jsx<CR>'
./scripts/nvim-broadcast.sh "Working on frontend components"

# Instance B
./scripts/nvim-command.sh 7002 ':e backend/api.js<CR>'
./scripts/nvim-broadcast.sh "Updating API endpoints"

# Either instance can query all
./scripts/nvim-query-all.sh
```

### State Persistence

All observation data is stored in `/tmp/nvim-mcp-state/`:
- `commands.log` - History of all commands executed
- `status.log` - All broadcast messages
- `status.json` - Current state snapshot
- `snapshot.json` - Full environment snapshot
- `broadcast.log` - Messages sent to broadcast instance

To preserve state across sessions:
```bash
# Backup state
cp -r /tmp/nvim-mcp-state ~/nvim-session-backup

# Restore state
cp -r ~/nvim-session-backup /tmp/nvim-mcp-state
```

### Troubleshooting Observation

1. **Dashboard not updating**: Check if scripts are executable
   ```bash
   chmod +x scripts/*.sh
   ```

2. **Can't see Instance A's commands**: Ensure CLAUDE_INSTANCE is set
   ```bash
   export CLAUDE_INSTANCE="A"  # or "B"
   ```

3. **Broadcast not working**: Verify port 7777 is active
   ```bash
   lsof -i :7777
   ```

4. **State files missing**: Create state directory
   ```bash
   mkdir -p /tmp/nvim-mcp-state
   ```

## Future Enhancements

1. **WebSocket Bridge**: Create a WebSocket server for real-time state sharing
2. **Persistent State**: Store state in a database instead of temp files
3. **Web Dashboard**: Create a web UI for remote observation
4. **Recording/Playback**: Record entire sessions for replay
5. **Multi-User Auth**: Add authentication for secure multi-user access