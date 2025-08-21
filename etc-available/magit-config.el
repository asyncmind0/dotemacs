;;; magit-config.el --- Git interface and optional Gerrit support

;; Core Magit setup
(use-package magit
  :ensure t
  :bind (("C-x g g" . magit-status)
         ("C-x g b" . mo-git-blame-current)
         ("C-x g l" . magit-log))
  :init
  ;; Utility function to add the current file to Git
  (defun magit-add-current-file ()
    "Run `git add` on the current file."
    (interactive)
    (let ((file-path (buffer-file-name (window-buffer))))
      (when file-path
        (let ((default-directory (file-name-directory file-path)))
          (message "Adding file to Git: %s" file-path)
          (shell-command (concat "git add " file-path)))))))

