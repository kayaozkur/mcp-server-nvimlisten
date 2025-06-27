#!/bin/bash

# Neovim Observer Dashboard
# Creates a tmux-based monitoring dashboard for observing Neovim sessions

# Configuration
SESSION_NAME="nvim-observer"
STATE_DIR="/tmp/nvim-mcp-state"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Function to show usage
usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start    - Start the observer dashboard (default)"
    echo "  stop     - Stop the observer dashboard"
    echo "  attach   - Attach to existing dashboard"
    echo "  status   - Check if dashboard is running"
    echo ""
    echo "The dashboard provides:"
    echo "  - Real-time session monitoring"
    echo "  - Command history"
    echo "  - Status messages"
    echo "  - File browser"
    exit 1
}

# Function to check if tmux session exists
session_exists() {
    tmux has-session -t "$SESSION_NAME" 2>/dev/null
}

# Function to start dashboard
start_dashboard() {
    if session_exists; then
        echo -e "${YELLOW}Dashboard already running. Use '$0 attach' to connect.${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Starting Neovim Observer Dashboard...${NC}"
    
    # Create state directory
    mkdir -p "$STATE_DIR"
    
    # Create tmux session with initial window
    tmux new-session -d -s "$SESSION_NAME" -n "observer"
    
    # Pane 0: Session monitor (top-left)
    tmux send-keys -t "$SESSION_NAME:0.0" "cd $(pwd) && ./scripts/nvim-session-monitor.sh --watch" C-m
    
    # Split horizontally for command log (top-right)
    tmux split-window -h -t "$SESSION_NAME:0.0"
    tmux send-keys -t "$SESSION_NAME:0.1" "tail -f $STATE_DIR/commands.log | while read line; do echo \"\$line\" | awk -F'|' '{printf \"[%s] Port %s: %s (from: %s)\\n\", \$1, \$2, \$3, \$4}'; done" C-m
    
    # Split vertically for status log (bottom-right)
    tmux split-window -v -t "$SESSION_NAME:0.1"
    tmux send-keys -t "$SESSION_NAME:0.2" "tail -f $STATE_DIR/status.log | while read line; do echo \"\$line\" | awk -F'|' '{printf \"[%s] %s: %s (from: %s)\\n\", \$1, \$2, \$3, \$4}'; done" C-m
    
    # Split vertically for interactive commands (bottom-left)
    tmux split-window -v -t "$SESSION_NAME:0.0"
    tmux send-keys -t "$SESSION_NAME:0.3" "echo 'Interactive Command Panel'; echo ''; echo 'Examples:'; echo '  ./scripts/nvim-command.sh 7001 \":w<CR>\"'; echo '  ./scripts/nvim-broadcast.sh \"Status update\"'; echo '  ./scripts/nvim-query-all.sh'; echo ''; export CLAUDE_INSTANCE=observer" C-m
    
    # Create second window for file monitoring
    tmux new-window -t "$SESSION_NAME:1" -n "files"
    
    # Watch for file changes in broadcast log
    tmux send-keys -t "$SESSION_NAME:1.0" "watch -n 1 'if [ -f $STATE_DIR/broadcast.log ]; then tail -20 $STATE_DIR/broadcast.log; fi'" C-m
    
    # Split for JSON state viewer
    tmux split-window -h -t "$SESSION_NAME:1.0"
    tmux send-keys -t "$SESSION_NAME:1.1" "watch -n 2 'if [ -f $STATE_DIR/status.json ] && command -v jq >/dev/null 2>&1; then cat $STATE_DIR/status.json | jq .; else cat $STATE_DIR/status.json 2>/dev/null || echo \"No status data\"; fi'" C-m
    
    # Set pane titles
    tmux select-pane -t "$SESSION_NAME:0.0" -T "Session Monitor"
    tmux select-pane -t "$SESSION_NAME:0.1" -T "Command Log"
    tmux select-pane -t "$SESSION_NAME:0.2" -T "Status Log"
    tmux select-pane -t "$SESSION_NAME:0.3" -T "Interactive"
    
    # Select the interactive pane
    tmux select-window -t "$SESSION_NAME:0"
    tmux select-pane -t "$SESSION_NAME:0.3"
    
    echo -e "${GREEN}✓ Dashboard started successfully${NC}"
    echo ""
    echo "To attach: tmux attach -t $SESSION_NAME"
    echo "To attach read-only: tmux attach -t $SESSION_NAME -r"
    echo ""
    echo -e "${YELLOW}Dashboard Layout:${NC}"
    echo "  Window 0 - Main Observer:"
    echo "    • Top-left: Live session monitor"
    echo "    • Top-right: Command history"
    echo "    • Bottom-right: Status messages"
    echo "    • Bottom-left: Interactive commands"
    echo "  Window 1 - File Monitor:"
    echo "    • Left: Broadcast log"
    echo "    • Right: JSON state viewer"
}

# Function to stop dashboard
stop_dashboard() {
    if ! session_exists; then
        echo -e "${YELLOW}Dashboard is not running${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Stopping dashboard...${NC}"
    tmux kill-session -t "$SESSION_NAME"
    echo -e "${GREEN}✓ Dashboard stopped${NC}"
}

# Function to attach to dashboard
attach_dashboard() {
    if ! session_exists; then
        echo -e "${RED}Dashboard is not running. Use '$0 start' first.${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Attaching to dashboard...${NC}"
    echo "Tip: Use Ctrl+b d to detach, Ctrl+b 0/1 to switch windows"
    sleep 1
    
    # Check if we should attach read-only
    if [ "${READONLY:-0}" = "1" ]; then
        tmux attach -t "$SESSION_NAME" -r
    else
        tmux attach -t "$SESSION_NAME"
    fi
}

# Function to check status
check_status() {
    if session_exists; then
        echo -e "${GREEN}✓ Dashboard is running${NC}"
        echo ""
        echo "Session: $SESSION_NAME"
        echo "Windows:"
        tmux list-windows -t "$SESSION_NAME" 2>/dev/null | sed 's/^/  /'
        echo ""
        echo "To attach: $0 attach"
        echo "To attach read-only: READONLY=1 $0 attach"
    else
        echo -e "${YELLOW}Dashboard is not running${NC}"
        echo "To start: $0 start"
    fi
}

# Make all scripts executable
chmod +x scripts/*.sh 2>/dev/null

# Parse command
COMMAND="${1:-start}"

case "$COMMAND" in
    start)
        start_dashboard
        ;;
    stop)
        stop_dashboard
        ;;
    attach)
        attach_dashboard
        ;;
    status)
        check_status
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        usage
        ;;
esac