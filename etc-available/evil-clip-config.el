;;; evil-clip-config.el --- Evil-mode clipboard bypass operator bindings

(use-package evil
  :after (evil)  ;; Ensure evil is loaded
  :init
  ;; Utility macros to temporarily disable Evil
  (defmacro evil-mode? ()
    "Return the current evil state (non-nil if Evil is active)."
    `evil-state)

  (defmacro disable-evil-mode ()
    "Temporarily disable Evil with message."
    `(progn
       (evil-mode 0)
       (message "Evil mode disabled")))

  (defmacro enable-evil-mode ()
    "Re-enable Evil with message."
    `(progn
       (evil-mode 1)
       (message "Evil mode enabled")))

  (defmacro without-evil-mode (&rest body)
    "Temporarily disable Evil to run BODY without Evil interference."
    `(let ((evil-mode-was-on (evil-mode?)))
       (when evil-mode-was-on (disable-evil-mode))
       (ignore-errors ,@body)
       (when evil-mode-was-on (enable-evil-mode))))

  ;; Clipboard-safe delete operators
  (evil-define-operator evil-destroy-char (beg end type register yank-handler)
    "Delete character without yanking to clipboard."
    :motion evil-forward-char
    (evil-delete-char beg end type ?_))

  (evil-define-operator evil-destroy-backward-char (beg end type register yank-handler)
    "Delete backward character without yanking to clipboard."
    :motion evil-forward-char
    (evil-delete-backward-char beg end type ?_))

  (evil-define-operator evil-destroy (beg end type register yank-handler)
    "Delete text object without yanking."
    (evil-delete beg end type ?_ yank-handler))

  (evil-define-operator evil-destroy-line (beg end type register yank-handler)
    "Delete to end of line without clipboard."
    :motion nil
    :keep-visual t
    (interactive "<R><x>")
    (evil-delete-line beg end type ?_ yank-handler))

  (evil-define-operator evil-destroy-whole-line (beg end type register yank-handler)
    "Delete entire line without affecting clipboard."
    :motion evil-line
    (interactive "<R><x>")
    (evil-delete-whole-line beg end type ?_ yank-handler))

  (evil-define-operator evil-destroy-change (beg end type register yank-handler delete-func)
    "Change text without yanking deleted content."
    (evil-change beg end type ?_ yank-handler delete-func))

  ;; Smart paste functions that avoid evil interference
  (defun evil-destroy-paste-before ()
    "Paste before, bypassing clipboard."
    (interactive)
    (without-evil-mode
     (delete-region (point) (mark))
     (evil-paste-before 1)))

  (defun evil-destroy-paste-after ()
    "Paste after, bypassing clipboard."
    (interactive)
    (without-evil-mode
     (delete-region (point) (mark))
     (evil-paste-after 1)))

  (evil-define-operator evil-destroy-replace (beg end type register yank-handler)
    "Replace with yank buffer, without copying deleted region."
    (evil-destroy beg end type register yank-handler)
    (evil-paste-before 1 register))

  ;; Rebind default operators in Evil normal mode
  :config
  (define-key evil-normal-state-map (kbd "s") 'evil-destroy)
  (define-key evil-normal-state-map (kbd "S") 'evil-destroy-line)
  (define-key evil-normal-state-map (kbd "c") 'evil-destroy-change)
  (define-key evil-normal-state-map (kbd "x") 'evil-destroy-char)
  (define-key evil-normal-state-map (kbd "X") 'evil-destroy-whole-line))
