#!/bin/bash
# Claude Project Switcher - Smart project navigation using atuin history

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Get project directories from various sources
get_project_dirs() {
    {
        # Git repositories in common locations
        fd -H -t d -d 3 ".git$" ~/Desktop ~/Documents ~/Projects ~/Code ~/Developer 2>/dev/null | xargs dirname 2>/dev/null
        
        # Recent cd commands from atuin
        atuin history list --limit 2000 --format "{command}" | \
            grep -E "^cd " | \
            awk '{print $2}' | \
            grep -E "^(/|~)" | \
            sed "s|^~|$HOME|" | \
            xargs -I {} sh -c 'test -d "{}" && echo "{}"' 2>/dev/null
        
        # Directories with package.json, Cargo.toml, go.mod, etc.
        fd -H -t f -d 3 "(package\.json|Cargo\.toml|go\.mod|Gemfile|requirements\.txt|pyproject\.toml)" ~/Desktop ~/Documents ~/Projects 2>/dev/null | xargs dirname 2>/dev/null
    } | sort -u | grep -v "^$"
}

# Get project info
get_project_info() {
    local dir="$1"
    local info=""
    
    # Check project type
    if [[ -f "$dir/package.json" ]]; then
        info="${info}📦 Node.js "
    fi
    if [[ -f "$dir/Cargo.toml" ]]; then
        info="${info}🦀 Rust "
    fi
    if [[ -f "$dir/go.mod" ]]; then
        info="${info}🐹 Go "
    fi
    if [[ -f "$dir/requirements.txt" ]] || [[ -f "$dir/pyproject.toml" ]]; then
        info="${info}🐍 Python "
    fi
    if [[ -d "$dir/.git" ]]; then
        # Get git info
        local branch=$(cd "$dir" && git branch --show-current 2>/dev/null)
        local status=$(cd "$dir" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        info="${info}📚 git:$branch"
        [[ $status -gt 0 ]] && info="${info} (${status} changes)"
    fi
    
    echo "$info"
}

# Main switcher
echo -e "${PURPLE}🚀 Claude Project Switcher${NC}"
echo -e "${BLUE}Scanning for projects...${NC}"

# Get projects with preview
PROJECT=$(get_project_dirs | \
    fzf --preview 'echo "📁 {}" && echo "━━━━━━━━━━━━━━━━━━━━━" && \
                   echo "Type: $(get_project_info {})" && \
                   echo "" && \
                   lsd -la --header {} | head -15' \
        --preview-window='right:60%:wrap' \
        --header='Select project to switch to' \
        --prompt='Project > ')

if [[ -n "$PROJECT" ]]; then
    echo -e "${GREEN}Switching to: $PROJECT${NC}"
    cd "$PROJECT"
    
    # Update all Neovim instances with the new directory
    echo -e "${YELLOW}Updating editors...${NC}"
    
    # Log to broadcast
    nvim --server 127.0.0.1:7777 --remote-send ":put =strftime('%H:%M:%S') . ' - Switched to project: $PROJECT'<CR>" 2>/dev/null
    
    # Open project in main editor
    nvim --server 127.0.0.1:7001 --remote-send ":cd $PROJECT<CR>:e .<CR>" 2>/dev/null
    
    # Update navigator
    nvim --server 127.0.0.1:7002 --remote-send ":cd $PROJECT<CR>" 2>/dev/null
    
    # Show project info
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Project: ${GREEN}$(basename "$PROJECT")${NC}"
    echo -e "Path: $PROJECT"
    echo -e "Info: $(get_project_info "$PROJECT")"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Show directory contents
    lsd -la --header --group-dirs first | head -20
    
    # Export for subshells
    export CLAUDE_CURRENT_PROJECT="$PROJECT"
    
    # If in zsh, update the prompt
    if [[ -n "$ZSH_VERSION" ]]; then
        exec zsh
    else
        exec bash
    fi
else
    echo -e "${YELLOW}No project selected${NC}"
fi