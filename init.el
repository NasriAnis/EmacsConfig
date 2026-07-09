;;; init.el --- entry point: bootstrap + load all modules -*- lexical-binding: t; -*-

;; Modules live in lisp/, next to this file.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; keep ~/.emacs.d clean: stash custom-set-variables noise elsewhere
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(require 'init-packages)   ; package.el + use-package bootstrap
(require 'init-theme)      ; dracula + pure-black overrides
(require 'init-ui)         ; fonts, scrolling, minimal chrome, window movement
(require 'init-editing)    ; backups, autosave, super-save
(require 'init-evil)       ; evil, evil-collection, leader key, which-key
(require 'init-treesit)    ; tree-sitter major modes, no LSP
(require 'init-compile)    ; compile / recompile at project root
(require 'init-git)        ; magit + diff-hl
(require 'init-sessions)   ; per-project desktop sessions
; (require 'init-terminal)   ; vterm + kitty
(require 'init-extras)     ; optional packages, commented out by default
(require 'init-fuzzyfind)
(require 'init-assembly)

;; clean up gpg-agent/scdaemon on exit
(add-hook 'kill-emacs-hook
          (lambda ()
            (let ((homedir (expand-file-name "elpa/gnupg" user-emacs-directory)))
              (when (file-directory-p homedir)
                (call-process "gpgconf" nil 0 nil
                               "--homedir" homedir "--kill" "gpg-agent")
                (call-process "gpgconf" nil 0 nil
                               "--homedir" homedir "--kill" "scdaemon")))))
(provide 'init)
;;; init.el ends here
