;;; web-mode-config.el --- Web / JS / CSS / HTML / Mustache indentation -*- lexical-binding: t; -*-

;;; Commentary:
;; Combined web-mode configuration for:
;; - HTML
;; - CSS
;; - JavaScript
;; - JSX / TSX
;; - Vue
;; - Mustache
;; - Handlebars
;; - Optional Prettier formatting
;;
;; Load from init.el with:
;;
;;   (require 'web-mode-config)

;;; Code:

(require 'req-package)

;; ------------------------------------------------------------
;; Global indentation defaults
;; ------------------------------------------------------------

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; JavaScript
(setq js-indent-level 2)

;; CSS
(setq css-indent-offset 2)

;; HTML / SGML
(setq sgml-basic-offset 2)

;; ------------------------------------------------------------
;; Optional tree-sitter remaps, guarded for Emacs 29+
;; ------------------------------------------------------------

(when (and (fboundp 'treesit-available-p)
           (treesit-available-p))
  (setq major-mode-remap-alist
        (append
         '((javascript-mode . js-ts-mode)
           (js-mode         . js-ts-mode)
           (css-mode        . css-ts-mode))
         major-mode-remap-alist)))

;; ------------------------------------------------------------
;; web-mode
;; ------------------------------------------------------------

(req-package web-mode
  :ensure t

  :mode
  (("\\.html?\\'"      . web-mode)
   ("\\.xhtml\\'"      . web-mode)
   ("\\.phtml\\'"      . web-mode)
   ("\\.ctp\\'"        . web-mode)
   ("\\.php\\'"        . web-mode)
   ("\\.php4\\'"       . web-mode)
   ("\\.php5\\'"       . web-mode)

   ("\\.ejs\\'"        . web-mode)
   ("\\.erb\\'"        . web-mode)

   ("\\.jsx\\'"        . web-mode)
   ("\\.tsx\\'"        . web-mode)
   ("\\.vue\\'"        . web-mode)

   ("\\.mustache\\'"   . web-mode)
   ("\\.mst\\'"        . web-mode)
   ("\\.hbs\\'"        . web-mode)
   ("\\.handlebars\\'" . web-mode))

  :config
  ;; Main indentation
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)

  ;; Keep script/style blocks tight
  (setq web-mode-script-padding 0)
  (setq web-mode-style-padding 0)

  ;; Attribute formatting
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-enable-auto-indentation t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t)

  ;; Template engines
  (setq web-mode-engines-alist
        '(("mustache"   . "\\.mustache\\'")
          ("mustache"   . "\\.mst\\'")
          ("handlebars" . "\\.hbs\\'")
          ("handlebars" . "\\.handlebars\\'")
          ("php"        . "\\.phtml\\'")
          ("php"        . "\\.php\\'")
          ("php"        . "\\.php4\\'")
          ("php"        . "\\.php5\\'"))))

;; ------------------------------------------------------------
;; Legacy multi-web support
;;
;; web-mode handles mixed HTML/CSS/JS better than multi-web in most
;; cases, but this keeps your old multi-web setup available.
;; ------------------------------------------------------------

(req-package multi-web
  :ensure t
  :require (haml-mode)
  :config
  (setq mweb-default-major-mode 'html-mode)

  (setq mweb-tags
        '((php-mode
           "<\\?php\\|<\\? \\|<\\?="
           "\\?>")

          (js-mode
           "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>"
           "</script>")

          (css-mode
           "<style +type=\"text/css\"[^>]*>"
           "</style>")))

  (setq mweb-filename-extensions
        '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))

  ;; Enable only if you still open some files in html-mode.
  ;; web-mode users usually do not need this.
  ;; (multi-web-global-mode 1)
  )

;; ------------------------------------------------------------
;; Manual buffer indentation
;; ------------------------------------------------------------

(defun damage/indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun damage/web-buffer-p ()
  "Return non-nil when current buffer is a frontend/web buffer."
  (derived-mode-p
   'js-mode
   'js-ts-mode
   'css-mode
   'css-ts-mode
   'html-mode
   'mhtml-mode
   'web-mode))

(defun damage/indent-web-buffer-before-save ()
  "Auto-indent JS, CSS, HTML, Mustache, and Handlebars buffers before saving."
  (when (and (damage/web-buffer-p)
             ;; Avoid fighting Prettier when prettier-js-mode is active.
             (not (and (boundp 'prettier-js-mode)
                       prettier-js-mode)))
    (damage/indent-buffer)))

(add-hook 'before-save-hook #'damage/indent-web-buffer-before-save)

;; ------------------------------------------------------------
;; Optional Prettier support
;;
;; Install with:
;;
;;   npm install -g prettier
;;
;; Prettier is better than raw Emacs indentation for JSX, TSX, Vue,
;; ugly HTML, and mixed template files.
;; ------------------------------------------------------------

(req-package prettier-js
  :ensure t
  :hook
  ((js-mode      . prettier-js-mode)
   (js-ts-mode   . prettier-js-mode)
   (css-mode     . prettier-js-mode)
   (css-ts-mode  . prettier-js-mode)
   (web-mode     . prettier-js-mode)))

(provide 'web-mode-config)

;;; web-mode-config.el ends here
