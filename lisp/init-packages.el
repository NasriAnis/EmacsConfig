;;; init-packages.el --- package.el + use-package bootstrap -*- lexical-binding: t; -*-

(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)   ; auto-install anything declared below

(provide 'init-packages)
;;; init-packages.el ends here
