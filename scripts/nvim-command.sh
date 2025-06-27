#!/bin/bash

# Neovim Command Logger
# Executes commands on Neovim instances and logs them for observation

# Configuration
STATE_DIR="/tmp/nvim-mcp-state"
LOG_FILE="$STATE_DIR/commands.log"
INSTANCE_ID="${CLAUDE_INSTANCE:-unknown}"

# Create state directory
mkdir -p "$STATE_DIR"

# Function to show usage
usage() {
    echo "Usage: $0 <port> <command>"
    echo ""
    echo "Execute and log a command on a Neovim instance"
    echo ""
    echo "Arguments:"
    echo "  port     - The port number (e.g., 7001)"
    echo "  command  - The Neovim command to execute"
    echo ""
    echo "Examples:"
    echo "  $0 7001 ':echo \"Hello\"<CR>'"
    echo "  $0 7002 ':Telescope find_files<CR>'"
    echo "  $0 7001 ':w<CR>'"
    echo ""
    echo "Environment:"
    echo "  CLAUDE_INSTANCE - Set this to identify which Claude instance (A/B)"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    usage
fi

PORT=$1
COMMAND=$2
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Log the command
echo "${TIMESTAMP}|${PORT}|${COMMAND}|${INSTANCE_ID}" >> "$LOG_FILE"

# Execute the command
if nvim --server 127.0.0.1:$PORT --remote-send "$COMMAND" 2>/dev/null; then
    echo "✓ Command sent to port $PORT"
    echo "  Command: $COMMAND"
    echo "  Logged at: $TIMESTAMP"
    
    # Also send to broadcast instance if available and it's not the target
    if [ "$PORT" != "7777" ] && lsof -i :7777 >/dev/null 2>&1; then
        # Log the action to broadcast instance
        BROADCAST_MSG=":echo '[${INSTANCE_ID}] Port $PORT: ${COMMAND//:/}'<CR>"
        nvim --server 127.0.0.1:7777 --remote-send "$BROADCAST_MSG" 2>/dev/null
    fi
else
    echo "✗ Failed to send command to port $PORT"
    echo "  Is Neovim running on this port?"
    exit 1
fi

# Show last few commands
echo ""
echo "Recent command history:"
tail -3 "$LOG_FILE" | while IFS='|' read -r ts port cmd instance; do
    echo "  [$ts] Port $port: $cmd (from: $instance)"
done