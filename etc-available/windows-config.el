;;; windows-config.el --- Custom window management configuration

(use-package windmove
  :ensure t
  :init
  ;; Enable directional window movement using Ctrl + arrow keys
  (windmove-default-keybindings 'control)

  ;; Customize vertical window border appearance
  (set-face-inverse-video-p 'vertical-border nil)
  (set-face-background 'vertical-border (face-background 'default))
  (set-display-table-slot standard-display-table
                          'vertical-border
                          (make-glyph-code ?│))

  ;; Custom split behavior: auto switch to previous buffer
  (defun sacha/vsplit-last-buffer (prefix)
    "Split window vertically and switch to previous buffer."
    (interactive "P")
    (split-window-vertically)
    (other-window 1)
    (unless prefix (switch-to-next-buffer)))

  (defun sacha/hsplit-last-buffer (prefix)
    "Split window horizontally and switch to previous buffer."
    (interactive "P")
    (split-window-horizontally)
    (other-window 1)
    (unless prefix (switch-to-next-buffer)))

  ;; Override default split bindings with custom ones
  :bind (("C-x 2" . sacha/vsplit-last-buffer)
         ("C-x 3" . sacha/hsplit-last-buffer)))
