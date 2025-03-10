;; My miscellaneous functions
(req-package chatgpt-shell
  :ensure t
  :init (setq
  chatgpt-shell-openai-key
   (password-store-get "emacs/openai-api-key"))
   )
(req-package which-key
  :init(progn
         (which-key-mode)))
(req-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(req-package fill-column-indicator
  :config (setq fci-rule-column 80)
  :init(progn
         (fci-mode)
         (blink-cursor-mode 0)
    )
  :require (
            powerline
            powerline-evil
            format-all
            google-this
            yaml-mode
            feature-mode
            ;;origami
            findr
            erlang
            )
  :config
  (progn
    (fci-mode t)
   (global-auto-revert-mode t)
   ;;(global-origami-mode)
    (format-all-mode)

        ))

(defun emacs-log ()
  (interactive)
  (let* ((log-buffer-name  "*Messages*")
         (log-buffer (get-buffer log-buffer-name))
         (log-file-name "~/.emacs.d/messages.log")
         (log-str (concat
                   (current-time-string)
                   " -- "
                   "\n")))
    (save-excursion
      (with-current-buffer log-buffer
      ;;  (goto-char (point-max))
      ;;  (insert log-str))
        (write-region (point-min) (point-max) log-file-name t
                      'nomessage nil nil)))))
(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defalias 'my-kill-other-buffers 'kill-other-buffers)

(defun kill-all-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer (buffer-list)))

(defun kill-other-file-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer 
          (delq (current-buffer) 
                (remove-if-not 'buffer-file-name (buffer-list)))))

(defun edit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d.jagguli/emacs.el"))

(defun gettags (filename)
  (interactive)
  (shell-command-to-string
   (format "/home/steven/bin/tagquery.py %s" filename)))

;;======= command line  =======
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("diff" . command-line-diff))

;; Usage: emacs -diff file1 file2

(defun xclip-insert ()
  (interactive)
  (insert (shell-command-to-string
      "nohup xclip -o")))
(defun xclip-copy (&optional b e)
  (interactive "r")
  (shell-command-on-region b e
      "nohup xclip -i > /dev/null 2>&1"))
  ;"echo nowitworks | nohup xclip -selection clipboard ") 
;(setq org-agenda-include-diary t)
;(pop-to-buffer (get-buffer-create (generate-new-buffer-name "*scratch-org*")))
;(insert "Scratch buffer with org-mode.\n\n")
;(org-mode)

(defun filename-to-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (setq lineno  (what-line))
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (insert ":")
        (insert lineno)
        (shell-command-on-region (point-min) (point-max) "xclip -i"))
      (message filename))))
(defalias 'my-filename-to-clipboard 'filename-to-clipboard)

(defun gitblt-filename-to-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  ;;(setq lineno  (what-line))
  (let (
        (filename (file-relative-name (if (equal major-mode 'dired-mode)
                                          default-directory
                                        (buffer-file-name)) (repository-root)))
    (when filename
      (with-temp-buffer
        (insert (format 
                 "https://sydxplansvn.devel.iress.com.au/gerrit/plugins/gitblit/blob/?f=%s&r=%s.git&h=%s#L%s"
                 filename
                 (file-name-nondirectory filename)
                 (s-trim (vc-git--run-command-string (buffer-file-name) "symbolic-ref" "--short" "-q" "HEAD"))
                 (what-line)
                 ))
        (shell-command-on-region (point-min) (point-max) "xsel -i"))
      (message filename)))))


(defun check-debug (&optional buffer)
  (interactive)
  (if buffer (set-buffer buffer) (set-buffer (current-buffer)))
  (goto-char (point-min))
  (assert (= 0 (search-forward "sj_debug"))))

(add-hook 'vc-before-checkin-hook 
          #'(lambda ()
              (check-debug vc-parent-buffer)
              ))

(defun search-all-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

(global-set-key (kbd "M-s /") 'search-all-buffers)
(eval-after-load 'tramp '(setenv "SHELL" "/bin/sh"))

(defun guess-where-keybinding-is-defined (key)
  "try to guess where a key binding might be defined"
  (interactive (list (read-key-sequence "Describe key: ")))
  (let ((bindings (minor-mode-key-binding key))
        found)
    (while (and bindings (not found))
      (if (setq found (caar bindings))
          (find-function (cdar bindings)))
      (setq bindings (cdr bindings)))))

(defun reset-font ()
  (interactive)
  (global-font-lock-mode nil)
  (font-lock-fontify-buffer)
  (global-font-lock-mode t)
  (recenter-top-bottom))
(global-set-key (kbd "C-l") 'reset-font)

(defun browse-url-webmacs (url &optional new-window)
  "Ask the Chromium WWW browser to load URL.
Default to the URL around or before point.  The strings in
variable `browse-url-chromium-arguments' are also passed to
Chromium."
  (interactive (browse-url-interactive-arg "URL: "))
  (message "opening webmacs %s" url)
  (setq url (browse-url-encode-url url))
  (let* ((process-environment (browse-url-process-environment)))
    (apply 'start-process
	   (concat (expand-file-name "~/.bin/browser") url) nil
	   (expand-file-name "~/.bin/browser")
	   (append
	    browse-url-chromium-arguments
	    (list url)))))
(defun browse-url-can-use-xdg-open ()
  "Return non-nil if the \"xdg-open\" program can be used.
xdg-open is a desktop utility that calls your preferred web browser.
This requires you to be running either Gnome, KDE, Xfce4 or LXDE."
  (and (getenv "DISPLAY")
       (executable-find "xdg-open")
       ;; xdg-open may call gnome-open and that does not wait for its child
       ;; to finish.  This child may then be killed when the parent dies.
       ;; Use nohup to work around.  See bug#7166, bug#8917, bug#9779 and
       ;; http://lists.gnu.org/archive/html/emacs-devel/2009-07/msg00279.html
       (executable-find "nohup")
       ))
(setq browse-url-browser-function 'browse-url-webmacs)

(defadvice replace-highlight 
  (before outline-expand-replace 
          (match-beg match-end range-beg range-end
                     search-string regexp-flag delimited-flag
                     case-fold-search backward))

  (condition-case nil 
      (save-excursion
        (outline-back-to-heading)
        (show-subtree))
    (error nil))
)

(ad-activate 'replace-highlight)

(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files
    http://blog.plover.com/prog/revert-all.html"
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (when (and (buffer-file-name buffer) 
                 (not (buffer-modified-p buffer)))
        (set-buffer buffer)
        (revert-buffer t t t))
      (setq list (cdr list))
      (setq buffer (car list))))
  (message "Refreshed open files"))

(defun my-insertion-filter (proc string)
  (when (buffer-live-p (process-buffer proc))
    (with-current-buffer (process-buffer proc)
      ;; Insert the text, advancing the process marker.
      (goto-char (process-mark proc))
      (insert string)
      (set-marker (process-mark proc) (point)))))

 (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;(add-to-list ‘comint-output-filter-functions ‘ansi-color-process-output)
(require 'shell)
(defun my-mongo-tail ()
  (interactive)
  (let ((output (get-buffer-create "*Mongotail Output*"))
        (default-directory (expand-file-name "~/iress/xplan/"))
        ;;(major-mode shell-mode)
        )
    ;;(set-buffer-major-mode output 
    (set-process-filter 
     (start-process 
      "mongotail" output "python" "scripts/mongotail.py" "-L" "DEBUG" "xplan.serverlog")
     'my-insertion-filter)
    (switch-to-buffer output)
    (ansi-term)
    (compilation-minor-mode 1)
))

(defun delete-terminal-tmux-rename (term)
              (shell-command "tmux rename-window zsh"))

(add-hook 'delete-terminal-functions 'delete-terminal-tmux-rename)

;; emacs doesn't actually save undo history with revert-buffer
;; see http://lists.gnu.org/archive/html/bug-gnu-emacs/2011-04/msg00151.html
;; fix that.
;; http://stackoverflow.com/questions/4924389/is-there-a-way-to-retain-the-undo-list-in-emacs-after-reverting-a-buffer-from-fi
(defun revert-buffer-keep-history (&optional IGNORE-AUTO NOCONFIRM PRESERVE-MODES)
  (interactive)

  ;; tell Emacs the modtime is fine, so we can edit the buffer
  (clear-visited-file-modtime)

  ;; insert the current contents of the file on disk
  (widen)
  (delete-region (point-min) (point-max))
  (insert-file-contents (buffer-file-name))

  ;; mark the buffer as not modified
  (not-modified)
  (set-visited-file-modtime))

(setq revert-buffer-function 'revert-buffer-keep-history)

(defun load-config ()
    (interactive)
    (eval-buffer (helm-find-files-1 (expand-file-name "~/.emacs.d/etc/"))))

;;http://emacsredux.com/blog/2013/04/21/edit-files-as-root/
(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


;; 2015-07-04 bug of pasting in emacs.
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737#17
;; http://ergoemacs.org/misc/emacs_bug_cant_paste_2015.html
;;http://ergoemacs.org/misc/emacs_bug_cant_paste_2015.html
(setq x-selection-timeout 300)

(defun dos2unix (buffer)
      "Automate M-% C-q C-m RET C-q C-j RET"
      (interactive "*b")
      (save-excursion
        (goto-char (point-min))
        (while (search-forward (string ?\C-m) nil t)
          (replace-match (string ?\C-j) nil t))))

(defvar gdocs-folder-id "0B_rnOKn_aQhKSDRmUTF5bzhmbVk"
  "location for storing org to gdocs exported files, use 'gdrive list  -t <foldername>' to find the id")

(defun gdoc-export-buffer ()
  "Export current buffer as google doc to folder irentified by gdocs-folder-id"
  (interactive)
  (shell-command
   (format "gdrive upload --convert --mimetype text/plain --parent %s --file %s"
           gdocs-folder-id buffer-file-name)))

(defun gdoc-import-buffer (doc)
  "Import a file in gdocs-folder-id into current buffer"
  (interactive
   (list
    (completing-read "Choose one: "
                     (split-string
                      (shell-command-to-string
                       (format "gdrive list -q \"'%s' in parents\"" gdocs-folder-id)) "\n"))))
  (insert (replace-regexp-in-string (string ?\C-m) (string ?\C-j) (shell-command-to-string
                                                                   (format "gdrive download -s --format txt --id %s" (car (split-string doc " ")))))))

(defun split-tmux ()
  (interactive)
  (shell-command
   (format "tmux split-window -c '%s'" default-directory)))


(defun joaot/delete-process-at-point ()
  ;;http://stackoverflow.com/questions/10627289/emacs-internal-process-killing-any-command
  (interactive)
  (let ((process (get-text-property (point) 'tabulated-list-id)))
    (cond ((and process
                (processp process))
           (delete-process process)
           (revert-buffer))
          (t
           (error "no process at point!")))))

(define-key process-menu-mode-map (kbd "C-k") 'joaot/delete-process-at-point)
(defun now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%A, %B %e %Y, %H:%M")))

(defun today ()
  "Insert string for today's date nicely formatted in American style,
 Sunday, September 17, 2000."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%A, %B %e %Y")))

(define-key process-menu-mode-map (kbd "C-k") 'joaot/delete-process-at-point)

(defun joaot/delete-process-at-point ()
  (interactive)
  (let ((process (get-text-property (point) 'tabulated-list-id)))
    (cond ((and process
                (processp process))
           (delete-process process)
           (revert-buffer))
          (t
           (error "no process at point!")))))
;; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
;; https://www.emacswiki.org/emacs/InteractiveSpell#h5o-15
(setq ispell-program-name "hunspell")
(setq ispell-local-dictionary "en_US")
(setq ispell-local-dictionary-alist
      '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil nil nil utf-8)))

(defun dired-do-ispell (&optional arg)
  (interactive "P")
  (dolist (file (dired-get-marked-files
                 nil arg
                 #'(lambda (f)
                     (not (file-directory-p f)))))
    (save-window-excursion
      (with-current-buffer (find-file file)
        (ispell-buffer)))
    (message nil)))
(defun my-first-helm-command ()
  (interactive)
  (helm :sources 'my-source
        :buffer "*helm my command*"))
(use-package yaml-mode
  :ensure t
  :mode (".yaml$")
  :hook
  (yaml-mode . yaml-mode-outline-hook)

  :init
  (defun yaml-outline-level ()
    "Return the outline level based on the indentation, hardcoded at 2 spaces."
    (s-count-matches "[ ]\\{2\\}" (match-string 0)))

  (defun yaml-mode-outline-hook ()
    (outline-minor-mode)
    (setq outline-regexp "^\\([ ]\\{2\\}\\)*\\([-] \\)?\\([\"][^\"]*[\"]\\|[a-zA-Z0-9_-]*\\): *\\([>|]\\|&[a-zA-Z0-9_-]*\\)?$")
    (setq outline-level 'yaml-outline-level))
  )

(defun my-disable-flycheck-mode-in-scratch-buffer ()
  "Disable flycheck-mode in the scratch buffer."
  (when (string= (buffer-name) "*scratch*")
    (flycheck-mode -1)))

(add-hook 'emacs-lisp-mode-hook #'my-disable-flycheck-mode-in-scratch-buffer)
(autoload 'html-fold-mode "html-fold" "Minor mode for hiding and revealing elements." t)
(add-hook 'html-mode-hook
 (lambda ()
 (define-key html-mode-map (kbd "<M-left>") 'sgml-skip-tag-backward)
 (define-key html-mode-map (kbd "<M-right>") 'sgml-skip-tag-forward)
 )
)
