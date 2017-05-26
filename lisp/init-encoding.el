
;; Set env use chinese lang
(set-language-environment 'Chinese-GB)
;;(set-language-environment 'Japanese)
;; Emacs default encoding
(setq locale-coding-system 'utf-8)
;; keyborad input encode
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
;; default saving encode utf-8
(set-buffer-file-coding-system 'utf-8)
(set-default buffer-file-coding-system 'utf8)
(set-default-coding-systems 'utf-8)
;; paste Chinese 
(set-clipboard-coding-system 'utf-8)
;; Chinese name in Terms
(set-terminal-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
;; Chinese name in directory
(setq-default pathname-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
;; Shell Mode(cmd) encoding
(defun change-shell-mode-coding ()

  (progn
    (set-terminal-coding-system 'gbk)
    (set-keyboard-coding-system 'gbk)
    (set-selection-coding-system 'gbk)
    (set-buffer-file-coding-system 'gbk)
    (set-file-name-coding-system 'gbk)
    (modify-coding-system-alist 'process "*" 'gbk)
    (set-buffer-process-coding-system 'gbk 'gbk)
    (set-file-name-coding-system 'gbk)))

(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hook-setup)

(provide 'init-encoding)
