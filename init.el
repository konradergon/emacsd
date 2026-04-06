(use-package emacs
  :custom
  (inhibit-splash-screen t)
  (display-time-default-load-average nil)
  (sentence-end-double-space nil)
  (use-short-answers t)
  (switch-to-buffer-obey-display-actions t)
  (completions-detailed t)
  (completion-styles '(flex substring partial-completion))
  (completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (mac-command-modifier 'meta)
  (mac-right-command-modifier 'super)
  (mac-option-modifier nil)
  (mac-right-option-modifier 'alt)
  (make-backup-file-name-function
   (lambda (fpath)
     (let* ((root (concat user-emacs-directory "backups/"))
            (clean (replace-regexp-in-string "[A-Za-z]:" "" fpath))
            (dest (replace-regexp-in-string "//" "/" (concat root clean "~"))))
       (make-directory (file-name-directory dest) t)
       dest)))
  :config
  (blink-cursor-mode -1)
  (delete-selection-mode)
  (when (display-graphic-p)
    (context-menu-mode)
    (load-theme 'yotsuba t))
  :bind (("M-h" . ns-do-hide-emacs)
         ("M-'" . other-frame)))

(setq auto-revert-use-notify nil
      auto-revert-interval 5)
(global-auto-revert-mode)
(savehist-mode)
(recentf-mode)
(windmove-default-keybindings 'control)

(setq c-default-style "linux"
      c-basic-offset 8)
(setq project-mode-line t)

(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'prog-mode-hook 'electric-pair-local-mode)

;;;; Completion

(fido-vertical-mode)
(keymap-set icomplete-minibuffer-map "TAB" 'icomplete-force-complete)

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))
(keymap-global-set "M-/" 'hippie-expand)

;;;; Org

(use-package org
  :hook (org-mode . flyspell-mode)
  :bind (("C-c l s" . org-store-link)
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

;;;; External packages

(use-package go-mode :ensure t)

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package eat
  :ensure t
  :custom (eat-term-name "xterm-256color")
  :config (add-hook 'eshell-load-hook 'eat-eshell-mode))

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :custom
  (claude-code-ide-terminal-backend 'eat)
  (claude-code-ide-use-side-window nil)
  :config (claude-code-ide-emacs-tools-setup))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((claude-code-ide :url
		      "https://github.com/manzaltu/claude-code-ide.el"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq gc-cons-threshold 800000)
