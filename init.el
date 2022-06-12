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

(setq straight-use-package-by-default t)

(straight-use-package 'use-package)

;; Org
;; Not sure why default repo is wrong
(straight-use-package
 `(org :type git :repo "git://git.sv.gnu.org/emacs/org-mode.git" :local-repo "org" :depth full :pre-build (straight-recipes-org-elpa--build) :build (:not autoloads) :files (:defaults "lisp/*.el" ("etc/styles/" "etc/styles/*"))))

(setq org-directory "c:/Users/evida/notes/")
(setq org-default-notes-file (concat org-directory "/notes.org"))

;; Magit
(use-package magit)

;; Start Server
(server-start)
