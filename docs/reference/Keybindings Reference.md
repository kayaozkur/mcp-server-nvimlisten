# Keybindings Reference - MCP Neovim Listen Server

## ⚠️ Important Note

**These keybindings are preset and should NOT be modified by Claude or any automated tools.** They have been carefully chosen to avoid conflicts and provide a consistent experience.

## Leader Key

The leader key is set to `<Space>` (spacebar) in all configurations.

## Core Neovim Keybindings

### Basic Operations
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `;` | Normal | `:` | Enter command mode |
| `jk` | Insert | `<ESC>` | Exit insert mode |
| `<C-s>` | Normal, Insert, Visual | `:w<CR>` | Save file |
| `<leader>w` | Normal | `:w<CR>` | Save file (alternative) |
| `<leader>q` | Normal | `:q<CR>` | Quit |
| `<leader>Q` | Normal | `:qa<CR>` | Quit all |

### Window Management
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>wh` | Normal | `<C-w>h` | Move to left window |
| `<leader>wj` | Normal | `<C-w>j` | Move to bottom window |
| `<leader>wk` | Normal | `<C-w>k` | Move to top window |
| `<leader>wl` | Normal | `<C-w>l` | Move to right window |
| `<leader>ws` | Normal | `:split<CR>` | Split horizontally |
| `<leader>wv` | Normal | `:vsplit<CR>` | Split vertically |
| `<leader>wc` | Normal | `:close<CR>` | Close current window |
| `<leader>wo` | Normal | `:only<CR>` | Close other windows |

### Buffer Navigation
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<S-h>` | Normal | Previous buffer | Via BufferLine |
| `<S-l>` | Normal | Next buffer | Via BufferLine |
| `<leader>bn` | Normal | `:bnext<CR>` | Next buffer |
| `<leader>bp` | Normal | `:bprevious<CR>` | Previous buffer |
| `<leader>bx` | Normal | `:bdelete<CR>` | Delete current buffer |
| `<leader>bd` | Normal | Buffer delete | Via Snacks |
| `<leader>bo` | Normal | Delete other buffers | Via Snacks |

### Text Manipulation
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>nh` | Normal | `:nohl<CR>` | Clear search highlights |
| `<` | Visual | `<gv` | Indent left and reselect |
| `>` | Visual | `>gv` | Indent right and reselect |
| `J` | Visual | Move selection down | With formatting |
| `K` | Visual | Move selection up | With formatting |

## Plugin Keybindings

### Telescope (Fuzzy Finding)
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>ff` | Normal | Find files | Telescope find_files |
| `<leader>fg` | Normal | Live grep | Search in files |
| `<leader>fb` | Normal | Find buffers | Open buffers |
| `<leader>fh` | Normal | Help tags | Search help |
| `<leader>fp` | Normal | Find projects | Via project.nvim |
| `<leader>fG` | Normal | Enhanced grep | Via egrepify |

### File Navigation
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `s` | Normal, Visual | Flash jump | Quick navigation |
| `S` | Normal, Visual | Flash treesitter | Syntax-aware jump |
| `<C-h>` | Normal | Navigate left | Tmux navigator |
| `<C-j>` | Normal | Navigate down | Tmux navigator |
| `<C-k>` | Normal | Navigate up | Tmux navigator |
| `<C-l>` | Normal | Navigate right | Tmux navigator |

### Harpoon (File Marks)
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>ma` | Normal | Add file to marks | Mark current file |
| `<leader>mm` | Normal | Show marks menu | View all marks |
| `<leader>m1` | Normal | Go to mark 1 | Quick jump |
| `<leader>m2` | Normal | Go to mark 2 | Quick jump |
| `<leader>m3` | Normal | Go to mark 3 | Quick jump |
| `<leader>m4` | Normal | Go to mark 4 | Quick jump |

### Terminal & Development
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-\>` | Normal | Toggle terminal | ToggleTerm |
| `<C-j>` | Insert | Accept suggestion | GitHub Copilot |

### Git Integration
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>gd` | Normal | Open diffview | View git diffs |
| `<leader>gc` | Normal | Close diffview | Close git view |
| `<leader>go` | Normal | Octo menu | GitHub integration |
| `<leader>gp` | Normal | List PRs | GitHub PRs |
| `<leader>gi` | Normal | List issues | GitHub issues |

### Git Conflicts
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>co` | Normal | Accept ours | Conflict resolution |
| `<leader>ct` | Normal | Accept theirs | Conflict resolution |
| `<leader>cn` | Normal | Accept none | Conflict resolution |
| `<leader>cb` | Normal | Accept both | Conflict resolution |
| `]x` | Normal | Next conflict | Navigate conflicts |
| `[x` | Normal | Previous conflict | Navigate conflicts |

### Testing & Debugging
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>tt` | Normal | Run nearest test | Neotest |
| `<leader>tf` | Normal | Run file tests | Neotest |
| `<leader>td` | Normal | Debug test | Neotest |
| `<leader>ts` | Normal | Toggle summary | Test summary |
| `<leader>to` | Normal | Show output | Test output |

### DAP (Debugging)
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>db` | Normal | Toggle breakpoint | Set/unset breakpoint |
| `<leader>dc` | Normal | Continue | Debug continue |
| `<leader>di` | Normal | Step into | Debug step into |
| `<leader>do` | Normal | Step over | Debug step over |
| `<leader>dO` | Normal | Step out | Debug step out |
| `<leader>dr` | Normal | Open REPL | Debug REPL |
| `<leader>dl` | Normal | Run last | Repeat last debug |
| `<leader>du` | Normal | Toggle UI | DAP UI |

### Code Actions
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>ca` | Normal | Code action | LSP code actions |
| `<leader>rn` | Normal | Rename | LSP rename |
| `<leader>f` | Normal | Format | Format document |
| `gr` | Normal | Substitute | Via substitute.nvim |
| `grr` | Normal | Substitute line | Replace current line |

### Advanced Features
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>lg` | Normal | Legendary | Command palette |
| `<leader>cn` | Normal | Center text | No Neck Pain |
| `<leader>sj` | Normal | Split/join | TreeSJ toggle |
| `<leader>rS` | Normal, Visual | Advanced substitute | Rip substitute |
| `<leader>sr` | Normal, Visual | Search & replace | Grug Far |

### Session Management
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>qs` | Normal | Restore session | Load saved session |
| `<leader>ql` | Normal | Restore last | Load last session |
| `<leader>qd` | Normal | Don't save | Skip session save |

### MCP Integration
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>cs` | Normal | Start Claude RPC | Initialize server |
| `<leader>cc` | Normal | Send context | Send to Claude |

## Zellij Keybindings

### Mode Switching
| Key | Action |
|-----|--------|
| `Ctrl+p` | Enter Pane mode |
| `Ctrl+t` | Enter Tab mode |
| `Ctrl+s` | Enter Scroll mode |
| `Ctrl+o` | Enter Session mode |
| `Ctrl+q` | Quit Zellij |

### Pane Mode
| Key | Action |
|-----|--------|
| `h` or `←` | Focus left pane |
| `l` or `→` | Focus right pane |
| `j` or `↓` | Focus down pane |
| `k` or `↑` | Focus up pane |
| `f` | Toggle fullscreen |
| `x` | Close pane |
| `n` | New pane |
| `Esc` | Exit to Normal mode |

## Emacs Keybindings (Evil Mode)

### Basic Evil Bindings
| Key | Mode | Action |
|-----|------|--------|
| `jk` | Insert | Exit to Normal mode |
| `C-g` | Insert | Exit to Normal mode |

### MCP Integration (Emacs)
| Key | Action |
|-----|--------|
| `C-c n 1` | Open current file in Neovim (port 7001) |
| `C-c n 2` | Open current file in Neovim (port 7002) |
| `C-c n b` | Broadcast message to Neovim |

## Usage Notes

1. **Leader Key**: Always `<Space>` - press spacebar followed by the key sequence
2. **Modifier Keys**: 
   - `C` = Control
   - `S` = Shift
   - `M` = Meta/Alt
3. **Modes**:
   - Normal: Default mode for navigation
   - Insert: Text insertion mode
   - Visual: Text selection mode
   - Command: Command line mode (after `:`)

## Customization Warning

**FOR CLAUDE**: Do not suggest modifications to these keybindings unless explicitly requested by the user. These bindings are part of the MCP server configuration and should remain consistent.