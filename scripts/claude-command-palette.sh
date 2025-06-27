#!/bin/bash
# Claude Dev Command Palette - Interactive tool selector using fzf

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Main menu options
show_menu() {
    echo "📋 Claude Dev Command Palette" | fzf \
        --prompt="Select Tool > " \
        --header="Navigate with arrows, Enter to select, Esc to cancel" \
        --preview-window="right:50%:wrap" \
        --preview='echo "Tool Descriptions:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 File Explorer (lsd) - Browse with icons
📜 Command History (atuin) - Search all commands  
🔎 Fuzzy Find Files - Search project files
📊 Directory Tree - Visual file structure
🚀 Recent Projects - Jump to recent dirs
📝 Open in Editor - Quick file edit
🔄 Git Operations - Common git commands
💻 System Info - Quick system stats
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"' \
        <<EOF
🔍 File Explorer (lsd)
📜 Command History (atuin) 
🔎 Fuzzy Find Files
📊 Directory Tree
🚀 Recent Projects
📝 Open in Editor
🔄 Git Operations
💻 System Info
🗂️ Yazi File Manager
🌐 Network Tools
EOF
}

# Execute selected option
case $(show_menu) in
    "🔍 File Explorer (lsd)")
        echo -e "${BLUE}Browsing with lsd...${NC}"
        lsd -la --header --group-dirs first | fzf \
            --header="Select file/directory" \
            --preview='[[ -f {} ]] && head -50 {} || lsd -la {}' \
            --bind='enter:execute(echo "Selected: {}")+abort'
        ;;
        
    "📜 Command History (atuin)")
        echo -e "${GREEN}Searching command history...${NC}"
        # Use atuin's search interface
        atuin search --interactive
        ;;
        
    "🔎 Fuzzy Find Files")
        echo -e "${YELLOW}Finding files...${NC}"
        # Use fd if available, otherwise find
        if command -v fd &> /dev/null; then
            selected=$(fd --type f --hidden --exclude .git | fzf \
                --preview='head -50 {}' \
                --header="Select file to view")
        else
            selected=$(find . -type f -not -path "./.git/*" | fzf \
                --preview='head -50 {}' \
                --header="Select file to view")
        fi
        [[ -n $selected ]] && echo "Selected: $selected"
        ;;
        
    "📊 Directory Tree")
        echo -e "${BLUE}Directory structure:${NC}"
        # Show tree with lsd
        lsd --tree --depth 3 --group-dirs first | less
        ;;
        
    "🚀 Recent Projects")
        echo -e "${GREEN}Recent directories from history:${NC}"
        # Extract unique directories from atuin history
        atuin history list --limit 1000 --format "{command}" | \
            grep -E "^cd " | \
            awk '{print $2}' | \
            grep -v "^-" | \
            sort -u | \
            tail -20 | \
            fzf --preview='lsd -la --header {}' \
                --header="Select directory to jump to" \
                --bind='enter:execute(echo "cd {}")+abort'
        ;;
        
    "📝 Open in Editor")
        echo -e "${YELLOW}Select file to edit:${NC}"
        file=$(fd --type f --hidden --exclude .git 2>/dev/null || find . -type f | \
            fzf --preview='head -50 {}' \
                --header="Select file to open in main editor")
        if [[ -n $file ]]; then
            nvim --server 127.0.0.1:7001 --remote "$file"
            echo "Opened $file in main editor (port 7001)"
        fi
        ;;
        
    "🔄 Git Operations")
        git_cmd=$(echo -e "status\nlog --oneline -10\ndiff\nadd -p\ncommit\npush\npull" | \
            fzf --header="Select git command")
        [[ -n $git_cmd ]] && git $git_cmd
        ;;
        
    "💻 System Info")
        echo -e "${BLUE}System Information:${NC}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Directory: $(pwd)"
        echo "Files: $(lsd -1 | wc -l) items"
        echo "Disk: $(df -h . | tail -1 | awk '{print $4}') free"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        lsd -la --header --group-dirs first | head -20
        ;;
        
    "🗂️ Yazi File Manager")
        echo -e "${GREEN}Launching Yazi file manager...${NC}"
        # Check if yazi is installed
        if command -v yazi &> /dev/null; then
            yazi
        else
            echo "Yazi not found. Install with: brew install yazi"
        fi
        ;;
        
    "🌐 Network Tools")
        echo -e "${BLUE}Launching Network Tools Menu...${NC}"
        if [[ -f ~/Desktop/claude-ssh-tools.sh ]]; then
            source ~/Desktop/claude-ssh-tools.sh
            network_menu
        else
            echo "Network tools not found!"
        fi
        ;;
esac