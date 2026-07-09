;;; early-init.el --- runs before init.el, before frame/UI is created -*- lexical-binding: t; -*-

;; ---------------------------------------------------------------------------
;; Startup perf: GC is the biggest lever. Raise the threshold during startup,
;; drop it back down once we're idle so normal editing doesn't get sluggish.
;; ---------------------------------------------------------------------------
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024) ; 32mb
                  gc-cons-percentage 0.1)))

;; We call (package-initialize) ourselves in init.el, after setting up
;; archives. Stop Emacs from doing it automatically and redundantly.
(setq package-enable-at-startup nil)

;; ---------------------------------------------------------------------------
;; Reduce startup flicker / resize jank
;; ---------------------------------------------------------------------------
(setq frame-inhibit-implied-resize t)
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; Strip UI chrome BEFORE the first frame is drawn (doing this in init.el
;; means you see a flash of menu/toolbar first, then it disappears).
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Pure black, set at the frame-alist level so even the startup frame is black.
(push '(background-color . "#000000") default-frame-alist)
(push '(foreground-color . "#e0e0e0") default-frame-alist)

(setq use-file-dialog nil
      use-dialog-box nil)

;; Quiet native-comp warnings (they're noisy and not actionable day-to-day)
(setq native-comp-async-report-warnings-errors 'silent)

;; (add-to-list 'default-frame-alist '(undecorated . t))
