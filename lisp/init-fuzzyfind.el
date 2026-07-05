
;; ===========================================================================
;; Fuzzy-find-everywhere (Equivalent to fzf-lua/Telescope in Neovim)
;; ===========================================================================

;; 1. Vertico: Minimalist, fast vertical completion UI for the minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :config
  ;; Enable cycling through the candidate list
  (setq vertico-cycle t
        vertico-resize nil) ; Keep minibuffer height stable
  
  ;; Bindings inside Vertico search window
  :bind (:map vertico-map
              ("C-j" . vertico-next)       ; Vim-style down
              ("C-k" . vertico-previous))) ; Vim-style up

;################################################################################

;; 2. Orderless: The ultimate fuzzy-matching engine
;; Allows you to type space-separated terms in any order to narrow down results.
(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        ;; Enable partial-completion for files (e.g., matching /u/s/lo to /usr/share/local)
        completion-category-overrides '((file (styles partial-completion)))))

;################################################################################

;; 3. Marginalia: Adds rich metadata annotations in the minibuffer margin
;; Displays file sizes, file permissions, git statuses, and command docstrings!
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

;################################################################################

;; 4. Consult: Interactive search & navigation commands (Matches fzf-lua features)
(use-package consult
  :ensure t
  :bind (
         ;; Switch buffers with live vertical previews
         ("C-x b" . consult-buffer)
         ; ("M-b" . consult-buffer)

         ;; Search current buffer line-by-line (highly interactive, like Swiper/FZF)
         ("M-s" . consult-line)

         ;; Find files starting from the current folder (like fzf.files)
         ("M-f" . consult-find)

         ;; Live RipGrep (instantly search code across the current project directory)
         ;; Note: Requires the 'ripgrep' binary installed on your Ubuntu machine
         ("M-g" . consult-ripgrep)

         ;; Jump to any function, heading, or variable in the current file
         ("M-i" . consult-imenu))
  :init
  ;; Configure live preview behavior for buffers and search commands
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format
        consult-preview-key 'any) ; Preview immediately on cursor movement

  :config
  ;; Extend the default filter list with your own noisy buffers
  (setq consult-buffer-filter
    (append consult-buffer-filter
      '("\\`\\*Messages\\*\\'"
        "\\`\\*Warnings\\*\\'"
        "\\`\\*Async-native-compile-log\\*\\'"
        "\\`\\*straight-process\\*\\'"
        "\\`magit-process:.*\\'"
        "\\`\\*Flymake.*\\'"
        "\\`\\*scratch\\*\\'"
        "\\`\\*Compile-Log\\*\\'"))))

;################################################################################

;; 5. Native Project File Finder (Like fzf.git_files / project-wide search)
;; Uses Emacs' built-in lightweight project manager.
;; We only use Alt + p (M-p) to avoid hijacking C-p (up) inside minibuffers.
;; (global-set-key (kbd "M-p") 'project-find-file)
;; keybinf leader ff can be found inside init-evil.el

;; Clean up minibuffer visual style
(savehist-mode 1) ; Persist minibuffer history across Emacs restarts

;################################################################################

; (use-package embark-consult
;   :ensure t
;   :after (embark consult))




(provide 'init-fuzzyfind)
