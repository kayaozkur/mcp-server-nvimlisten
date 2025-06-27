#!/bin/bash

# Enhanced Neovim Session Monitor with Real-time Updates
# Provides detailed information about running Neovim instances

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PORTS=(7001 7002 7777 7778 7779 8001 8002 8003)
STATE_DIR="/tmp/nvim-mcp-state"
LOG_FILE="$STATE_DIR/commands.log"
STATUS_FILE="$STATE_DIR/status.json"

# Create state directory if it doesn't exist
mkdir -p "$STATE_DIR"

# Function to get port description
get_port_description() {
    case $1 in
        7001) echo "Main Editor" ;;
        7002) echo "Navigator" ;;
        7777) echo "Broadcast/Status" ;;
        *) echo "Instance $1" ;;
    esac
}

# Function to query Neovim instance
query_nvim() {
    local port=$1
    local expr=$2
    nvim --server 127.0.0.1:$port --remote-expr "$expr" 2>/dev/null
}

# Function to send command to Neovim
send_nvim_cmd() {
    local port=$1
    local cmd=$2
    nvim --server 127.0.0.1:$port --remote-send "$cmd" 2>/dev/null
}

# Function to check if port is active
is_port_active() {
    lsof -i :$1 >/dev/null 2>&1
}

# Function to display session info
display_session_info() {
    clear
    echo -e "${BLUE}=== Neovim Session Monitor ===${NC}"
    echo -e "Last Update: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # Check Zellij sessions
    if command -v zellij &> /dev/null; then
        echo -e "${YELLOW}Zellij Sessions:${NC}"
        zellij list-sessions 2>/dev/null | grep -v "EXITED" | head -5 || echo "  No active Zellij sessions"
        echo ""
    fi
    
    # Check Neovim instances
    echo -e "${YELLOW}Neovim Instances:${NC}"
    echo ""
    
    local active_count=0
    local instance_data="["
    local first=true
    
    for port in "${PORTS[@]}"; do
        if is_port_active $port; then
            ((active_count++))
            
            # Get instance info
            local desc=$(get_port_description $port)
            local file=$(query_nvim $port 'expand("%:p")')
            local line=$(query_nvim $port 'line(".")')
            local col=$(query_nvim $port 'col(".")')
            local mode=$(query_nvim $port 'mode()')
            local modified=$(query_nvim $port '&modified ? "modified" : "saved"')
            local buf_count=$(query_nvim $port 'len(getbufinfo({"buflisted": 1}))')
            
            # Display info
            echo -e "  ${GREEN}● Port $port${NC} - $desc"
            if [ -n "$file" ]; then
                echo -e "    File: $file"
                echo -e "    Position: Line $line, Col $col | Status: $modified"
                echo -e "    Buffers: $buf_count"
            else
                echo -e "    File: [No file]"
            fi
            echo ""
            
            # Add to JSON data
            if [ "$first" = false ]; then
                instance_data+=","
            fi
            first=false
            instance_data+="{\"port\":$port,\"description\":\"$desc\",\"file\":\"$file\",\"line\":$line,\"col\":$col,\"modified\":\"$modified\",\"buffers\":$buf_count}"
        fi
    done
    
    instance_data+="]"
    
    if [ $active_count -eq 0 ]; then
        echo -e "  ${RED}No active Neovim instances found${NC}"
        echo ""
    fi
    
    # Save current state
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"instances\":$instance_data}" > "$STATUS_FILE"
    
    # Show recent commands if log exists
    if [ -f "$LOG_FILE" ] && [ -s "$LOG_FILE" ]; then
        echo -e "${YELLOW}Recent Commands:${NC}"
        tail -5 "$LOG_FILE" | while IFS='|' read -r timestamp port cmd; do
            echo -e "  ${BLUE}[$timestamp]${NC} Port $port: $cmd"
        done
        echo ""
    fi
    
    # Show quick commands
    echo -e "${YELLOW}Quick Commands:${NC}"
    echo "  1. Broadcast status:    ./nvim-broadcast.sh \"Status: Working on feature X\""
    echo "  2. Log command:        ./nvim-command.sh 7001 ':Telescope find_files<CR>'"
    echo "  3. Query all files:    ./nvim-query-all.sh"
    echo ""
    echo -e "${BLUE}Press Ctrl+C to exit${NC}"
}

# Function for continuous monitoring
monitor_mode() {
    while true; do
        display_session_info
        sleep 2
    done
}

# Function for single run
single_run() {
    display_session_info
    
    # Also output JSON to stdout for programmatic access
    if [ -f "$STATUS_FILE" ]; then
        echo ""
        echo "JSON Output:"
        cat "$STATUS_FILE"
    fi
}

# Parse arguments
case "${1:-}" in
    "--watch"|"-w")
        monitor_mode
        ;;
    "--json"|"-j")
        if [ -f "$STATUS_FILE" ]; then
            cat "$STATUS_FILE"
        else
            echo '{"error": "No status file found"}'
        fi
        ;;
    *)
        single_run
        ;;
esac