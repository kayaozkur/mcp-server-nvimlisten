#!/bin/bash

# Neovim Status Broadcaster
# Sends status messages to the broadcast instance and logs them

# Configuration
BROADCAST_PORT=7777
STATE_DIR="/tmp/nvim-mcp-state"
STATUS_LOG="$STATE_DIR/status.log"
INSTANCE_ID="${CLAUDE_INSTANCE:-unknown}"

# Create state directory
mkdir -p "$STATE_DIR"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to show usage
usage() {
    echo "Usage: $0 <message> [type]"
    echo ""
    echo "Broadcast a status message to all Neovim instances"
    echo ""
    echo "Arguments:"
    echo "  message  - The status message to broadcast"
    echo "  type     - Message type: info, warning, error, success (default: info)"
    echo ""
    echo "Examples:"
    echo "  $0 \"Starting code review\""
    echo "  $0 \"Build failed\" error"
    echo "  $0 \"Tests passed\" success"
    echo ""
    echo "Environment:"
    echo "  CLAUDE_INSTANCE - Set this to identify which Claude instance (A/B)"
    exit 1
}

# Check arguments
if [ $# -lt 1 ]; then
    usage
fi

MESSAGE=$1
TYPE=${2:-info}
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Format message based on type
case $TYPE in
    error)
        PREFIX="ERROR"
        COLOR="ErrorMsg"
        ;;
    warning)
        PREFIX="WARN"
        COLOR="WarningMsg"
        ;;
    success)
        PREFIX="OK"
        COLOR="String"
        ;;
    *)
        PREFIX="INFO"
        COLOR="Normal"
        ;;
esac

# Log the status
echo "${TIMESTAMP}|${TYPE}|${MESSAGE}|${INSTANCE_ID}" >> "$STATUS_LOG"

# Check if broadcast instance is running
if ! lsof -i :$BROADCAST_PORT >/dev/null 2>&1; then
    echo -e "${RED}✗ Broadcast instance not running on port $BROADCAST_PORT${NC}"
    echo "  Message logged but not broadcasted"
    exit 1
fi

# Create the Vim command
VIM_CMD=":echohl ${COLOR} | echo '[${TIMESTAMP}] [${PREFIX}] ${MESSAGE} (from: ${INSTANCE_ID})' | echohl None<CR>"

# Send to broadcast instance
if nvim --server 127.0.0.1:$BROADCAST_PORT --remote-send "$VIM_CMD" 2>/dev/null; then
    echo -e "${GREEN}✓ Status broadcasted${NC}"
    echo "  Type: $TYPE"
    echo "  Message: $MESSAGE"
    echo "  From: $INSTANCE_ID"
    
    # Also append to a buffer in the broadcast instance
    APPEND_CMD=":call writefile(['[${TIMESTAMP}] [${PREFIX}] ${MESSAGE} (${INSTANCE_ID})'], '/tmp/nvim-mcp-state/broadcast.log', 'a')<CR>"
    nvim --server 127.0.0.1:$BROADCAST_PORT --remote-send "$APPEND_CMD" 2>/dev/null
    
    # Try to send to other instances as comments
    for port in 7001 7002; do
        if [ "$port" != "$BROADCAST_PORT" ] && lsof -i :$port >/dev/null 2>&1; then
            COMMENT_CMD=":\" [${PREFIX}] ${MESSAGE}<CR>"
            nvim --server 127.0.0.1:$port --remote-send "$COMMENT_CMD" 2>/dev/null
        fi
    done
else
    echo -e "${RED}✗ Failed to broadcast status${NC}"
    exit 1
fi

# Show recent statuses
echo ""
echo "Recent status messages:"
tail -3 "$STATUS_LOG" | while IFS='|' read -r ts type msg instance; do
    echo "  [$ts] $type: $msg (from: $instance)"
done