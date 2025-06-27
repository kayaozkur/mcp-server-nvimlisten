#!/bin/bash

# Kill any existing processes
pkill -f "emacs --daemon"
pkill -f "nvim --listen"
sleep 1

# Start Emacs daemon
echo "Starting Emacs daemon..."
emacs --daemon=claude-server
sleep 3

# Test Emacs connection
echo "Testing Emacs connection..."
emacsclient -s claude-server -e '(message "Emacs server ready!")'

# Export terminal bridge and tools for Claude
export CLAUDE_TERMINAL_BRIDGE="/Users/kayaozkur/Desktop/claude-terminal-bridge.sh"
export CLAUDE_ALIASES="/Users/kayaozkur/Desktop/claude-dev-aliases.sh"

# Source aliases if in interactive shell
[[ $- == *i* ]] && source "$CLAUDE_ALIASES"

# Create a startup log file for command history
echo "[$(date +%H:%M:%S)] Claude Dev Session Started" > /tmp/claude-commands.log

# Start Zellij with enhanced layout
clear
echo "🚀 Claude Enhanced Development Environment"
echo "=========================================="
echo ""
echo "📊 Layout Features:"
echo "  ├─ 3 Neovim editors (ports 7001, 7002, 7003)"
echo "  ├─ 2 Terminal panes:"
echo "  │  ├─ Main: Interactive commands (pane 5)"
echo "  │  └─ Monitor: btop system monitor (pane 6)"
echo "  ├─ Command history logger (port 7004)"
echo "  ├─ Git status with diff stats (auto-refresh)"
echo "  └─ Broadcast log (port 7777)"
echo ""
echo "🛠  Enhanced with your tools:"
echo "  ├─ atuin: Shell history search (Ctrl+R)"
echo "  ├─ btop: System monitor (auto-starts in pane 6)"
echo "  ├─ fzf: Fuzzy finder integration"
echo "  ├─ lsd: Better directory listings"
echo "  └─ broot: Advanced file navigation"
echo ""
echo "⌨️  Key Shortcuts:"
echo "  ├─ Ctrl+p: Pane navigation mode"
echo "  ├─ Ctrl+s: Scroll mode"
echo "  └─ Ctrl+r: Atuin history search"
echo ""
echo "Press Enter to launch..."
read -r

zellij --layout claude-dev-enhanced

# Cleanup on exit
echo "Cleaning up..."
pkill -f "nvim --listen"
pkill -f "emacs --daemon"