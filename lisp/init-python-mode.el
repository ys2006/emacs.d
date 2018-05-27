;; (require 'ein)
;; (require 'ein-loaddefs)
;; (require 'ein-notebook)
;; (require 'ein-subpackages)
(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))

;; run command `pip install jedi flake8 importmagic` in shell,
;; or just check https://github.com/jorgenschaefer/elpy
(elpy-enable)
;;(eply-use-ipython)
(defun python-mode-hook-setup ()
  (unless (is-buffer-file-temp)
    (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --simple-prompt")

    ;; http://emacs.stackexchange.com/questions/3322/python-auto-indent-problem/3338#3338
    ;; emacs 24.4 only
    (setq electric-indent-chars (delq ?: electric-indent-chars))))

(add-hook 'python-mode-hook 'python-mode-hook-setup)

(provide 'init-python-mode)
