#!/bin/bash
# Claude SSH & Network Tools Integration

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# SSH Config Manager - fuzzy search SSH hosts
fssh() {
    local host
    host=$(grep "^Host " ~/.ssh/config 2>/dev/null | \
           grep -v "[?*]" | \
           cut -d " " -f 2- | \
           fzf --preview 'grep -A 5 "^Host {}" ~/.ssh/config' \
               --header "Select SSH host to connect")
    
    if [[ -n "$host" ]]; then
        echo -e "${GREEN}Connecting to $host...${NC}"
        ssh "$host"
    fi
}

# Recent SSH connections from history
fssh_history() {
    local cmd
    cmd=$(atuin history list --limit 500 --format "{command}" | \
          grep "^ssh " | \
          grep -v "ssh-" | \
          sort -u | \
          fzf --header "Recent SSH connections")
    
    if [[ -n "$cmd" ]]; then
        echo -e "${BLUE}Executing: $cmd${NC}"
        eval "$cmd"
    fi
}

# Termscp launcher with saved connections
ftermscp() {
    echo -e "${PURPLE}Launching termscp...${NC}"
    echo "Tips:"
    echo "  • Press <TAB> to switch panels"
    echo "  • Press <h> for help"
    echo "  • Press <c> to connect to saved bookmarks"
    echo ""
    termscp
}

# Quick SCP with fuzzy file selection
fscp() {
    local file
    local host
    local remote_path="${2:-~/}"
    
    # Select local file
    file=$(fd --type f --hidden --exclude .git | \
           fzf --preview 'head -50 {}' \
               --header "Select file to transfer")
    
    if [[ -z "$file" ]]; then
        return 1
    fi
    
    # Select host
    host=$(grep "^Host " ~/.ssh/config 2>/dev/null | \
           grep -v "[?*]" | \
           cut -d " " -f 2- | \
           fzf --header "Select destination host")
    
    if [[ -n "$host" ]]; then
        echo -e "${GREEN}Copying $file to $host:$remote_path${NC}"
        scp "$file" "$host:$remote_path"
    fi
}

# Port forwarding helper
fport() {
    local host
    local local_port
    local remote_port
    
    echo -e "${BLUE}SSH Port Forwarding Setup${NC}"
    echo -n "Local port: "
    read local_port
    echo -n "Remote port: "
    read remote_port
    
    host=$(grep "^Host " ~/.ssh/config 2>/dev/null | \
           grep -v "[?*]" | \
           cut -d " " -f 2- | \
           fzf --header "Select host for port forwarding")
    
    if [[ -n "$host" ]] && [[ -n "$local_port" ]] && [[ -n "$remote_port" ]]; then
        echo -e "${GREEN}Forwarding localhost:$local_port -> $host:$remote_port${NC}"
        ssh -L "$local_port:localhost:$remote_port" "$host"
    fi
}

# Network tools menu
network_menu() {
    local choice
    choice=$(echo -e "🌐 SSH Connect (fuzzy)\n📁 Termscp File Transfer\n🔌 Port Forwarding\n📡 MQTT UI\n🌍 Share Terminal (ttyd)\n🔗 Check Links (lychee)\n💾 Download Webpage (monolith)\n📊 Network Status" | \
             fzf --header "Network Tools Menu")
    
    case "$choice" in
        "🌐 SSH Connect"*)
            fssh
            ;;
        "📁 Termscp"*)
            ftermscp
            ;;
        "🔌 Port Forwarding"*)
            fport
            ;;
        "📡 MQTT UI"*)
            mqttui
            ;;
        "🌍 Share Terminal"*)
            echo -e "${YELLOW}Starting terminal sharing on port 7681...${NC}"
            echo "Access at: http://localhost:7681"
            ttyd -p 7681 zsh
            ;;
        "🔗 Check Links"*)
            echo -n "Enter URL or file to check: "
            read target
            lychee "$target"
            ;;
        "💾 Download Webpage"*)
            echo -n "Enter URL to download: "
            read url
            echo -n "Output filename: "
            read output
            monolith "$url" -o "$output"
            ;;
        "📊 Network Status"*)
            echo -e "${BLUE}Network Status:${NC}"
            echo "━━━━━━━━━━━━━━━━━━━━━━"
            networksetup -getinfo Wi-Fi 2>/dev/null || ip addr
            echo ""
            echo "Active connections:"
            lsof -i -n -P | grep ESTABLISHED | head -10
            ;;
    esac
}

# SSH key management
ssh_keys() {
    echo -e "${PURPLE}SSH Keys:${NC}"
    ls -la ~/.ssh/*.pub 2>/dev/null | awk '{print "  •", $9}'
    echo ""
    echo "Add key to agent: ssh-add ~/.ssh/[keyname]"
    echo "Copy public key: pbcopy < ~/.ssh/[keyname].pub"
}

# Export functions
export -f fssh
export -f fssh_history
export -f ftermscp
export -f fscp
export -f fport
export -f network_menu

# Aliases
alias sshf='fssh'                    # Fuzzy SSH
alias sshh='fssh_history'            # SSH from history
alias scpf='fscp'                    # Fuzzy SCP
alias tsc='ftermscp'                 # Termscp
alias netm='network_menu'            # Network tools menu
alias sshkeys='ssh_keys'             # Show SSH keys
alias ports='lsof -i -n -P | grep LISTEN'  # Show listening ports

echo "🌐 SSH & Network tools loaded! Try: sshf, tsc, netm"