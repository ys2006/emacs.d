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

;; (use-package lsp-ui :commands lsp-ui-mode)
;; (use-package company-lsp :commands company-lsp)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; (use-package dap-mode
;;   :ensure t
;;   :after lsp-mode
;;   :config
;;   (dap-mode t)
;;   (dap-ui-mode t))
(with-eval-after-load 'dap-mode
   (require 'auto-complete)
   (require 'go-autocomplete))

;; Java
;; (require 'cc-mode)
;; (use-package lsp-java
;;   :ensure t
;;   :init
;;   (setq lsp-server-install-dir "~/install/java-language-server" )
;;   :after lsp
;;   :config (add-hook 'java-mode-hook 'lsp))
(setq lsp-java-server-install-dir "/Users/dylan/install/eclipse.jdt.ls" )
(add-hook 'java-hook '(lambda ()
                          (lsp-deferred)))  ; or lsp-deferred

;; (use-package lsp-python-ms
;;   :ensure t
;;   :init
;;   (setq lsp-python-ms-executable "~/install/python-language-server/output/bin/Release/osx-x64/publish/Microsoft.Python.LanguageServer")
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-python-ms)
;;                           (lsp-deferred))))  ; or lsp-deferred
;; Config lsp-python-ms
(setq lsp-python-ms-executable "~/install/python-language-server/output/bin/Release/osx-x64/publish/Microsoft.Python.LanguageServer")
(add-hook 'python-hook '(lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred)))  ; or lsp-deferred
;; Python
(use-package elpy
  :ensure t
  :commands elpy-enable
  :init (with-eval-after-load 'python (elpy-enable))
  :config
  (electric-indent-local-mode -1)
  (delete 'elpy-module-highlight-indentation elpy-modules)
  (delete 'elpy-module-flymake elpy-modules)
  (when (executable-find "ipython")
    (setq python-shell-interpreter "ipython"
          elpy-shell-echo-output nil
          python-shell-interpreter-args "-i --simple-prompt")))

;; (use-package python
;;   :mode ("\\.py" . python-mode)
;;         ("\\.wsgi$" . python-mode)
;;   :interpreter ("python" . python-mode)
;;   :init
;;   (setq-default indent-tabs-mode nil)
;;   :config
;;   (setq python-indent-offset 4)
;;   (when (executable-find "ipython")
;;     (setq python-shell-interpreter "ipython")))

(use-package pyenv-mode
  :commands pyenv-mode
  :init
  (add-to-list 'exec-path "/Users/dylan/install/pyenv/shims")
  ;; (setenv "WORKON_HOME" "/Users/dylan/install/pyenv/versions/")
  (setenv "WORKON_HOME" "/Users/dylan/install/pyenv/versions/3.6.8/envs/"))
  ;; :bind
  ;; ("C-x p e" . pyenv-activate-current-project))

;; (defun pyenv-activate-current-project ()
;;   "Automatically activates pyenv version if .python-version file exists."
;;   (interactive)
;;   (let ((python-version-directory (locate-dominating-file (buffer-file-name) ".python-version")))
;;     (if python-version-directory
;;         (let* ((pyenv-version-path (f-expand ".python-version" python-version-directory))
;;                (pyenv-current-version (s-trim (f-read-text pyenv-version-path 'utf-8))))
;;           (pyenv-mode-set pyenv-current-version)
;;           (message (concat "Setting virtualenv to " pyenv-current-version))))))

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
