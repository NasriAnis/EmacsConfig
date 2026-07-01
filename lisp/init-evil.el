;;; init-evil.el --- vim keybindings: evil, leader key, which-key -*- lexical-binding: t; -*-

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil   ; let evil-collection handle keybinding setup
        evil-want-C-u-scroll t     ; C-u = scroll up, like real vim
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  ;; gives you proper evil bindings inside magit, compilation buffers,
  ;; dired, help, etc. instead of half-vim half-emacs everywhere
  (evil-collection-init))

(use-package evil-commentary   ; gcc / gc<motion> to comment code, vim-commentary style
  :after evil
  :config (evil-commentary-mode))

;; Leader key (SPC), since plain evil doesn't give you one
(use-package general
  :after evil
  :config
  (general-create-definer my/leader
    :states '(normal visual motion)
    :keymaps 'override   ; takes priority over evil's own SPC binding
    :prefix "SPC")
  (my/leader
    "f"  '(:ignore t :which-key "file")
    "fd" 'dired
    "fD" 'dired-jump

    "b"  '(:ignore t :which-key "buffer")
    "bb" 'switch-to-buffer
    "bk" 'kill-buffer

    "w"  '(:ignore t :which-key "window")
    "wv" 'split-window-right
    "ws" 'split-window-below
    "wd" 'delete-window
    "wo" 'delete-other-windows

    "g"  '(:ignore t :which-key "git")
    "gg" 'magit-status
    "gb" 'magit-blame
    "gl" 'magit-log-current
    "gh" '(:ignore t :which-key "hunk")
    "ghs" 'diff-hl-stage-current-hunk
    "ghr" 'diff-hl-revert-hunk
    "ghp" 'diff-hl-show-hunk
    "ghn" 'diff-hl-next-hunk
    "ghP" 'diff-hl-previous-hunk

    "c"  '(:ignore t :which-key "compile")
    "cc" 'compile
    "cr" 'recompile
    "cn" 'next-error
    "cp" 'previous-error

    "q"  '(:ignore t :which-key "quit/session")
    "qs" 'my/session-save   ; SPC q s -> Saves current directory session
    "ql" 'my/session-load   ; SPC q l -> Search and load a folder session
    "qd" 'my/session-delete ; SPC q d -> Delete a session

    "tt" 'my/vterm-toggle
    "tk" 'my/open-kitty   ; SPC t k -> opens Kitty as its own window, cd'd here

    "qq" 'save-buffers-kill-terminal))

(use-package which-key   ; shows available leader bindings as you type SPC
  :config (which-key-mode 1))

(provide 'init-evil)
;;; init-evil.el ends here
