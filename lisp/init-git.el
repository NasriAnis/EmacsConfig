;;; init-git.el --- magit + diff-hl gutter -*- lexical-binding: t; -*-

;; ===========================================================================
;; GIT (magit — the tool neogit was built to imitate)
;; ===========================================================================
(use-package magit
  :commands (magit-status magit-blame magit-log-current))
;; evil-collection (loaded in init-evil.el) auto-wires evil keybindings into
;; magit's status buffer, so j/k/Enter/etc. just work without extra config.

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
