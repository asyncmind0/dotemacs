;;; flycheck-erlang-and-dialyzer.el --- sane Erlang + Dialyzer setup

(require 'flycheck)

;; ---------- General hooks ----------
(add-hook 'erlang-mode-hook #'flycheck-mode)
(add-hook 'js-mode-hook #'flycheck-mode)
(add-hook 'js-ts-mode-hook #'flycheck-mode) ;; tree-sitter JS
(add-hook 'yaml-mode-hook #'flycheck-mode) ;; tree-sitter JS

(setq flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled))

;; ---------- JS (your existing bits kept) ----------
(setq-default flycheck-javascript-eslint-executable "eslint")
(flycheck-add-mode 'javascript-eslint 'js-mode)
(flycheck-add-mode 'javascript-eslint 'js-ts-mode)

(with-eval-after-load 'flycheck
  (add-to-list 'flycheck-checkers 'erlang)
  (add-to-list 'flycheck-checkers 'yaml-yamllint)
  ;;(add-to-list 'flycheck-checkers 'erlang-rebar3)
  )
;; ---------- Helpers ----------
(defun steven/flycheck-erlang-project-root (_checker)
  "Find the project root for Erlang by locating rebar.config."
  (or (locate-dominating-file (or buffer-file-name default-directory)
                              "rebar.config")
      default-directory))

(defvar steven/flycheck-erlang-include-path
  '("include" "apps/*/include" "_build/default/lib/*/include")
  "Default include paths relative to project root for Dialyzer/erlc.")

(defvar steven/flycheck-erlang-library-path
  '("_build/default/lib")
  "Default library paths for erlc (rarely needed by Dialyzer).")

(defun steven/flycheck--expand-paths (paths)
  "Expand PATHS relative to the current Erlang project root."
  (let* ((root (steven/flycheck-erlang-project-root nil)))
    (mapcar (lambda (p) (expand-file-name p root)) paths)))

(defun steven/flycheck-dialyzer-plt ()
  "Resolve the PLT path for Dialyzer."
  (or (getenv "DIALYZER_PLT")
      (expand-file-name "~/.cache/erlang/dialyzer_plt")))

(add-hook 'erlang-mode-hook (lambda ()
  (when (projectile-project-p) ; Check if within a project managed by Projectile
    (let* ((root (projectile-project-root))
           (include-dir (expand-file-name "include" root))
           (build-include-dir (expand-file-name "_build/default/lib/damage/include" root))) ; Adjust as necessary
      (setq-local flycheck-erlang-include-path (list include-dir build-include-dir))))))
;; ---------- Checkers ----------
;; 1) rebar3 compile (fast feedback)
;;(flycheck-define-checker erlang-rebar3
;;  "Erlang syntax checker using rebar3 compile."
;;  :command ("rebar3" "compile")
;;  :error-patterns
;;  ((error line-start (file-name) ":" line ": " (message) line-end))
;;  :modes erlang-mode
;;  :working-directory steven/flycheck-erlang-project-root)
;;
;;;; 2) raw erlc (optional, but handy outside rebar)
;;(flycheck-define-checker erlang-erlc
;;  "Erlang syntax checker using erlc."
;;  :command ("erlc"
;;            (option-list "-I" (eval (steven/flycheck--expand-paths
;;                                     steven/flycheck-erlang-include-path)))
;;            "-o" temporary-directory
;;            source)
;;  :error-patterns
;;  ((error line-start (file-name) ":" line ":" (message) line-end))
;;  :modes erlang-mode
;;  :working-directory steven/flycheck-erlang-project-root)
;;
;;;; 3) Dialyzer (the good stuff)
;;(flycheck-define-checker erlang-dialyzer
;;  "Erlang static analysis via dialyzer on the current source."
;;  :command ("dialyzer"
;;            "--plt" (eval (steven/flycheck-dialyzer-plt))
;;            "--fullpath"
;;            (option-list "-I" (eval (steven/flycheck--expand-paths
;;                                     steven/flycheck-erlang-include-path)))
;;            "--src" source-original)
;;  ;; Dialyzer typically emits warnings; surface them as Flycheck warnings.
;;  :error-patterns
;;  ((warning line-start (file-name) ":" line ": " (message) line-end))
;;  :modes erlang-mode
;;  :working-directory steven/flycheck-erlang-project-root)
;;
;;;; Register checkers
;;(add-to-list 'flycheck-checkers 'erlang-rebar3 t)
;;(add-to-list 'flycheck-checkers 'erlang-erlc t)
;;(add-to-list 'flycheck-checkers 'erlang-dialyzer t)
;;
;;;; Chain them: rebar3 → dialyzer (skip erlc unless you want it in between)
;;(flycheck-add-next-checker 'erlang-rebar3 'erlang-dialyzer)
;;;; If you prefer: rebar3 → erlc → dialyzer, also add:
;;;; (flycheck-add-next-checker 'erlang-rebar3 'erlang-erlc)
;;;; (flycheck-add-next-checker 'erlang-erlc 'erlang-dialyzer)
;;
;;(provide 'flycheck-erlang-and-dialyzer)
;;;;; flycheck-erlang-and-dialyzer.el ends here
;;
