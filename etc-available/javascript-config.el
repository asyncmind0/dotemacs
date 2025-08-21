;;; javascript-config.el --- JS development environment

(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode)
  :init
  ;; Define your JS editing enhancements
  (defun my-js-mode-hooks ()
    ;; Enable syntax checking
    (flycheck-mode t)

    ;; Optional tern-mode integration (commented out by default)
    ;; (tern-mode t)
    ;; (define-key evil-normal-state-map (kbd "C-]") 'tern-find-definition)
    ;; (define-key evil-normal-state-map (kbd "C-t") 'tern-pop-find-definition)
    ;; (define-key evil-normal-state-map (kbd "C-M-]") 'tern-find-definition-by-name)

    ;; Additional evil keybindings for JS structural editing (commented)
    ;; (unless (or
    ;;          (string-prefix-p "*mo-git-blame" (buffer-name))
    ;;          (string-prefix-p "*svn-status" (buffer-name)))
    ;;   (define-key evil-normal-state-map "za" 'js3-mode-toggle-element)
    ;;   (define-key evil-normal-state-map "\\t" 'js3-mode-toggle-element)
    ;;   (define-key evil-normal-state-map "zo" 'js3-mode-show-element)
    ;;   (define-key evil-normal-state-map "zO" 'hide-other)
    ;;   (define-key evil-normal-state-map "zc" 'hide-entry)
    ;;   (define-key evil-normal-state-map "zr" 'js3-mode-show-node)
    ;;   (define-key evil-normal-state-map "zR" 'js3-mode-show-all)
    ;;   (define-key evil-normal-state-map "zm" 'js3-mode-hide-functions)
    ;;   (define-key evil-normal-state-map "zM" 'hide-sublevels)
    ;;   (define-key evil-normal-state-map (kbd "C-i") 'evil-jump-forward))
    )

  :hook (js2-mode . my-js-mode-hooks))

;; Optional: Tern integration for JS/TS navigation
(use-package tern
  :ensure t
  :defer t
  :after js2-mode)

