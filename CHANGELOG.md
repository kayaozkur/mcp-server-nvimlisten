# Changelog

## [0.1.0] - Initial Release

### Added
- Complete MCP server implementation for Neovim control
- Multi-instance Neovim orchestration support
- Terminal integration via Zellij
- Interactive file explorer with fzf and bat preview
- Health check system for dependency verification
- Comprehensive configuration templates:
  - NvChad configuration with custom mappings
  - Zellij layouts for 9-pane environment
  - Emacs configuration with Evil mode
- Dependency installer script with OS detection
- Full documentation suite:
  - API Reference
  - Setup Guide
  - Quick Reference
  - Keybindings Reference
  - CLAUDE.md integration guide

### Environment Features
- **Pane 1-4**: Neovim instances on ports 7001-7004
- **Pane 5**: Terminal with lsd file listing on startup
- **Pane 6**: Interactive file explorer (fzf + bat preview)
- **Pane 7**: Broadcast/logs on port 7777
- **Pane 8**: Live command history tracking
- **Pane 9**: Auto-updating git status

### Key Improvements
- Replaced btop monitoring with interactive file explorer
- Terminal now shows lsd output on startup
- Added comprehensive keybinding documentation with preservation warnings
- Integrated both mcp-server-nvimlisten and mcp-server-nvim functionality

### Tools Available
- `neovim-connect`: Send commands to Neovim instances
- `neovim-open-file`: Open files with optional line navigation
- `terminal-execute`: Execute commands in visible terminal
- `command-palette`: Interactive command selection
- `project-switcher`: Project navigation
- `start-environment`: Launch development environment
- `get-nvim-config`: Retrieve configurations
- `set-nvim-config`: Update configurations
- `list-plugins`: List Neovim plugins
- `manage-plugin`: Install/update/remove plugins
- `run-orchestra`: Multi-instance orchestration
- `broadcast-message`: Send to all instances
- `get-keybindings`: View keybindings
- `manage-session`: Session management
- `health-check`: System health verification