#!/bin/bash
# Claude Terminal Bridge - Execute commands in visible terminal pane

# Function to send commands to terminal using Zellij actions
send_to_terminal() {
    local command="$1"
    
    # Send command characters
    zellij action write-chars "$command"
    
    # Send Enter key
    zellij action write-chars $'\n'
}

# Function to log command to command history
log_command() {
    local command="$1"
    nvim --server 127.0.0.1:7004 --remote-send ":put =strftime('%H:%M:%S') . ' $ $command'<CR>"
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

command="$*"

# Log to broadcast that we're executing a command
nvim --server 127.0.0.1:7777 --remote-send ":put =strftime('%H:%M:%S') . ' - Executing: $command'<CR>"

# Log command to command history
log_command "$command"

# Also append to file for persistence
echo "[$(date +%H:%M:%S)] $ $command" >> /tmp/claude-commands.log

# Send to terminal
send_to_terminal "$command"

echo "Command sent to terminal: $command"