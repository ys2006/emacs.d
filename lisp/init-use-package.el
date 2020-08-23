;; -*- coding: utf-8; lexical-binding: t; -*-


;; {{ org-opml config
(setq org-opml-src "/home/user/org-opml/")

(use-package ox-opml
  :ensure t
  :load-path org-opml-src)

(use-package org-opml
  :ensure t
  :load-path org-opml-src)
;; }}


(provide 'init-use-package)