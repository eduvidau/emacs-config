;; Inhibit Startup Screen

(setq inibit-startup-screen t)

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
  (setq org-directory "c:/Users/Lalo/notes/")
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

;; Elm

(elpaca-use-package elm-mode)

;; Eglot

(elpaca-use-package eglot)

;; Start Server

(server-start)

;; Not sure what this is

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(custom-safe-themes
;;    '("002ed973bd54d22d01f4d4213e88d181af2c439d8538dc856d3794f0c32f3ae1" "447f0fe00896b127d686d7e1936301e965c160e72ffb24279056d4d03adeb91a" "77a6c33dd3377c5384eab42f000beae2bf898f44dfdf6a5d52505f929f5e2f52" default)))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
