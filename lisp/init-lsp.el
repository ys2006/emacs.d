;; -*- coding: utf-8; lexical-binding: t; -*-

;; Lsp mode
(eval-after-load 'lsp-mode
  '(progn
     ;; enable log only for debug
     (setq lsp-log-io nil)
     ;; turn off watcher for bad performance
     (setq lsp-enable-file-watchers nil)
     ;; use `evil-matchit' instead
     (setq lsp-enable-folding nil)
     ;; handle yasnippet by myself
     (setq lsp-enable-snippet nil)
     ;; use `company-ctags' only.
     ;; Please `company-lsp' is automatically enabled if installed
     (setq lsp-enable-completion-at-point nil)
     ;; turn off for better performance
     (setq lsp-enable-symbol-highlighting nil)
     ;; use ffip instead
     (setq lsp-enable-links nil)
     ;; don't scan 3rd party javascript libraries
     (push "[/\\\\]\\node_modules$" lsp-file-watch-ignored)))

;; Lsp-ui mode
(add-hook 'lsp-mode-hook '(lambda ()
                          (lsp-ui-mode)))

(eval-after-load 'lsp-ui-mode
  '(progn
     ;; enable log only for debug
    (setq lsp-ui-sideline-ignore-duplicate t)))

(with-eval-after-load 'dap-mode
   (require 'auto-complete)
   (require 'go-autocomplete))

;; Java
(setq lsp-java-server-install-dir "/Users/dylan/install/eclipse.jdt.ls" )
(add-hook 'java-hook '(lambda ()
                          (lsp-deferred)))  ; or lsp-deferred
;; Python
;; Config lsp-python-ms
(setq-default indent-tabs-mode nil)
(setq lsp-python-ms-executable "~/install/python-language-server/output/bin/Release/osx-x64/publish/Microsoft.Python.LanguageServer")
(add-hook 'python-mode-hook '(lambda ()
                        (pipenv-activate)
                        (setq python-indent-offset 4)
                        (setq python-shell-interpreter "ipython")
                        ;; (setq python-shell-interpreter "jupyter-console")
                        (setq python-shell-interpreter-args "--simple-prompt -i")
                        (require 'lsp-python-ms)
                        (lsp-deferred)))  ; or lsp-deferred
(use-package pipenv
    :ensure t
    :init
    (setq
     pipenv-projectile-after-switch-function
     #'pipenv-projectile-after-switch-extended))

(eval-after-load 'pyenv
  '(progn
    (setq pyenv-use-alias 't)
    (setq pyenv-modestring-prefix "□ ")
    (setq pyenv-modestring-postfix nil)
    (setq pyenv-set-path nil)))

(defvar pyenv-current-version nil nil)

(defun pyenv-init()
  "Initialize pyenv's current version to the global one."
  (let ((global-pyenv (replace-regexp-in-string "\n" "" (shell-command-to-string "pyenv global"))))
    (message (concat "Setting pyenv version to " global-pyenv))
    (pyenv-mode-set global-pyenv)
    ;; (pyenv-mode-set "myenv")
    (setq pyenv-current-version global-pyenv)))
    ;; (setq pyenv-current-version "myenv")))

(add-hook 'after-init-hook 'pyenv-init)

(provide 'init-lsp)
