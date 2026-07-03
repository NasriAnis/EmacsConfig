;;; init-extras.el --- optional extras, commented out by default -*- lexical-binding: t; -*-
;; Uncomment whatever you want to try. Left out by default to keep the base
;; config genuinely minimal.

; ===========================================================================
; TABS (centaur-tabs)
; ===========================================================================
; (use-package centaur-tabs
;   :ensure t
;   :demand t
;   :config
;   (centaur-tabs-mode 1)
;   (setq centaur-tabs-style "bar"
;         centaur-tabs-height 20                    ; slim profile
;         centaur-tabs-set-icons t
;         centaur-tabs-set-modified-marker t
;         ;; --- clean and minimal settings ---
;         centaur-tabs-set-close-button nil          ; remove the 'x' close buttons
;         centaur-tabs-show-new-tab-button nil       ; remove the '+' button
;         centaur-tabs-show-navigation-buttons nil)  ; disable right-side nav buttons

;   (centaur-tabs-change-fonts "JetBrainsMono Nerd Font" 90)

;   ;; --- pure black face overrides ---
;   ;; force the native header-line (empty right-hand space) to pure black
;   (set-face-attribute 'header-line nil
;                        :background "#000000" :foreground "#F8F8F2"
;                        :box nil :underline nil)

;   ;; force the main tab bar background to pure black
;   (set-face-attribute 'centaur-tabs-default nil
;                        :background "#000000" :foreground "#F8F8F2")
;   (set-face-attribute 'centaur-tabs-active-bar-face nil
;                        :background "#20ce46")      ; active green accent indicator

;   ;; style active vs inactive tabs for high-contrast black aesthetic
;   (set-face-attribute 'centaur-tabs-selected nil
;                        :background "#000000" :foreground "#F8F8F2" :bold t)
;   (set-face-attribute 'centaur-tabs-unselected nil
;                        :background "#000000" :foreground "#666666")
;   (set-face-attribute 'centaur-tabs-selected-modified nil
;                        :background "#000000" :foreground "#20ce46")
;   (set-face-attribute 'centaur-tabs-unselected-modified nil
;                        :background "#000000" :foreground "#666666")

;   :bind
;   ("M-h" . centaur-tabs-backward)
;   ("M-l" . centaur-tabs-forward))

;; ===========================================================================
;; Rainbow delimiters for nested parens (useful in Rust/C/Lisp)
;; ===========================================================================
;; (use-package rainbow-delimiters
;;   :hook (prog-mode . rainbow-delimiters-mode))

;; ===========================================================================
;; Spellcheck while writing markdown/prose
;; ===========================================================================
;; (add-hook 'gfm-mode-hook #'flyspell-mode)

;################################################################################

; Kill async shell buffer / other part of config in init-compile.el fro bottom split window
(defun my/kill-async-shell-buffer ()
  "Kill the process, buffer, and window for `*Async Shell Command*`."
  (interactive)
  (let ((buf (get-buffer "*Async Shell Command*")))
    (if (not buf)
        (message "No async shell command buffer running.")
      (let ((proc (get-buffer-process buf))
            (win (get-buffer-window buf)))
        (when proc
          (set-process-query-on-exit-flag proc nil)
          (kill-process proc))
        (kill-buffer buf)
        (when (and win (window-live-p win))
          (delete-window win))))))

;################################################################################
;; Make Dired overwrite its own buffer instead of spawning a new one for every folder
(setq dired-kill-when-opening-new-buffer t)

(defun my/kill-dead-dired-buffers ()
  "Automatically kill Dired buffers when they are no longer visible on screen."
  (dolist (buf (buffer-list))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (when (and (eq major-mode 'dired-mode)
                   (not (get-buffer-window buf 'visible)))
          (kill-buffer buf))))))

;; Clear out any broken version of the hook first
(remove-hook 'window-configuration-change-hook #'my/kill-dired-buffers)
;; Add the corrected, zero-argument version
(add-hook 'window-configuration-change-hook #'my/kill-dead-dired-buffers)


(provide 'init-extras)
;;; init-extras.el ends here