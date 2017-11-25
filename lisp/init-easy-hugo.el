(require 'package)
(setq easy-hugo-basedir "~/blog/")
(setq easy-hugo-url "https://ys2006.github.io")
(setq easy-hugo-sshdomain "blogdomain")
(setq easy-hugo-root "/home/dylan/")
(setq easy-hugo-previewtime "300")
(define-key global-map (kbd "C-c C-e") 'easy-hugo)

(provide 'init-easy-hugo)
