(defun shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (recentf-save-list)
  (kill-emacs))

(defun reload-emacs-config ()
  "reload emacs config"
  (interactive)
  (load-file "~/.emacs.d/init.el")
)
(defvar server-name "" "current server name")
(defun start-server (name)
  "start an emacs server"
  (interactive)
  (setq server-name name)
  (setq server-use-tcp t)
  (server-start)
  (setq history-dir (expand-file-name "~/.emacs.d/history.d/"))
  (setq savehist-additional-variables    ;; also save...
        '(search-ring regexp-search-ring)    ;; ... my search entries
        savehist-file (concat history-dir (format "history_%s" server-name)))
  ;;(require recentf)
  ;;(recentf-mode 1)
  (setq recentf-initialize-file-name-history t)
  (setq recentf-save-file (concat history-dir (format "recentf_%s" server-name)))
  (recentf-load-list)
  (require 'org-protocol)
  )

(defun shell-command-maybe (exe &optional paramstr)
  "run executable EXE with PARAMSTR, or warn if EXE's not available; eg. "
  " (djcb-shell-command-maybe \"ls\" \"-l -a\")"
  (if (executable-find exe)
    (shell-command-to-string (concat exe " " paramstr))
    (message (concat "'" exe "' not found found; please install"))))

(setq-default
 indent-tabs-mode nil
 c-basic-offset 4
 )
(setq
 req-package-log-level "debug"
 initial-scratch-message (format "     MM\"\"\"\"\"\"\"\"`M
     MM  mmmmmmmM
     M`      MMMM 88d8b.d8b. .d8888b. .d8888b. .d8888b.
     MM  MMMMMMMM 88''88'`88 88'  `88 88'  `\"\" Y8ooooo.
     MM  MMMMMMMM 88  88  88 88.  .88 88.  ...       88
     MM        .M dP  dP  dP `88888P8 '88888P' '88888P'
     MMMMMMMMMMMM

         M\"\"MMMMMMMM M\"\"M M\"\"MMMMM\"\"M MM\"\"\"\"\"\"\"\"`M
         M  MMMMMMMM M  M M  MMMMM  M MM  mmmmmmmM
         M  MMMMMMMM M  M M  MMMMP  M M`      MMMM
         M  MMMMMMMM M  M M  MMMM' .M MM  MMMMMMMM
         M  MMMMMMMM M  M M  MMP' .MM MM  MMMMMMMM
         M         M M  M M     .dMMM MM        .M
         MMMMMMMMMMM MMMM MMMMMMMMMMM MMMMMMMMMMMM

           https://github.com/asyncmind0/dotemacs

- The first step to being your master, is mastering your self.

 
%s

"  (shell-command-maybe "fortune") )
 initial-buffer-choice nil
 inhibit-startup-screen t
 font-lock-maximum-decoration t
 stack-trace-on-error t
 inhibit-splash-screen t
 inhibit-startup-echo-area-message t
 inhibit-startup-message t
 paredit-mode 0
 uniqueify-buffer-name-style 'reverse
 c-default-style "linux"
 c-basic-offset 4
 x-select-enable-clipboard t
 inhibit-splash-screen t
 ido-use-filename-at-point nil
 plantuml-jar-path "/opt/plantuml/plantuml.jar"
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/tmp/backups"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t       ; use versioned backups
 frame-title-format "%b"
 use-package-always-ensure t
 )

(goto-address-mode)
(global-font-lock-mode t)
(add-to-list 'auto-mode-alist '("\\.*rc$" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(defalias 'yes-or-no-p 'y-or-n-p)
(if (fboundp 'toggle-scroll-bar)
    (toggle-scroll-bar -1))

;;(setenv "SSH_AUTH_SOCK" (concat (getenv "HOME") "/.ssh-auth-sock"))
(setenv "XDG_CURRENT_DESKTOP" "LXDE")
(menu-bar-mode -1)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'scroll-left 'disabled nil)
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))
(setq create-lockfiles nil)
(set-face-attribute 'default nil :font "Hack-9" )
(set-frame-font "Hack-9" nil t)
;; Straight config start
(setq straight-repository-branch "develop")
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)

;; Straight config end
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(setenv "PATH" 
  (concat
   (expand-file-name "~/.emacs.d/bin/") ":"
   (expand-file-name "~/.bin/") ":"
   (expand-file-name "~/.local/bin/") ":"
   (getenv "PATH")
  )
)
(setq
 byte-compile-warnings '(cl-functions)
 use-package-always-ensure t
 )
(setq package-enable-at-startup nil)
(defun wrap-obsolete (orig-fn &rest args)
  (let ((args_ (if (= (length args) 2)
                   (append args (list "0"))
                 args)))
    (apply orig-fn args_)))

(advice-add 'define-obsolete-function-alias :around #'wrap-obsolete)
;; https://github.com/Bruce-Connor/smart-mode-line/issues/88
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list "Mode")
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#4d4d4c" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#3e999f" "#ffffff"))
 '(async-bytecomp-package-mode 1)
 '(auth-source-protocols
   '((imap "imap" "imaps" "143" "993") (pop3 "pop3" "pop" "pop3s" "110" "995")
     (ssh "ssh" "22") (sftp "sftp" "115")))
 '(auth-source-save-behavior nil)
 '(auth-sources '("~/.authinfo.gpg"))
 '(auto-revert-interval 0.5)
 '(background-color nil)
 '(background-mode dark)
 '(blacken-line-length 80)
 '(bookmark-default-file (expand-file-name "~/.emacsbookmarks"))
 '(bookmark-save-flag 1)
 '(bookmark-version-control 'nospecial)
 '(browse-url-browser-function 'browse-url-default-browser)
 '(col-highlight-overlay-priority -300)
 '(col-highlight-vline-face-flag nil)
 '(column-highlight-mode nil)
 '(compilation-disable-input t)
 '(cursor-color nil)
 '(custom-safe-themes
   '("ce6f7f49c3ae30199d85827d7c0308172b46581fdde778d66cc65e61740f8cda"
     "1e6fd4358c7ca703d7114562fa41fa89c3d50f87113c1a07cced16e175cd465f"
     "25833f8e6af287a32dad719f55371b618d52a23181cd3659a6464c1462883e86"
     "9f050b37d1cd8ec3d2eb835354af848bdfae53956082f4eb7b8eaa19c6643571"
     "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19"
     "def8decf1058d7f38b403ad6acf2e83469f186fbb62ad92280e42fc4aa8534a2"
     "5b86f933833c7987eda1be3a534e4dc84b89a1746117b631afbd3266bd7a8eed"
     "4aa639a41f19674bfa0f29d0389daca16e4962f9fcb8b8fd089038583ff34085"
     "c85a604d78d8f64cd555d11d58dad4ea14d7d97b5005afaa2ec0b73a7538f984"
     "fad9c3dbfd4a889499f6921f54f68de8857e6846a0398e89887dbe5f26b591c0"
     "d449d469fcfc44d5def5d076c2cfbc29389855fc537017b028583b8da7ed03df"
     "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58"
     "3a727bdc09a7a141e58925258b6e873c65ccf393b2240c51553098ca93957723" default))
 '(diary-file "~/org/diary")
 '(dictionary-proxy-port 80)
 '(dictionary-proxy-server "syd-devproxy1.devel.iress.com.au")
 '(dictionary-use-http-proxy t)
 '(dired-omit-files "^\\.[^.]+.*$")
 '(ecb-activation-selects-ecb-frame-if-already-active t)
 '(ecb-options-version "2.40")
 '(ecb-source-file-regexps
   '((".*"
      ("\\(^\\(\\.\\|#\\)\\|\\(~$\\|\\.\\(elc\\|obj\\|o\\|class\\|lib\\|dll\\|a\\|so\\|cache\\|pyc\\)$\\)\\)")
      ("^\\.\\(emacs\\|gnus\\)$"))))
 '(ecb-source-path '("~/devel/"))
 '(ecb-tree-indent 2)
 '(ecb-vc-enable-support nil)
 '(ediff-split-window-function 'split-window-right)
 '(erc-autojoin-channels-alist
   '((".*\\.freenode.net" "#emacs" "#python" "#archlinux") (".*\\.oftc.net" "#suckless")))
 '(erc-autojoin-mode t)
 '(erc-button-mode t)
 '(erc-fill-mode t)
 '(erc-hide-list '("JOIN" "NICK" "PART" "QUIT" "MODE"))
 '(erc-irccontrols-mode t)
 '(erc-list-mode t)
 '(erc-match-mode t)
 '(erc-menu-mode t)
 '(erc-move-to-prompt-mode t)
 '(erc-netsplit-mode t)
 '(erc-networks-mode t)
 '(erc-nick "jagguli")
 '(erc-noncommands-mode t)
 '(erc-pcomplete-mode t)
 '(erc-readonly-mode t)
 '(erc-ring-mode t)
 '(erc-stamp-mode t)
 '(erc-track-minor-mode t)
 '(erc-track-mode t)
 '(erc-track-position-in-mode-line t)
 '(evil-ex-hl-update-delay 0.1)
 '(evil-fold-level 1)
 '(evil-search-module 'evil-search)
 '(evil-undo-system 'undo-redo)
 '(evil-want-keybinding nil)
 '(fci-rule-character 9474)
 '(fci-rule-color "magenta")
 '(fci-rule-use-dashes t)
 '(ffap-machine-p-known 'reject)
 '(flycheck-check-syntax-automatically '(save mode-enabled))
 '(flycheck-checker-error-threshold 5000)
 '(flycheck-checkers
   '(coffee-coffeelint css-csslint elixir emacs-lisp emacs-lisp-checkdoc erlang go-gofmt
                       go-build go-test haml html-tidy javascript-jshint json-jsonlint lua
                       perl php php-phpcs puppet-parser puppet-lint python-flake8
                       python-pylint rst ruby-rubocop ruby ruby-jruby rust sass scala scss
                       sh-bash tex-chktex tex-lacheck xml-xmlstarlet))
 '(flycheck-idle-change-delay 5)
 '(foreground-color nil)
 '(fortune-dir "/usr/share/fortune/")
 '(gmm-tool-bar-style 'retro t)
 '(grep-command "ack --with-filename --nogroup --all")
 '(grep-highlight-matches 'auto)
 '(gud-pdb-command-name "python -d")
 '(helm-minibuffer-history-key "M-p")
 '(idle-highlight-idle-time 1.5)
 '(idle-update-delay 1.5)
 '(itail-fancy-mode-line t)
 '(itail-highlight-list
   '(("Error" . hi-red-b) ("GET\\|POST\\|DELETE\\|PUT" . hi-green-b)
     ("[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}"
      . font-lock-string-face)
     ("File \\\".*\\\"" . hi-red-b) ("^Traceback.*$" . hi-red-b)))
 '(jabber-account-list nil)
 '(jabber-alert-info-message-hooks '(jabber-info-tmux jabber-info-switch jabber-info-echo))
 '(jabber-alert-message-hooks
   '(jabber-message-notifications jabber-message-switch jabber-message-echo
                                  jabber-message-libnotify))
 '(jabber-alert-message-wave "~/.sounds/message-new-instant.wav")
 '(jabber-alert-muc-hooks
   '(jabber-muc-libnotify jabber-muc-echo jabber-muc-switch jabber-muc-display
                          jabber-muc-scroll))
 '(jabber-auto-reconnect t)
 '(jabber-autoaway-priority 0)
 '(jabber-autoaway-verbose t)
 '(jabber-autoaway-xa-priority 0)
 '(jabber-backlog-days 30)
 '(jabber-backlog-number 40)
 '(jabber-default-priority 300 t)
 '(jabber-default-show "chat" t)
 '(jabber-default-status "can I automate it ?" t)
 '(jabber-history-enable-rotation t)
 '(jabber-history-enabled t)
 '(jabber-history-muc-enabled t)
 '(jabber-keepalive-interval 30 t)
 '(jabber-mode-line-mode t)
 '(jabber-roster-line-format "%c %-25n %u %-8s  %S")
 '(jabber-show-offline-contacts t)
 '(jedi:install-python-jedi-dev-command
   '("pip2" "install" "--upgrade" "git+https://github.com/davidhalter/jedi.git@dev#egg=jedi"))
 '(js3-indent-level 4)
 '(lazy-highlight-cleanup nil)
 '(lazy-highlight-initial-delay 0)
 '(lazy-highlight-max-at-a-time nil)
 '(line-number-mode t)
 '(ls-lisp-dirs-first t)
 '(ls-lisp-verbosity 'nil)
 '(lsp-enable-snippet nil)
 '(magit-section-initial-visibility-alist '((untracked . hide)))
 '(mml-enable-flowed nil)
 '(mu4e-compose-signature "Sent with emacs - the one true editor.")
 '(newsticker-html-renderer 'w3m-region)
 '(newsticker-retrieval-method 'extern)
 '(newsticker-url-list
   '(("FastCompany" "http://www.fastcompany.com/rss.xml" nil nil nil)
     ("TheNextWeb" "http://feeds2.feedburner.com/thenextweb" nil nil nil)
     ("BoingBoing" "http://feeds.boingboing.net/boingboing/iBag" nil nil nil)
     ("TechRepublic" "http://www.techrepublic.com/search?t=1&o=1&mode=rss" nil nil nil)
     ("TechCrunch" "http://feeds.feedburner.com/TechCrunch/" nil nil nil)
     ("Archlinux" "https://www.archlinux.org/feeds/news/" nil nil nil)))
 '(notmuch-search-hook '(notmuch-hl-line-mode))
 '(notmuch-search-oldest-first nil)
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(notmuch-show-empty-saved-searches t)
 '(notmuch-show-indent-messages-width 2)
 '(notmuch-show-indent-multipart nil)
 '(notmuch-show-insert-text/plain-hook
   '(notmuch-wash-convert-inline-patch-to-part notmuch-wash-wrap-long-lines
                                               notmuch-wash-tidy-citations
                                               notmuch-wash-elide-blank-lines
                                               notmuch-wash-excerpt-citations))
 '(notmuch-show-only-matching-messages t)
 '(notmuch-show-part-button-default-action 'notmuch-show-view-part)
 '(notmuch-tree-show-out t)
 '(notmuch-wash-citation-lines-prefix 0)
 '(notmuch-wash-original-regexp "^\\(From: .*\\|.* writes:\\)$")
 '(notmuch-wash-wrap-lines-length 70)
 '(org-agenda-repeating-timestamp-show-all nil)
 '(org-agenda-skip-scheduled-if-deadline-is-shown 'repeated-after-deadline)
 '(org-html-checkbox-type 'html)
 '(paredit-mode nil t)
 '(password-cache-expiry nil)
 '(poetry-tracking-mode t)
 '(py-complete-function 'py-indent-or-complete)
 '(py-ffap-p 'py-ffap)
 '(recentf-auto-cleanup 300)
 '(recentf-exclude '("~/.cache" "~/\\..*cache"))
 '(recentf-max-menu-items 500)
 '(recentf-max-saved-items 500)
 '(recentf-mode t)
 '(repository-root-matchers '(repository-root-matcher/git repository-root-matcher/svn))
 '(req-package-log-level 'trace t)
 '(request-backend 'url-retrieve)
 '(ring-bell-function 'ignore)
 '(ropemacs-confirm-saving nil)
 '(ropemacs-global-prefix "C-x @")
 '(safe-local-variable-values
   '((eval load-file
           (expand-file-name "scripts/bop.el"
                             (locate-dominating-file buffer-file-name ".dir-locals.el")))
     (eval load-file
           (expand-file-name "scripts/publish.el"
                             (locate-dominating-file buffer-file-name ".dir-locals.el")))
     (eval load-file "./scripts/publish.el")
     (eval add-hook 'after-save-hook (lambda nil (org-babel-tangle)) nil t)
     (eval when
           (and (bound-and-true-p projectile-mode) (require 'projectile nil 'noerror))
           (setq projectile-enable-caching nil) (projectile-invalidate-cache))
     (eval progn (setq projectile-enable-caching nil) (projectile-invalidate-cache nil))))
 '(scroll-conservatively 10000)
 '(scroll-step 1)
 '(scss-compile-at-save nil)
 '(select-enable-clipboard nil)
 '(select-enable-primary nil)
 '(send-mail-function 'smtpmail-send-it)
 '(smtpmail-smtp-server "localhost")
 '(smtpmail-smtp-service 25)
 '(solarized-termcolors 256 t)
 '(split-height-threshold 200)
 '(split-width-threshold 155)
 '(split-window-keep-point nil)
 '(tab-width 4)
 '(tags-add-tables nil)
 '(tool-bar-mode nil)
 '(traad-debug t)
 '(traad-server-program nil)
 '(url-handler-mode nil)
 '(url-handler-regexp "\\`\\(\\(https?\\|ftp\\|file\\|nfs\\)://|File\\)")
 '(url-proxy-services nil)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#dc322f") (40 . "#cb4b16") (60 . "#b58900") (80 . "#859900") (100 . "#2aa198")
     (120 . "#268bd2") (140 . "#d33682") (160 . "#6c71c4") (180 . "#dc322f")
     (200 . "#cb4b16") (220 . "#b58900") (240 . "#859900") (260 . "#2aa198")
     (280 . "#268bd2") (300 . "#d33682") (320 . "#6c71c4") (340 . "#dc322f")
     (360 . "#cb4b16")))
 '(vc-annotate-very-old-color nil)
 '(visible-cursor nil)
 '(xclip-mode nil))



;;(custom-set-faces
;; ;; custom-set-faces was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(bmkp-local-file-without-region ((t (:foreground "green"))))
;; '(col-highlight ((t (:background "color-233"))))
;; '(column-marker-1 ((t (:background "color-232"))))
;; '(cscope-line-face ((t nil)))
;; '(cursor ((t (:background "light slate blue" :foreground "#888888"))))
;; '(diredp-date-time ((((type tty)) :foreground "yellow") (t :foreground "goldenrod1")))
;; '(diredp-dir-heading ((((type tty)) :background "yellow" :foreground "blue") (t :background "Pink" :foreground "DarkOrchid1")))
;; '(diredp-dir-priv ((t (:background "color-16" :foreground "color-51"))))
;; '(diredp-display-msg ((((type tty)) :foreground "blue") (t :foreground "cornflower blue")) t)
;; '(diredp-file-name ((t nil)))
;; '(diredp-file-suffix ((t nil)))
;; '(ediff-current-diff-A ((t (:background "color-17" :foreground "white"))))
;; '(ediff-current-diff-B ((t (:background "color-17" :foreground "white"))))
;; '(ediff-even-diff-A ((t (:background "color-237" :foreground "Black"))))
;; '(ediff-even-diff-B ((t (:background "color-239" :foreground "White"))))
;; '(ediff-odd-diff-A ((t (:background "color-239" :foreground "White"))))
;; '(ediff-odd-diff-B ((t (:background "color-239" :foreground "Black"))))
;; '(flycheck-error ((t (:background "color-89"))))
;; '(flycheck-warning ((t (:background "color-89"))))
;; '(flymake-error ((t (:background "color-124"))))
;; '(flymake-warning ((t (:background "color-161"))))
;; ;;'(hl-line ((t (:background "color-232" :weight bold))))
;; '(idle-highlight ((t (:background "color-17"))) t)
;; '(log-view-message ((t nil)))
;; '(magit-header ((t (:inherit header-line :background "white" :foreground "black"))) t)
;; '(match ((t (:background "color-22"))))
;; '(notmuch-message-summary-face ((t (:background "color-17"))))
;; '(notmuch-tag-face ((t (:foreground "color-19"))))
;; '(rst-level-1 ((t (:background "color-236"))))
;; '(trailing-whitespace ((t (:background "color-54" :foreground "color-54" :inverse-video t :underline nil :slant normal :weight normal))))
;; '(transient-mark-mode 1)
;; '(vertical-border ((t (:inherit mode-line-inactive :background "black" :foreground "grey" :weight thin :width condensed))))
;; ;'(vline ((t (:background "color-233"))))
;; ;'(vline-visual ((t (:background "color-234")))))
;; )


(require 'cl-lib)

(defun org-clocking-buffer (&rest _))
(defun rope-exiting-actions (&rest _))
;;(add-to-list 'load-path "~/.emacs.d/lisp/")
(defun emacs-log ()
  "Append *Messages* to ~/.emacs.d/messages.log with timestamp."
  (interactive)
  (let* ((log-buffer "*Messages*")
         (log-file "~/.emacs.d/messages.log"))
    (when (get-buffer log-buffer)
      (with-current-buffer log-buffer
        (write-region (point-min) (point-max) log-file t 'nomessage)))))

(defun kill-other-buffers ()
  "Kill all buffers except the current one."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun kill-all-buffers ()
  "Kill all open buffers."
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun kill-other-file-buffers ()
  "Kill all other file-visiting buffers."
  (interactive)
  (mapc 'kill-buffer 
        (delq (current-buffer)
              (remove-if-not 'buffer-file-name (buffer-list)))))

(defun edit-emacs-config ()
  "Quick access to config file."
  (interactive)
  (find-file "~/.emacs.d.jagguli/emacs.el"))

(defun gettags (filename)
  "Call external script to get tags."
  (interactive "fFile: ")
  (shell-command-to-string
   (format "/home/steven/bin/tagquery.py %s" filename)))

(defun command-line-diff (_switch)
  "Ediff two files from the command line."
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("diff" . command-line-diff))

(defun cocd/copy-region-to-clipboard (beg end)
  "Copy region to clipboard using xclip from TTY (st)."
  (interactive "r")
  (when (use-region-p)
    (let ((text (buffer-substring-no-properties beg end)))
      (kill-new text)
      (let ((process-connection-type nil))
        (start-process "xclip" nil "xclip" "-selection" "clipboard")
        (let ((proc (start-process "xclip" nil "xclip" "-selection" "clipboard")))
          (process-send-string proc text)
          (process-send-eof proc))))
    (message "📋 Copied to clipboard via xclip.")))


(global-set-key (kbd "C-c y") #'cocd/copy-region-to-clipboard)

(defun cocd/paste-from-clipboard ()
  "Paste text from the system clipboard into point. Handles GUI, xclip, and wl-paste."
  (interactive)
  (let ((text
         (cond
          ;; GUI Emacs — blessed by the X
          ((display-graphic-p)
           (gui-get-selection 'CLIPBOARD))

          ;; X11 — use xclip if available
          ((executable-find "xclip")
           (with-temp-buffer
             (call-process "xclip" nil t nil "-selection" "clipboard" "-o")
             (buffer-string)))

          ;; Wayland — use wl-paste if available
          ((executable-find "wl-paste")
           (with-temp-buffer
             (call-process "wl-paste" nil t)
             (buffer-string)))

          ;; Else, deny the request
          (t
           (message "⚠️ No clipboard reader found.")
           nil))))
    (when text
      (insert text)
      (message "📥 Pasted from clipboard."))))







(require 'cl-lib)
(require 'package)

;; Set up package repositories
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t))

(package-initialize)

(defun activated-packages ()
  "Display list of activated packages."
  (interactive)
  (message "%s" package-activated-list))

;; Define custom directories
(defconst user-lib-dir    (expand-file-name "modules.d/" user-emacs-directory))
(defconst user-themes-dir (expand-file-name "themes.d/" user-emacs-directory))
(defconst user-config-dir (expand-file-name "etc.d/" user-emacs-directory))

(setq custom-theme-directory user-themes-dir)
(show-paren-mode 1)

;; Associate file extensions with modes
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.wiki\\'" . mediawiki-mode))
(add-to-list 'auto-mode-alist '("\\.aes\\'" . sophia-mode))

;; Load preferred theme
(load-theme 'tango-2-steven t)

;; Load user-defined Elisp files with use-package
(use-package pymacs
  :load-path "modules.d/Pymacs"
  :commands pymacs-load)

(use-package vline
  :load-path "modules.d"
  :commands vline-mode)

(use-package col-highlight
  :load-path "modules.d"
  :commands col-highlight-mode)

(use-package hl-line+
  :load-path "modules.d"
  :commands global-hl-line-mode)
(use-package sophia-mode
  :load-path "modules.d")

;; Optional modules (uncomment as needed)
;; (use-package notmuch-pick :load-path "modules.d")
;; (add-to-list 'load-path (expand-file-name "buffer-timer" user-lib-dir))
(load-file  "~/.emacs.d/modules.d/crosshairs.el")
(use-package crosshairs
  :load-path "modules.d"
  :defer nil)  ;; evaluated immediately if it's config, not a package
;; You can include config files (not packages) from etc.d like this:
(use-package helm-my-config
  :load-path "etc.d"
  :defer nil)  ;; evaluated immediately if it's config, not a package

(use-package evil-config
  :load-path "etc.d"
  :defer nil)

(use-package evil-clip-config
  :load-path "etc.d"
  :defer nil)

;; Optionally load everything from a directory manually
;; (dolist (file (directory-files user-config-dir t "\\.el$"))
;;   (load file nil 'nomessage))
;; Load non-package config files from etc.d
(let ((user-config-dir (expand-file-name "etc.d/" user-emacs-directory)))
  (mapc #'load
        (directory-files user-config-dir 'full "\\.el$")))

(set-face-background 'region "#666")  ; gray highlight

(setq-default fill-column 90)
(use-package visual-fill-column
  :ensure t
  :hook (visual-line-mode . visual-fill-column-mode)
  :custom
  (visual-fill-column-width 80)
  (visual-fill-column-center-text nil))

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . markdown-mode)
  :hook
  (markdown-mode . visual-line-mode)  ;; triggers visual-fill-column via its own hook
  (markdown-mode . flyspell-mode))   ;; optional: spell check



(setq org-src-fontify-natively t
      org-src-tab-acts-natively t)

(use-package display-line-numbers
  :hook (prog-mode . display-line-numbers-mode)
  :custom
  (display-line-numbers-type t))
(global-display-line-numbers-mode 1)

(global-set-key [S-Left] 'tab-next)
  (define-key evil-normal-state-map [S-Left]  'tab-next)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Set OpenAI API Key (via pass)
(use-package chatgpt-shell
  :ensure t
  :init
  (setq chatgpt-shell-openai-key
        (password-store-get "emacs/openai-api-key")
        chatgpt-model "gpt-5.5"
        ))
;=======
(require 'cl-lib)
;(load-file "~/.emacs.d/emacs.el")
;(load-file "~/.emacs.d/modules.el")
;>>>>>>> 113afc538b4ccc3dd7df33b7cd42b271f916503a

;; Enable which-key for command discovery
(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode))

;; Markdown editing support
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

;; Save minibuffer history (M-x, searches, etc.)
(use-package savehist
  :ensure nil  ;; built-in
  :init
  (savehist-mode 1)
  :custom
  (savehist-additional-variables
   '(search-ring regexp-search-ring kill-ring))
  (savehist-file (expand-file-name "savehist" user-emacs-directory))
  (history-length 1000))
(use-package consult
  :ensure t
  :bind (("C-c f" . consult-fd))) ;; Or any key you prefer

(use-package flycheck
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-display-errors-function nil
        flycheck-erlang-include-path '("../include")
        flycheck-erlang-library-path '()
        flycheck-check-syntax-automatically '(save)))


