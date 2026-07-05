;;; init-git.el --- magit + diff-hl gutter -*- lexical-binding: t; -*-

;; ===========================================================================
;; GIT (magit — the tool neogit was built to imitate)
;; ===========================================================================
; (use-package magit
;   :commands (magit-status magit-blame magit-log-current))
;; evil-collection (loaded in init-evil.el) auto-wires evil keybindings into
;; magit's status buffer, so j/k/Enter/etc. just work without extra config.

;; Kill all magit processes via q
(use-package magit
  :commands (magit-status magit-blame magit-log-current)
  :init
  (setq magit-bury-buffer-function #'magit-mode-quit-window)
  :config
  (defun my/magit-kill-all-buffers ()
    "Kill ALL magit-related buffers, everywhere, no leftovers."
    (interactive)
    (magit-mode-quit-window t) ;; t = kill-buffer, restores window layout properly
    (dolist (buf (buffer-list))
      (when (with-current-buffer buf
              (derived-mode-p 'magit-mode 'magit-process-mode))
        (kill-buffer buf))))

  ;; Bind for vanilla Emacs keybinding users
  (dolist (map (list magit-status-mode-map
                      magit-diff-mode-map
                      magit-log-mode-map
                      magit-revision-mode-map
                      magit-stash-mode-map
                      magit-process-mode-map))
    (define-key map (kbd "q") #'my/magit-kill-all-buffers))

  ;; Bind for evil-collection, since that's likely what's actually
  ;; intercepting "q" in your setup
  (with-eval-after-load 'evil-collection-magit
    (dolist (mode '(magit-status-mode magit-diff-mode magit-log-mode
                     magit-revision-mode magit-stash-mode
                     magit-process-mode))
      (evil-collection-define-key 'normal (intern (format "%s-map" mode))
        "q" #'my/magit-kill-all-buffers))))

;; ===========================================================================
;; GIT GUTTER (diff-hl — colored gutter for changed lines, IDE-style)
;; ===========================================================================
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (gfm-mode  . diff-hl-mode)
         ;; refresh the gutter automatically after magit stages/commits/etc.
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode 1)

  ;; Use the margin (a dedicated column) instead of the fringe — the fringe
  ;; bitmap was overlapping display-line-numbers and hiding the number itself.
  (diff-hl-margin-mode 1)
  (setq diff-hl-margin-symbols-alist
        '((insert . "┃") (delete . "┃") (change . "┃")
          (unknown . "┃") (ignored . "┃")))

  ;; Continuous updates as you type, not just on save (idle-timer based)
  (diff-hl-flydiff-mode 1)

  ;; Colors: for the margin these apply to both foreground AND background of
  ;; the symbol character, so they're actually visible now.
  (set-face-attribute 'diff-hl-insert nil :foreground "#00ff5f" :background "#000000")
  (set-face-attribute 'diff-hl-change nil :foreground "#ffaf00" :background "#000000")
  (set-face-attribute 'diff-hl-delete nil :foreground "#ff3333" :background "#000000"))

;; Stage/revert/see a diff for the hunk under point, without opening magit:
;;   SPC g h s  -> stage this hunk
;;   SPC g h r  -> revert this hunk
;;   SPC g h p  -> preview/peek the diff for this hunk
;; (bound in init-evil.el's leader map)

(provide 'init-git)
;;; init-git.el ends here


;; ;;; init-git.el --- magit + diff-hl gutter -*- lexical-binding: t; -*-

;; ;; ===========================================================================
;; ;; GIT (magit   the tool neogit was built to imitate)
;; ;; ===========================================================================
;; ; (use-package magit
;; ;   :commands (magit-status magit-blame magit-log-current))
;; ;; evil-collection (loaded in init-evil.el) auto-wires evil keybindings into
;; ;; magit's status buffer, so j/k/Enter/etc. just work without extra config.
;; ;; Kill all magit processes via q
;; (use-package magit
;;   :commands (magit-status magit-blame magit-log-current)
;;   :init
;;   (setq magit-bury-buffer-function #'magit-mode-quit-window)
;;   ;; Always show the diff when committing
;;   (setq magit-commit-show-diff t)
;;   :config
;;   (defun my/magit-kill-all-buffers ()
;;     "Kill ALL magit-related buffers, everywhere, no leftovers."
;;     (interactive)
;;     (magit-mode-quit-window t) ;; t = kill-buffer, restores window layout properly
;;     (dolist (buf (buffer-list))
;;       (when (with-current-buffer buf
;;               (derived-mode-p 'magit-mode 'magit-process-mode))
;;         (kill-buffer buf))))
;;   ;; Bind for vanilla Emacs keybinding users
;;   (dolist (map (list magit-status-mode-map
;;                       magit-diff-mode-map
;;                       magit-log-mode-map
;;                       magit-revision-mode-map
;;                       magit-stash-mode-map
;;                       magit-process-mode-map))
;;     (define-key map (kbd "q") #'my/magit-kill-all-buffers))
;;   ;; Bind for evil-collection, since that's likely what's actually
;;   ;; intercepting "q" in your setup
;;   (with-eval-after-load 'evil-collection-magit
;;     (dolist (mode '(magit-status-mode magit-diff-mode magit-log-mode
;;                      magit-revision-mode magit-stash-mode
;;                      magit-process-mode))
;;       (evil-collection-define-key 'normal (intern (format "%s-map" mode))
;;         "q" #'my/magit-kill-all-buffers))))

;; ;; ===========================================================================
;; ;; WINDOW LAYOUT (force commit-msg / diff into a left/right split)
;; ;; ===========================================================================
;; ;; Emacs' generic split-window-sensibly falls back to a top/bottom split
;; ;; whenever the frame is narrower than `split-width-threshold` (160 cols by
;; ;; default). Lower it so side-by-side splitting kicks in on normal-width
;; ;; frames, and disable the horizontal fallback entirely.
;; (setq split-width-threshold 100    ;; side-by-side once frame >= ~100 cols
;;       split-height-threshold nil)  ;; never fall back to top/bottom

;; ;; Belt-and-suspenders: force the magit diff buffer specifically into a
;; ;; right-hand side window regardless of frame size, so `c c` always gives
;; ;; you commit message on the left, diff on the right.
;; ;; (add-to-list 'display-buffer-alist
;; ;;              '("COMMIT_EDITMSG"
;; ;;                (display-buffer-reuse-window display-buffer-same-window)
;; ;;                (side . left)))

;; ;; (add-to-list 'display-buffer-alist
;; ;;              '("\\`magit-diff"
;; ;;                (display-buffer-in-side-window)
;; ;;                (side . right)
;; ;;                (window-width . 0.5)))

;; (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)

;; ;; Commit message buffer stays full-frame too (no diff pane, since diff-on-
;; ;; commit is shown as a separate buffer you can switch to if needed)
;; (add-to-list 'display-buffer-alist
;;              '("COMMIT_EDITMSG"
;;                (display-buffer-same-window)))

;; ;; ===========================================================================
;; ;; GIT GUTTER (diff-hl   colored gutter for changed lines, IDE-style)
;; ;; ===========================================================================
;; (use-package diff-hl
;;   :hook ((prog-mode . diff-hl-mode)
;;          (gfm-mode  . diff-hl-mode)
;;          ;; refresh the gutter automatically after magit stages/commits/etc.
;;          (magit-post-refresh . diff-hl-magit-post-refresh))
;;   :config
;;   (global-diff-hl-mode 1)
;;   ;; Use the margin (a dedicated column) instead of the fringe   the fringe
;;   ;; bitmap was overlapping display-line-numbers and hiding the number itself.
;;   (diff-hl-margin-mode 1)
;;   (setq diff-hl-margin-symbols-alist
;;         '((insert . " ") (delete . " ") (change . " ")
;;           (unknown . " ") (ignored . " ")))
;;   ;; Continuous updates as you type, not just on save (idle-timer based)
;;   (diff-hl-flydiff-mode 1)
;;   ;; Colors: for the margin these apply to both foreground AND background of
;;   ;; the symbol character, so they're actually visible now.
;;   (set-face-attribute 'diff-hl-insert nil :foreground "#00ff5f" :background "#000000")
;;   (set-face-attribute 'diff-hl-change nil :foreground "#ffaf00" :background "#000000")
;;   (set-face-attribute 'diff-hl-delete nil :foreground "#ff3333" :background "#000000"))

;; ;; Stage/revert/see a diff for the hunk under point, without opening magit:
;; ;;   SPC g h s  -> stage this hunk
;; ;;   SPC g h r  -> revert this hunk
;; ;;   SPC g h p  -> preview/peek the diff for this hunk
;; ;; (bound in init-evil.el's leader map)

;; (provide 'init-git)
;; ;;; init-git.el ends here
