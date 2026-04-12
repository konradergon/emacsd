;;; early-init.el --- Pre GUI config  -*- lexical-binding: t; -*-

(setq gc-cons-threshold 16777216)

(setq load-prefer-newer t)

(setq native-comp-async-report-warnings-errors 'silent)
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
(setq idle-update-delay 1.0)
(setq read-process-output-max 1048576)

(setq-default bidi-display-reordering 'left-to-right 
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

(setq-default cursor-in-non-selected-windows nil)

(setq highlight-nonselected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq inhibit-compacting-font-caches t)

(menu-bar-mode -1)
(tool-bar-mode -1)

;;; early-init.el ends here
