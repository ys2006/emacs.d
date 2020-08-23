;; -*- coding: utf-8; lexical-binding: t; -*-

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

(use-package treemacs
  :init
  (add-hook 'treemacs-mode-hook
            (lambda () (treemacs-resize-icons 15))))


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
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  ;; :hook ((lsp-after-open . lsp-enable-imenu))
  :init
        (setq lsp-log-io t))

;; (use-package lsp-mode
;;   :ensure t
;;   ;; :hook ((java-mode . lsp))
;;   :commands (lsp lsp-deferred)
;;   :init
;;         (setq lsp-log-io nil)
;;         ;; (setq lsp-log-io t)
;;         (setq lsp-print-performance nil)
;;         ;; (setq lsp-inhibit-message nil)
;;         (setq lsp-enable-file-watchers nil)
;;         ;; (setq lsp-report-if-no-buffer 'debug)
;;         (setq lsp-keep-workspace-alive t)
;;         (setq lsp-enable-snippet nil)
;;         (setq lsp-restart 'interactive)
;;         (setq lsp-auto-configure t)
;;         (setq lsp-diagnostic-package :flycheck)
;;         (setq lsp-document-sync-method nil)
;;         (setq lsp-auto-execute-action nil)
;;         (setq lsp-auto-guess-root nil)
;;         (setq lsp-eldoc-render-all t)
;;         ;; use `company-ctags' only.
;;         ;; Please `company-lsp' is automatically enabled if installed
;;         (setq lsp-enable-completion-at-point t)
;;         ;; turn off for better performance
;;         (setq lsp-enable-symbol-highlighting nil)
;;         (setq lsp-enable-links nil)
;;         (setq lsp-enable-xref nil)
;;         (setq lsp-enable-indentation t)
;;         (setq lsp-enable-on-type-formatting t)
;;         (setq lsp-signature-auto-activate t)
;;         ;; (setq lsp-enable-semantic-highlighting nil)
;;   :config
;;         ;; don't scan some files
;;         (push "[/\\\\][^/\\\\]*\\.json$" lsp-file-watch-ignored)
;;         ;; don't ping LSP lanaguage server too frequently
;;         (defvar lsp-on-touch-time 0)
;;         (defadvice lsp-on-change (around lsp-on-change-hack activate)
;;         ;; don't run `lsp-on-change' too frequently
;;         (when (> (- (float-time (current-time))
;;                     lsp-on-touch-time) 30) ;; 30 seconds
;;                 (setq lsp-on-touch-time (float-time (current-time)))
;;                 ad-do-it)))

;; Lsp-ui mode
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :custom-face
  (lsp-ui-doc-background ((t (:background nil))))
  (lsp-ui-doc-header ((t (:inherit (font-lock-string-face italic)))))
  ;; :bind (:map lsp-ui-mode-map
  ;;             ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
  ;;             ([remap xref-find-references] . lsp-ui-peek-find-references)
  ;;             ("C-c u" . lsp-ui-imenu))
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-delay 5.0)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-border (face-foreground 'default))
  (lsp-ui-sideline-enable t)
  ;; (lsp-ui-sideline-delay 5.0)
  (lsp-ui-sideline-ignore-duplicate nil)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-show-symbol t)
  (lsp-ui-peek-enable nil)
  (lsp-ui-peek-always-show nil)
  (lsp-ui-flycheck-list-position 'right)
  ;; :init
  :config
  ;; (lsp-ui-flycheck-enable t)
  ;; Use flycheck-check-syntax-automatically
  ;; (setq lsp-ui-flycheck-live-reporting nil)
  ;; Use lsp-ui-doc-webkit only in GUI
  ;; (setq lsp-ui-doc-use-webkit t))
  ;; WORKAROUND Hide mode-line of the lsp-ui-imenu buffer
  ;; https://github.com/emacs-lsp/lsp-ui/issues/243
  (defadvice lsp-ui-imenu (after hide-lsp-ui-imenu-mode-line activate)
    (setq mode-line-format nil)))

;; Combine lsp mode and lsp-ui mode
;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'lsp-ui-mode-hook 'flycheck-mode)

;; Dap-mode
(use-package dap-mode
  :ensure t
  :commands dap-mode
  :config
  (dap-mode 1)
  (require 'dap-ui)
  (dap-ui-mode 1)
  (require 'dap-lldb))

;; enables mouse hover support
;; (dap-tooltip-mode 1)
;; use tooltips for mouse hover
;; if it is not enabled `dap-mode' will use the minibuffer.
;; (tooltip-mode 1)

(add-hook 'dap-stopped-hook
          (lambda () (call-interactively #'dap-hydra)
            (message "BP Hitted!!")))
;; }} General Config

;; {{ Java Mode
;; (defun my/dap-java-debug (debug-args)
;;  "Start debug session with DEBUG-ARGS."
;;   (interactive (list (dap-java--populate-default-args (-> (dap--completing-read "Select configuration template: "
;;                                                                                 dap--debug-template-configurations
;;                                                                                 'cl-first nil t)
;;                                                           cl-rest
;;                                                           copy-tree))))
;;   (dap-start-debugging debug-args))
;; (eval-after-load 'dap-mode
;;     '(progn
;;         (require 'auto-complete)
;;         (require 'go-autocomplete)))

;; (add-hook 'dap-stopped-hook
;;           (lambda () (call-interactively #'dap-hydra)))

;; (setq lsp-java-server-install-dir "/Users/dylan/install/eclipse.jdt.ls" )
(defun my/java-mode-config ()
    (setq-local tab-width 4)
    (setq-local indent-tabs-mode t)
    (setq-local c-basic-offset 4)
    (toggle-truncate-lines 1)
    (rainbow-delimiters-mode)
    (enable-paredit-mode)
    (lsp))
;; (add-hook 'java-mode-hook #'lsp)
;; (remove-hook 'java-mode-hook 'lsp)
(add-hook 'java-mode-hook 'my/java-mode-config)
;; (use-package lsp-java
;;   :ensure t
;;   :init
;;     (setq lsp-java-java-path "/usr/bin/java")
;;   :config
;;     ;; (require 'dap-java)
;;     (setq lsp-java-vmargs
;;           (list "-noverify"
;;                 "-Xmx1G"
;;                 "-XX:+UseG1GC"
;;                 "-XX:+UseStringDeduplication")
;;           lsp-file-watch-ignored
;;           '(".idea" ".ensime_cache" ".eunit" "node_modules"
;;             ".git" ".hg" ".fslckout" "_FOSSIL_"
;;             ".bzr" "_darcs" ".tox" ".svn" ".stack-work"
;;             "build")
;;           lsp-java-import-order '["" "java" "javax" "#"])
;;   ;; :demand t
;;   :after (lsp lsp-mode lsp-ui-mode dap-mode dap-ui-mode))
;;   ;; :after (lsp))
;; (use-package dap-java :after (lsp-java))

;; https://www.reddit.com/r/emacs/comments/c2s1v0/how_to_input_in_a_java_program_in_emacs_with/?ref=readnext
;; (setq dap-java-java-command "xterm -e java")
;; https://github.com/Microsoft/vscode-java-debug
(use-package dap-mode
  :ensure t :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-register-debug-template
   "localhost:5005"
   (list :type "java"
         :requert "compile_attach"
         :hostName "localhost"
         :port 5005
         :wait-for-port t
         :request "launch"))
  (dap-register-debug-template
   "10.186.38.171:5005"
   (list :type "java"
         :request "attach"
         :wait-for-port t
         :request "launch"
         :hostName "10.186.38.171"
         :port 5005)))
;; (dap-register-debug-template "My Runner"
;;                              (list
;;                               :cwd "/Users/dylan/recipes/practicing/JAVA"
;;                               :type "java"
;;                               :args ""
;;                               ;; :vmArgs "-ea -Dmyapp.instance.name=myapp_1"
;;                               :vmArgs "-ea"
;;                               :projectName "leetcode"
;;                               ;; :mainClass "Solution"
;;                               ;; :env '(("DEV" . "1"))
;;                               :request "launch"))

;; (use-package dap-java
;;   :ensure t
;;   :after (lsp-java)

;;   ;; The :bind here makes use-package fail to lead the dap-java block!
;;   ;; :bind
;;   ;; (("C-c R" . dap-java-run-test-class)
;;   ;;  ("C-c d" . dap-java-debug-test-method)
;;   ;;  ("C-c r" . dap-java-run-test-method)
;;   ;;  )

;;   :config
;;   (global-set-key (kbd "<f7>") 'dap-step-in)
;;   (global-set-key (kbd "<f8>") 'dap-next)
;;   (global-set-key (kbd "<f9>") 'dap-continue)
;;   )

;; }} Java Mode

;; {{ Python Mode
;; Config lsp-python-ms
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
