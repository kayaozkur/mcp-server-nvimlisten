#!/bin/bash

# Port Checker for MCP Neovim Servers
# Ensures consistency between mcp-server-nvim and mcp-server-nvimlisten

echo "=== MCP Neovim Port Checker ==="
echo ""

# Standard ports
PORTS=(7001 7002 7777 7003 7004 7778 7779)
PORT_NAMES=(
    "Main Editor"
    "Navigator/Explorer"
    "Broadcast/Status"
    "Extra Editor 1"
    "Extra Editor 2"
    "Secondary Broadcast"
    "Tertiary Broadcast"
)

echo "Standard Port Configuration:"
echo "----------------------------"
for i in "${!PORTS[@]}"; do
    port=${PORTS[$i]}
    name=${PORT_NAMES[$i]}
    printf "Port %-5s : %s\n" "$port" "$name"
done

echo ""
echo "Checking Current Usage:"
echo "----------------------"

for i in "${!PORTS[@]}"; do
    port=${PORTS[$i]}
    name=${PORT_NAMES[$i]}
    
    if lsof -i :$port >/dev/null 2>&1; then
        process=$(lsof -i :$port | grep LISTEN | awk '{print $1}' | head -1)
        echo "✓ Port $port ($name) - IN USE by $process"
    else
        echo "✗ Port $port ($name) - FREE"
    fi
done

echo ""
echo "Quick Commands:"
echo "--------------"
echo "Start basic setup (3 instances):"
echo "  nvim --listen 127.0.0.1:7001 &  # Main"
echo "  nvim --listen 127.0.0.1:7002 &  # Navigator"
echo "  nvim --listen 127.0.0.1:7777 &  # Broadcast"
echo ""
echo "Kill all Neovim listeners:"
echo "  pkill -f 'nvim.*--listen'"
echo ""
echo "Test connection:"
echo "  nvim --server 127.0.0.1:7001 --remote-send ':echo \"Connected\"<CR>'"