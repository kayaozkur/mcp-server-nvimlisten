#!/bin/bash
# Yazi integration for Claude Dev Enhanced

# Yazi with editor integration
yazi_to_vim() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
    
    # If a file was selected, open it in main editor
    if [[ -f "$cwd" ]]; then
        nvim --server 127.0.0.1:7001 --remote "$cwd"
    fi
}

# Yazi project browser
yazi_projects() {
    echo "🚀 Opening Yazi in project directories..."
    local project_dirs=(
        ~/Desktop
        ~/Documents
        ~/Projects
        ~/Code
        ~/Developer
    )
    
    # Find the first existing directory
    for dir in "${project_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            yazi "$dir"
            break
        fi
    done
}

# Yazi with preview in specific Neovim instance
yazi_preview() {
    local selected
    local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    
    # Run yazi and capture the path
    yazi "$@" --cwd-file="$tmp"
    
    if selected="$(cat -- "$tmp")" && [ -n "$selected" ]; then
        if [[ -f "$selected" ]]; then
            # Open in diff viewer for preview
            nvim --server 127.0.0.1:7003 --remote "$selected"
            echo "📄 Opened $selected in diff viewer (port 7003)"
        elif [[ -d "$selected" ]]; then
            cd "$selected"
            echo "📁 Changed to directory: $selected"
        fi
    fi
    
    rm -f -- "$tmp"
}

# Export functions
export -f yazi_to_vim
export -f yazi_projects
export -f yazi_preview

# Aliases
alias y='yazi'
alias yv='yazi_to_vim'
alias yp='yazi_projects'
alias ypr='yazi_preview'

echo "🎯 Yazi integration loaded!"
echo "Commands:"
echo "  y   - Launch yazi"
echo "  yv  - Yazi with vim integration" 
echo "  yp  - Yazi project browser"
echo "  ypr - Yazi with preview in diff viewer"