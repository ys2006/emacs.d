;; make sure mu4e is in your load-path
(require 'smtpmail)
(require 'starttls)

(add-to-list 'load-path "~/.emacs.d/site-lisp/mu4e")
(require 'mu4e)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

;; (defvar my-mu4e-account-alist
;;     '(("Work"
;;         (mu4e-maildir "~/Maildir/Work")
;;         (user-mail-address "dylan.yin@oracle.com")
;;         (smtpmail-smtp-user "dylan.yin@oracle.com")
;;         (smtpmail-smtp-server "stbeehive.oracle.com")
;;         (smtpmail-smtp-service 465)
;;         (mu4e-sent-folder   "/INBOX")
;;         (mu4e-sent-folder   "/Sent")
;;         (mu4e-drafts-folder "/Drafts")
;;         (mu4e-trash-folder  "/Trash")
;;     )
;;     ("Hotmail"
;;         (mu4e-maildir "~/Maildir/Hotmail")
;;         (user-mail-address "yinshuo335@hotmail.com")
;;         (smtpmail-smtp-user "yinshuo335@hotmail.com")
;;         (smtpmail-smtp-server "smtp-mail.outlook.com")
;;         (smtpmail-smtp-service 587)
;;         (mu4e-sent-folder   "/Sent")
;;         (mu4e-drafts-folder "/Drafts")
;;         (mu4e-trash-folder  "/Junk")
;;      )
;;     ("Gmail"
;;         (mu4e-maildir "~/Maildir/Gmail")
;;         (user-mail-address "dylan.yins@gmail.com")
;;         (smtpmail-smtp-user "dylan.yins@gmail.com")
;;         (smtpmail-smtp-server "smtp.gmail.com")
;;         (smtpmail-smtp-service 587)
;;         (mu4e-sent-folder   "/sent")
;;         (mu4e-drafts-folder "/drafts")
;;         (mu4e-trash-folder  "/trash")
;;      )))

;; (defun my-mu4e-set-account ()
;;   "Set the account for composing a message."
;;   (interactive)
;;   (let* ((account
;;           (if mu4e-compose-parent-message
;;               (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
;;                 (string-match "/\\(.*?\\)/" maildir)
;;                 (match-string 1 maildir))
;;             (completing-read (format "Compose with account: (%s) "
;;                                      (mapconcat #'(lambda (var) (car var))
;;                                                 my-mu4e-account-alist "/"))
;;                              (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
;;                              nil t nil nil (caar my-mu4e-account-alist))))
;;          (account-vars (cdr (assoc account my-mu4e-account-alist))))
;;     (if account-vars
;;         (mapc #'(lambda (var)
;;                   (set (car var) (cadr var)))
;;               account-vars)
;;       (error "No email account found"))))

;; (add-hook 'mu4e-main-mode-hook 'my-mu4e-set-account)

;; the maildirs you use frequently; access them with 'j' ('jump')
;; (setq   mu4e-maildir-shortcuts
;;     '(("/archive"     . ?a)
;;       ("/INBOX"       . ?i)
;;       ("/work"        . ?w)
;; ))

;; program to get mail; alternatives are 'fetchmail', 'getmail'
;; isync or your own shellscript. called when 'U' is pressed in
;; main view.

;; If you get your mail without an explicit command,
;; use "true" for the command (this is the default)
(setq mu4e-get-mail-command "offlineimap")

;; smtp mail setting; these are the same that `gnus' uses.
;; (require 'smtpmail)
;; (setq
;;     message-send-mail-function   'smtpmail-send-it
;;     smtpmail-default-smtp-server "stbeehive.oracle.com"
;;     smtpmail-default-smtp-server  "stbeehive.oracle.com")

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; save attachment to my desktop (this can also be a function)
(setq mu4e-attachment-dir "~/Downloads")

;; attempt to show images when viewing messages
(setq mu4e-view-show-images t)

;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-default-smtp-server "stbeehive.oracle.com"
;;       smtpmail-smtp-server "stbeehive.oracle.com"
;;       smtpmail-smtp-service 465
;;       smtpmail-stream-type 'starttls
;;       smtpmail-debug-info t)

(setq message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "/usr/bin/msmtp"
      user-full-name "Dylan")

(setq mu4e-contexts
      `( ,(make-mu4e-context
          :name "Work"
          :enter-func (lambda () (mu4e-message "Switch to the Work context"))
          :leave-func (lambda () (mu4e-message "Leaving Work context"))
          ;; we match based on the maildir of the message
          ;; this matches maildir /Work and its sub-directories
          :match-func (lambda (msg)
                        (when msg
                          (string-match-p "^/Work" (mu4e-message-field msg :maildir))))
          :vars '((mu4e-maildir            . "~/Maildir/Work")
                  (smtpmail-smtp-user      . "dylan.yin@oracle.com")
                  (smtpmail-smtp-server    . "stbeehive.oracle.com")
                  (smtpmail-smtp-service   . 465)
                  (mu4e-sent-folder        . "/Sent")
                  (mu4e-drafts-folder      . "/Drafts")
                  (mu4e-trash-folder       . "/Junk E-mail")
                  (mu4e-refile-folder      . "/Archives")
                  (user-mail-address       . "dylan.yin@oracle.com")
                  (user-full-name          . "Dylan Yin" )
                  (mu4e-compose-signature  .
                                            (concat
                                             "Sincerely,\n"
                                             "Dylan.\n"))))
        ,(make-mu4e-context
          :name "Hotmail"
          :enter-func (lambda () (mu4e-message "Entering Hotmail context"))
          :leave-func (lambda () (mu4e-message "Leaving Hotmail context"))
          ;; we match based on the maildir of the message
          ;; this matches maildir /Work and its sub-directories
          :match-func (lambda (msg)
                        (when msg
                          (string-match-p "^/Hotmail" (mu4e-message-field msg :maildir))))
          :vars '((mu4e-maildir            . "~/Maildir/Hotmail")
                  (smtpmail-smtp-user      . "yinshuo335@hotmail.com")
                  (smtpmail-smtp-server    . "imap-mail.outlook.com")
                  (smtpmail-smtp-service   . 587)
                  (mu4e-sent-folder        . "/Sent")
                  (mu4e-drafts-folder      . "/Drafts")
                  (mu4e-trash-folder       . "/Junk E-mail")
                  (mu4e-refile-folder      . "/Archives")
                  (user-mail-address      . "yinshuo335@hotmail.com")
                  (user-full-name         . "Yinshuo" )
                  (mu4e-compose-signature .
                                          (concat
                                           "Sincerely,\n"
                                           "Yin Shuo.\n"))))
        ,(make-mu4e-context
          :name "Gmail"
          :enter-func (lambda () (mu4e-message "Switch to the Gmail context"))
          :leave-func (lambda () (mu4e-message "Leaving Gmail context"))
          ;; we match based on the maildir of the message
          ;; this matches maildir /Gmail and its sub-directories
          :match-func (lambda (msg)
                        (when msg
                          (string= (mu4e-message-field msg :maildir) "/Gmail")))
          :vars '((user-mail-address       . "dylan.yins@gmail.com" )
                  (user-full-name          . "Yinshuo" )
                  (mu4e-compose-signature  .
                                             (concat
                                              "Sincerely,\n"
                                              "Yin Shuo.\n"))))))

  ;; set `mu4e-context-policy` and `mu4e-compose-policy` to tweak when mu4e should
  ;; guess or ask the correct context, e.g.

  ;; start with the first (default) context;
  ;; default is to ask-if-none (ask when there's no context yet, and none match)
  ;; (setq mu4e-context-policy 'pick-first)

  ;; compose with the current context is no context matches;
  ;; default is to ask
  ;; (setq mu4e-compose-context-policy nil)

(setq mu4e-refile-folder
  (lambda (msg)
    (cond
      ;; messages to the mu mailing list go to the /mu folder
      ((mu4e-message-contact-field-matches msg :to
         "mu-discuss@googlegroups.com")
        "/mu")
      ;; messages sent directly to me go to /archive
      ;; also `mu4e-user-mail-address-p' can be used
      ((mu4e-message-contact-field-matches msg :to "me@example.com")
        "/private")
      ;; messages with football or soccer in the subject go to /football
      ((string-match "football\\|soccer"
         (mu4e-message-field msg :subject))
        "/football")
      ;; messages sent by me go to the sent folder
      ((find-if
         (lambda (addr)
           (mu4e-message-contact-field-matches msg :from addr))
         mu4e-user-mail-address-list)
        mu4e-sent-folder)
      ;; everything else goes to /archive
      ;; important to have a catch-all at the end!
      (t  "/archive"))))

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

(require 'mu4e-contrib)
(setq mu4e-html2text-command 'mu4e-shr2text)

(add-to-list 'mu4e-view-actions
  '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; Include a bookmark to open all of my inboxes
;; (add-to-list 'mu4e-bookmarks
;;        (make-mu4e-bookmark
;;         :name "All Inboxes"
;;         :query "maildir:/Work/INBOX OR maildir:/Gmail/INBOX"
;;         :key ?i))

;; This allows me to use 'helm' to select mailboxes
(setq mu4e-completing-read-function 'completing-read)
;; Why would I want to leave my message open after I've sent it?
(setq message-kill-buffer-on-exit t)
;; Don't ask for a 'context' upon opening mu4e
;; (setq mu4e-context-policy 'pick-first)
;; Don't ask to quit... why is this the default?
(setq mu4e-confirm-quit nil)

mu4e-attachment-dir (expand-file-name "~/Downloads")

(provide 'init-mu4e)
