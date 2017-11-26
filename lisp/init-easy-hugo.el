(require 'package)
(setq easy-hugo-basedir "/rivers/bookshelf/")
(setq easy-hugo-url "https://ys2006.github.io")
(setq easy-hugo-sshdomain "github.com-ys2006")
(setq easy-hugo-root "/rivers/blog/")
(setq easy-hugo-previewtime "300")
(define-key global-map (kbd "C-c C-e") 'easy-hugo)

(provide 'init-easy-hugo)
