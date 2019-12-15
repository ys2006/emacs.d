;; -*- coding: utf-8; lexical-binding: t; -*-

(use-package elpy
    :init
    (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
    :bind (:map elpy-mode-map
	      ("<M-left>" . nil)
	      ("<M-right>" . nil)
	      ("<M-S-left>" . elpy-nav-indent-shift-left)
	      ("<M-S-right>" . elpy-nav-indent-shift-right)
	      ("M-." . elpy-goto-definition)
	      ("M-," . pop-tag-mark))
    :config
    (setq elpy-rpc-backend "jedi"))

(use-package python
  :mode ("\\.py" . python-mode)
  :config
  (setq python-indent-offset 4)
  (elpy-enable))

(use-package pyenv-mode
  :init
  (add-to-list 'exec-path "/Users/dylan/install/pyenv/shims")
  ;; (setenv "WORKON_HOME" "/Users/dylan/install/pyenv/versions/")
  (setenv "WORKON_HOME" "/Users/dylan/install/pyenv/versions/3.6.8/envs/")
  :config
  (pyenv-mode)
  :bind
  ("C-x p e" . pyenv-activate-current-project))

(defun pyenv-activate-current-project ()
  "Automatically activates pyenv version if .python-version file exists."
  (interactive)
  (let ((python-version-directory (locate-dominating-file (buffer-file-name) ".python-version")))
    (if python-version-directory
        (let* ((pyenv-version-path (f-expand ".python-version" python-version-directory))
               (pyenv-current-version (s-trim (f-read-text pyenv-version-path 'utf-8))))
          (pyenv-mode-set pyenv-current-version)
          (message (concat "Setting virtualenv to " pyenv-current-version))))))

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

;; (setq interpreter-mode-alist
;;       (cons '("python" . python-mode) interpreter-mode-alist))

;; (eval-after-load 'python
;;   '(progn
;;      (require 'elpy)
;;      ;; run command `pip install jedi flake8 importmagic` in shell,
;;      ;; or just check https://github.com/jorgenschaefer/elpy
;;      (unless (or (is-buffer-file-temp)
;;                  (not buffer-file-name)
;;                  ;; embed python code in org file
;;                  (string= (file-name-extension buffer-file-name) "org"))
;;        (elpy-enable))

;;      (pyenv-mode)

;;      ;; https://elpy.readthedocs.io/en/latest/ide.html#interpreter-setup
;;      ;; Issue https://github.com/jorgenschaefer/elpy/issues/1550
;;      (setq python-shell-interpreter "ipython"  ;; IPython
;;            elpy-shell-echo-output nil
;;            python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i")
;;      (setq py-shell-name "python3")
;;      ;; (setq elpy-rpc-python-command "python3")  ;; python3
;;      (setq elpy-rpc-backend "jedi")
;;      (setq python-indent-offset 4)

;;      ;; (require 'py-autopep8)
;;      ;; (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;;      (when (require 'flycheck nil t)
;;         (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;         (add-hook 'elpy-mode-hook 'flycheck-mode))


;;      ;; http://emacs.stackexchange.com/questions/3322/python-auto-indent-problem/3338#3338
;;      ;; emacs 24.4 only
;;      (setq electric-indent-chars (delq ?: electric-indent-chars))))

(provide 'init-python)
