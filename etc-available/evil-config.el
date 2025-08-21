;;; Evil-mode configuration with use-package

;; Required settings *before* loading evil
;(setq evil-want-integration nil        ;; Required for evil-collection
;      evil-want-C-i-jump nil)


;; Core Evil setup

(use-package evil
  :ensure t
  :init
  ;; Ensure evil keymaps are defined before :bind or hook use
  (require 'evil)

  ;; Global keybinding (outside evil states)
  :bind (
         ("C-c p" . cocd/paste-from-clipboard))

  :config
  ;; Enable evil-mode globally
  (evil-mode 1)

  ;; Set global evil behavior defaults
  (setq evil-default-state 'normal
        evil-flash-delay 60
        evil-default-cursor t
        evil-kill-on-visual-paste nil
        evil-undo-system 'undo-fu
        x-select-enable-clipboard t
        x-select-enable-primary t)

  ;; Use undo-fu for undo/redo
  (evil-set-undo-system 'undo-fu)

  ;; Visual tweaks: override tab in org-mode
  (with-eval-after-load 'org
    (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle))

  ;; Normal state keybindings
  (define-key evil-normal-state-map (kbd "`")      'helm-find-files)
  (define-key evil-normal-state-map (kbd "M-`")    'helm-find-file)
  (define-key evil-normal-state-map (kbd "C-x v")  'helm-show-kill-ring)
  (define-key evil-normal-state-map (kbd "=")      'evil-indent)
  (define-key evil-normal-state-map (kbd "\"")     'helm-split-mini)
  (define-key evil-normal-state-map (kbd "'")      'helm-mini)
  (define-key evil-normal-state-map (kbd "C-c p")  'cocd/paste-from-clipboard)

  ;; Optional: simulate C-u prefix for helm-ag if you want a shortcut
  (defun helm-ag-with-prefix-arg ()
    "Call `helm-ag` with a simulated C-u prefix."
    (interactive)
    (setq current-prefix-arg '(4))
    (call-interactively 'helm-ag))

  ;; Insert state: window movement
  (define-key evil-insert-state-map (kbd "C-w")         'evil-window-map)
  (define-key evil-insert-state-map (kbd "C-w <left>")  'evil-window-left)
  (define-key evil-insert-state-map (kbd "C-w <right>") 'evil-window-right)
  (define-key evil-insert-state-map (kbd "C-w <up>")    'evil-window-up)
  (define-key evil-insert-state-map (kbd "C-w <down>")  'evil-window-down)

  ;; Hooks: toggle symbol word search in text
  (defun my-text-mode-hook ()
    (setq evil-symbol-word-search t))
  (add-hook 'evil-local-mode-hook #'my-text-mode-hook)

  ;; Automatically enter insert state in specific modes
  (add-hook 'git-commit-mode-hook #'evil-insert-state)

  ;; Set initial state to 'emacs for specific modes
  (dolist (mode '(jabber-chat-mode jabber-roster-mode direx:direx-mode
                   mo-git-blame-mode svn-mode svn-status-mode
                   newsticker-mode newsticker-treeview-mode
                   dirtree-mode egg-status egg-log egg-filehistory
                   calendar-mode journal-mode
                   circe-mode circe-server-mode circe-channel-mode
                   deft-mode rope-occurrences
                   notmuch-show-mode notmuch-search-mode))
    (evil-set-initial-state mode 'emacs)))

;; Evil collection: integrate evil with other modes
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Undo system compatible with Evil
(use-package undo-fu
  :ensure t)

;; Visual feedback for Evil operations
(use-package evil-goggles
  :ensure t
  :hook (evil-mode . evil-goggles-mode))

;; Org-mode integration for Evil
(use-package evil-org
  :after org
  :ensure t
  :hook (org-mode . evil-org-mode))
