;;; init.el --- Emacs configuration for MCP Neovim Listen Server -*- lexical-binding: t -*-

;;; Commentary:
;; This configuration is optimized for use with Claude Code MCP integration
;; It provides a minimal but powerful Emacs setup that works alongside Neovim

;;; Code:

;; Performance optimizations for startup
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; Package management setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("gnu" . "https://elpa.gnu.org/packages/")
                        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Basic settings
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq ring-bell-function 'ignore)

;; UI improvements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(electric-pair-mode 1)

;; Font and theme
(set-face-attribute 'default nil :height 120)

;; Better scrolling
(setq scroll-margin 8
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; Essential packages for Claude integration
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "jk") 'evil-normal-state))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package ripgrep
  :ensure t)

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; File management
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

;; Terminal emulation
(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

;; Server configuration for Claude integration
(use-package server
  :ensure nil
  :config
  (unless (server-running-p)
    (server-start)))

;; Custom functions for MCP integration
(defun mcp/send-to-neovim (port command)
  "Send COMMAND to Neovim instance on PORT."
  (shell-command-to-string 
   (format "nvim --server 127.0.0.1:%s --remote-send '%s'" port command)))

(defun mcp/open-in-neovim (port file &optional line)
  "Open FILE in Neovim instance on PORT, optionally at LINE."
  (let ((cmd (if line
                 (format "nvim --server 127.0.0.1:%s --remote +%s %s" port line file)
               (format "nvim --server 127.0.0.1:%s --remote %s" port file))))
    (shell-command cmd)))

;; Key bindings for MCP integration
(global-set-key (kbd "C-c n 1") 
                (lambda () (interactive) 
                  (mcp/open-in-neovim 7001 (buffer-file-name))))
(global-set-key (kbd "C-c n 2") 
                (lambda () (interactive) 
                  (mcp/open-in-neovim 7002 (buffer-file-name))))
(global-set-key (kbd "C-c n b") 
                (lambda () (interactive) 
                  (mcp/send-to-neovim 7777 
                                     (format ":put ='[Emacs] %s'<CR>" 
                                            (read-string "Broadcast message: ")))))

;; Restore gc threshold
(setq gc-cons-threshold 800000)

(provide 'init)
;;; init.el ends here