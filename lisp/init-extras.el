;;; init-extras.el --- optional extras, commented out by default -*- lexical-binding: t; -*-
;; Uncomment whatever you want to try. Left out by default to keep the base
;; config genuinely minimal.

; ===========================================================================
; TABS (centaur-tabs)
; ===========================================================================
(use-package centaur-tabs
  :ensure t
  :demand t
  :config
  (centaur-tabs-mode 1)
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 20                    ; slim profile
        centaur-tabs-set-icons t
        centaur-tabs-set-modified-marker t
        ;; --- clean and minimal settings ---
        centaur-tabs-set-close-button nil          ; remove the 'x' close buttons
        centaur-tabs-show-new-tab-button nil       ; remove the '+' button
        centaur-tabs-show-navigation-buttons nil)  ; disable right-side nav buttons

  (centaur-tabs-change-fonts "JetBrainsMono Nerd Font" 90)

  ;; --- pure black face overrides ---
  ;; force the native header-line (empty right-hand space) to pure black
  (set-face-attribute 'header-line nil
                       :background "#000000" :foreground "#F8F8F2"
                       :box nil :underline nil)

  ;; force the main tab bar background to pure black
  (set-face-attribute 'centaur-tabs-default nil
                       :background "#000000" :foreground "#F8F8F2")
  (set-face-attribute 'centaur-tabs-active-bar-face nil
                       :background "#20ce46")      ; active green accent indicator

  ;; style active vs inactive tabs for high-contrast black aesthetic
  (set-face-attribute 'centaur-tabs-selected nil
                       :background "#000000" :foreground "#F8F8F2" :bold t)
  (set-face-attribute 'centaur-tabs-unselected nil
                       :background "#000000" :foreground "#666666")
  (set-face-attribute 'centaur-tabs-selected-modified nil
                       :background "#000000" :foreground "#20ce46")
  (set-face-attribute 'centaur-tabs-unselected-modified nil
                       :background "#000000" :foreground "#666666")

  :bind
  ("M-h" . centaur-tabs-backward)
  ("M-l" . centaur-tabs-forward))

;; ===========================================================================
;; MODERN PERFORMANCE FILE TREE (Dirvish)
;; ===========================================================================
; (use-package dirvish
;   :ensure t
;   :init
;   (dirvish-override-dired-mode) ; Replace native dired with dirvish everywhere
;   :config
;   (setq dirvish-attributes '(vc-state file-size) ; Keep it light and uncluttered
;         dirvish-side-width 30)
;
;   ;; Style the sidebar components safely using standard faces
;   (with-eval-after-load 'dirvish
;     (set-face-attribute 'header-line nil :background "#000000" :box nil)
;     (set-face-attribute 'fringe nil :background "#000000")))
;
;; Toggle shortcut under your leader keys (SPC t t)
;; (my/leader
;;   "t" '(:ignore t :which-key "tabs/tree")
;;   "tt" #'dirvish-side)

;; ===========================================================================
;; Fuzzy-find-everywhere (closer to fzf-lua in your nvim config)
;; ===========================================================================
;; (use-package vertico   :config (vertico-mode 1))
;; (use-package orderless :config (setq completion-styles '(orderless basic)))
;; (use-package marginalia :config (marginalia-mode 1))

;; ===========================================================================
;; Rainbow delimiters for nested parens (useful in Rust/C/Lisp)
;; ===========================================================================
;; (use-package rainbow-delimiters
;;   :hook (prog-mode . rainbow-delimiters-mode))

;; ===========================================================================
;; Spellcheck while writing markdown/prose
;; ===========================================================================
;; (add-hook 'gfm-mode-hook #'flyspell-mode)


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
              ("C-n" . vertico-next)
              ("C-p" . vertico-previous)
              ("C-j" . vertico-next)       ; Vim-style down
              ("C-k" . vertico-previous))) ; Vim-style up

;; 2. Orderless: The ultimate fuzzy-matching engine
;; Allows you to type space-separated terms in any order to narrow down results.
(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        ;; Enable partial-completion for files (e.g., matching /u/s/lo to /usr/share/local)
        completion-category-overrides '((file (styles partial-completion)))))

;; 3. Marginalia: Adds rich metadata annotations in the minibuffer margin
;; Displays file sizes, file permissions, git statuses, and command docstrings!
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

;; 4. Consult: Interactive search & navigation commands (Matches fzf-lua features)
(use-package consult
  :ensure t
  :bind (
         ;; Switch buffers with live vertical previews
         ("C-x b" . consult-buffer)
         ("M-b" . consult-buffer)

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
        consult-preview-key 'any)) ; Preview immediately on cursor movement

;; 5. Native Project File Finder (Like fzf.git_files / project-wide search)
;; Uses Emacs' built-in lightweight project manager.
;; We only use Alt + p (M-p) to avoid hijacking C-p (up) inside minibuffers.
(global-set-key (kbd "M-p") 'project-find-file)

;; Clean up minibuffer visual style
(savehist-mode 1) ; Persist minibuffer history across Emacs restarts


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


(provide 'init-extras)
;;; init-extras.el ends here