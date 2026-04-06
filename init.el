;;;; Basic settings

(setopt inhibit-splash-screen t)
(setopt display-time-default-load-average nil)
(setopt sentence-end-double-space nil)
(setopt use-short-answers t)
(setopt switch-to-buffer-obey-display-actions t)

(setopt auto-revert-use-notify nil)
(setopt auto-revert-interval 5)
(global-auto-revert-mode)

(savehist-mode)
(recentf-mode)
(delete-selection-mode)
(blink-cursor-mode -1)

(windmove-default-keybindings 'control)

(when (display-graphic-p)
  (context-menu-mode))

;; Backups
(defun k--backup-file-name (fpath)
  "Return a new file path for a given FPATH backup.
Creates parent directories as needed."
  (let* ((backup-root (concat user-emacs-directory "backups/"))
         (file-path (replace-regexp-in-string "[A-Za-z]:" "" fpath))
         (backup-path (replace-regexp-in-string "//" "/" (concat backup-root file-path "~"))))
    (make-directory (file-name-directory backup-path) (file-name-directory backup-path))
    backup-path))
(setopt make-backup-file-name-function 'k--backup-file-name)

;;;; macOS modifiers

(setopt mac-command-modifier 'meta)
(setopt mac-right-command-modifier 'super)
(setopt mac-option-modifier nil)
(setopt mac-right-option-modifier 'alt)

(keymap-set global-map "M-h" 'ns-do-hide-emacs)
(keymap-set global-map "M-'" 'other-frame)

;;;; Theme

(when (display-graphic-p)
  (load-theme 'yotsuba t))

;;;; Minibuffer completion

(fido-vertical-mode)
(keymap-set icomplete-minibuffer-map "TAB" 'icomplete-force-complete)

(setopt completions-detailed t)
(setopt completion-styles '(flex substring partial-completion))
(setopt completion-ignore-case t)
(setopt read-buffer-completion-ignore-case t)
(setopt read-file-name-completion-ignore-case t)

;;;; In-buffer completion

(setopt hippie-expand-try-functions-list
        '(try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-complete-file-name-partially
          try-complete-file-name
          try-expand-all-abbrevs
          try-expand-line
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol))

(keymap-global-set "M-/" 'hippie-expand)

;;;; Editing

(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'prog-mode-hook 'electric-pair-local-mode)

;; Tree-sitter
(setopt treesit-language-source-alist
        '((yaml       "https://github.com/ikatyang/tree-sitter-yaml")
          (bash       "https://github.com/tree-sitter/tree-sitter-bash")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (json       "https://github.com/tree-sitter/tree-sitter-json")
          (css        "https://github.com/tree-sitter/tree-sitter-css")
          (python     "https://github.com/tree-sitter/tree-sitter-python")
          (go         "https://github.com/tree-sitter/tree-sitter-go")
          (gomod      "https://github.com/camdencheek/tree-sitter-go-mod")
          (c          "https://github.com/tree-sitter/tree-sitter-c")
          (cpp        "https://github.com/tree-sitter/tree-sitter-cpp")))

(setopt major-mode-remap-alist
        '((yaml-mode       . yaml-ts-mode)
          (sh-mode         . bash-ts-mode)
          (js2-mode        . js-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (json-mode       . json-ts-mode)
          (css-mode        . css-ts-mode)
          (python-mode     . python-ts-mode)
          (go-mode         . go-ts-mode)
          (c-mode          . c-ts-mode)
          (c++-mode        . c++-ts-mode)))

(use-package go-ts-mode
  :mode "\\.go\\'")

(use-package c-ts-mode
  :defer
  :custom
  (c-ts-mode-indent-style 'linux))

;;;; Project & version control

(use-package project
  :defer
  :custom
  (project-mode-line t))

(use-package magit
  :ensure t
  :defer
  :bind ("C-x g" . magit-status))

;;;; Org

(use-package org
  :hook (org-mode . flyspell-mode)
  :bind (:map global-map
              ("C-c l s" . org-store-link)
              ("C-c l i" . org-insert-link-global))
  :custom
  (org-directory "~/org/")
  (org-agenda-files '("inbox.org" "work.org"))
  (org-tag-alist '((:startgroup)
                   ("home" . ?h)
                   ("work" . ?w)
                   ("school" . ?s)
                   (:endgroup)
                   (:newline)
                   (:startgroup)
                   ("one-shot" . ?o)
                   ("project" . ?j)
                   ("tiny" . ?t)
                   (:endgroup)
                   ("meta")
                   ("review")
                   ("reading")))
  (org-link-abbrev-alist '(("family_search" . "https://www.familysearch.org/tree/person/details/%s")))
  (org-export-with-smart-quotes t)
  (org-todo-keywords '((sequence "TODO(t)" "WAITING(w@/!)" "STARTED(s!)" "|" "DONE(d!)" "OBSOLETE(o@)")))
  (org-outline-path-complete-in-steps nil)
  (org-refile-use-outline-path 'file)
  (org-capture-templates
   '(("c" "Default Capture" entry (file "inbox.org")
      "* TODO %?\n%U\n%i")
     ("r" "Capture with Reference" entry (file "inbox.org")
      "* TODO %?\n%U\n%i\n%a")
     ("w" "Work")
     ("wm" "Work meeting" entry (file+headline "work.org" "Meetings")
      "** TODO %?\n%U\n%i\n%a")
     ("wr" "Work report" entry (file+headline "work.org" "Reports")
      "** TODO %?\n%U\n%i\n%a")))
  (org-agenda-custom-commands
   '(("n" "Agenda and All Todos"
      ((agenda)
       (todo)))
     ("w" "Work" agenda ""
      ((org-agenda-files '("work.org"))))))
  :config
  (require 'oc-csl)
  (add-to-list 'org-export-backends 'md)
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file))

;;;; Terminal

(use-package eat
  :ensure t
  :defer
  :config
  (add-hook 'eshell-load-hook #'eat-eshell-mode)
  :custom
  (eat-term-name "xterm-256color"))

;;;; Claude Code

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup)
  :custom
  (claude-code-ide-terminal-backend 'eat)
  (claude-code-ide-use-side-window nil))

;;;; Custom

(custom-set-variables
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((claude-code-ide :url
                      "https://github.com/manzaltu/claude-code-ide.el"))))
(custom-set-faces)

(setq gc-cons-threshold (or k--initial-gc-threshold 800000))
