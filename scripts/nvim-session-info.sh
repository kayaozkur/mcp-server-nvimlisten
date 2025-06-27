#!/bin/bash

# Neovim Session Discovery Tool
# Shows running Neovim instances and their status

echo "=== Neovim Session Discovery ==="
echo ""

# Check for running Neovim instances on known ports
PORTS=(7001 7002 7777 7778 7779 8001 8002 8003)

echo "Checking for Neovim instances..."
echo ""

found_any=false

for port in "${PORTS[@]}"; do
    if lsof -i :$port >/dev/null 2>&1; then
        found_any=true
        echo "✓ Port $port: ACTIVE"
        
        # Try to get current file
        current_file=$(nvim --server 127.0.0.1:$port --remote-expr 'expand("%:p")' 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$current_file" ]; then
            echo "  Current file: $current_file"
        fi
        
        # Try to get current line
        current_line=$(nvim --server 127.0.0.1:$port --remote-expr 'line(".")' 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$current_line" ]; then
            echo "  Current line: $current_line"
        fi
        
        echo ""
    fi
done

if [ "$found_any" = false ]; then
    echo "No active Neovim instances found on standard ports."
    echo ""
fi

# Check for Zellij sessions
echo "=== Zellij Sessions ==="
echo ""

if command -v zellij &> /dev/null; then
    zellij list-sessions 2>/dev/null | grep -E "(claude|nvim)" || echo "No relevant Zellij sessions found."
else
    echo "Zellij not installed."
fi

echo ""
echo "=== Quick Connect Commands ==="
echo ""
echo "# Send command to main editor:"
echo "nvim --server 127.0.0.1:7001 --remote-send ':echo \"Hello\"<CR>'"
echo ""
echo "# Open file in main editor:"
echo "nvim --server 127.0.0.1:7001 --remote-send ':e /path/to/file<CR>'"
echo ""
echo "# Query current file:"
echo "nvim --server 127.0.0.1:7001 --remote-expr 'expand(\"%:p\")'"
echo ""

# Create a state file with current session info
STATE_FILE="/tmp/nvim-session-state.json"
echo "{" > "$STATE_FILE"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"," >> "$STATE_FILE"
echo "  \"instances\": [" >> "$STATE_FILE"

first=true
for port in "${PORTS[@]}"; do
    if lsof -i :$port >/dev/null 2>&1; then
        if [ "$first" = false ]; then
            echo "," >> "$STATE_FILE"
        fi
        first=false
        
        current_file=$(nvim --server 127.0.0.1:$port --remote-expr 'expand("%:p")' 2>/dev/null || echo "")
        current_line=$(nvim --server 127.0.0.1:$port --remote-expr 'line(".")' 2>/dev/null || echo "0")
        
        echo -n "    {\"port\": $port, \"file\": \"$current_file\", \"line\": $current_line}" >> "$STATE_FILE"
    fi
done

echo "" >> "$STATE_FILE"
echo "  ]" >> "$STATE_FILE"
echo "}" >> "$STATE_FILE"

echo "Session state saved to: $STATE_FILE"