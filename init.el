;;Strait Package Manager

;;Bootstraping code
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;Theme
(setq custom-theme-directory "~/.emacs.d/themes")
(load-theme 'lalo 1)


(setq straight-use-package-by-default t)

(straight-use-package 'use-package)

;; Org
;; Not sure why default repo is wrong
(straight-use-package
 `(org :type git :repo "git://git.sv.gnu.org/emacs/org-mode.git" :local-repo "org" :depth full :pre-build (straight-recipes-org-elpa--build) :build (:not autoloads) :files (:defaults "lisp/*.el" ("etc/styles/" "etc/styles/*"))))

(setq org-directory "c:/Users/evida/notes/")
(setq org-default-notes-file (concat org-directory "/notes.org"))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Magit
(use-package magit)

;; Start Server
(server-start)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("447f0fe00896b127d686d7e1936301e965c160e72ffb24279056d4d03adeb91a" "77a6c33dd3377c5384eab42f000beae2bf898f44dfdf6a5d52505f929f5e2f52" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
