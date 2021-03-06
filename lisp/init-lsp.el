;;; -*- coding: utf-8; lexical-binding: t; -*-

;; {{ General Config
;; Flycheck
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  (add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.22)))
  :config
  (setq flycheck-check-syntax-automatically '(save)))

;; {{
;; treemacs
(use-package treemacs
  :init
  (add-hook 'treemacs-mode-hook
            (lambda () (treemacs-resize-icons 15))))
(lsp-treemacs-sync-mode 1)
;; }}

(use-package projectile
  :init
  (setq projectile-enable-caching t
        projectile-globally-ignored-file-suffixes
        '(
          "blob"
          "class"
          "classpath"
          "gz"
          "iml"
          "ipr"
          "jar"
          "pyc"
          "tkj"
          "war"
          "xd"
          "zip"
          )
        projectile-globally-ignored-files '("TAGS" "*~")
        ;; projectile-tags-command "/usr/bin/ctags -Re -f \"%s\" %s"
        projectile-tags-command "/usr/local/Cellar/universal-ctags/HEAD-81fa5b1/bin/ctags -Re -f \"%s\" %s"
        projectile-mode-line '(:eval (format " [%s]" (projectile-project-name)))
        )
  :config
  ;; (projectile-global-mode)
  (projectile-mode +1)
  (setq projectile-globally-ignored-directories
        (append (list
                 ".pytest_cache"
                 "__pycache__"
                 "build"
                 "elpa"
                 "node_modules"
                 "output"
                 "reveal.js"
                 "semanticdb"
                 "target"
                 "venv"
                 )
                projectile-globally-ignored-directories))
)

;;{{ Lsp config
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (java-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; (use-package which-key
;;     :config
;;     (which-key-mode))

;; lsp-ui
(use-package lsp-ui :commands lsp-ui-mode)
;; As a ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)


;; lsp-java
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))

(setq lsp-java-server-install-dir "/Users/dylan/install/eclipse.jdt.ls/" )
(defun my/java-mode-config ()
    (setq-local tab-width 4)
    (setq-local indent-tabs-mode t)
    (setq-local c-basic-offset 4)
    (toggle-truncate-lines 1)
    (rainbow-delimiters-mode)
    (enable-paredit-mode)
    (lsp))

(add-hook 'java-mode-hook 'my/java-mode-config)

(setq lsp-java-workspace-dir "/Users/dylan/doCoding/langs/JAVA/cheese-shop/")
;; java debug mode
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)
;; }} lsp config

;; {{ Python Mode
;; Config lsp-python-ms
(use-package lsp-python-ms
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp)))
  :init
  (setq lsp-python-ms-executable (executable-find "python-language-server")))

(setq-default indent-tabs-mode nil)
(setq lsp-python-ms-executable "~/install/python-language-server/output/bin/Release/osx-x64/publish/Microsoft.Python.LanguageServer")
;; pyenv config @See https://cestlaz.github.io/post/using-emacs-58-lsp-mode/
(setq lsp-python-executable-cmd "~/install/pyenv/shims/python")

(add-hook 'python-mode-hook '(lambda ()
                        (pipenv-activate)
                        (setq python-indent-offset 4)
                        (setq python-shell-interpreter "ipython")
                        ;; (setq python-shell-interpreter "jupyter-console")
                        (setq python-shell-interpreter-args "--simple-prompt -i")
                        (require 'lsp-python-ms)
                        (lsp)))  ; or lsp-deferred

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
;; }} Python Mode

;; {{ Go Mode
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook '(lambda ()
                        #'lsp-go-install-save-hooks
                        (lsp)))  ; or lsp-deferred
;; }} Go Mode

(provide 'init-lsp)
;;; init-lsp.el ends here
