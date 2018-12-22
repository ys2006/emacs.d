;; -*- coding: utf-8; lexical-binding: t; -*-

(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))

(eval-after-load 'python
  '(progn
     ;; run command `pip install jedi flake8 importmagic` in shell,
     ;; or just check https://github.com/jorgenschaefer/elpy
     (elpy-enable)

     ;; https://elpy.readthedocs.io/en/latest/ide.html#interpreter-setup
     (setq python-shell-interpreter "ipython"  ;; IPython
           python-shell-interpreter-args "-i --simple-prompt")

     (setq elpy-rpc-python-command "python3")  ;; python3

     (require 'py-autopep8)
     (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

     (when (require 'flycheck nil t)
        (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
        (add-hook 'elpy-mode-hook 'flycheck-mode))

     ;; http://emacs.stackexchange.com/questions/3322/python-auto-indent-problem/3338#3338
     ;; emacs 24.4 only
     (setq electric-indent-chars (delq ?: electric-indent-chars))))

(provide 'init-python)
