(setq gc-cons-threshold 10000000)

(setq load-prefer-newer t)

(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)
(setq read-process-output-max 1000000)

(menu-bar-mode -1)
(tool-bar-mode -1)
