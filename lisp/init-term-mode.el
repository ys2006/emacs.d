;; -*- coding: utf-8; lexical-binding: t; -*-

(defun my-kill-process-buffer-when-exit (process event)
  "Kill buffer of PROCESS when it's terminated.
EVENT is ignored."
  (ignore event)
  (when (memq (process-status process) '(signal exit))
    (kill-buffer (process-buffer process))))

;; {{ @see https://coredumped.dev/2020/01/04/native-shell-completion-in-emacs/
;; Enable auto-completion in `shell'.
(with-eval-after-load 'shell
  (unless comint-terminfo-terminal (setq comint-terminfo-terminal "dumb"))
  (native-complete-setup-bash))

;; `bash-completion-tokenize' can handle garbage output of "complete -p"
(defun my-bash-completion-tokenize-hack (orig-fun &rest args)
  "Original code extracts tokens line by line of output of \"complete -p\"."
  (let* ((beg (nth 0 args))
         (end (nth 1 args)))
    (cond
     ((not (string-match-p "^complete " (buffer-substring beg end)))
      ;; filter out some weird lines
      nil)
     (t
      (apply orig-fun args)))))
(advice-add 'bash-completion-tokenize :around #'my-bash-completion-tokenize-hack)

(defun shell-mode-hook-setup ()
  "Set up `shell-mode'."

  ;; analyze error output in shell
  (shellcop-start)

  (setq shellcop-sub-window-has-error-function
        (lambda ()
          (and (eq major-mode 'js2-mode)
               (> (length (js2-errors)) 0))))

  ;; hook `completion-at-point', optional
  (add-hook 'completion-at-point-functions #'native-complete-at-point nil t)
  (setq-local company-backends '((company-files company-native-complete)))
  ;; `company-native-complete' is better than `completion-at-point'
  (local-set-key (kbd "TAB") 'company-complete)

  ;; @see https://github.com/redguardtoo/emacs.d/issues/882
  (setq-local company-idle-delay 1)

  ;; try to kill buffer when exit shell
  (let* ((proc (get-buffer-process (current-buffer)))
         (shell (file-name-nondirectory (car (process-command proc)))))
    ;; Don't waste time on dumb shell which `shell-write-history-on-exit' is binding to
    (unless (string-match shell-dumb-shell-regexp shell)
      (set-process-sentinel proc #'my-kill-process-buffer-when-exit))))
(add-hook 'shell-mode-hook 'shell-mode-hook-setup)
;; }}

(defun eshell-mode-hook-setup ()
  "Set up `eshell-mode'."
  (local-set-key (kbd "C-c C-y") 'hydra-launcher/body)
  (local-set-key (kbd "M-n") 'counsel-esh-history))
(add-hook 'eshell-mode-hook 'eshell-mode-hook-setup)

;; {{ @see http://emacs-journey.blogspot.com.au/2012/06/improving-ansi-term.html
(advice-add 'term-sentinel :after #'my-kill-process-buffer-when-exit)

;; always use bash
(defvar my-term-program "/bin/bash")

;; utf8
(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)
;; }}

;; {{ multi-term delete??
;; (defun last-term-buffer (l)
;;   "Return most recently used term buffer."
;;   (when l
;;     (if (eq 'term-mode (with-current-buffer (car l) major-mode))
;;         (car l) (last-term-buffer (cdr l)))))

;; (defun get-term ()
;;   "Switch to the term buffer last used, or create a new one if
;;     none exists, or if the current buffer is already a term."
;;   (interactive)
;;   (let* ((b (last-term-buffer (buffer-list))))
;;     (if (or (not b) (eq 'term-mode major-mode))
;;         (multi-term)
;;       (switch-to-buffer b))))

;; (defun term-send-kill-whole-line ()
;;   "Kill whole line in term mode."
;;   (interactive)
;;   (term-send-raw-string "\C-a")
;;   (term-send-raw-string "\C-k"))

;; (defun term-send-kill-line ()
;;   "Kill line in term mode."
;;   (interactive)
;;   (term-send-raw-string "\C-k"))

;; (setq multi-term-program my-term-program)
;; ;; elpy issue when using zsh https://github.com/jorgenschaefer/elpy/issues/1001
;; ;; (setq multi-term-program "/bin/zsh")

;; ;; check `term-bind-key-alist' for key bindings
;; (eval-after-load 'multi-term
;;   '(progn
;;      (dolist (p '(("C-p" . term-send-up)
;;                   ("C-n" . term-send-down)
;;                   ("C-s" . swiper)
;;                   ("C-r" . term-send-reverse-search-history)
;;                   ("C-m" . term-send-raw)
;;                   ("C-k" . term-send-kill-whole-line)
;;                   ("C-y" . yank)
;;                   ("C-_" . term-send-raw)
;;                   ("M-f" . term-send-forward-word)
;;                   ("M-b" . term-send-backward-word)
;;                   ("M-K" . term-send-kill-line)
;;                   ("M-p" . previous-line)
;;                   ("M-n" . next-line)
;;                   ("M-y" . yank-pop)
;;                   ("M-." . term-send-raw-meta)))
;;        (setq term-bind-key-alist (delq (assoc (car p) term-bind-key-alist) term-bind-key-alist))
;;        (add-to-list 'term-bind-key-alist p))))

;; {{ hack counsel-browser-history
(defvar my-comint-full-input nil)
(defun my-counsel-shell-history-hack (orig-func &rest args)
  (setq my-comint-full-input (my-comint-current-input))
  (my-comint-kill-current-input)
  (apply orig-func args)
  (setq my-comint-full-input nil))
(advice-add 'counsel-shell-history :around #'my-counsel-shell-history-hack)
(defun my-ivy-history-contents-hack (orig-func &rest args)
  (let* ((rlt (apply orig-func args))
         (input my-comint-full-input))
    (when (and input (not (string= input "")))
      ;; filter shell history with current input
      (setq rlt
            (delq nil (mapcar
                       `(lambda (s)
                          (unless (stringp s) (setq s (car s)))
                          (if (string-match (regexp-quote ,input) s) s))
                       rlt))))
    (when (and rlt (> (length rlt) 0)))
    rlt))
(advice-add 'ivy-history-contents :around #'my-ivy-history-contents-hack)
;; }}

;; {{ comint-mode
(with-eval-after-load 'comint
  ;; Don't echo passwords when communicating with interactive programs:
  ;; Github prompt is like "Password for 'https://user@github.com/':"
  (setq comint-password-prompt-regexp
        (format "%s\\|^ *Password for .*: *$" comint-password-prompt-regexp))
  (add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt))
(defun comint-mode-hook-setup ()
  ;; look up shell command history
  (local-set-key (kbd "M-n") 'counsel-shell-history)
  ;; Don't show trailing whitespace in REPL.
  (local-set-key (kbd "M-;") 'comment-dwim))
(add-hook 'comint-mode-hook 'comint-mode-hook-setup)
;; }}

(add-hook 'term-mode-hook
          (lambda ()
            (setq term-buffer-maximum-size 10000)))

(provide 'init-term-mode)
