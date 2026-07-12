;;; init-extras.el --- optional extras, commented out by default -*- lexical-binding: t; -*-
;; Uncomment whatever you want to try. Left out by default to keep the base
;; config genuinely minimal.

; ===========================================================================
; moving between tabs
; ===========================================================================
;; Make sure evil is loaded first
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "H") 'previous-buffer)
  (define-key evil-normal-state-map (kbd "L") 'next-buffer))

; ===========================================================================
; Full sreen splits
; ===========================================================================
(defvar my/window-config-before-fullscreen nil)

(defun my/toggle-buffer-fullscreen ()
  "Toggle current window between full-frame and previous split layout."
  (interactive)
  (if (and my/window-config-before-fullscreen
           (= 1 (length (window-list))))
      (progn
        (set-window-configuration my/window-config-before-fullscreen)
        (setq my/window-config-before-fullscreen nil))
    (setq my/window-config-before-fullscreen (current-window-configuration))
    (delete-other-windows)))

(global-set-key (kbd "C-c t f") #'my/toggle-buffer-fullscreen)

;################################################################################
;; Make Dired overwrite its own buffer instead of spawning a new one for every folder
;################################################################################

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

;################################################################################
;; higlight parenthesis
;################################################################################
(use-package highlight-parentheses
  :ensure t
  :hook (prog-mode . highlight-parentheses-mode))


(provide 'init-extras)
;;; init-extras.el ends here
