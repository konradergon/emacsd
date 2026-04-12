;;; init.el --- Personal config  -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;;; Set up the package manager

(require 'package)
(setq package-native-compile t)
(setq package-quickstart t) ;; For blazingly fast startup times, this line makes startup miles faster
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

;;; Basic behaviour

(setq use-short-answers t) ;; When emacs asks for "yes" or "no", let "y" or "n" suffice

(setq frame-resize-pixelwise t)
(setq ns-pop-up-frames nil) ;; When opening a file (like double click) on Mac, use an existing frame
(setq window-resize-pixelwise nil)
(setq split-width-threshold 80) ;; How thin the window should be to stop splitting vertically (I think)

(setq-default truncate-lines t)
(setq line-move-visual t) ;; C-p, C-n, etc uses visual lines

(setq scroll-conservatively 101)
(setq
 mouse-wheel-follow-mouse 't
 mouse-wheel-progressive-speed nil
 ;; The most important setting of all! Make each scroll-event move 2 lines at
 ;; a time (instead of 5 at default). Simply hold down shift to move twice as
 ;; fast, or hold down control to move 3x as fast. Perfect for trackpads.
 mouse-wheel-scroll-amount '(1 ((shift) . 3) ((control) . 6)))
(setq mac-redisplay-dont-reset-vscroll t ;; sane trackpad/mouse scroll settings (doom)
      mac-mouse-wheel-smooth-scroll nil)

;; Try really hard to keep the cursor from getting stuck in the read-only prompt
;; portion of the minibuffer.
(setq minibuffer-prompt-properties '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;; When opening a symlink that links to a file in a git repo, edit the file in the
;; git repo so we can use the Emacs vc features (like Diff) in the future
(setq vc-follow-symlinks t)

;; Backups/lockfiles
;; Don't generate backups or lockfiles.
(setq create-lockfiles nil
      make-backup-files nil
      ;; But in case the user does enable it, some sensible defaults:
      version-control t     ; number each backup file
      backup-by-copying t   ; instead of renaming current file (clobbers links)
      delete-old-versions t ; clean up after itself
      kept-old-versions 5
      kept-new-versions 5
      backup-directory-alist (list (cons "." (concat user-emacs-directory "backups/"))))

(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))       ; pretty
(prefer-coding-system 'utf-8)            ; pretty
(setq locale-coding-system 'utf-8)       ; please

(setq blink-cursor-interval 0.6)
(blink-cursor-mode -1)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t)

(setq what-cursor-show-names t) ;; improves C-x =

(setq reb-re-syntax 'string) ;; https://www.masteringemacs.org/article/re-builder-interactive-regexp-builder

(setq mac-command-modifier       'meta
      mac-option-modifier        nil
      mac-control-modifier       'control
      mac-right-command-modifier 'super
      mac-right-option-modifier  'hyper)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package recentf
  :ensure nil
  :config
  (setq ;;recentf-auto-cleanup 'never
   ;; recentf-max-menu-items 0
   recentf-max-saved-items 200)
  (setq recentf-filename-handlers ;; Show home folder path as a ~
        (append '(abbreviate-file-name) recentf-filename-handlers))
  (recentf-mode 1))

(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)

(use-package which-key
  :diminish which-key-mode
  :init
  (which-key-mode 1)
  (which-key-setup-minibuffer)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-min-display-lines 3
        which-key-max-display-columns nil))

;;; Tweak the looks of Emacs

(setq inhibit-startup-screen t)
(setq display-time-default-load-average nil)

(line-number-mode 1)
(column-number-mode 1)

;; Text
(let ((mono-spaced-font "Monospace")
      (proportionately-spaced-font "Sans"))
  (set-face-attribute 'default nil :family mono-spaced-font :height 120)
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))

;; Colors
(let ((bg      "#ffffee")
      (post    "#f0e0d6")
      (subject "#800000")
      (text    "#000000")
      (green   "#789922")
      (link    "#0000ee")
      (name    "#117743")
      (border  "#d6bad0")
      (red     "#af0a0f")
      (grey    "#444444"))
  (set-face-attribute 'default nil :background bg :foreground text)
  (set-face-attribute 'cursor nil :background subject)
  (set-face-attribute 'region nil :background border)
  (set-face-attribute 'fringe nil :background bg)
  (set-face-attribute 'mode-line nil :background post :foreground subject :box `(:line-width -1 :color ,border))
  (set-face-attribute 'mode-line-inactive nil :background bg :foreground grey :box `(:line-width -1 :color ,post))
  (set-face-attribute 'minibuffer-prompt nil :foreground subject :weight 'bold)
  (set-face-attribute 'font-lock-comment-face nil :foreground green)
  (set-face-attribute 'font-lock-doc-face nil :foreground green :slant 'italic)
  (set-face-attribute 'font-lock-string-face nil :foreground name)
  (set-face-attribute 'font-lock-keyword-face nil :foreground subject :weight 'bold)
  (set-face-attribute 'font-lock-function-name-face nil :foreground link)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground text)
  (set-face-attribute 'font-lock-type-face nil :foreground red)
  (set-face-attribute 'font-lock-constant-face nil :foreground link :slant 'italic)
  (set-face-attribute 'font-lock-warning-face nil :foreground red :weight 'bold)
  (set-face-attribute 'font-lock-builtin-face nil :foreground subject)
  (set-face-attribute 'org-level-1 nil :foreground subject :weight 'bold :height 1.2)
  (set-face-attribute 'org-level-2 nil :foreground name :weight 'bold :height 1.1)
  (set-face-attribute 'org-link nil :foreground link :underline t)
  (set-face-attribute 'org-block nil :background post)
  (set-face-attribute 'org-quote nil :foreground green)
  (set-face-attribute 'org-document-title nil :foreground subject :weight 'bold :height 1.5)
  (set-face-attribute 'line-number nil :foreground border :background bg)
  (set-face-attribute 'line-number-current-line nil :foreground subject :background post))

;;; Configure the minibuffer and completions

(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :config
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)

  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

  ;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

;;; The file manager (Dired)

(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

;;; Claude

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup) ; Optionally enable Emacs MCP tools
  (setq claude-code-ide-terminal-backend 'eat))

;;; init.el ends here
