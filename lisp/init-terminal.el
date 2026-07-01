;;; init-terminal.el --- vterm + kitty -*- lexical-binding: t; -*-

(use-package vterm
  :commands vterm)

(defvar my/vterm-buffer-name "*vterm-main*")
(defvar my/vterm-last-wconf nil)

(defun my/vterm-toggle ()
  "Toggle a single persistent fullscreen vterm session.
Hiding it does NOT kill the process — switching back resumes the same
session, still running whatever you left going. The buffer only closes
when the shell itself exits (you type `exit`), never by force-kill."
  (interactive)
  (if (and (get-buffer my/vterm-buffer-name)
           (get-buffer-window my/vterm-buffer-name))
      ;; visible -> hide it, restore whatever windows you had before
      (when (window-configuration-p my/vterm-last-wconf)
        (set-window-configuration my/vterm-last-wconf))
    ;; not visible -> remember current layout, then show fullscreen
    (setq my/vterm-last-wconf (current-window-configuration))
    (if (get-buffer my/vterm-buffer-name)
        (switch-to-buffer my/vterm-buffer-name)
      (vterm my/vterm-buffer-name))
    (delete-other-windows)))

(defun my/open-kitty ()
  "Open a Kitty terminal window in the current project/buffer's directory."
  (interactive)
  (let ((dir (if-let ((proj (project-current)))
                 (project-root proj)
               default-directory)))
    (start-process "kitty" nil "kitty" "--directory" (expand-file-name dir))))

(provide 'init-terminal)
;;; init-terminal.el ends here
