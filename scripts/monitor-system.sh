#!/bin/bash
# System monitoring script for Claude Dev Enhanced

echo "=== Claude Dev System Monitor ==="
echo "Starting at $(date)"
echo "================================"

while true; do
    clear
    echo "=== System Status $(date +%H:%M:%S) ==="
    echo ""
    
    # Memory usage
    echo "Memory Usage:"
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
    echo ""
    
    # Disk usage
    echo "Disk Usage:"
    df -h / | grep -E "^/"
    echo ""
    
    # Process count
    echo "Process Stats:"
    echo "Total processes: $(ps aux | wc -l)"
    echo "Neovim instances: $(ps aux | grep -c "[n]vim --listen")"
    echo "Emacs running: $(ps aux | grep -c "[e]macs --daemon")"
    echo ""
    
    # Network
    echo "Network Listeners:"
    lsof -i -P | grep LISTEN | grep -E "(7001|7002|7003|7004|7777)" | awk '{print $1, $8, $9}'
    echo ""
    
    # Git status if in repo
    if [ -d .git ]; then
        echo "Git Status:"
        git status -sb | head -5
    fi
    
    sleep 5
done