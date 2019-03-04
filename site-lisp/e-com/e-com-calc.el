;;; calc.el --- Calc functions for e-commercial .

;; Author: dylan <dylan.yins@gmail.com>
;; URL: https://github.com/ys2006/c-com
;; Version: 0.1
;; Package-Required: (request json)
;; Keywords: calc

;; Reference
;; https://tkf.github.io/emacs-request/

;;; Code:
(require 'cl-lib)
(require 'xml)
(require 'request)
(require 'json)


(setq request-backend 'url-retrieve)

(let*
    ((thisrequest
      (request "httpbin.org/get"
               :params '(("key" . "value") ("key2" . "value2"))
               :parser 'json-read
               :success (cl-function
                         (lambda (&key data &allow-other-keys)
                           (message "I sent: %S" (assoc-default 'args data))))))
     (data (request-response-data thisrequest))
     (err (request-response-error-thrown thisrequest))
     (status (request-response-status-code thisrequest)))
  ;; do stuff here
)


(request
 "http://httpbin.org/get"
 :params '(("key" . "value") ("key2" . "value2"))
 :parser 'json-read
 :success (cl-function
           (lambda (&key data &allow-other-keys)
             (message "I sent: %S" (assoc-default 'args data)))))



(provide 'e-com-calc)
