;;; helm-my-config.el --- Personal Helm configuration

;; Reference: http://tuhdo.github.io/helm-intro.html
    (defun helm-split-mini()
      (interactive)
      (let ((buffers (mapcar 'window-buffer (window-list))))
        (if (= 1 (length buffers))
            (split-window-sensibly)
          (other-window 1)
          ))
      (helm-mini))

(use-package helm
  :ensure t
  :init
  ;; Enable Helm globally
  (helm-mode 1)

  :config
  ;; General interface settings
  (setq
   helm-split-window-in-side-p nil                      ; Avoid occupying entire window
   helm-move-to-line-cycle-in-source nil                ; No wrapping in source
   helm-ff-search-library-in-sexp t                     ; Search for `require` libraries
   helm-scroll-amount 8                                 ; Scroll by 8 lines
   helm-ff-file-name-history-use-recentf t              ; Use recentf in file history
   helm-autoresize-mode t                               ; Resize Helm window dynamically
   helm-M-x-always-save-history t                       ; Persist `M-x` history
   helm-always-two-windows t                            ; Always split windows
   helm-ff-lynx-style-map t                             ; Use lynx-style navigation
 helm-completion-style 'emacs
 helm-ff-lynx-style-map t
 helm-locate-command "locate -l 500 %s -e -A -N  %s"
 helm-locate-project-list '("~/devel/" "~/DamageInc")
 helm-minibuffer-history-key "M-p"

   ;; Buffer & file ignoring
   helm-boring-buffer-regexp-list
   '("^ " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf"
     "\\*vc-" "\\*Complet" "\\*magit" "\\*cscope" "\\*epc")
   helm-boring-file-regexp-list
   '("\\.cache" "\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$"
     "\\._darcs$" "\\.la$" "\\.o$" "~$" "\\.pyc$")

   ;; Fuzzy matching
   helm-buffers-fuzzy-matching t
   helm-M-x-fuzzy-match t
   helm-recentf-fuzzy-match t
   helm-mode-fuzzy-match t
   helm-imenu-fuzzy-match t
   helm-locate-fuzzy-match nil                         ; Too noisy sometimes
   helm-semantic-fuzzy-match t

   ;; File and search optimizations
   helm-ff-auto-update-initial-value nil
   helm-ff-ido-style-backspace t
   helm-ff-skip-boring-files t
   helm-ff-smart-completion t
   helm-ff-transformer-show-only-basename nil
   helm-findutils-skip-boring-files t

   ;; Behavior tuning
   helm-mode-handle-completion-in-region t
   helm-mode-reverse-history nil
   helm-quick-update t
   helm-reuse-last-window-split-state nil
   helm-match-plugin-mode t
   helm-adaptive-mode t
   helm-full-frame nil
   helm-buffer-max-length 30
   helm-truncate-lines t

   ;; Helm-ag integration
   helm-ag-use-grep-ignore-list t
   helm-ag-use-agignore t
   helm-ag-insert-at-point t

   ;; Customize sources shown in `helm-mini`
   helm-mini-default-sources
   '(helm-source-buffers-list
     helm-source-bookmarks
     helm-source-recentf
     helm-source-buffer-not-found
     helm-source-locate)

   ;; Customize sources for `helm-for-files`
   helm-for-files-preferred-list
   '(helm-source-recentf
     helm-source-locate)

   ;; Format of buffer listings
   helm-buffer-list-format
   '(("%p" . 25) ("%u" . 8))
 helm-completion-style 'emacs
 helm-ff-lynx-style-map t
 helm-minibuffer-history-key "M-p"

   )

    (global-set-key "\M-x" 'helm-M-x)
    (global-set-key "\C-xb" 'helm-bookmarks)
    (global-set-key "\C-x " 'helm-split-mini)
    (global-set-key "\C-c " 'helm-mini)
    (global-set-key "\C-xr" 'helm-recentf)
    ;;(define-key helm-command-map "b" 'helm-bookmarks)
    (global-set-key "\C-xt" 'helm-eproject-ag)
    (global-set-key "\C-xc" 'helm-resume)
    (global-set-key [(f5)] 'helm-etags-select)
    (global-set-key "\C-x/"  'helm-cmd-t)
    ;(global-set-key "\C-xv"  'helm-show-kill-ring)
    (global-set-key "\C-x\\"  'ag)
    (global-set-key "\M-so"  'helm-occur)
    (global-set-key (kbd "C-c b") 'helm-bookmarks)
    ;(global-set-key "\C-xv"  'helm-show-kill-ring)
    ;;(define-key helm-command-map "b" 'helm-bookmarks)
  )

;; Optional: Use helm for improved M-x and file-finding experience
;;(use-package helm-command
;;  :after helm
;;  :bind (("M-x" . helm-M-x)
;;         ("C-x C-f" . helm-find-files)
;;         ("C-x b" . helm-mini)))

;; Enable helm-ag if available
(use-package helm-ag
  :ensure t
  :after helm)

(use-package crosshairs
  :load-path "modules.d"
  :commands crosshairs-mode)
(defun fileinfo ()
  (interactive)
  ;;(keyboard-quit)
  (message nil)
  (crosshairs-flash)
  (evil-show-file-info)
  (evil-normal-state)
  )

(global-set-key (kbd "C-g") 'fileinfo)

(use-package evil
  :after crosshairs
:config (define-key evil-normal-state-map [escape] 'fileinfo))
