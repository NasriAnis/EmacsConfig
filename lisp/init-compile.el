;;; init-compile.el --- compile/recompile, run from project root -*- lexical-binding: t; -*-
(use-package compile
  :ensure nil   ; built into Emacs
  :config
  (setq compilation-scroll-output t        ; follow output as it streams
        compilation-ask-about-save nil     ; just save before compiling
        compilation-always-kill t)         ; don't ask to kill a running compile

  ;; 0a. Compilation window: bottom split
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*compilation\\*"
  ;;                (display-buffer-reuse-window
  ;;                 display-buffer-in-side-window)
  ;;                (side . bottom)
  ;;                (slot . 0)
  ;;                (window-height . 0.25)
  ;;                (dedicated . t)
  ;;                (reusable-frames . visible)))
  ;; ;; 0b. Async shell command window: bottom split
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*Async Shell Command\\*"
  ;;                (display-buffer-reuse-window
  ;;                 display-buffer-in-side-window)
  ;;                (side . bottom)
  ;;                (slot . 1)
  ;;                (window-height . 0.25)
  ;;                (dedicated . t)
  ;;                (reusable-frames . visible)))

  ;; 0a. Compilation window: bottom split (regular window, not side window)
  (add-to-list 'display-buffer-alist
	       '("\\*compilation\\*"
		 (display-buffer-reuse-window
		  display-buffer-at-bottom)
		 (window-height . 0.4)
		 (reusable-frames . visible)))

  ;; 0b. Async shell command window: bottom split (regular window, not side window)
  (add-to-list 'display-buffer-alist
               '("\\*Async Shell Command\\*"
		 (display-buffer-reuse-window
                  display-buffer-at-bottom)
		 (window-height . 0.25)
		 (reusable-frames . visible)))

  ;; 1. Parse Rust/Cargo error patterns correctly, with severity-based coloring
  (add-to-list 'compilation-error-regexp-alist 'cargo-error)
  (add-to-list 'compilation-error-regexp-alist 'cargo-warning)
  (add-to-list 'compilation-error-regexp-alist 'cargo-note)
  ;; error[E0384]: ...
  ;;   --> src/main.rs:5:9
  (add-to-list 'compilation-error-regexp-alist-alist
               '(cargo-error
                 "^error\\(\\[E[0-9]+\\]\\)?:.*\n\\s-*--> \\([^:\n]+\\):\\([0-9]+\\):\\([0-9]+\\)"
                 2 3 4 2))   ; type 2 = error (red)
  ;; warning: unused variable: `x`
  ;;   --> src/main.rs:3:9
  (add-to-list 'compilation-error-regexp-alist-alist
               '(cargo-warning
                 "^warning:.*\n\\s-*--> \\([^:\n]+\\):\\([0-9]+\\):\\([0-9]+\\)"
                 1 2 3 1))   ; type 1 = warning (yellow)
  ;; note: `x` does not implement `Copy`
  ;;   --> src/main.rs:3:9
  (add-to-list 'compilation-error-regexp-alist-alist
               '(cargo-note
                 "^note:.*\n\\s-*--> \\([^:\n]+\\):\\([0-9]+\\):\\([0-9]+\\)"
                 1 2 3 0))   ; type 0 = info (blue/gray)
  ;; 2. Intercept compilation and force execution from the project root
  (defun my/compile-at-project-root (orig-fun &rest args)
    "Force `compile` to run from the root of the current project/git repo."
    (let ((default-directory (if-let ((proj (project-current)))
                                  (project-root proj)
                                default-directory)))
      (apply orig-fun args)))
  (advice-add 'compile :around #'my/compile-at-project-root)
  (advice-add 'recompile :around #'my/compile-at-project-root)
  ;; 3. Free up C-k so it falls through to window-movement instead of
  ;;    compilation-previous-error
  (define-key compilation-mode-map (kbd "C-k") nil)
  (with-eval-after-load 'evil-collection-compile
    (evil-collection-define-key 'normal 'compilation-mode-map
      (kbd "C-k") nil)))
;; 4. When jumping to an error, reuse an existing window instead of
;;    splitting to create a new one
(setq display-buffer-base-action
      '((display-buffer-reuse-window
         display-buffer-use-some-window)))
;; leader-key bindings for compile live in init-evil.el (SPC c c / c r / c n / c p / c k)
(provide 'init-compile)
;;; init-compile.el ends here
