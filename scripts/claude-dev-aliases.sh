#!/bin/bash
# Claude Dev Smart Aliases - Power tools combining fzf, atuin, lsd, and more

# ── Directory Navigation ──
# Fuzzy cd using fd/fzf
fcd() {
    local dir
    dir=$(fd --type d --hidden --exclude .git 2>/dev/null | fzf --preview 'lsd -la --header {}' --header "Select directory") && cd "$dir"
}

# Fuzzy cd to recent directories from history
fcdh() {
    local dir
    dir=$(atuin history list --limit 1000 --format "{command}" | \
          grep -E "^cd " | \
          awk '{print $2}' | \
          grep -v "^-" | \
          sort -u | \
          tail -20 | \
          fzf --preview 'lsd -la --header {}' --header "Recent directories") && cd "$dir"
}

# Interactive directory browser with lsd
lsdi() {
    while true; do
        local selection
        selection=$(lsd -la --header --group-dirs first | \
            tail -n +4 | \
            fzf --header "Current: $(pwd) | Enter: cd into dir | Ctrl-C: exit" \
                --preview '[[ -d {} ]] && lsd -la --header {} || head -50 {}')
        
        [[ -z "$selection" ]] && break
        
        # Extract just the filename from lsd output
        local name=$(echo "$selection" | awk '{print $NF}')
        
        if [[ -d "$name" ]]; then
            cd "$name"
        else
            echo "Selected file: $name"
            break
        fi
    done
}

# ── File Operations ──
# Fuzzy file open in Neovim
fvim() {
    local file
    file=$(fd --type f --hidden --exclude .git 2>/dev/null | \
           fzf --preview 'head -50 {}' --header "Select file to edit") && \
           nvim --server 127.0.0.1:7001 --remote "$file"
}

# Fuzzy grep with ripgrep and fzf
fzgrep() {
    local result
    result=$(rg --line-number --no-heading --color=always "${1:-.}" | \
             fzf --ansi --delimiter ':' \
                 --preview 'head -50 {1}' \
                 --preview-window 'right:50%:+{2}-5' \
                 --header "Search results for: ${1:-.}")
    
    if [[ -n "$result" ]]; then
        local file=$(echo "$result" | cut -d: -f1)
        local line=$(echo "$result" | cut -d: -f2)
        nvim --server 127.0.0.1:7001 --remote "+$line" "$file"
    fi
}

# ── Process Management ──
# Fuzzy process killer
fkill() {
    local pid
    pid=$(ps aux | fzf --header "Select process to kill" | awk '{print $2}')
    if [[ -n "$pid" ]]; then
        echo "Killing process $pid"
        kill -9 "$pid"
    fi
}

# ── Git Operations ──
# Fuzzy git branch switcher
fgb() {
    local branch
    branch=$(git branch -a | \
             grep -v HEAD | \
             sed 's/.* //' | \
             sed 's#remotes/[^/]*/##' | \
             sort -u | \
             fzf --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | sed s/^..// )' \
                 --header "Select branch to checkout")
    [[ -n "$branch" ]] && git checkout "$branch"
}

# Fuzzy git log browser
fgl() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs git show --color=always' \
        --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs git show --color=always | less -R"
}

# ── History Operations ──
# Fuzzy command history search with execution
fh() {
    local cmd
    cmd=$(atuin history list --limit 1000 --format "{time} | {command}" | \
          fzf --tac --no-sort --header "Select command to execute" | \
          sed 's/^[^|]*| //')
    [[ -n "$cmd" ]] && eval "$cmd"
}

# ── Claude Dev Specific ──
# Quick jump to any Neovim pane with file selection
vjump() {
    local pane=$(echo -e "7001 - Main Editor\n7002 - Navigator\n7003 - Diff Viewer\n7777 - Broadcast\n7004 - Command History" | \
                 fzf --header "Select Neovim instance")
    
    if [[ -n "$pane" ]]; then
        local port=$(echo "$pane" | cut -d' ' -f1)
        local file=$(fd --type f --hidden --exclude .git 2>/dev/null | \
                     fzf --preview 'head -50 {}' --header "Select file to open")
        [[ -n "$file" ]] && nvim --server 127.0.0.1:$port --remote "$file"
    fi
}

# Quick status check
cstatus() {
    echo "🔍 Claude Dev Status Check"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Neovim Instances:"
    lsof -i :7001-7004,7777 | grep LISTEN | awk '{print "  ✓", $9}'
    echo ""
    echo "Emacs:"
    ps aux | grep -E "emacs.*daemon.*claude" | grep -v grep > /dev/null && echo "  ✓ Running" || echo "  ✗ Not running"
    echo ""
    echo "Recent Commands:"
    tail -5 /tmp/claude-commands.log 2>/dev/null | sed 's/^/  /'
}

# ── Yazi Integration ──
# Yazi with cd on exit
yz() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ── Export Aliases ──
alias cp='~/Desktop/claude-command-palette.sh'  # Quick access to command palette
alias la='lsd -la --header --group-dirs first'
alias lat='lsd -la --tree --depth 2'
alias ..='cd ..'
alias ...='cd ../..'
alias y='yazi'  # Quick yazi launch

# Source SSH tools if available
[[ -f ~/Desktop/claude-ssh-tools.sh ]] && source ~/Desktop/claude-ssh-tools.sh

echo "🚀 Claude Dev aliases loaded! Try: fcd, fvim, fzgrep, lsdi, cp, y (yazi), sshf, netm"