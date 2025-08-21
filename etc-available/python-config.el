;;; python-config.el --- Python development setup for Emacs

;;; LSP support (optional)
(use-package lsp-jedi
  :ensure t)

;;; Python Mode Configuration
(use-package python-mode
  :ensure t
  :after (evil blacken flycheck outline-magic poetry)
  :init
  ;; Outline visibility marker
  (set-display-table-slot standard-display-table
                          'selective-display
                          (string-to-vector " [...]\\n"))

  ;; Show/hide subtree fix after `goto-line` and `evil-goto-line`
  (defun my/show-subtree-after-goto-line (&rest _)
  "Expand folded block after jumping to a line."
  (save-excursion
    (ignore-errors (show-subtree))))

  (advice-add 'goto-line :after #'my/show-subtree-after-goto-line)
  (advice-add 'evil-goto-line :after #'my/show-subtree-after-goto-line)

  ;; Define string prefix helper
  (defun string/starts-with (s begins)
    "Return non-nil if string S starts with BEGINS."
    (and (>= (length s) (length begins))
         (string-equal (substring s 0 (length begins)) begins)))

  ;; Define outline level for Python blocks
  (defun py-outline-level ()
    "Calculate indentation-based outline level in Python."
    (let (buffer-invisibility-spec)
      (save-excursion
        (skip-chars-forward "    ")
        (current-column))))

  ;; Core Python mode hook
  (defun my-python-mode-hook ()
    (interactive)
    (message "my-python-mode-hook")

    ;; Enable tools
    (flycheck-mode)
    (flyspell-prog-mode)

    ;; Activate blacken, rope, etc. if not in transient system buffers
    (unless (seq-some (lambda (prefix)
                        (string/starts-with (buffer-name) prefix))
                      '("magit" "*mo-git-blame" "*svn-status"))
      (blacken-mode)
      (pymacs-load "ropemacs" "rope-")))

  ;; Load pymacs manually (user may want to gate this by OS)
  (require 'pymacs)

  ;; Enable flycheck globally
  (add-hook 'after-init-hook #'global-flycheck-mode)

  ;; Use flake8 with python-mode
  (flycheck-add-mode 'python-flake8 'python-mode)

  ;; Enable outline magic
  (add-hook 'outline-minor-mode-hook
            (lambda () (require 'outline-magic)))

  :hook (python-mode . my-python-mode-hook)

  :config
  (setq
   python-remove-cwd-from-path nil
   py-load-pymaqcs-p t
   pymacs-python-command "/usr/sbin/python"
   pymacs-load-path
   '("/usr/lib/python3.11/site-packages"
     "~/.local/lib/python3.11/site-packages/")
   ropemacs-confirm-saving nil
   ropemacs-global-prefix "C-x @"
   ropemacs-enable-autoimport t
   blacken-executable "~/.local/bin/black"))
