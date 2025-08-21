(use-package recentf
;;; recent-files-config.el --- Recent file history tracking with custom merging
  :ensure nil ;; recentf is built-in
  :init
  (global-set-key (kbd "C-x C-r") #'helm-recentf)
  :config
  (require 'cl-lib)

  ;; Set limits and exclusions
  (setq recentf-max-saved-items 100
        recentf-exclude
        '("~$"
          "\\`\\(/home/[^/]+\\)?/\\.cache/.*"
          "\\`\\(/home/[^/]+\\)?/\\..*cache/.*"
          "\\`\\(/home/[^/]+\\)?/.local/share/Trash/.*"))

  ;; Merge recentf lists across sessions
  (defun my/recentf-merge-and-save ()
    (let ((old recentf-list))
      (recentf-load-list)
      (setq recentf-list (cl-union recentf-list old :test #'equal))
      (recentf-save-list)))

  (add-hook 'kill-emacs-hook #'my/recentf-merge-and-save)

  ;; Enable mode
  (recentf-mode 1))


