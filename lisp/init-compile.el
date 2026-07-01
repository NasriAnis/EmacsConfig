;;; init-compile.el --- compile/recompile, run from project root -*- lexical-binding: t; -*-

(use-package compile
  :ensure nil   ; built into Emacs
  :config
  (setq compilation-scroll-output t        ; follow output as it streams
        compilation-ask-about-save nil     ; just save before compiling
        compilation-always-kill t)         ; don't ask to kill a running compile

  ;; 1. Parse Rust/Cargo error patterns correctly
  (with-eval-after-load 'compile
    (add-to-list 'compilation-error-regexp-alist 'cargo)
    (add-to-list 'compilation-error-regexp-alist-alist
                 '(cargo "^\\s-+-->\\s-+\\([^:\n]+\\):\\([0-9]+\\):\\([0-9]+\\)" 1 2 3)))

  ;; 2. Intercept compilation and force execution from the project root
  (defun my/compile-at-project-root (orig-fun &rest args)
    "Force `compile` to run from the root of the current project/git repo."
    (let ((default-directory (if-let ((proj (project-current)))
                                 (project-root proj)
                               default-directory)))
      (apply orig-fun args)))

  (advice-add 'compile :around #'my/compile-at-project-root)
  (advice-add 'recompile :around #'my/compile-at-project-root))

;; leader-key bindings for compile live in init-evil.el (SPC c c / c r / c n / c p)

(provide 'init-compile)
;;; init-compile.el ends here
