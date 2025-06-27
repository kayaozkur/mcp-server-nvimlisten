# Collaboration & Monitoring Features - Multi-Instance Guide

## 🤝 Multi-Instance Architecture

### Overview
The system supports multiple Claude Code instances collaborating on the same Neovim environment, working around Zellij's single-client limitation through observation and communication tools.

### Instance Roles
```
┌─────────────────────────────────────────────────────┐
│          Instance A (Launcher/Controller)           │
│  • Starts environment                               │
│  • Direct Zellij access                             │
│  • Primary control                                  │
├─────────────────────────────────────────────────────┤
│         Instance B (Observer/Collaborator)          │
│  • Monitors via tools                              │
│  • Executes commands                               │
│  • Read-only dashboard                             │
├─────────────────────────────────────────────────────┤
│              Shared State & Logging                 │
│  • /tmp/nvim-mcp-state/                           │
│  • JSON snapshots                                  │
│  • Command history                                 │
└─────────────────────────────────────────────────────┘
```

## 📊 Monitoring Tools Suite

### 1. **Session Monitor** (`nvim-session-monitor.sh`)
Real-time monitoring of all Neovim instances:

```bash
# Single status check
./scripts/nvim-session-monitor.sh

# Continuous monitoring (updates every 2 seconds)
./scripts/nvim-session-monitor.sh --watch

# JSON output for programmatic access
./scripts/nvim-session-monitor.sh --json
```

**Output Example:**
```json
{
  "timestamp": "2025-06-25T23:45:00Z",
  "instances": {
    "7001": {
      "status": "active",
      "files": ["main.js", "test.js"],
      "mode": "NORMAL",
      "cursor": [45, 12]
    },
    "7002": {
      "status": "active",
      "files": ["README.md"],
      "mode": "INSERT"
    }
  }
}
```

### 2. **Command Logger** (`nvim-command.sh`)
Execute and log commands with audit trail:

```bash
# Set instance identifier
export CLAUDE_INSTANCE="A"  # or "B", "C", etc.

# Execute commands with logging
./scripts/nvim-command.sh 7001 ':w<CR>'                    # Save file
./scripts/nvim-command.sh 7002 ':Telescope find_files<CR>' # Open finder
./scripts/nvim-command.sh 7777 ':put ="Status: OK"<CR>'   # Add status
```

**Features:**
- Command history logging
- Instance tracking
- Success/failure recording
- Timestamp for each command

### 3. **Status Broadcaster** (`nvim-broadcast.sh`)
Send messages to all instances simultaneously:

```bash
# Basic status update
./scripts/nvim-broadcast.sh "Starting code review"

# With severity levels
./scripts/nvim-broadcast.sh "Build failed" error
./scripts/nvim-broadcast.sh "All tests passed" success
./scripts/nvim-broadcast.sh "Analyzing code" info
```

**Broadcast Targets:**
- All Neovim instances
- Orchestra state file
- Command history log
- Observer dashboard

### 4. **Query All Instances** (`nvim-query-all.sh`)
Complete environment snapshot:

```bash
# Generate snapshot
./scripts/nvim-query-all.sh

# View snapshot
cat /tmp/nvim-mcp-state/snapshot.json | jq .

# Filter specific instance
cat /tmp/nvim-mcp-state/snapshot.json | jq '.instances["7001"]'
```

**Snapshot Contents:**
- Buffer lists
- Current files
- Cursor positions
- Modified status
- Plugin states
- Window layouts

### 5. **Observer Dashboard** (`nvim-observer-dashboard.sh`)
Comprehensive tmux-based monitoring:

```bash
# Start dashboard
./scripts/nvim-observer-dashboard.sh start

# Attach (Instance A - full control)
./scripts/nvim-observer-dashboard.sh attach

# Attach read-only (Instance B)
READONLY=1 ./scripts/nvim-observer-dashboard.sh attach

# Check if running
./scripts/nvim-observer-dashboard.sh status

# Stop dashboard
./scripts/nvim-observer-dashboard.sh stop
```

**Dashboard Layout:**
```
Window 0: Main Observer
┌─────────────────────┬─────────────────────┐
│ Session Monitor     │ Command History     │
│ • Port 7001 ✓       │ 11:45:02 A: :w     │
│ • Port 7002 ✓       │ 11:45:15 B: :q     │
├─────────────────────┼─────────────────────┤
│ Status Messages     │ Command Panel       │
│ [INFO] Ready        │ > Enter command     │
│ [SUCCESS] Saved     │                     │
└─────────────────────┴─────────────────────┘

Window 1: File Monitoring
┌─────────────────────┬─────────────────────┐
│ Broadcast Log       │ State Viewer        │
│ Recent messages     │ JSON state display  │
└─────────────────────┴─────────────────────┘
```

## 🔄 Communication Patterns

### File-Based Communication
```bash
# State directory structure
/tmp/nvim-mcp-state/
├── orchestra-state.json    # Instance coordination
├── command-history.log     # All commands executed
├── status-messages.log     # Broadcast messages
├── snapshot.json          # Latest environment snapshot
└── sessions/              # Session-specific data
    ├── instance-A.log
    └── instance-B.log
```

### Message Types
1. **Status Updates**: General information
2. **Error Messages**: Problems requiring attention
3. **Success Messages**: Completed operations
4. **Info Messages**: Neutral information
5. **Commands**: Executed operations

### Instance Identification
```bash
# Set in each Claude instance
export CLAUDE_INSTANCE="A"  # Primary
export CLAUDE_INSTANCE="B"  # Observer
export CLAUDE_INSTANCE="C"  # Additional
```

## 🎯 Collaboration Workflows

### 1. **Code Review Workflow**
```bash
# Instance A: Open files for review
./scripts/nvim-command.sh 7001 ':e src/main.js<CR>'
./scripts/nvim-broadcast.sh "Ready for review in port 7001"

# Instance B: Navigate and comment
./scripts/nvim-command.sh 7001 '/function.*calculate<CR>'
./scripts/nvim-broadcast.sh "Found issue on line 45" warning
```

### 2. **Parallel Development**
```bash
# Instance A: Backend development
./scripts/nvim-command.sh 7001 ':e server.js<CR>'

# Instance B: Frontend development
./scripts/nvim-command.sh 7002 ':e client.js<CR>'

# Both: Monitor shared status
./scripts/nvim-session-monitor.sh --watch
```

### 3. **Testing Coordination**
```bash
# Instance A: Run tests
./scripts/nvim-command.sh 7777 ':terminal npm test<CR>'

# Instance B: Monitor results
READONLY=1 ./scripts/nvim-observer-dashboard.sh attach

# Both: React to results
./scripts/nvim-broadcast.sh "Tests complete - fixing issues"
```

## 📈 Advanced Monitoring Features

### Atuin Integration
```bash
# Monitor command history with AI search
./scripts/atuin-monitor.sh

# Features:
# - Real-time command tracking
# - Statistics and analytics
# - Context-aware search
# - Session correlation
```

### Development Activity Monitor
```bash
# Track file changes and commands
./scripts/dev-monitor.sh

# Monitors:
# - File modifications (fswatch)
# - Command execution
# - Git operations
# - Build processes
```

### System Resource Monitoring
- **btop**: CPU, memory, network
- **Process tracking**: Neovim instances
- **Port monitoring**: Connection status
- **Log aggregation**: Centralized viewing

## 🔐 Access Control

### Read-Only Mode
```bash
# For observer instances
READONLY=1 ./scripts/nvim-observer-dashboard.sh attach
```

### Command Filtering
- Dangerous commands logged but not executed
- Whitelist/blacklist support
- Instance-based permissions

### Audit Trail
- Every command logged with:
  - Timestamp
  - Instance ID
  - Success/failure
  - User context

## 💡 Best Practices

### Instance Management
1. **Always set CLAUDE_INSTANCE** environment variable
2. **Use descriptive broadcast messages** for clarity
3. **Regular snapshots** for state preservation
4. **Monitor resource usage** to avoid overload

### Communication
1. **Use severity levels** in broadcasts
2. **Keep messages concise** but informative
3. **Include context** in status updates
4. **Coordinate before major operations**

### Monitoring
1. **Start observer dashboard early** in session
2. **Use --watch mode** for real-time updates
3. **Check snapshots** before major changes
4. **Review command history** for debugging

## 🚀 Quick Start Commands

```bash
# Instance A (Launcher)
cd /path/to/mcp-server-nvimlisten
./scripts/start-claude-dev-enhanced.sh
export CLAUDE_INSTANCE="A"
./scripts/nvim-observer-dashboard.sh start

# Instance B (Observer)
export CLAUDE_INSTANCE="B"
./scripts/nvim-session-monitor.sh --watch
READONLY=1 ./scripts/nvim-observer-dashboard.sh attach

# Both instances can:
./scripts/nvim-broadcast.sh "Collaboration ready!"
./scripts/nvim-query-all.sh
```

---

*This multi-instance system enables powerful collaboration between Claude Code instances while maintaining clean separation of concerns and comprehensive monitoring capabilities.*