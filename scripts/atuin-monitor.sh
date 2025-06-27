#!/bin/bash
# Atuin command history monitor for Claude Dev

echo "=== Atuin Command History Monitor ==="
echo "Real-time command tracking with statistics"
echo "====================================="

# Show initial stats
echo "Command Statistics:"
atuin stats | head -10
echo ""

# Monitor new commands in real-time
echo "Monitoring new commands (press Ctrl+C to stop):"
echo "---"

# Use atuin to show recent history and update
while true; do
    clear
    echo "=== Recent Commands (Last 20) ==="
    atuin history list --limit 20 --format "{time} | {command}" | tac
    
    echo ""
    echo "=== Top Commands Today ==="
    atuin stats --period 1d | head -5
    
    echo ""
    echo "=== Active Sessions ==="
    ps aux | grep -E "(nvim --listen|emacs --daemon|zellij)" | grep -v grep | awk '{print $11, $12, $13}'
    
    sleep 3
done