;;; orgmode-config.el --- Org-mode configuration with integrations

(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :hook (org-mode . org-indent-mode)
  :init
  ;; Load supported babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (python . t)))

  :config
  ;; HTML export settings
  (setq org-html-validation-link nil
        org-html-head-include-scripts nil
        org-html-head-include-default-style nil
        org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

  ;; General org-mode behavior
  (setq org-log-done t
        org-return-follows-link t
        org-catch-invisible-edits t
        org-indent-mode t
        org-directory "~/Org/"
        org-default-notes-file (concat org-directory "notes.org")
        org-archive-location "~/Org/.archived/archive.org::"
        org-clock-into-drawer t
        org-clock-persist 'history
        org-default-priority 90
        org-lowest-priority 90)
  (require 'cl-lib)
  (setq org-emphasis-alist
        (cons '("+" (:strike-through t :foreground "#121212"))
              (cl-remove-if (lambda (e) (equal (car e) "+"))
                            org-emphasis-alist)))



  ;; Agenda and journal
  (setq org-agenda-files '("~/Org/" "~/Org/damagebdd/")
        org-agenda-file-regexp "[^.#].*\\.org$"
        org-journal-dir "~/Org/journal/"
        org-journal-file-format "%A_%Y%m%d")

  ;; Org Mobile
  (setq org-mobile-directory "~/Org/MobileOrg/"
        org-mobile-inbox-for-pull (concat org-mobile-directory "mobileorg.org"))

  ;; Org Toodledo
  (setq org-toodledo-userid (password-store-get "internet/toodledo/userid")
        org-toodledo-password (password-store-get "internet/toodledo/password")
        org-toodledo-folder-support-mode 'heading)

)

;;; Additional Org Packages

(use-package org-journal
  :ensure t
  :after org)

(use-package org-alert
  :ensure t
  :after org
  :config
  (setq alert-default-style 'libnotify))

(use-package org-gcal
  :ensure t
  :after org
  :init
  ;; Set credentials before loading org-gcal
  (setq org-gcal-client-id (password-store-get "internet/google/melit/emacs/org-gcal/clientid")
        org-gcal-client-secret (password-store-get "internet/google/melit/emacs/org-gcal/clientsecret")
        org-gcal-file-alist
        `((,(password-store-get "internet/google/melit/username") . "~/Org/gcal_personal.org")))
  :config
  ;; Now reload credentials after variables are set
  (org-gcal-reload-client-id-secret))

(use-package htmlize
  :ensure t)

;; Optional visual + workflow packages
(use-package hydra :ensure t)
(use-package major-mode-hydra :ensure t)
(use-package evil :ensure t)
(defvar my-gpg-signing-key nil
  "The GPG key to use for signing published files.")


(defun cocd-get-gpg-keys ()
  "Return an alist of available GPG secret keys and associated UIDs.
Each entry is a cons cell: (\"UID <email> [KEYID]\" . KEYID)."
  (let ((keys '())
        (current-key-id nil))
    (with-temp-buffer
      (call-process "gpg" nil t nil "--list-secret-keys" "--with-colons")
      (goto-char (point-min))
      (while (not (eobp))
        (let ((line (buffer-substring-no-properties
                     (line-beginning-position) (line-end-position))))
          (let ((fields (split-string line ":" t)))
            (cond
             ((string= (car fields) "sec")
              (setq current-key-id (nth 4 fields)))  ; Field 5 is key ID
             ((and (string= (car fields) "uid") current-key-id)
              (message "fields %s" fields)
              (let ((uid (nth 4 fields)))            ; Field 10 is UID string
                (push (cons (format "%s [%s]" uid current-key-id)
                            current-key-id)
                      keys))))))
        (forward-line 1)))
    (reverse keys)))


(defun cocd-prompt-gpg-key ()
  "Prompt the user to choose a GPG key for signing using Helm."
  (interactive)
  (let* ((keys (cocd-get-gpg-keys))
         (key (helm :sources (helm-build-sync-source "GPG Keys"
                          :candidates keys
                          :fuzzy-match t)
                    :prompt "Choose GPG key: ")))
    (message "setting keys %s" key )
    (setq my-gpg-signing-key key )))


(defun my-sign-published-file (_orgfilename filename)
  "Sign the published file using a specific GPG key."
  (when (and (stringp filename)
             (file-exists-p filename)
             (string-match-p "\\.html" filename)) ;; Or customize
    (unless my-gpg-signing-key
      (cocd-prompt-gpg-key))
    (let ((sigfile (concat filename ".asc")))
      (cocd-log-message (format "Signing %s with GPG key %s..." filename my-gpg-signing-key))
      (call-process "gpg" nil nil nil
                    "--armor"
                    "--local-user" my-gpg-signing-key
                    "--output" sigfile
                    "--detach-sign" filename)
      (cocd-log-message (format "Created signature: %s" sigfile)))))

(add-hook 'org-publish-after-publishing-hook #'my-sign-published-file)

(add-hook 'org-mode-hook #'visual-line-mode)
