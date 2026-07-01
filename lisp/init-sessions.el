;;; init-sessions.el --- per-project desktop sessions -*- lexical-binding: t; -*-

(use-package desktop
  :ensure nil
  :init
  (setq desktop-save-mode nil
        desktop-auto-save-timeout nil
        desktop-load-locked-desktop t)
  :config
  (defun my/get-project-session-dir ()
    "Get unique session directory based strictly on the opened project/workspace root."
    (let* ((root (if-let ((proj (project-current)))
                     (project-root proj)         ; Force the actual opened folder root
                   default-directory))           ; Fallback if not a project
           (safe-name (subst-char-in-string ?/ ?! root))
           (session-dir (expand-file-name (concat "sessions/" safe-name) user-emacs-directory)))
      (make-directory session-dir t)
      session-dir))

  (defun my/session-save ()
    "Manually save the session for the opened project root folder."
    (interactive)
    (let* ((proj-root (if-let ((proj (project-current))) (project-root proj) default-directory))
           (desktop-dirname (my/get-project-session-dir)))
      ;; Lock the desktop's internal directory references to the project root folder
      (setq desktop-directory-list (list proj-root))
      (desktop-save desktop-dirname)
      (message "Session saved for project root: %s" proj-root)))

  (defun my/session-load ()
    "Search and jump back to a saved project folder session."
    (interactive)
    (let* ((sessions-base (expand-file-name "sessions/" user-emacs-directory))
           (folders (when (file-directory-p sessions-base)
                      (directory-files sessions-base nil "^[^.]")))
           (decoded-folders (mapcar (lambda (f) (subst-char-in-string ?! ?/ f)) folders)))
      (if (null decoded-folders)
          (message "No saved sessions found.")
        (let* ((chosen-path (completing-read "Jump to workspace session: " decoded-folders))
               (encoded-path (subst-char-in-string ?/ ?! chosen-path))
               (target-dir (expand-file-name encoded-path sessions-base)))
          (desktop-read target-dir)
          (setq default-directory chosen-path)
          (message "Switched to workspace layout: %s" chosen-path))))))

(defun my/session-delete ()
    "Search and delete a saved project folder session from disk."
    (interactive)
    (let* ((sessions-base (expand-file-name "sessions/" user-emacs-directory))
           (folders (when (file-directory-p sessions-base)
                      (directory-files sessions-base nil "^[^.]")))
           (decoded-folders (mapcar (lambda (f) (subst-char-in-string ?! ?/ f)) folders)))
      (if (null decoded-folders)
          (message "No saved sessions found.")
        (let* ((chosen-path (completing-read "Delete workspace session: " decoded-folders))
               (encoded-path (subst-char-in-string ?/ ?! chosen-path))
               (target-dir (expand-file-name encoded-path sessions-base)))
          (when (yes-or-no-p (format "Permanently delete session for %s? " chosen-path))
            (delete-directory target-dir t t)
            (message "Deleted session layout for: %s" chosen-path))))))

(defun my/session-exists-for-root-p (root)
  "Check if a saved session already exists for ROOT, without creating anything."
  (let* ((safe-name (subst-char-in-string ?/ ?! root))
         (session-dir (expand-file-name (concat "sessions/" safe-name) user-emacs-directory))
         (desktop-file (expand-file-name desktop-base-file-name session-dir)))
    (file-exists-p desktop-file)))

(defun my/session-auto-save-on-exit ()
  "If a session already exists for the current project root, save it automatically on exit."
  (let ((proj-root (if-let ((proj (project-current))) (project-root proj) default-directory)))
    (when (my/session-exists-for-root-p proj-root)
      (ignore-errors (my/session-save))
      (message "Auto-saved session for: %s" proj-root))))

(add-hook 'kill-emacs-hook #'my/session-auto-save-on-exit)

(provide 'init-sessions)
;;; init-sessions.el ends here
