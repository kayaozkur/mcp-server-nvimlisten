# Setup Guide for MCP Neovim Listen Server

## Overview

This guide helps you set up the MCP Neovim Listen Server for use with Claude Code. The server provides advanced Neovim control, terminal integration, and development environment management.

## Prerequisites

### Required
- **Node.js** 18.0 or higher
- **Neovim** 0.9.0 or higher
- **npm** or **yarn** package manager

### Optional (for full functionality)
- **Zellij** - Terminal multiplexer (recommended)
- **tmux** - Alternative to Zellij
- **Python 3** with `pynvim` package
- **fzf** - Fuzzy finder for interactive tools
- **ripgrep** (`rg`) - Fast search tool
- **fd** - Fast file finder
- **lsd** - Modern ls with icons (used in terminal)
- **bat** - Syntax highlighting for file preview
- **atuin** - Enhanced shell history

## Installation

### Option 1: Install from npm (when published)
```bash
npm install -g @mcp/server-nvimlisten
```

### Option 2: Install from source
```bash
# Clone the repository
git clone https://github.com/yourusername/mcp-server-nvimlisten
cd mcp-server-nvimlisten

# Install dependencies
npm install

# Build the project
npm run build

# Link globally
npm link
```

## Configuration

### 1. Add to Claude Code MCP Settings

Add the following to your Claude Code configuration:

```json
{
  "mcpServers": {
    "nvimlisten": {
      "command": "mcp-server-nvimlisten",
      "args": []
    }
  }
}
```

### 2. Install Optional Dependencies

#### macOS (using Homebrew)
```bash
# Core tools
brew install neovim zellij tmux

# Search and file tools
brew install ripgrep fd fzf lsd

# Shell enhancements
brew install atuin

# Python support
pip3 install pynvim
```

#### Linux (Ubuntu/Debian)
```bash
# Core tools
sudo apt update
sudo apt install neovim tmux

# Install Zellij
curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz
sudo mv zellij /usr/local/bin

# Search and file tools
sudo apt install ripgrep fd-find fzf

# Python support
pip3 install pynvim
```

## Environment Setup

### 1. Basic Neovim Configuration

Create a minimal Neovim config if you don't have one:

```bash
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.lua << 'EOF'
-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Enable mouse
vim.opt.mouse = 'a'

-- Better search
vim.opt.ignorecase = true
vim.opt.smartcase = true
EOF
```

### 2. Start Neovim Instances

For basic usage, start Neovim with listening ports:

```bash
# Main editor
nvim --listen 127.0.0.1:7001

# Navigator
nvim --listen 127.0.0.1:7002

# Broadcast/logs
nvim --listen 127.0.0.1:7777
```

### 3. Use the Enhanced Environment

For the full experience with Zellij:

```bash
# Start the enhanced environment
~/scripts/start-claude-dev-enhanced.sh
```

## Verification

### Test the MCP Server

1. Start the MCP server:
```bash
mcp-server-nvimlisten
```

2. In Claude Code, test basic connectivity:
```javascript
await use_mcp_tool("nvimlisten", "neovim-connect", {
  "port": 7001,
  "command": ":echo 'Hello from Claude!'<CR>"
});
```

### Check Dependencies

Run this command to see which optional tools are missing:

```bash
for cmd in nvim zellij tmux python3 fzf rg fd lsd atuin; do
  if command -v $cmd &> /dev/null; then
    echo "✓ $cmd installed"
  else
    echo "✗ $cmd missing"
  fi
done
```

## Troubleshooting

### Common Issues

1. **"Neovim not found"**
   - Ensure Neovim is installed and in your PATH
   - Try `which nvim` to verify

2. **"Cannot connect to port"**
   - Check if Neovim is running with `--listen`
   - Verify no firewall is blocking local connections

3. **"Script not found"**
   - Ensure the scripts directory is included in the package
   - Check file permissions on shell scripts

### Debug Mode

Set environment variable for verbose logging:

```bash
export MCP_DEBUG=true
mcp-server-nvimlisten
```

## Next Steps

1. Read the [Quick Reference](./Quick%20Reference.md) for keyboard shortcuts
2. Check [CLAUDE.md](./CLAUDE.md) for Claude-specific usage patterns
3. Explore the example workflows in the README

## Support

- Report issues: [GitHub Issues](https://github.com/yourusername/mcp-server-nvimlisten/issues)
- Documentation: [README.md](./README.md)
- Claude integration guide: [CLAUDE.md](./CLAUDE.md)