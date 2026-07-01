;;; init-theme.el --- pure-black Dracula theme -*- lexical-binding: t; -*-

;; ===========================================================================
;; PURE BLACK THEME (unused, kept for reference)
;; early-init.el sets the startup frame, this re-applies it (and to any new
;; frame you create, e.g. emacsclient -c) so it's consistent everywhere.
;; ===========================================================================
; (defun my/pure-black-theme (&optional frame)
;   (with-selected-frame (or frame (selected-frame))
;     (set-face-attribute 'default nil :background "#000000" :foreground "#e0e0e0")
;     (set-face-attribute 'fringe nil :background "#000000")
;     (set-face-attribute 'line-number nil :background "#000000" :foreground "#3a3a3a")
;     (set-face-attribute 'line-number-current-line nil :background "#000000" :foreground "#ffffff")
;     (set-face-attribute 'mode-line nil :background "#0a0a0a" :foreground "#e0e0e0" :box nil)
;     (set-face-attribute 'mode-line-inactive nil :background "#000000" :foreground "#555555" :box nil)
;     (set-face-attribute 'vertical-border nil :foreground "#1a1a1a")
;     (set-face-attribute 'region nil :background "#262626")
;     (set-face-attribute 'minibuffer-prompt nil :foreground "#00d75f" :weight 'bold)))

; (my/pure-black-theme)
; (add-hook 'after-make-frame-functions #'my/pure-black-theme) ; daemon / emacsclient

;; ===========================================================================
;; DRACULA THEME (pure-black variant, matching your nvim dracula overrides)
;; ===========================================================================
(use-package dracula-theme
  :config
  (load-theme 'dracula t)

  (defun my/dracula-pure-black (&optional frame)
    "Force pure-black overrides on top of dracula. Run after load-theme AND
on every new frame (daemon/emacsclient), since set-face-attribute — unlike
theme-based specs — doesn't automatically apply to frames created later."
    (with-selected-frame (or frame (selected-frame))
      ;; core UI — guaranteed to win over the theme's own spec
      (set-face-attribute 'default nil :background "#000000" :foreground "#F8F8F2")
      (set-face-attribute 'cursor nil :background "#F8F8F2")
      (set-face-attribute 'fringe nil :background "#000000")
      (set-face-attribute 'region nil :background "#2b2b2b")                ; visual
      (set-face-attribute 'vertical-border nil :foreground "#0d0d0d")
      (set-face-attribute 'mode-line nil :background "#0d0d0d" :foreground "#F8F8F2" :box nil)
      (set-face-attribute 'mode-line-inactive nil :background "#000000" :foreground "#6272A4" :box nil)
      (set-face-attribute 'line-number nil :background "#000000" :foreground "#44475a")
      (set-face-attribute 'line-number-current-line nil :background "#000000" :foreground "#F8F8F2")
      (set-face-attribute 'minibuffer-prompt nil :foreground "#50fa7b" :weight 'bold)
      ;; syntax — same palette as your dracula.nvim overrides
      (set-face-attribute 'font-lock-comment-face nil :foreground "#6272A4" :slant 'italic)
      (set-face-attribute 'font-lock-string-face nil :foreground "#F1FA8C")
      (set-face-attribute 'font-lock-keyword-face nil :foreground "#FF79C6")
      (set-face-attribute 'font-lock-function-name-face nil :foreground "#50fa7b")
      (set-face-attribute 'font-lock-variable-name-face nil :foreground "#FFB86C")
      (set-face-attribute 'font-lock-type-face nil :foreground "#8BE9FD")
      (set-face-attribute 'font-lock-constant-face nil :foreground "#BD93F9")
      (set-face-attribute 'font-lock-builtin-face nil :foreground "#8BE9FD")
      (set-face-attribute 'font-lock-warning-face nil :foreground "#FF5555" :weight 'bold)))

  (my/dracula-pure-black)
  (add-hook 'after-make-frame-functions #'my/dracula-pure-black))

(provide 'init-theme)
;;; init-theme.el ends here
