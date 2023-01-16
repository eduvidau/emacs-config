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
(declare-function elpaca-generate-autoloads "elpaca")
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(when-let ((elpaca-repo (expand-file-name "repos/elpaca/" elpaca-directory))
           (elpaca-build (expand-file-name "elpaca/" elpaca-builds-directory))
           (elpaca-target (if (file-exists-p elpaca-build) elpaca-build elpaca-repo))
           (elpaca-url  "https://www.github.com/progfolio/elpaca.git")
           ((add-to-list 'load-path elpaca-target))
           ((not (file-exists-p elpaca-repo)))
           (buffer (get-buffer-create "*elpaca-bootstrap*")))
  (condition-case-unless-debug err
      (progn
        (unless (zerop (call-process "git" nil buffer t "clone" elpaca-url elpaca-repo))
          (error "%s" (list (with-current-buffer buffer (buffer-string)))))
        (byte-recompile-directory elpaca-repo 0 'force)
        (require 'elpaca)
        (elpaca-generate-autoloads "elpaca" elpaca-repo)
        (kill-buffer buffer))
    ((error)
     (delete-directory elpaca-directory 'recursive)
     (with-current-buffer buffer
       (goto-char (point-max))
       (insert (format "\n%S" err))
       (display-buffer buffer)))))
(require 'elpaca-autoloads)
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca (elpaca :host github :repo "progfolio/elpaca"))
(setq package-enable-at-startup nil)

;; Use-package

(elpaca use-package (require 'use-package))

;; Nord Themes

(elpaca-use-package nord-theme
  :init
  (setq nord-region-highlight "frost")
  :config
  (load-theme 'nord t))

;; Org
(elpaca-use-package org
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

(elpaca-use-package magit)

;; Eglot : LSP

(elpaca-use-package eglot
  :commands eglot
  :hook (js2-mode . eglot-ensure))

;; Company-mode : Completions

(elpaca-use-package company
  :init
  (global-company-mode))

;; ;; PL modes
;; Elm

(elpaca-use-package elm-mode)

;; JS

(elpaca-use-package js2-mode
  :mode "\\.js\\'")

;; Start Server

(server-start)
