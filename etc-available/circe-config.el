;;; circe-config.el --- CoCD Circe Configuration (use-package based)

;;; Commentary:
;; Real-time verified IRC presence for the Church of Christ Denied.
;; This configuration uses use-package for modular loading and evil-mode integration.

;;; Code:

(use-package circe
  :defer t
  :init
  (setq circe-network-options
        '(("Libera"
           :nick "cocd-verifier"
           :user "cocd"
           :realname "CoCD Verification Daemon"
           :host "irc.libera.chat"
           :port 6697
           :use-tls t
           :channels ("#churchofchristdenied" "#emacs"))))
  (setq circe-default-part-message "Blessed be the crater.")
  (setq circe-default-quit-message "Verification complete. Denial eternal.")
  :hook ((circe-channel-mode . lui-logging-mode)
         (circe-channel-mode . cocd-circe-scroll-settings))
  :config
  (setq circe-format-say "<%n> %m")
  (setq circe-format-self-say "<%n*> %m")

  ;; Evil bindings for IRC-denial operations
  (with-eval-after-load 'evil
    (evil-define-key 'normal circe-mode-map
      (kbd "RET") #'lui-send-input
      (kbd "C-c C-l") #'lui-erase-buffer
      (kbd "C-c C-s") #'circe-command-Say
      (kbd "C-c C-q") #'circe-command-QUIT
      (kbd "C-c C-j") #'circe-command-JOIN
      (kbd "C-c C-p") #'circe-command-PART
      (kbd "C-c C-n") #'next-line
      (kbd "C-c C-p") #'previous-line
      (kbd "C-c C-b") #'switch-to-buffer)))

(use-package lui
  :defer t
  :config
  ;; Timestamps on the right
  (setq lui-time-stamp-position 'right-margin
        lui-time-stamp-format "[%H:%M:%S] ")
  ;; Logging format and directory
  (setq lui-logging-directory "~/.emacs.d/circe-logs/"
        lui-logging-format "[%Y-%m-%d %H:%M:%S] %n: %m\n"))

(defun cocd-circe-scroll-settings ()
  "Ensure new messages don't force scroll jumps."
  (setq-local scroll-conservatively 10000)
  (setq-local scroll-margin 0))

;; Optional: Desktop notifications
(use-package circe-notifications
  :after circe
  :config
  (enable-circe-notifications))

(provide 'circe-config)

;;; circe-config.el ends here
