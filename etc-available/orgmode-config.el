(req-package org
  :require (
            org
            org-journal
            org-journal-list
            password-store
            org-alert
            ;;helm-org-rfile
            hydra
            major-mode-hydra
            org-gcal
            ;org-trello
            evil
            ;appt
            )
  :config (setq
           alert-default-style 'libnotify
           org-log-done t
           org-directory  "/home/steven/org/"
           org-from-is-user-regexp nil
           org-log-done t
           org-archive-location "~/org/archive.org::"
           org-indent-mode t
           org-mobile-directory (expand-file-name "~/share/Dropbox/MobileOrg/")
           org-mobile-inbox-for-pull (concat org-mobile-directory "mobileorg.org")
           org-return-follows-link t
           org-catch-invisible-edits t
           org-agenda-file-regexp "[^.#].*\\.org$"
           org-default-notes-file (concat org-directory "notes.org")
           org-clock-persist 'history
           org-toodledo-userid (password-store-get "internet/toodledo/userid")
           org-toodledo-password (password-store-get "internet/toodledo/password")
           org-toodledo-folder-support-mode t
           org-toodledo-folder-support-mode (quote heading)
           org-agenda-files
           (quote
            ("/home/steven/Org/" "/home/steven/Org/damagebdd/"))
                                        ; ("/home/steven/org/todo.org"))
           org-clock-into-drawer t
           org-default-priority 90
           org-ehtml-docroot "~/Org/ehtml/"
           org-journal-dir "~/Org/journal/"
           org-journal-file-format "%A_%Y%m%d"
           org-lowest-priority 90
           org-emphasis-alist
           (cons '("+" '(:strike-through t :foreground "#121212"))
                 (delete* "+" org-emphasis-alist :key 'car :test 'equal))
        ;; https://cestlaz.github.io/posts/using-emacs-26-gcal/#.WIqBud9vGAk
           org-gcal-client-id (password-store-get "internet/google/melit/emacs/org-gcal/clientid")
           org-gcal-client-secret (password-store-get "internet/google/melit/emacs/org-gcal/clientsecret")
           org-gcal-file-alist '(
                                 ((password-store-get "internet/google/melit/username") .  "~/Org/gcal_personal.org")
                                 ;((password-store-get "internet/google/melit/username") .  "~/Org/gcal_work.org")
                                 )
            )
  :init
  (progn
    ;(custom-set-variables '(orgtrello-log-level orgtrello-log-trace))
    (epa-file-enable)
    ;;(require 'journal)
    (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
    ;;(define-key global-map "c l" 'org-store-link)
    ;;(define-key global-map "c a" 'org-agenda)
    (org-clock-persistence-insinuate)
    (setq org-todo-keywords
          '((sequence "TODO(t)" "WAIT(w@/!)" "SOMETIME(s)"
                      "STARTED(i)" "OSC_DEV" "|" "OSC_DONE"
                      "DONE(d!)" "CANCELED(c@)" "DEFFERED(f)")))

    (setq org-agenda-skip-function-global
                '(org-agenda-skip-entry-if 'todo '("OSC_DONE" "OSC_DEV")))
          
    ;; I use C-c c to start capture mode
    (global-set-key (kbd "C-c c") 'org-capture)
    (add-to-list 'org-agenda-files org-directory)

    (defun my-org-files ()
      (interactive)
      (helm-find-files-1 org-directory))




    ;; NOTE: the org-ehtml-docroot value should be fully expanded
    (setq org-ehtml-docroot org-directory)
    (setq org-ehtml-everything-editable t)

    ;;(require 'org-ehtml)
    ;;(ws-start org-ehtml-handler 8888 "webserver")

    (defun org-toggle-todo-and-fold ()
      (interactive)
      (save-excursion
        (org-back-to-heading t) ;; Make sure command works even if point is
        ;; below target heading
        (cond ((looking-at "\*+ TODO")
               (org-todo "DONE")
               (hide-subtree))
              ((looking-at "\*+ DONE")
               (org-todo "TODO")
               (hide-subtree))
              (t (message "Can only toggle between TODO and DONE.")))))

    (define-key org-mode-map (kbd "C-c d") 'org-toggle-todo-and-fold)


    ;;http://doc.norang.ca/org-mode.html

    ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
    (setq org-capture-templates
          (quote (("t" "todo" entry (file "~/org/todo.org")
                   "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                  ("r" "respond" entry (file "~/org/respond.org")
                   "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                  ("n" "note" entry (file "~/org/notes.org")
                   "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                  ("j" "Journal" entry (file+datetree "~/org/ijournal.org")
                   "* %?\n%U\n" :clock-in t :clock-resume t)
                  ("w" "org-protocol" entry (file "~/org/todo.org")
                   "* TODO Review %c\n%U\n" :immediate-finish t)
                  ("m" "Meeting" entry (file "~/org/meetings.org")
                   "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                  ("p" "Phone call" entry (file "~/org/todo.org")
                   "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
                  ("h" "Habit" entry (file "~/org/todo.org")
                   "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
                  ("o" "OSC_DEV" entry (file+datetree "~/org/osc.org")
                   "* OSC_DEV %?\n" :clock-in t :clock-resume t)
                  ("c" "todo" entry (file "~/org/todo.org")
                   "* TODO %?\nSCHEDULED: %(format-time-string \"<%Y-%m-%d>\")")
                  ("d" "todo" entry (file "~/org/todo.org")
                   "* TODO %?\nDEADLINE: %(format-time-string \"<%Y-%m-%d>\")")
                  )))

    (setq org-agenda-custom-commands
          '(
            ("o" "OSCS"   
             (
              (todo "OSC_DEV")
              (todo "OSC_DONE")
              ))
            ("P" "Projects"   
             ((tags "PROJECT")))
            ("h" "Office and Home Lists"
             ((agenda)
              (tags-todo "OFFICE")
              (tags-todo "HOME")
              (tags-todo "COMPUTER")
              (tags-todo "DVD")
              (tags-todo "READING")))
            ("D" "Daily Action List" 
             ((agenda "" ((org-agenda-ndays 1)
                          (org-agenda-sorting-strategy
                           (quote ((agenda time-up priority-down tag-up) )))
                          (org-deadline-warning-days 0)
                          )))
             )))

    (defun my-org-archive-done-tasks ()
      (interactive)
      (org-map-entries 'org-archive-subtree "/DONE" 'file))

    (global-set-key (kbd "C-c a") 'org-agenda)
    (major-mode-hydra-bind org-agenda-mode "Org Agenda"
      ("r" helm-org-rifle "org-rifle")
      )
    (pretty-hydra-define hydra-global-org 
      (:hint nil :color amaranth :quit-key "q" :title "Org")
      ("Clock"
       (
        ("s" org-timer-start "Start Timer")
        ("S" org-timer-stop "Stop Timer")
        ("r" org-timer-set-timer "Set Timer") ; This one requires you be in an orgmode doc, as it sets the timer for the header
        ("p" org-timer "Print Timer") ; output timer value to buffer
        ("w" (org-clock-in '(4)) "Clock-In") ; used with (org-clock-persistence-insinuate) (setq org-clock-persist t)
        ("o" org-clock-out "Clock-Out") ; you might also want (setq org-log-note-clock-out t)
        ("j" org-clock-goto "Clock Goto") ; global visit the clocked task
        )
       "Capture"
       (
        ("c" org-capture "Capture") ; Don't forget to define the captures you want http://orgmode.org/manual/Capture.html
        ("l" org-capture-goto-last-stored "Last Capture")
        )
       "Journal"
       (
        ("i" org-journal-new-entry "iJournal entry")
        )
       "Todo"
       (
        ("t" org-todo-list "List todos")
        )
       )
      )
    (global-set-key (kbd "<f3>") 'hydra-global-org/body)

    ;(add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
    ;(add-hook 'org-capture-after-finalize-hook (lambda () (org-gcal-sync)))
   (defun my-org-agenda-hook ()
    (interactive)
    (define-key evil-normal-state-map "za" 'outline-toggle-children)
    (define-key evil-normal-state-map "TAB" 'outline-toggle-children)
    )
    ;(add-hook 'org-agenda-mode-hook 'my-org-agenda-hook)

    ;(custom-set-variables '(org-trello-files '("~/org/trellos/home" "~/org/trellos/work")))
    )
    (setq appt-time-msg-list nil) ; Clear existing appointments
    (setq appt-display-interval '5) ; Update interval in minutes
    (setq appt-message-warning-time '15) ; Warning time in minutes
    (setq appt-display-mode-line t) ; Show in the mode-line
    (setq appt-display-format 'window) ; Use a separate window for notifications
    (appt-activate 1) ; Enable notifications
    (defun my-org-agenda-to-appt ()
        (interactive)
        (setq appt-time-msg-list nil)
        (org-agenda-to-appt))

    ;(add-hook 'org-agenda-finalize-hook 'my-org-agenda-to-appt)
    (defun my-org-save-and-update-appt ()
        (interactive)
        (when (eq major-mode 'org-mode)
            (org-save-all-org-buffers)
            (my-org-agenda-to-appt)))

    ;(add-hook 'after-save-hook 'my-org-save-and-update-appt)
    (defun org-toggle-link-display ()
      "Toggle the literal or descriptive display of links."
      (interactive)
      (if org-descriptive-links
          (progn (org-remove-from-invisibility-spec '(org-link))
                 (org-restart-font-lock)
                 (setq org-descriptive-links nil))
        (progn (add-to-invisibility-spec '(org-link))
               (org-restart-font-lock)
               (setq org-descriptive-links t))))
    (defun my-org-mode-setup ()
  "Enable visual-line-mode when opening an Org buffer."
    (visual-line-mode 1)) ;; Activate visual-line-mode

    (add-hook 'org-mode-hook 'my-org-mode-setup)

    )
  )
;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
