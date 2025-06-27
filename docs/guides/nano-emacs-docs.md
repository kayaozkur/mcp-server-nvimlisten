# Straight.el and Nano Emacs Comprehensive Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Straight.el Package Manager](#straightel-package-manager)
3. [Nano Emacs Configuration](#nano-emacs-configuration)
4. [Integration Guide](#integration-guide)
5. [Module Reference](#module-reference)
6. [Configuration Examples](#configuration-examples)
7. [Troubleshooting](#troubleshooting)

## Introduction

This comprehensive guide covers two powerful Emacs tools:

- **Straight.el**: A next-generation, purely functional package manager for Emacs
- **Nano Emacs**: A minimal, elegant Emacs configuration framework designed around simplicity and consistency

These tools work excellently together to provide a clean, maintainable, and reproducible Emacs configuration.

## Straight.el Package Manager

### Overview

Straight.el is a revolutionary package manager that treats packages as Git repositories rather than opaque tarballs. It provides:

- **Reproducible package management** with version lockfiles
- **Local package development** with full Git integration
- **No persistent state** beyond your init file and lockfiles
- **Compatibility** with MELPA, GNU ELPA, and Emacsmirror

### Key Features

#### 🔄 Pure Functional Approach
- Init-file and version lockfiles as the sole source of truth
- 100% reproducible package management
- No support for package.el to avoid conflicts

#### 🛠️ Developer-Friendly
- Edit packages by editing their source code directly
- Manual version control operations supported
- Explicit support for package forks
- Built for `emacs -Q` bug reproduction

#### 📦 Universal Package Support
- Install from MELPA, GNU ELPA, Emacsmirror
- Custom recipe support
- Git repository cloning (not tarballs)
- Powerful recipe format based on MELPA

### Installation and Bootstrap

#### Basic Bootstrap Code

```elisp
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
```

#### Important Configuration Variables

Set these **before** the bootstrap code:

```elisp
;; Use develop branch for latest features
(setq straight-repository-branch "develop")

;; Faster startup with file watcher (requires Python 3 and watchexec)
(setq straight-check-for-modifications '(watch-files find-when-checking))

;; Use straight.el with use-package by default
(setq straight-use-package-by-default t)

;; Use SSH for private repositories
(setq straight-vc-git-default-protocol 'ssh)

;; Custom base directory (optional)
(setq straight-base-dir (expand-file-name "~/.emacs.d/"))
```

### Core Usage

#### Basic Package Installation

```elisp
;; Simple package installation
(straight-use-package 'magit)

;; With custom recipe
(straight-use-package
 '(my-package :type git :host github :repo "user/my-package"))

;; With fork support
(straight-use-package
 '(el-patch :type git :host github :repo "radian-software/el-patch"
           :fork (:host github :repo "my-name/el-patch")))
```

#### Use-Package Integration

After installing straight.el:

```elisp
(straight-use-package 'use-package)

;; Now you can use :straight keyword
(use-package magit
  :straight t
  :commands magit-status)

;; With custom recipe
(use-package my-package
  :straight (:host github :repo "user/my-package")
  :config
  (my-package-setup))
```

### Recipe Format

Straight.el uses a powerful recipe format:

```elisp
(package-name :keyword value :keyword value ...)
```

#### Core Keywords

- **`:local-repo`** - Name of local repository
- **`:files`** - Files to symlink (defaults work for most packages)
- **`:build`** - Build steps (autoloads, compile, etc.)
- **`:pre-build`** - Commands/elisp to run before building
- **`:post-build`** - Commands/elisp to run after building
- **`:type`** - Version control backend (git, built-in, nil)

#### Git-Specific Keywords

- **`:repo`** - Repository URL or "user/repo" format
- **`:host`** - github, gitlab, sourcehut, codeberg, bitbucket, or nil
- **`:branch`** - Development branch name
- **`:fork`** - Fork configuration
- **`:depth`** - Clone depth (full or integer)
- **`:protocol`** - https or ssh

### Version Management

#### Lockfiles

Create reproducible configurations:

```elisp
;; Freeze current package versions
(straight-freeze-versions)

;; Restore package versions from lockfile
(straight-thaw-versions)
```

#### Profile System

Manage multiple package sets:

```elisp
(setq straight-profiles
      '((nil . "default.el")
        (dev . "dev.el")))

;; Use different profile
(let ((straight-current-profile 'dev))
  (straight-use-package 'some-dev-package))
```

### Interactive Commands

#### Package Management
- `M-x straight-use-package` - Install package temporarily
- `M-x straight-rebuild-package` - Rebuild specific package
- `M-x straight-rebuild-all` - Rebuild all packages
- `M-x straight-prune-build` - Clean unused packages

#### Version Control Operations
- `M-x straight-pull-all` - Update all packages
- `M-x straight-fetch-all` - Fetch from all remotes
- `M-x straight-merge-all` - Merge updates
- `M-x straight-push-all` - Push local changes
- `M-x straight-normalize-all` - Normalize all repositories

## Nano Emacs Configuration

### Philosophy

Nano Emacs follows these principles:
- **Minimal dependencies** - Stick to vanilla Emacs when possible
- **Modular design** - Pick and choose components
- **Consistent aesthetics** - Based on design principles from academic research
- **Functional simplicity** - Clean, readable code

### Design Principles

Based on the research paper "On the design of text Editors":

#### The Six Nano Faces

1. **Default** - Standard text
2. **Critical** - Errors, urgent information (high contrast)
3. **Popout** - Attention-grabbing (distinct hue)
4. **Strong** - Structural elements (bold weight)
5. **Salient** - Important information
6. **Faded** - Secondary information
7. **Subtle** - Background elements

### Installation Options

#### Option 1: Using Straight.el (Recommended)

```elisp
(straight-use-package
 '(nano :type git :host github :repo "rougier/nano-emacs"))

;; Load all modules
(require 'nano)

;; Or load specific modules
(require 'nano-faces)
(require 'nano-theme)
```

#### Option 2: Manual Installation

```elisp
;; Add to load path
(add-to-list 'load-path "/path/to/nano-emacs")

;; Load required modules
(require 'nano-base-colors)
(require 'nano-faces)
(require 'nano-theme-light) ; or nano-theme-dark
(require 'nano-theme)
```

### Core Configuration

#### Font Settings

```elisp
;; Set before loading nano-faces
(setq nano-font-family-monospaced "Roboto Mono")  ; Default font
(setq nano-font-family-proportional nil)          ; Variable width font
(setq nano-font-size 14)                          ; Font size
```

#### Theme Selection

```elisp
;; For light theme
(require 'nano-theme-light)
(nano-theme-set-light)

;; For dark theme  
(require 'nano-theme-dark)
(nano-theme-set-dark)

;; Apply theme
(nano-theme)
```

## Module Reference

### nano-base-colors.el

Defines the fundamental color palette derived from existing Emacs faces.

**Key Variables:**
- `nano-color-foreground` - Primary text color
- `nano-color-background` - Background color
- `nano-color-highlight` - Highlight color
- `nano-color-critical` - Error/warning color
- `nano-color-salient` - Important information color
- `nano-color-strong` - Structural elements color
- `nano-color-popout` - Attention-grabbing color
- `nano-color-subtle` - Secondary background color
- `nano-color-faded` - Dimmed text color

### nano-faces.el

Defines the six fundamental faces used throughout Nano Emacs.

**Core Faces:**
```elisp
(defface nano-face-default ...)    ; Standard text
(defface nano-face-critical ...)   ; Critical information
(defface nano-face-popout ...)     ; Attention-getting
(defface nano-face-strong ...)     ; Structural elements
(defface nano-face-salient ...)    ; Important content
(defface nano-face-faded ...)      ; Secondary content
(defface nano-face-subtle ...)     ; Background elements
```

### nano-theme-light.el / nano-theme-dark.el

Override base colors for light and dark themes respectively.

**Light Theme Colors:**
- Based on Material Design colors
- High contrast for readability
- Warm, comfortable palette

**Dark Theme Colors:**
- Based on Nord color scheme
- Easy on the eyes
- Cool, professional palette

### nano-theme.el

Applies nano faces to built-in Emacs faces and popular packages.

**Supported Packages:**
- Font-lock (syntax highlighting)
- Company (completion)
- Helm/Ivy/Counsel
- Magit
- Org-mode
- And many more...

### nano-modeline.el

Provides a clean, contextual modeline/headerline.

**Features:**
- Mode-specific information display
- Minimal visual clutter
- Header-line and mode-line variants
- Integration with popular modes

### nano-layout.el

Configures the overall frame layout and visual elements.

**Settings:**
- Frame margins and fringes
- Font configuration
- Window decorations
- Visual elements

### nano-defaults.el

Provides sensible default settings for Emacs.

**Includes:**
- Better default behaviors
- Improved keybindings
- Performance optimizations
- User experience improvements

### Additional Modules

- **nano-splash.el** - Custom startup screen
- **nano-help.el** - Contextual help system
- **nano-session.el** - Session management
- **nano-bindings.el** - Key binding configurations
- **nano-counsel.el** - Counsel integration
- **nano-mu4e.el** - Email client theming
- **nano-minibuffer.el** - Minibuffer enhancements
- **nano-command.el** - Command line interface

## Integration Guide

### Complete Configuration Example

Here's a complete configuration combining straight.el with nano-emacs:

```elisp
;;; early-init.el
;; Disable package.el
(setq package-enable-at-startup nil)

;;; init.el
;; Configure straight.el
(setq straight-repository-branch "develop"
      straight-use-package-by-default t
      straight-check-for-modifications '(check-on-save find-when-checking))

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure nano-emacs fonts BEFORE loading
(setq nano-font-family-monospaced "Roboto Mono"
      nano-font-family-proportional "Inter"
      nano-font-size 13)

;; Install and configure nano-emacs
(use-package nano
  :straight (:host github :repo "rougier/nano-emacs")
  :config
  ;; Choose theme
  (require 'nano-theme-light)  ; or nano-theme-dark
  (nano-theme-set-light)       ; or (nano-theme-set-dark)
  
  ;; Load desired modules
  (require 'nano-layout)
  (require 'nano-defaults)
  (require 'nano-modeline)
  
  ;; Apply theme
  (nano-theme))

;; Example package configuration
(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status))

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.3))
```

### Selective Module Loading

You can pick and choose nano modules:

```elisp
;; Minimal nano setup - just the faces and theme
(use-package nano
  :straight (:host github :repo "rougier/nano-emacs")
  :config
  (require 'nano-base-colors)
  (require 'nano-faces)
  (require 'nano-theme-light)
  (nano-theme-set-light)
  (nano-theme))

;; Add layout improvements
(with-eval-after-load 'nano
  (require 'nano-layout))

;; Add modeline when you want it
(with-eval-after-load 'nano
  (require 'nano-modeline))
```

### Custom Color Schemes

You can create custom color schemes:

```elisp
;; Custom colors
(setq nano-color-foreground "#2E3440"
      nano-color-background "#ECEFF4"
      nano-color-highlight "#E5E9F0"
      nano-color-critical "#BF616A"
      nano-color-salient "#5E81AC"
      nano-color-strong "#2E3440"
      nano-color-popout "#D08770"
      nano-color-subtle "#D8DEE9"
      nano-color-faded "#4C566A")

;; Apply after setting colors
(nano-faces)
(nano-theme)
```

## Configuration Examples

### Development Setup

Perfect for software development:

```elisp
(use-package nano
  :straight (:host github :repo "rougier/nano-emacs")
  :config
  (setq nano-font-family-monospaced "Fira Code"
        nano-font-size 12)
  
  (require 'nano-theme-dark)
  (nano-theme-set-dark)
  (require 'nano-layout)
  (require 'nano-defaults)
  (require 'nano-modeline)
  (nano-theme))

;; Development packages
(use-package lsp-mode
  :commands lsp
  :hook ((python-mode . lsp)
         (js-mode . lsp)))

(use-package company
  :hook (after-init . global-company-mode))

(use-package flycheck
  :hook (after-init . global-flycheck-mode))
```

### Writing Setup

Optimized for writing and documentation:

```elisp
(use-package nano
  :straight (:host github :repo "rougier/nano-emacs")
  :config
  (setq nano-font-family-monospaced "iA Writer Mono"
        nano-font-family-proportional "iA Writer Duo"
        nano-font-size 14)
  
  (require 'nano-theme-light)
  (nano-theme-set-light)
  (require 'nano-layout)
  (require 'nano-splash)
  (nano-theme))

;; Writing enhancements
(use-package olivetti
  :hook (text-mode . olivetti-mode))

(use-package writeroom-mode
  :commands writeroom-mode)
```

### Minimal Setup

Just the essential nano components:

```elisp
(use-package nano
  :straight (:host github :repo "rougier/nano-emacs"
             :files ("nano-base-colors.el"
                     "nano-faces.el"
                     "nano-theme.el"
                     "nano-theme-light.el"))
  :config
  (require 'nano-base-colors)
  (require 'nano-faces)
  (require 'nano-theme-light)
  (nano-theme-set-light)
  (nano-theme))
```

## Troubleshooting

### Common Straight.el Issues

#### Slow Initialization
```elisp
;; Use faster modification checking
(setq straight-check-for-modifications '(check-on-save find-when-checking))

;; Or use filesystem watcher (requires watchexec)
(setq straight-check-for-modifications '(watch-files find-when-checking))
```

#### Package Not Found
```elisp
;; Update recipe repositories
(straight-pull-recipe-repositories)

;; Check available packages
M-x straight-use-package
```

#### Build Failures
```elisp
;; Rebuild specific package
M-x straight-rebuild-package

;; Rebuild all packages
M-x straight-rebuild-all

;; Check for repository issues
M-x straight-normalize-package
```

### Common Nano Emacs Issues

#### Fonts Not Loading
Ensure fonts are installed system-wide and set variables before loading nano-faces:

```elisp
;; Set BEFORE requiring nano modules
(setq nano-font-family-monospaced "Roboto Mono"
      nano-font-size 14)

(require 'nano-faces)
(nano-faces)  ; Reapply if changed after loading
```

#### Theme Not Applied
Load theme modules in correct order:

```elisp
;; Correct order
(require 'nano-base-colors)
(require 'nano-faces)
(require 'nano-theme-light)  ; Choose light or dark
(nano-theme-set-light)       ; Apply base colors
(require 'nano-theme)
(nano-theme)                 ; Apply to all faces
```

#### Module Loading Errors
Check dependencies and load order:

```elisp
;; nano-faces is required by most modules
(require 'nano-base-colors)
(require 'nano-faces)

;; Then load other modules
(require 'nano-modeline)
(require 'nano-layout)
```

### Performance Tips

1. **Lazy Loading**: Use `with-eval-after-load` for optional modules
2. **Selective Loading**: Only load modules you need
3. **Font Caching**: Ensure fonts are properly installed
4. **Theme Caching**: Set colors once, apply theme once

### Getting Help

- **Straight.el Issues**: Check the [GitHub repository](https://github.com/radian-software/straight.el)
- **Nano Emacs Issues**: Visit the [Nano Emacs repository](https://github.com/rougier/nano-emacs)
- **Configuration Examples**: Look at community configurations
- **Debug Mode**: Use `emacs -Q` with minimal config for testing

---

This documentation provides a comprehensive guide to using straight.el and nano-emacs together. Both tools emphasize simplicity, reproducibility, and elegance in Emacs configuration. Start with the basic examples and gradually add more features as needed.