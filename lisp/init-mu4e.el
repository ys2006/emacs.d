;; make sure mu4e is in your load-path
(require 'smtpmail)
(require 'starttls)

(add-to-list 'load-path "~/.emacs.d/site-lisp/mu4e")
(require 'mu4e)

(setq mu4e-mu-binary "/opt/local/bin/mu")

;;; Default
(setq mu4e-maildir "~/Maildir")
(setq mu4e-compose-complete-addresses nil)
(setq mu4e-completing-read-function 'completing-read)
(setq mu4e-view-show-addresses t)
(setq mu4e-headers-include-related nil)

;; use mu4e for e-mail in emacs
(setq mail-user-agent      'mu4e-user-agent
      read-mail-command    'mu4e
      gnus-dired-mail-mode 'mu4e-user-agent)

;; the maildirs you use frequently; access them with 'j' ('jump')
(setq mu4e-maildir-shortcuts
      '(("/drafts"                         . ?d)
        ("/Hotmail/INBOX.00NeedDo"         . ?1)
        ("/Hotmail/INBOX.01NeedSee"        . ?2)
        ("/Hotmail/INBOX.02NeedSave"       . ?3)
        ("/Hotmail/INBOX.03NeedReading"    . ?4)
        ("/Hotmail/INBOX.96Dylan"          . ?5)
        ("/Hotmail/INBOX.Github"           . ?g)
        ("/Gmail/INBOX"                    . ?i)
        ("/Gmail/Sent Mail"        . ?s)
        ("/Gmail/Trash"            . ?t)
        ("/Gmail/Spam"             . ?!)))

;; todo @See https://groups.google.com/forum/#!topic/mu-discuss/BpGtwVHMd2E
;; (setq mu4e-bookmarks `(("\\\\Inbox" "Inbox" ?i)
;;                        ("flag:flagged" "Flagged messages" ?f)
;;                        (,(concat "flag:unread AND "
;;                                  "NOT flag:trashed AND "
;;                                  "NOT maildir:/[Gmail].Spam AND "
;;                                  "NOT maildir:/[Gmail].Bin")
;;                         "Unread messages" ?u)))

;; todo
(setq mu4e-bookmarks
      '(("date:1w..now helm AND NOT flag:trashed" "Last 7 days helm messages" ?h)
        ("date:1d..now helm AND NOT flag:trashed" "Yesterday and today helm messages" ?b)
        ("flag:unread AND NOT flag:trashed AND NOT maildir:/Gmail/[Gmail].Spam \
AND NOT maildir:/Zoho/Spam AND NOT maildir:/Yahoo/Bulk\\ Mail" "Unread messages" ?u)
        ("date:today..now AND NOT flag:trashed AND NOT maildir:/Gmail/[Gmail].Spam \
AND NOT maildir:/Zoho/Spam AND NOT maildir:/Yahoo/Bulk\\ Mail" "Today's messages" ?t)
        ("date:1d..now AND NOT flag:trashed AND NOT maildir:/Gmail/[Gmail].Spam \
AND NOT maildir:/Zoho/Spam AND NOT maildir:/Yahoo/Bulk\\ Mail" "Yesterday and today messages" ?y)
        ("date:7d..now AND NOT flag:trashed AND NOT maildir:/Gmail/[Gmail].Spam \
AND NOT maildir:/Zoho/Spam AND NOT maildir:/Yahoo/Bulk\\ Mail" "Last 7 days" ?w)
        ("mime:image/* AND NOT flag:trashed AND NOT maildir:/Gmail/[Gmail].Spam \
AND NOT maildir:/Zoho/Spam AND NOT maildir:/Yahoo/Bulk\\ Mail" "Messages with images" ?p)))
;; todo 
;; (add-hook 'mu4e-mark-execute-pre-hook
;;           (lambda (mark msg)
;;             (cond ((member mark '(refile trash)) (mu4e-action-retag-message msg "-\\Inbox"))
;;                   ((equal mark 'flag) (mu4e-action-retag-message msg "\\Starred"))
;;                   ((equal mark 'unflag) (mu4e-action-retag-message msg "-\\Starred")))))


;; program to get mail; alternatives are 'fetchmail', 'getmail'
;; isync or your own shellscript. called when 'U' is pressed in
;; main view.

;; If you get your mail without an explicit command,
;; use "true" for the command (this is the default)
;; (setq mu4e-get-mail-command "offlineimap")
;; allow for updating mail using 'U' in the main view:
;; (setq mu4e-get-mail-command "true")
(setq mu4e-get-mail-command "offlineimap -q -u Basic")

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

;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-default-smtp-server "stbeehive.oracle.com"
;;       smtpmail-smtp-server "stbeehive.oracle.com"
;;       smtpmail-smtp-service 465
;;       smtpmail-stream-type 'starttls
;;       smtpmail-debug-info t)

(setq message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "/usr/local/bin/msmtp"
      user-full-name "Dylan")

(setq mu4e-contexts
      `(,(make-mu4e-context
          :name "Hotmail"
          :enter-func (lambda () (mu4e-message "Switch Hotmail context"))
          :leave-func (lambda () (mu4e-message "Leaving Hotmail context"))
          ;; we match based on the maildir of the message
          ;; this matches maildir /Work and its sub-directories
          :match-func (lambda (msg)
                        (when msg
                          (string-match-p "^/Hotmail" (mu4e-message-field msg :maildir))))
          :vars '((mu4e-maildir            . "~/Maildir")
                  (smtpmail-smtp-user      . "yinshuo335@hotmail.com")
                  (smtpmail-smtp-server    . "smtp.office365.com")
                  (smtpmail-smtp-service   . 587)
                  (mu4e-sent-folder        . "/Hotmail/Sent")
                  (mu4e-drafts-folder      . "/Hotmail/Drafts")
                  (mu4e-trash-folder           . "/Hotmail/Deleted")
                  (mu4e-refile-folder          . "/Hotmail/Archive")
                  (mu4e-sent-messages-behavior . "delete")
                  (user-mail-address           . "yinshuo335@hotmail.com")
                  (user-full-name              . "Yinshuo" )
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
                          (string= (mu4e-message-field msg :maildir) "^/Gmail")))
          :vars '((mu4e-maildir            . "~/Maildir")
                  (user-mail-address       . "dylan.yins@gmail.com" )
                  (user-full-name          . "Yinshuo" )
                  (mu4e-sent-folder        . "/Gmail/Sent Mail")
                  (mu4e-drafts-folder      . "/Gmail/Drafts")
                  (mu4e-trash-folder           . "/Gmail/Trash")
                  (mu4e-sent-messages-behavior . "delete")
                  (mu4e-compose-signature  .
                                             (concat
                                              "Sincerely,\n"
                                              "Yin Shuo.\n"))))))

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
;; (setq mu4e-sent-messages-behavior 'delete)

(require 'mu4e-contrib)
(setq mu4e-html2text-command 'mu4e-shr2text)
;; add option to view html message in a browser
;; `aV` in view to activate
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

;; Don't ask for a 'context' upon opening mu4e
;; (setq mu4e-context-policy 'pick-first)
;; Don't ask to quit... why is this the default?
(setq mu4e-confirm-quit nil)

mu4e-attachment-dir (expand-file-name "~/Downloads")

;; Try to show images
(setq mu4e-view-show-images t
      mu4e-show-images t
      mu4e-view-image-max-width 800)
;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))
;; spell check
(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
           (set-fill-column 72)
           (flyspell-mode)))
;; the list of all of my e-mail addresses
(setq mu4e-user-mail-address-list '("yinshuo335@hotmail.com"
                                    "dylan.yins@gmail.com"
                                    "yinshuo333@gmail.com"))
;; the headers to show in the headers list -- a pair of a field
;; and its width, with `nil' meaning 'unlimited'
;; (better only use that for the last field.
;; These are the defaults:
(setq mu4e-headers-fields
     '( (:human-date          .  25)    ;; alternatively, use :human-date
        (:flags               .   6)
        (:from-or-to          .  22)
        (:thread-subject      .  nil))) ;; alternatively, use :thread-subject

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; start with the first (default) context;
(setq mu4e-context-policy 'pick-first)
;; give me ISO(ish) format date-time stamps in the header list
(setq mu4e-headers-date-format "%Y/%m/%d %H:%M")

;; Call EWW to display HTML messages
(defun jcs-view-in-eww (msg)
  (eww-browse-url (concat "file://" (mu4e~write-body-to-html msg))))

;; Arrange to view messages in either the default browser or EWW
(add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)
(add-to-list 'mu4e-view-actions '("Eww view" . jcs-view-in-eww) t)

;; From Ben Maughan: Get some Org functionality in compose buffer
(add-hook 'message-mode-hook 'turn-on-orgtbl)
(add-hook 'message-mode-hook 'turn-on-orgstruct++)

(defun offlineimap-get-password (host port)
  (require 'netrc)
  (let* ((netrc (netrc-parse (expand-file-name "~/.authinfo.gpg")))
         (hostentry (netrc-machine netrc host port port)))
    (when hostentry (netrc-get hostentry "password"))))

;; every new email composition gets its own frame! (window)
;; (setq mu4e-compose-in-new-frame t)

(provide 'init-mu4e)
