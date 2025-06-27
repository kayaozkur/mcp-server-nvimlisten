#!/bin/bash
# Developer activity monitor for Claude Dev Enhanced

echo "=== Development Activity Monitor ==="
echo "Tracking file changes and commands..."
echo "===================================="

# Set up file watchers
if command -v fswatch &> /dev/null; then
    echo "Using fswatch for file monitoring"
    
    # Monitor current directory
    fswatch -r . --exclude .git | while read path; do
        timestamp=$(date +%H:%M:%S)
        filename=$(basename "$path")
        
        # Log to key recorder
        nvim --server 127.0.0.1:7004 --remote-send ":put ='$timestamp [FILE] $filename modified'<CR>"
        
        # Also show in terminal
        echo "[$timestamp] FILE: $filename"
    done &
else
    echo "Install fswatch for file monitoring: brew install fswatch"
    
    # Fallback: Simple loop checking modification times
    while true; do
        find . -type f -mmin -1 -not -path "./.git/*" 2>/dev/null | while read file; do
            echo "[$(date +%H:%M:%S)] Recent change: $file"
        done
        sleep 10
    done
fi