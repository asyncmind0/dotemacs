(defun email () 
  (interactive)
  (when (not (featurep 'mu4e))
    (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
    
    (require 'mu4e)
    ;;(require 'org-mu4e)
    (require 'password-store)
    ;; sending mail -- replace USERNAME with your gmail username
    ;; also, make sure the gnutls command line utils are installed
    ;; package 'gnutls-bin' in Debian/Ubuntu
    (require 'smtpmail)
    ;; these are actually the defaults
    ;; convert org mode to HTML automatically
    ;;(setq 
    ;; org-mu4e-convert-to-html nil
    ;; ;; need this to convert some e-mails properly
    ;; mu4e-html2text-command "html2text -utf8 -width 72"
    ;; user-full-name  "Steven Joseph"
    ;; message-signature nil
    ;; ;; don't keep message buffers around
    ;; message-kill-buffer-on-exit t
    ;; 
    ;; ;; show images
    ;; mu4e-show-images t
    ;; ;; allow for updating mail using 'U' in the main view:
    ;; ;; I have this running in the background anyway
    ;; ;; (setq mu4e-get-mail-command "offlineimap")
    ;; ;; convert org mode to HTML automatically
    ;; org-mu4e-convert-to-html t
    ;;
    ;; ;; need this to convert some e-mails properly
    ;; ;; (setq mu4e-html2text-command "html2text -utf8 -width 72")
    ;; mu4e-html2text-command "html2text "
    ;; mu4e-sent-folder   "/Sent"       ;; folder for sent messages
    ;; mu4e-drafts-folder "/Drafts"     ;; unfinished messages
    ;; mu4e-trash-folder  "/Trash"      ;; trashed messages
    ;; mu4e-refile-folder "/Archive"   ;; saved messages
    ;; )

    ;;(setq mu4e-refile-folder
    ;;      (lambda (msg)
    ;;        (cond
    ;;         ;; messages with football or soccer in the subject go to /football
    ;;         ((string-match "football\\|soccer"
    ;;                        (mu4e-message-field msg :subject))
    ;;          "/football")
    ;;         ;; messages sent by me go to the sent folder
    ;;         ((find-if
    ;;           (lambda (addr)
    ;;             (mu4e-message-contact-field-matches msg :from addr))
    ;;           mu4e-user-mail-address-list)
    ;;          mu4e-sent-folder)
    ;;         ;; everything else goes to /archive
    ;;         ;; important to have a catch-all at the end!
    ;;         (t  "/inbox"))))
    ;;

    ;; something about ourselves
        (setq
         mu4e-maildir       "~/Maildir"   ;; top-level Maildir
         user-mail-address "steven@damagebdd.com"
         user-full-name  "Steven Joseph"
           ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
         mu4e-sent-messages-behavior 'delete
         mu4e-maildir-shortcuts '( ("Inbox" . ?i)
                                   )
         )
  
  
    ;; use imagemagick, if available
    (when (fboundp 'imagemagick-register-types)
      (imagemagick-register-types))
  
    ;;; message view action
    (defun mu4e-msgv-action-view-in-browser (msg)
      "View the body of the message in a web browser."
      (interactive)
      (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
            (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
        (unless html (error "No html part for this message"))
        (with-temp-file tmpfile
          (insert
           "<html>"
           "<head><meta http-equiv=\"content-type\""
           "content=\"text/html;charset=UTF-8\">"
           html))
        (browse-url (concat "file://" tmpfile))))
    (defun mu4e-msgv-action-view-in-kmail(msg)
      "View the body of the message in a kmail."
      (interactive)
      (let ((path (mu4e-msg-field (mu4e-message-at-point t) :path))
            (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
        (unless path (error "No path for this message"))
        (message path)
        (shell-command (concat "kmail --view file://" path))))
    
    (add-to-list 'mu4e-view-actions
                 '("View in browser" . mu4e-msgv-action-view-in-browser) t)
    (add-to-list 'mu4e-view-actions
                 '("kView in kmail" . mu4e-msgv-action-view-in-kmail) t)
    
    )
  (mu4e))

(defalias 'org-mail 'org-mu4e-compose-org-mode)

;; Configure desktop notifs for incoming emails:
(use-package mu4e-alert
  :ensure t
  :init
  (defun perso--mu4e-notif ()
    "Display both mode line and desktop alerts for incoming new emails."
    (interactive)
    (mu4e-update-mail-and-index 1)        ; getting new emails is ran in the background
    (mu4e-alert-enable-mode-line-display) ; display new emails in mode-line
    (mu4e-alert-enable-notifications))    ; enable desktop notifications for new emails
  (defun perso--mu4e-refresh ()
    "Refresh emails every 300 seconds and display desktop alerts."
    (interactive)
    (mu4e t)                            ; start silently mu4e (mandatory for mu>=1.3.8)
    (run-with-timer 0 300 'perso--mu4e-notif))
  :after mu4e
  :bind ("<f2>" . perso--mu4e-refresh)  ; F2 turns Emacs into a mail client
  :config
  ;; Mode line alerts:
  (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
  ;; Desktop alerts:
  (mu4e-alert-set-default-style 'libnotify)
  (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
  ;; Only notify for "interesting" (non-trashed) new emails:
  (setq mu4e-alert-interesting-mail-query
        (concat
         "flag:unread maildir:/INBOX"
         " AND NOT flag:trashed")))

;;(defadvice epg--start (around advice-epg-disable-agent disable)
;;  "Make epg--start not able to find a gpg-agent"
;;  (let ((agent (getenv "GPG_AGENT_INFO")))
;;    (setenv "GPG_AGENT_INFO" nil)
;;    ad-do-it
;;    (setenv "GPG_AGENT_INFO" agent)))
;;
;;(defun epg-disable-agent ()
;;  "Make EasyPG bypass any gpg-agent"
;;  (interactive)
;;  (ad-enable-advice 'epg--start 'around 'advice-epg-disable-agent)
;;  (ad-activate 'epg--start)
;;  (message "EasyPG gpg-agent bypassed"))
;;
;;(defun epg-enable-agent ()
;;  "Make EasyPG use a gpg-agent after having been disabled with epg-disable-agent"
;;  (interactive)
;;  (ad-disable-advice 'epg--start 'around 'advice-epg-disable-agent)
;;  (ad-activate 'epg--start)
;;  (message "EasyPG gpg-agent re-enabled"))
;;
;;(require 'epg-config)
;;(setq mml2015-use 'epg
;;
;;      mml2015-verbose t
;;      epg-user-id "520A188A"
;;      mml2015-encrypt-to-self t
;;      mml2015-always-trust nil
;;      mml2015-cache-passphrase t
;;      mml2015-passphrase-cache-expiry '36000
;;      mml2015-sign-with-sender t
;;
;;      gnus-message-replyencrypt t
;;      gnus-message-replysign t
;;      gnus-message-replysignencrypted t
;;      gnus-treat-x-pgp-sig t
;;
;;      ;;       mm-sign-option 'guided
;;      ;;       mm-encrypt-option 'guided
;;      mm-verify-option 'always
;;      mm-decrypt-option 'always
;;
;;      gnus-buttonized-mime-types
;;      '("multipart/alternative"
;;        "multipart/encrypted"
;;        "multipart/signed")
;;
;;      epg-debug t ;;  then read the *epg-debug*" buffer
;;      )

;; without this, "symbol's value as variable is void: mml2014-use" when signing
;; then found http://www.gnu.org/software/emacs/manual/html_node/gnus/Security.html
;; so set to epg and all was good!
;; to sign a mail: M-x mml-secure-sign-pgpmime
;; http://vxlabs.com/2014/06/06/configuring-emacs-mu4e-with-nullmailer-offlineimap-and-multiple-identities/
(setq mml2015-use 'epg)
