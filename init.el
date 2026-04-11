(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(require 'package)
(setq package-native-compile t)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(unless package-archive-contents
  (package-refresh-contents))

(dolist (pkg '(go-mode magit vterm exec-path-from-shell))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(exec-path-from-shell-initialize)

(unless (package-installed-p 'claude-code-ide)
  (package-vc-install
   '(claude-code-ide :url "https://github.com/manzaltu/claude-code-ide.el")))

(setq inhibit-splash-screen t
      display-time-default-load-average nil
      sentence-end-double-space nil
      use-short-answers t
      switch-to-buffer-obey-display-actions t)

(setq mac-command-modifier 'meta
      mac-right-command-modifier 'super
      mac-option-modifier nil
      mac-right-option-modifier 'alt)

(defun backup-file-name (fpath)
  (let* ((root (concat user-emacs-directory "backups/"))
         (dest (concat root fpath "~")))
    (make-directory (file-name-directory dest) t)
    dest))

(setq make-backup-file-name-function 'backup-file-name)

(setq project-mode-line t)

(delete-selection-mode)
(auto-revert-mode -1)
(savehist-mode)
(recentf-mode)

(context-menu-mode)

(windmove-default-keybindings 'control)

(keymap-global-set "M-h" 'ns-do-hide-emacs)
(keymap-global-set "M-'" 'other-frame)

;;; Org

(setq org-directory "~/org/"
      org-agenda-files (list (expand-file-name "inbox.org" org-directory)
                             (expand-file-name "work.org" org-directory))
      org-export-with-smart-quotes t
      org-outline-path-complete-in-steps nil
      org-refile-use-outline-path 'file)

(setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w@/!)" "STARTED(s!)"
                  "|" "DONE(d!)" "OBSOLETE(o@)")))

(setq org-tag-alist
      '((:startgroup)
        ("home" . ?h) ("work" . ?w) ("school" . ?s)
        (:endgroup)
        (:newline)
        (:startgroup)
        ("one-shot" . ?o) ("project" . ?j) ("tiny" . ?t)
        (:endgroup)
        ("meta") ("review") ("reading")))

(setq org-capture-templates
      '(("c" "Default Capture" entry (file "inbox.org")
         "* TODO %?\n%U\n%i")
        ("r" "Capture with Reference" entry (file "inbox.org")
         "* TODO %?\n%U\n%i\n%a")
        ("w" "Work")
        ("wm" "Work meeting" entry (file+headline "work.org" "Meetings")
         "** TODO %?\n%U\n%i\n%a")
        ("wr" "Work report" entry (file+headline "work.org" "Reports")
         "** TODO %?\n%U\n%i\n%a")))

(setq org-agenda-custom-commands
      '(("n" "Agenda and All Todos"
         ((agenda)
          (todo)))
        ("w" "Work" agenda ""
         ((org-agenda-files '("work.org"))))))

(with-eval-after-load 'org
  (require 'oc-csl)
  (add-to-list 'org-export-backends 'md)
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file))

(add-hook 'org-mode-hook 'flyspell-mode)
(keymap-global-set "C-c l s" 'org-store-link)
(keymap-global-set "C-c l i" 'org-insert-link-global)

;;; Dev

(keymap-global-set "C-x g" 'magit-status)
(keymap-global-set "C-c C-0" 'claude-code-ide)

;;; Colors

(custom-set-faces
 '(default                      ((t (:background "#ffffee" :foreground "#000000"))))
 '(cursor                       ((t (:background "#800000"))))
 '(fringe                       ((t (:background "#ffffee"))))
 '(region                       ((t (:background "#d6bad0"))))
 '(minibuffer-prompt            ((t (:foreground "#800000" :weight bold))))
 '(line-number                  ((t (:foreground "#d6bad0" :background "#ffffee"))))
 '(line-number-current-line     ((t (:foreground "#800000" :background "#f0e0d6"))))
 '(mode-line                    ((t (:background "#f0e0d6" :foreground "#800000" :box (:line-width -1 :color "#d6bad0")))))
 '(mode-line-inactive           ((t (:background "#ffffee" :foreground "#444444" :box (:line-width -1 :color "#f0e0d6")))))
 '(font-lock-builtin-face       ((t (:foreground "#800000"))))
 '(font-lock-comment-face       ((t (:foreground "#789922"))))
 '(font-lock-constant-face      ((t (:foreground "#0000ee" :slant italic))))
 '(font-lock-doc-face           ((t (:foreground "#789922" :slant italic))))
 '(font-lock-function-name-face ((t (:foreground "#0000ee"))))
 '(font-lock-keyword-face       ((t (:foreground "#800000" :weight bold))))
 '(font-lock-string-face        ((t (:foreground "#117743"))))
 '(font-lock-type-face          ((t (:foreground "#af0a0f"))))
 '(font-lock-variable-name-face ((t (:foreground "#000000"))))
 '(font-lock-warning-face       ((t (:foreground "#af0a0f" :weight bold))))
 '(org-block                    ((t (:background "#f0e0d6"))))
 '(org-document-title           ((t (:foreground "#800000" :weight bold :height 1.5))))
 '(org-level-1                  ((t (:foreground "#800000" :weight bold :height 1.2))))
 '(org-level-2                  ((t (:foreground "#117743" :weight bold :height 1.1))))
 '(org-link                     ((t (:foreground "#0000ee" :underline t))))
 '(org-quote                    ((t (:foreground "#789922")))))
