;;; sophia-mode.el --- sample major mode for editing sophia smart contracts. -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright © 2022, by Steven Joseph

;; Author: Steven Joseph (steven@stevenjoseph.in)
;; Version: 0.0.1
;; Created: 26 Jun 2022
;; Keywords: languages
;; Homepage: http://ergoemacs.org/emacs/elisp_syntax_coloring.html

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the GNU General Public License version 2.

;;; Commentary:

;; short description here

;; full doc on how to use here

;;; Code:

;; create the list for font-lock.
;; each category of keyword is given a particular face
(setq sophia-font-lock-keywords
      (let* (
            ;; define several category of keywords
            (x-keywords '("include" "stateful" "entrypoint" "default" "do" "else" "elif" "for" "if" "let" "switch" "function" "payable"))
            (x-types '("record" "float" "int" "contract" "list" "rotation" "string" "vector" "hash" "address" "map" "bool" "option"))
            (x-constants '("compiler" "AGENT" "ALL_SIDES" "ATTACH_BACK"))
            (x-events '("at_rot_target" "at_target" "attach" "public" "private"))
            (x-functions '("llAbs" "llAcos" "llAddToLandBanList" "llAddToLandPassList"))

            ;; generate regex string for each category of keywords
            (x-keywords-regexp (regexp-opt x-keywords 'words))
            (x-types-regexp (regexp-opt x-types 'words))
            (x-constants-regexp (regexp-opt x-constants 'words))
            (x-events-regexp (regexp-opt x-events 'words))
            (x-functions-regexp (regexp-opt x-functions 'words)))

        `(
          (,x-types-regexp . 'font-lock-type-face)
          (,x-constants-regexp . 'font-lock-constant-face)
          (,x-events-regexp . 'font-lock-builtin-face)
          (,x-functions-regexp . 'font-lock-function-name-face)
          (,x-keywords-regexp . 'font-lock-keyword-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))

;;;###autoload
(define-derived-mode sophia-mode c-mode "sophia mode"
  "Major mode for editing Sophia Smart Contract Language)"


  ;; code for syntax highlighting
  (setq
   font-lock-defaults '((sophia-font-lock-keywords))
    indent-tabs-mode nil;; use spaces instead of tabs
    tab-width 2 ;; set the indentation width to 2 spaces
    )
  )

;; add the mode to the `features' list
(provide 'sophia-mode)

;; define the function to enable sophia-mode when file extension is .aes
(defun enable-sophia-mode ()
  (when (string= (file-name-extension buffer-file-name) "aes")
    (sophia-mode)))

;; add the hook to enable sophia-mode for files with .aes extension
(add-hook 'find-file-hook 'enable-sophia-mode)



;;; sophia-mode.el ends here
