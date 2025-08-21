;;; hydra-config.el --- Hydra keybindings and setup

;; Reference: http://oremacs.com/2015/01/20/introducing-hydra/

(use-package hydra
  :ensure t
  :bind
  ("C-M-m" . major-mode-hydra) ;; Entry point to major-mode hydras
  :init
  ;; Define a custom hydra for Magit operations
  (defhydra hydra-magit (:color blue :columns 8)
    "Magit"
    ("c" magit-status        "status")
    ("C" magit-checkout      "checkout")
    ("v" magit-branch-manager "branch manager")
    ("m" magit-merge         "merge")
    ("l" magit-log           "log")
    ("!" magit-git-command   "command")
    ("$" magit-process       "process"))

  ;; Bind it globally to C-c g
  (global-set-key (kbd "C-c g") #'hydra-magit/body))

;; Optional: Load additional hydra extensions
(use-package major-mode-hydra
  :ensure t)
