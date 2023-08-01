;; Basic config stuff

(setq inhibit-startup-screen t) ;; Inhibit Startup Screen

(menu-bar-mode -1) ;; Disable Menu bar
(tool-bar-mode -1) ;; Disable tool bar
(setq visible-bell t) ;; Flash instead of ping

(column-number-mode t) ;; Global colum-number-mode
(global-display-line-numbers-mode t) ;;Display line numbers

(dolist (mode '(org-mode-hook ;;Don't display line numbers
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-number-mode 0))))

;; Move customazation variables to a seperate file and load it
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;;Keep files and other buffers upto date
(setq global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;;Backups
(setq backup-directory  "c:/Users/Lalo/AppData/Roaming/.emacs.d/backups")
(setq backup-directory-alist  `(("." . ,backup-directory)))

;; Elpaca Package Manager

;; Bootstrap Elpaca
(defvar elpaca-installer-version 0.4)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil
                              :files (:defaults (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (call-process "git" nil buffer t "clone"
                                       (plist-get order :repo) repo)))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (kill-buffer buffer)
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;Enable use package
;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Block until current queue processed.
(elpaca-wait)

;; Nord Themes

(use-package nord-theme
  :init
  (setq nord-region-highlight "frost")
  :config
  (load-theme 'nord t))

;; Org
(use-package org
  :init
  (setq org-directory "c:/Users/Lalo/org/")
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)
  ("C-c n" . (lambda ()
	       (interactive)
	       (find-file (symbol-value 'org-default-notes-file)))))

;; Magit

(use-package magit)

;; Eglot : LSP

(use-package eglot
  :commands eglot
  :hook (js2-mode . eglot-ensure))

;; Company-mode : Completions

(use-package company
  :init
  (global-company-mode))

;; ;; PL modes
;; Elm

(use-package elm-mode)

;; JS

(use-package js2-mode
  :mode "\\.js\\'")

;;EPUBS
(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-unzip-program (executable-find "unzip")))

;; Start Server

(server-start)

;; Landing page
(setq initial-buffer-choice "c:/Users/Lalo/org/landing.org")
