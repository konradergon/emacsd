(setq k--initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold 10000000)

(setq load-prefer-newer t)

(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

(setq native-comp-async-jobs-number 2)
(setq read-process-output-max 1000000)

(tool-bar-mode -1)
(menu-bar-mode -1)
