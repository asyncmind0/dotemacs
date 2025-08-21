;;; org-publish.el --- Website publishing configuration using Org-mode

;;; Utilities
(defun org-sitemap-date-entry-format (entry style project)
  "Custom sitemap format with dates."
  (let ((title (org-publish-find-title entry project)))
    (if (string-empty-p title)
        (format "*%s*" entry)
      (format "{{{timestamp(%s)}}} [[file:%s][%s]]"
              (format-time-string "%Y-%m-%d"
                                  (org-publish-find-date entry project))
              entry
              title))))

;;; HTML templates for stevenjoseph.in
(defvar stevenjoseph-html-head "<div class='head'></div>")
(defvar stevenjoseph-html-preamble
  "<div class='preamble'>
     <div class='columns'>
       <h1>Steven's Web Logs</h1>
     </div>
   </div>")
(defvar stevenjoseph-html-postamble
  "<div class='footer'>
     Copyright 2024 %a (%v HTML).<br>
     Last updated %C.<br>
     Built with %c.
   </div>")

;;; HTML templates for asyncmind.xyz
(defvar asyncmind-html-head "<div class='head'></div>")
(defvar asyncmind-html-preamble
  "<div class='preamble'>
     <div class='columns'></div>
   </div>")
(defvar asyncmind-html-postamble
  "<div class='footer'>
     Copyright 2024 %a (%v HTML).<br>
     Last updated %C.<br>
     Built with %c.
   </div>")

;;; Org-mode and Publishing
(use-package org
  :ensure t
  :config
  (setq org-confirm-babel-evaluate nil
        org-html-checkbox-type 'html)

  (setq org-publish-project-alist
        `(
          ;; StevenJoseph main content
          ("stevenjoseph" :components ("stevenjoseph.blog" "stevenjoseph.blog.static"))

          ("stevenjoseph.blog"
           :base-directory "~/Org/blog/"
           :base-extension "org"
           :publishing-directory "/var/www/stevenjoseph.in/"
           :recursive t
           :publishing-function org-html-publish-to-html
           :auto-preamble t
           :auto-sitemap nil
           :auto-index nil
           :sitemap-title "Steven's Blog"
           :sitemap-filename "sitemap.org"
           :sitemap-sort-files anti-chronologically
           :html-head ,stevenjoseph-html-head
           :html-preamble ,stevenjoseph-html-preamble
           :html-postamble ,stevenjoseph-html-postamble)

          ("stevenjoseph.blog.static"
           :base-directory "~/Org/blog/assets/"
           :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|ttf\\|map\\|svg"
           :publishing-directory "/var/www/stevenjoseph.in/assets/"
           :recursive t
           :publishing-function org-publish-attachment)
          ;; Asyncmind main content
          ("asyncmind" :components ("asyncmind.blog" "asyncmind.blog.static"))

          ;; Asyncmind content
          ("asyncmind.blog"
           :base-directory "~/Org/asyncmind/"
           :base-extension "org"
           :publishing-directory "/var/www/asyncmind.xyz/"
           :recursive t
           :publishing-function org-html-publish-to-html
           :auto-preamble t
           :auto-sitemap nil
           :auto-index nil
           :html-head ,asyncmind-html-head
           :html-preamble ,asyncmind-html-preamble
           :html-postamble ,asyncmind-html-postamble)

          ("asyncmind.blog.static"
           :base-directory "~/Org/asyncmind/assets/"
           :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|ttf\\|map\\|svg"
           :publishing-directory "/var/www/asyncmind.xyz/assets/"
           :recursive t
           :publishing-function org-publish-attachment)
          )))
