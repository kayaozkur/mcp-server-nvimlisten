#!/bin/bash

# Query All Neovim Instances
# Gets current state from all running Neovim instances

# Configuration
PORTS=(7001 7002 7777 7778 7779)
STATE_DIR="/tmp/nvim-mcp-state"
SNAPSHOT_FILE="$STATE_DIR/snapshot.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create state directory
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

echo -e "${BLUE}=== Querying All Neovim Instances ===${NC}"
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Start JSON output
JSON_OUTPUT='{"timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'","instances":['
FIRST=true

for port in "${PORTS[@]}"; do
    if lsof -i :$port >/dev/null 2>&1; then
        DESC=$(get_port_description $port)
        echo -e "${GREEN}● Port $port${NC} - $DESC"
        
        # Query various information
        FILE=$(nvim --server 127.0.0.1:$port --remote-expr 'expand("%:p")' 2>/dev/null || echo "")
        LINE=$(nvim --server 127.0.0.1:$port --remote-expr 'line(".")' 2>/dev/null || echo "0")
        COL=$(nvim --server 127.0.0.1:$port --remote-expr 'col(".")' 2>/dev/null || echo "0")
        MODE=$(nvim --server 127.0.0.1:$port --remote-expr 'mode()' 2>/dev/null || echo "")
        MODIFIED=$(nvim --server 127.0.0.1:$port --remote-expr '&modified' 2>/dev/null || echo "0")
        BUFFERS=$(nvim --server 127.0.0.1:$port --remote-expr 'len(getbufinfo({"buflisted": 1}))' 2>/dev/null || echo "0")
        CWD=$(nvim --server 127.0.0.1:$port --remote-expr 'getcwd()' 2>/dev/null || echo "")
        
        # Get buffer list
        BUFFER_LIST=$(nvim --server 127.0.0.1:$port --remote-expr 'join(map(getbufinfo({"buflisted": 1}), "v:val.name"), ",")' 2>/dev/null || echo "")
        
        # Display information
        echo "  Current file: ${FILE:-[No file]}"
        echo "  Position: Line $LINE, Column $COL"
        echo "  Modified: $([ "$MODIFIED" = "1" ] && echo "Yes" || echo "No")"
        echo "  Working dir: $CWD"
        echo "  Open buffers: $BUFFERS"
        
        if [ -n "$BUFFER_LIST" ] && [ "$BUFFER_LIST" != "" ]; then
            echo "  Buffer list:"
            IFS=',' read -ra BUFFERS_ARRAY <<< "$BUFFER_LIST"
            for buf in "${BUFFERS_ARRAY[@]}"; do
                echo "    - $(basename "$buf")"
            done
        fi
        
        echo ""
        
        # Add to JSON
        if [ "$FIRST" = false ]; then
            JSON_OUTPUT+=','
        fi
        FIRST=false
        
        # Escape strings for JSON
        FILE_ESC=$(echo "$FILE" | sed 's/"/\\"/g')
        CWD_ESC=$(echo "$CWD" | sed 's/"/\\"/g')
        BUFFER_LIST_ESC=$(echo "$BUFFER_LIST" | sed 's/"/\\"/g')
        
        JSON_OUTPUT+='{"port":'$port',"description":"'$DESC'","file":"'$FILE_ESC'","line":'$LINE',"col":'$COL',"modified":'$([ "$MODIFIED" = "1" ] && echo "true" || echo "false")',"buffers":'$BUFFERS',"cwd":"'$CWD_ESC'","bufferList":"'$BUFFER_LIST_ESC'"}'
    fi
done

JSON_OUTPUT+=']}'

# Save snapshot
echo "$JSON_OUTPUT" > "$SNAPSHOT_FILE"

# Summary
echo -e "${YELLOW}Summary:${NC}"
ACTIVE_COUNT=$(echo "$JSON_OUTPUT" | grep -o '"port":' | wc -l)
echo "  Active instances: $ACTIVE_COUNT"
echo "  Snapshot saved to: $SNAPSHOT_FILE"
echo ""

# Show quick actions
echo -e "${YELLOW}Quick Actions:${NC}"
echo "  View snapshot: cat $SNAPSHOT_FILE | jq ."
echo "  Monitor live: ./nvim-session-monitor.sh --watch"
echo "  Send command: ./nvim-command.sh <port> '<command>'"
echo "  Broadcast: ./nvim-broadcast.sh '<message>'"