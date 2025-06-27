#!/bin/bash
# MCP Neovim Listen Server - Dependency Installer
# This script installs all required and optional dependencies

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/redhat-release ]]; then
        echo "redhat"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew (macOS)
install_homebrew() {
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        log_success "Homebrew installed"
    else
        log_success "Homebrew already installed"
    fi
}

# Install dependencies based on OS
install_dependencies() {
    local os=$1
    
    case $os in
        macos)
            install_homebrew
            log_info "Installing dependencies via Homebrew..."
            
            # Required
            brew install neovim || true
            brew install node || true
            
            # Optional but recommended
            brew install zellij || true
            brew install tmux || true
            brew install python3 || true
            brew install ripgrep || true
            brew install fd || true
            brew install fzf || true
            brew install lsd || true
            brew install bat || true
            brew install git-delta || true
            brew install btop || true
            brew install emacs || true
            
            # Shell enhancements
            brew install atuin || true
            brew install starship || true
            ;;
            
        debian)
            log_info "Installing dependencies via apt..."
            sudo apt update
            
            # Required
            sudo apt install -y neovim nodejs npm
            
            # Optional
            sudo apt install -y tmux python3 python3-pip ripgrep fd-find fzf
            
            # Install Zellij
            if ! command_exists zellij; then
                log_info "Installing Zellij..."
                curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz
                sudo mv zellij /usr/local/bin
            fi
            
            # Install lsd
            if ! command_exists lsd; then
                log_info "Installing lsd..."
                wget https://github.com/lsd-rs/lsd/releases/latest/download/lsd-musl_x86_64.deb
                sudo dpkg -i lsd-musl_x86_64.deb
                rm lsd-musl_x86_64.deb
            fi
            ;;
            
        arch)
            log_info "Installing dependencies via pacman..."
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm neovim nodejs npm zellij tmux python ripgrep fd fzf lsd bat git-delta btop emacs
            ;;
            
        *)
            log_error "Unsupported OS. Please install dependencies manually."
            exit 1
            ;;
    esac
}

# Install Python packages
install_python_packages() {
    log_info "Installing Python packages..."
    
    if command_exists pip3; then
        pip3 install --user pynvim || log_warning "Failed to install pynvim"
        pip3 install --user neovim-remote || log_warning "Failed to install neovim-remote"
    else
        log_warning "pip3 not found, skipping Python packages"
    fi
}

# Install Node.js packages
install_node_packages() {
    log_info "Installing Node.js packages..."
    
    if command_exists npm; then
        npm install -g neovim || log_warning "Failed to install neovim npm package"
        npm install -g typescript typescript-language-server || log_warning "Failed to install TypeScript tools"
    else
        log_warning "npm not found, skipping Node packages"
    fi
}

# Setup Neovim
setup_neovim() {
    log_info "Setting up Neovim..."
    
    # Check if NvChad should be installed
    if [[ ! -d "$HOME/.config/nvim" ]] || [[ "$1" == "--nvchad" ]]; then
        log_info "Installing NvChad..."
        
        # Backup existing config
        if [[ -d "$HOME/.config/nvim" ]]; then
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
            log_info "Backed up existing Neovim config"
        fi
        
        # Clone NvChad
        git clone https://github.com/NvChad/NvChad "$HOME/.config/nvim" --depth 1
        
        # Copy our custom config
        if [[ -d "templates/nvchad" ]]; then
            log_info "Applying MCP custom configuration..."
            cp -r templates/nvchad/* "$HOME/.config/nvim/"
        fi
        
        log_success "NvChad installed"
    else
        log_info "Neovim config already exists. Use --nvchad flag to reinstall."
    fi
}

# Setup Zellij
setup_zellij() {
    log_info "Setting up Zellij layouts..."
    
    mkdir -p "$HOME/.config/zellij/layouts"
    
    if [[ -d "templates/zellij/layouts" ]]; then
        cp templates/zellij/layouts/*.kdl "$HOME/.config/zellij/layouts/"
        log_success "Zellij layouts installed"
    fi
}

# Setup Emacs
setup_emacs() {
    log_info "Setting up Emacs..."
    
    if [[ ! -d "$HOME/.emacs.d" ]] || [[ "$1" == "--emacs" ]]; then
        # Backup existing config
        if [[ -d "$HOME/.emacs.d" ]]; then
            mv "$HOME/.emacs.d" "$HOME/.emacs.d.backup.$(date +%s)"
            log_info "Backed up existing Emacs config"
        fi
        
        mkdir -p "$HOME/.emacs.d"
        
        if [[ -f "templates/emacs/init.el" ]]; then
            cp templates/emacs/init.el "$HOME/.emacs.d/"
            log_success "Emacs config installed"
        fi
        
        # Start Emacs daemon
        if command_exists emacs; then
            emacs --daemon=claude-server 2>/dev/null || true
            log_success "Emacs daemon started"
        fi
    else
        log_info "Emacs config already exists. Use --emacs flag to reinstall."
    fi
}

# Health check
health_check() {
    log_info "Running health check..."
    echo
    
    # Required tools
    echo "Required Dependencies:"
    for cmd in nvim node npm; do
        if command_exists "$cmd"; then
            log_success "$cmd is installed"
        else
            log_error "$cmd is NOT installed (required)"
        fi
    done
    
    echo
    echo "Optional Dependencies:"
    
    # Optional tools
    for cmd in zellij tmux python3 pip3 rg fd fzf lsd bat delta btop emacs atuin; do
        if command_exists "$cmd"; then
            log_success "$cmd is installed"
        else
            log_warning "$cmd is not installed (optional)"
        fi
    done
    
    echo
    echo "Python Packages:"
    
    # Check Python packages
    if command_exists python3; then
        if python3 -c "import pynvim" 2>/dev/null; then
            log_success "pynvim is installed"
        else
            log_warning "pynvim is not installed"
        fi
    fi
    
    echo
    echo "Configuration Files:"
    
    # Check configs
    [[ -d "$HOME/.config/nvim" ]] && log_success "Neovim config exists" || log_warning "Neovim config not found"
    [[ -d "$HOME/.config/zellij" ]] && log_success "Zellij config exists" || log_warning "Zellij config not found"
    [[ -d "$HOME/.emacs.d" ]] && log_success "Emacs config exists" || log_warning "Emacs config not found"
    
    echo
}

# Main installation flow
main() {
    log_info "MCP Neovim Listen Server - Dependency Installer"
    echo
    
    local os=$(detect_os)
    log_info "Detected OS: $os"
    echo
    
    # Parse arguments
    local install_all=false
    local nvchad_flag=""
    local emacs_flag=""
    
    for arg in "$@"; do
        case $arg in
            --all) install_all=true ;;
            --nvchad) nvchad_flag="--nvchad" ;;
            --emacs) emacs_flag="--emacs" ;;
            --check-only) health_check; exit 0 ;;
        esac
    done
    
    if [[ "$install_all" == true ]] || [[ "$os" != "unknown" ]]; then
        install_dependencies "$os"
        install_python_packages
        install_node_packages
        setup_neovim "$nvchad_flag"
        setup_zellij
        setup_emacs "$emacs_flag"
    fi
    
    echo
    health_check
    
    echo
    log_success "Installation complete!"
    echo
    echo "Next steps:"
    echo "1. Start Neovim and let plugins install: nvim"
    echo "2. Run the environment: start-claude-dev-enhanced.sh"
    echo "3. Configure Claude Code to use this MCP server"
}

# Run main
main "$@"