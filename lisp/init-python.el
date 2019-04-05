;; -*- coding: utf-8; lexical-binding: t; -*-

(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))

(eval-after-load 'python
  '(progn
     ;; run command `pip install jedi flake8 importmagic` in shell,
     ;; or just check https://github.com/jorgenschaefer/elpy
     (elpy-enable)
     (pyenv-mode)

     ;; https://elpy.readthedocs.io/en/latest/ide.html#interpreter-setup
     (setq python-shell-interpreter "ipython"  ;; IPython
           python-shell-interpreter-args "-i --simple-prompt")

     (setq elpy-rpc-python-command "python3")  ;; python3
     (setq elpy-rpc-backend "jedi")
     (setq python-indent-offset 4)

     (require 'py-autopep8)
     (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

     (when (require 'flycheck nil t)
        (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
        (add-hook 'elpy-mode-hook 'flycheck-mode))))

(provide 'init-python)
