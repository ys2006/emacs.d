;; -*- coding: utf-8; lexical-binding: t; -*-
;; (advice-add #'package-initialize :after #'update-load-path)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (defadvice package-initialize (after my-init-load-path activate)
;;   "Reset `load-path'."
;;   (push (expand-file-name "~/.emacs.d/lisp") load-path))
(package-initialize)
(push (expand-file-name "~/.emacs.d/lisp") load-path)

(let* ((minver "24.4"))
  (when (version< emacs-version minver)
    (error "Emacs v%s or higher is required." minver)))

(defvar best-gc-cons-threshold
  4000000
  "Best default gc threshold value.  Should NOT be too big!")

;; don't GC during startup to save time
(setq gc-cons-threshold most-positive-fixnum)


(setq emacs-load-start-time (current-time))

;; (setq url-using-proxy t)
;; (setq url-proxy-services
;;       '(("http"     . "cn-proxy.cn.oracle.com:80")
;;         ("https"    . "cn-proxy.cn.oracle.com:80")
;;         ("ftp"      . "cn-proxy.cn.oracle.com:80")
;;         ("no_proxy" . "^\\(localhost\\|8.*\\)")))

;; (setq url-proxy-services
;;     '(("http"     . "www-proxy.us.oracle.com:80")
;;       ("https"    . "www-proxy.us.oracle.com:80")
;;       ("ftp"      . "www-proxy.us.oracle.com:80")
;;       ("no_proxy" . "^\\(localhost\\|10.*\\)")))

(setq default-directory "~/.emacs.d")
;;(setq browse-url-browser-function 'browse-url-default-windows-browser)
;;(setq browse-url-browser-function 'eww-browse-url)
;;(setq tramp-default-method "ssh")
;;(setq tramp-chunksize 500)
;;(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

;; {{ emergency security fix
;; https://bugs.debian.org/766397
(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))
;; }}
(modify-all-frames-parameters '((inhibit-double-buffering . t)))
;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *is-a-mac* (eq system-type 'darwin))
(setq *win64* (eq system-type 'windows-nt))
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *emacs24* (>= emacs-major-version 24))
(setq *emacs25* (>= emacs-major-version 25))
(setq *emacs26* (>= emacs-major-version 26))
(setq *no-memory* (cond
                   (*is-a-mac*
                    (< (string-to-number (nth 1 (split-string (shell-command-to-string "sysctl hw.physmem")))) 4000000000))
                   (*linux* nil)
                   (t nil)))

;; @see https://www.reddit.com/r/emacs/comments/55ork0/is_emacs_251_noticeably_slower_than_245_on_windows/
;; Emacs 25 does gc too frequently
(when *emacs25*
  ;; (setq garbage-collection-messages t) ; for debug
  (setq best-gc-cons-threshold (* 64 1024 1024))
  (setq gc-cons-percentage 0.5)
  (run-with-idle-timer 5 t #'garbage-collect))

(defmacro local-require (pkg)
  `(unless (featurep ,pkg)
     (load (expand-file-name
             (cond
               ((eq ,pkg 'bookmark+)
                (format "~/.emacs.d/site-lisp/bookmark-plus/%s" ,pkg))
               ((eq ,pkg 'go-mode-load)
                (format "~/.emacs.d/site-lisp/go-mode/%s" ,pkg))
               (t
                 (format "~/.emacs.d/site-lisp/%s/%s" ,pkg ,pkg))))
           t t)))

;; *Message* buffer should be writable in 24.4+
(defadvice switch-to-buffer (after switch-to-buffer-after-hack activate)
  (if (string= "*Messages*" (buffer-name))
      (read-only-mode -1)))

;; @see https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
;; Normally file-name-handler-alist is set to
;; (("\\`/[^/]*\\'" . tramp-completion-file-name-handler)
;; ("\\`/[^/|:][^/|]*:" . tramp-file-name-handler)
;; ("\\`/:" . file-name-non-special))
;; Which means on every .el and .elc file loaded during start up, it has to runs those regexps against the filename.
(let* ((file-name-handler-alist nil))
  ;; `package-initialize' takes 35% of startup time
  ;; need check https://github.com/hlissner/doom-emacs/wiki/FAQ#how-is-dooms-startup-so-fast for solution
  (require 'init-autoload)
  (require 'init-modeline)
  (require 'init-utils)
  (require 'init-elpa)
  (require 'init-exec-path) ;; Set up $PATH
  ;; Any file use flyspell should be initialized after init-spelling.el
  (require 'init-spelling)
  (require 'init-gui-frames)
  (require 'init-uniquify)
  (require 'init-ibuffer)
  (require 'init-ivy)
  (require 'init-hippie-expand)
  (require 'init-windows)
  (require 'init-markdown)
  (require 'init-erlang)
  (require 'init-javascript)
  (require 'init-org)
  (require 'init-css)
  (require 'init-python)
  (require 'init-haskell)
  (require 'init-ruby-mode)
  (require 'init-lisp)
  (require 'init-elisp)
  (require 'init-yasnippet)
  ;; Use bookmark instead
  (require 'init-cc-mode)
  (require 'init-gud)
  (require 'init-linum-mode)
  (require 'init-git) ;; git-gutter should be enabled after `display-line-numbers-mode' turned on
  ;; (require 'init-gist)
  (require 'init-gtags)
  ;; init-evil dependent on init-clipboard
  (require 'init-clipboard)
  ;; use evil mode (vi key binding)
  (require 'init-evil)
  (require 'init-multiple-cursors)
  (require 'init-ctags)
  (require 'init-bbdb)
  (require 'init-gnus)
  (require 'init-lua-mode)
  (require 'init-workgroups2)
  (require 'init-term-mode)
  (require 'init-web-mode)
  (require 'init-company)
  (require 'init-chinese) ;; cannot be idle-required
  ;; need statistics of keyfreq asap
  (require 'init-keyfreq)
  (require 'init-httpd)
  ;; (require-init 'init-dictionary)
  (require 'init-magit)
  (require 'init-easy-hugo)
  (require 'init-calendar)
  (require 'init-mu4e)

  ;; projectile costs 7% startup time


  ;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
  ;; (local-require 'idle-require)
  ;; (setq idle-require-idle-delay 2)
  ;; (setq idle-require-symbols '(init-perforce
  ;;                              init-slime
  ;;                              init-misc-lazy
  ;;                              init-which-func
  ;;                              init-fonts
  ;;                              init-hs-minor-mode
  ;;                              init-writting
  ;;                              init-pomodoro
  ;;                              init-dired
  ;;                              init-artbollocks-mode
  ;;                              init-semantic))
  ;; (idle-require-mode 1) starts loading

  ;; @see https://github.com/hlissner/doom-emacs/wiki/FAQ
  ;; Adding directories under "site-lisp/" to `load-path' slows
  ;; down all `require' statement. So we do this at the end of startup
  ;; Neither ELPA package nor dependent on "site-lisp/".
  (setq load-path (cdr load-path))
  (load (expand-file-name "~/.emacs.d/lisp/init-site-lisp") t t)

  ;; misc has some crucial tools I need immediately
  (require 'init-misc)
  (require 'init-emacs-w3m)
  (require 'init-emacs-eww)
  (require 'init-hydra)
  (require 'init-shackle)
  (require 'init-dired)
  (require 'init-artbollocks-mode)
  (require 'init-writting)
  (require 'init-encoding)
  (require 'init-golang)

  ;; my personal setup, other major-mode specific setup need it.
  ;; It's dependent on "~/.emacs.d/site-lisp/*.el"
  (load (expand-file-name "~/.custom.el") t nil)

  ;; @see https://www.reddit.com/r/emacs/comments/4q4ixw/how_to_forbid_emacs_to_touch_configuration_files/
  ;; See `custom-file' for details.
  (load (setq custom-file (expand-file-name "~/.emacs.d/custom-set-variables.el")) t t))

(setq gc-cons-threshold best-gc-cons-threshold)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-check-signature nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)

(when (require 'time-date nil t)
  (message "Emacs startup time: %d seconds."
           (time-to-seconds (time-since emacs-load-start-time))))

;;; Local Variables:
;;; no-byte-compile: t
;;; End:
(put 'erase-buffer 'disabled nil)

(setq visible-bell 1)

(put 'dired-find-alternate-file 'disabled nil)
