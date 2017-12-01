(require 'package)
(setq easy-hugo-basedir "/rivers/bookshelf/")
(setq easy-hugo-url "https://ys2006.github.io")
(setq easy-hugo-sshdomain "github.com-ys2006")
(setq easy-hugo-root "/rivers/blog/")
(setq easy-hugo-previewtime "300")
(define-key global-map (kbd "C-c C-e") 'easy-hugo)

;; (setq easy-hugo-bloglist
;;       ;; blog2 setting
;;       '(((easy-hugo-basedir . "~/src/github.com/masasam/hugo2/")
;;          (easy-hugo-url . "http://example2.com")
;;          (easy-hugo-sshdomain . "myblogdomain")
;;          (easy-hugo-root . "/home/hugo/"))
;;         ;; blog3 setting
;;         ((easy-hugo-basedir . "~/src/github.com/masasam/hugo3/")
;;          (easy-hugo-url . "http://example3.net")
;;          (easy-hugo-amazon-s3-bucket-name . "yours3bucketname"))
;;         ;; blog4 setting
;;         ((easy-hugo-basedir . "~/src/github.com/masasam/hugo4/")
;;          (easy-hugo-url . "http://example4.net")
;;          (easy-hugo-google-cloud-storage-bucket-name . "yourGCPbucketname")
;;          (easy-hugo-image-directory . "img"))))
;;:bind ("C-c C-e" . easy-hugo)
(provide 'init-easy-hugo)
