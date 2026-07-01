;;; init-editing.el --- backups, autosave, super-save -*- lexical-binding: t; -*-

(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; ===========================================================================
;; MODERN AUTO-SAVE (Save files silently as you type/navigate)
;; ===========================================================================
(use-package super-save
  :ensure t
  :config
  ;; Save silently when Emacs is idle for 1 second, or when you switch windows/buffers
  (setq super-save-auto-save-when-idle t
        super-save-idle-duration 0.0
        super-save-exclude-modes '("git-commit-mode") ; don't auto-commit empty messages
        super-save-remote-files nil)                  ; don't auto-save over slow SSH connections

  (super-save-mode 1)

  ;; Silence the native "Wrote /path/to/file" echo area spam on every auto-save
  (setq save-silently t))

(provide 'init-editing)
;;; init-editing.el ends here
