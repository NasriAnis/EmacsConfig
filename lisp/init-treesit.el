;;; init-treesit.el --- tree-sitter major modes, no LSP -*- lexical-binding: t; -*-

(setq treesit-language-source-alist
      '((rust       "https://github.com/tree-sitter/tree-sitter-rust")
        (c          "https://github.com/tree-sitter/tree-sitter-c")
        (cpp        "https://github.com/tree-sitter/tree-sitter-cpp")
        (python     "https://github.com/tree-sitter/tree-sitter-python")
        (bash       "https://github.com/tree-sitter/tree-sitter-bash")
        (json       "https://github.com/tree-sitter/tree-sitter-json")
        (toml       "https://github.com/tree-sitter/tree-sitter-toml")
        (html       "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (cmake      "https://github.com/uyha/tree-sitter-cmake")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (make       "https://github.com/alemuller/tree-sitter-make")))

;; Run this once after first install (and whenever you add a language above):
;;   M-x my/treesit-install-all
(defun my/treesit-install-all ()
  "Download and build every grammar in `treesit-language-source-alist'."
  (interactive)
  (dolist (lang treesit-language-source-alist)
    (treesit-install-language-grammar (car lang))))

;; Prefer the tree-sitter major modes wherever a grammar is available
(dolist (mapping '((c-mode          . c-ts-mode)
                    (c++-mode        . c++-ts-mode)
                    (python-mode     . python-ts-mode)
                    (sh-mode         . bash-ts-mode)
                    (json-mode       . json-ts-mode)
                    (typescript-mode . typescript-ts-mode)
                    (js-mode         . js-ts-mode)))
  (add-to-list 'major-mode-remap-alist mapping))

(add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.mts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cts\\'" . typescript-ts-mode))

(when (treesit-language-available-p 'rust)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode)))

(provide 'init-treesit)
;;; init-treesit.el ends here


; ;;; init-treesit.el --- tree-sitter major modes, no LSP -*- lexical-binding: t; -*-
; (setq treesit-language-source-alist
;       '((rust   "https://github.com/tree-sitter/tree-sitter-rust")
;         (c      "https://github.com/tree-sitter/tree-sitter-c")
;         (cpp    "https://github.com/tree-sitter/tree-sitter-cpp")
;         (python "https://github.com/tree-sitter/tree-sitter-python")
;         (bash   "https://github.com/tree-sitter/tree-sitter-bash")
;         (json   "https://github.com/tree-sitter/tree-sitter-json")
;         (toml   "https://github.com/tree-sitter/tree-sitter-toml")
;         (html   "https://github.com/tree-sitter/tree-sitter-html")
;         (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
;         (cmake  "https://github.com/uyha/tree-sitter-cmake")
;         (make   "https://github.com/alemuller/tree-sitter-make")))

; ;; Run this once after first install (and whenever you add a language above):
; ;;   M-x my/treesit-install-all
; (defun my/treesit-install-all ()
;   "Download and build every grammar in `treesit-language-source-alist'."
;   (interactive)
;   (dolist (lang treesit-language-source-alist)
;     (treesit-install-language-grammar (car lang))))

; ;; Prefer the tree-sitter major modes wherever a grammar is available.
; ;; major-mode-remap-alist catches ALL routes into a mode (auto-mode-alist,
; ;; interpreter-mode-alist, other packages calling (rust-mode) directly, etc.)
; ;; not just file-extension matches, so use it uniformly instead of mixing
; ;; it with auto-mode-alist entries.
; (dolist (mapping '((c-mode      . c-ts-mode)
;                     (c++-mode    . c++-ts-mode)
;                     (python-mode . python-ts-mode)
;                     (sh-mode     . bash-ts-mode)
;                     (json-mode   . json-ts-mode)
;                     (js-mode     . js-ts-mode)))
;   (add-to-list 'major-mode-remap-alist mapping))

; (when (treesit-language-available-p 'rust)
;   (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode)))

; ;; toml-mode isn't built into Emacs core, so there's no base mode to remap
; ;; from — hook the extension directly to toml-ts-mode instead.
; (when (treesit-language-available-p 'toml)
;   (add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode)))

; ;; HTML: Emacs core's tree-sitter HTML mode is `mhtml-ts-mode' (added in
; ;; Emacs 30), which handles embedded CSS/JS submodes the way `mhtml-mode'
; ;; does, unlike a plain `html-ts-mode'. On Emacs 29, `mhtml-ts-mode' does
; ;; not exist, so guard on both the grammar and the mode being present and
; ;; silently fall back to `mhtml-mode' otherwise.
; (if (and (treesit-language-available-p 'html)
;          (fboundp 'mhtml-ts-mode))
;     (add-to-list 'major-mode-remap-alist '(mhtml-mode . mhtml-ts-mode))
;   (when (treesit-language-available-p 'html)
;     (message "init-treesit: html grammar installed but mhtml-ts-mode unavailable (needs Emacs 30+); staying on mhtml-mode")))

; (provide 'init-treesit)
; ;;; init-treesit.el ends here
