;;; init-ui.el --- fonts, scrolling, minimal chrome, window movement -*- lexical-binding: t; -*-

;; --- Smooth Keyboard Scrolling ---
(setq scroll-conservatively 101)       ; Scroll line-by-line instead of jumping half a page
(setq scroll-margin 3)                 ; Start scrolling 3 lines before the cursor hits the margin
(setq scroll-step 1)                   ; Force keyboard scrolling to move 1 line at a time

;; Optional: Smooth mouse/trackpad scrolling (Emacs 29+)
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(setq display-line-numbers-type 'relative)

(repeat-mode 1)

;; ===========================================================================
;; FONT
;; ===========================================================================
; (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font-11")
; (add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-11"))

;; Set the default font using the exact system font name
(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font"
                    :weight 'bold
                    :height 110)

;; Ensure fixed-pitch face matches
(set-face-attribute 'fixed-pitch nil
                    :font "JetBrainsMono Nerd Font"
                    :weight 'bold
                    :height 110)

;; ===========================================================================
;; COMPLETION NAVIGATION (M-j/M-k instead of M-<down>/M-<up>)
;; ===========================================================================
(with-eval-after-load 'minibuffer
  (define-key minibuffer-local-completion-map (kbd "M-j") #'minibuffer-next-completion)
  (define-key minibuffer-local-completion-map (kbd "M-k") #'minibuffer-previous-completion))

(with-eval-after-load 'simple
  (define-key completion-list-mode-map (kbd "M-j") #'next-completion)
  (define-key completion-list-mode-map (kbd "M-k") #'previous-completion))

;; ===========================================================================
;; UI MINIMALISM
;; ===========================================================================
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)   (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq ring-bell-function 'ignore)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)

;; ===========================================================================
;; WINDOW MOVEMENT (C-h/j/k/l, tmux/vim style)
;; C-h is normally the Emacs help prefix (C-h k, C-h f, etc). We move help
;; to C-c h so C-h is free for window movement instead.
;; ===========================================================================
(global-set-key (kbd "C-c h") 'help-command)
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)

(provide 'init-ui)
;;; init-ui.el ends here
