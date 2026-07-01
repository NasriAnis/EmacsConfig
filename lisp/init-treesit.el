;;; init-treesit.el --- tree-sitter major modes, no LSP -*- lexical-binding: t; -*-

(setq treesit-language-source-alist
      '((rust   "https://github.com/tree-sitter/tree-sitter-rust")
        (c      "https://github.com/tree-sitter/tree-sitter-c")
        (cpp    "https://github.com/tree-sitter/tree-sitter-cpp")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (bash   "https://github.com/tree-sitter/tree-sitter-bash")
        (json   "https://github.com/tree-sitter/tree-sitter-json")
        (toml   "https://github.com/tree-sitter/tree-sitter-toml")
        (cmake  "https://github.com/uyha/tree-sitter-cmake")
        (make   "https://github.com/alemuller/tree-sitter-make")))

;; Run this once after first install (and whenever you add a language above):
;;   M-x my/treesit-install-all
(defun my/treesit-install-all ()
  "Download and build every grammar in `treesit-language-source-alist'."
  (interactive)
  (dolist (lang treesit-language-source-alist)
    (treesit-install-language-grammar (car lang))))

;; Prefer the tree-sitter major modes wherever a grammar is available
(dolist (mapping '((c-mode      . c-ts-mode)
                    (c++-mode    . c++-ts-mode)
                    (python-mode . python-ts-mode)
                    (sh-mode     . bash-ts-mode)
                    (json-mode   . json-ts-mode)))
  (add-to-list 'major-mode-remap-alist mapping))

(when (treesit-language-available-p 'rust)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode)))

(provide 'init-treesit)
;;; init-treesit.el ends here
