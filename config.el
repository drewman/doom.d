;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Drew Bruce"
      user-mail-address "drew.bruce@nike.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      :desc "M-x" "x" #'counsel-M-x
      :desc "other-window" "w o" #'other-window
      :desc "org-capture" "n n" #'org-roam-capture
      :desc "org-today" "n j" #'org-roam-dailies-today)

(setq deft-extensions '("txt" "tex" "org"))
(setq deft-directory "~/org")
(setq deft-recursive t)
(setq org-roam-directory "~/org/notes")
(setq org-agenda-files '("~/org/tasks"))
(defvar my/refile-targets
  (mapcar 'abbreviate-file-name
          (split-string
           (shell-command-to-string "find -L ~/org -name '*.org'") "\n")))
(setq org-refile-targets '((my/refile-targets :maxlevel . 2)))

(after! time-stamp
  (add-hook 'write-file-functions 'time-stamp))

(map! :after org
      :map org-mode-map
      :n :desc "refile headline" "C-c r" #'org-refile
      :n :desc "insert snippet" "C-c s" #'yas-insert-snippet
      :n :desc "insert link & goto" "C-c i" #'org-roam-insert
      :n :desc "insert link" "C-c I" #'org-roam-insert-immediate)

;; I do not want properties to be exported when I run org-babel-tangle with ':comments org'
;; This will only give me the headline
(defun my/remove-properties (str)
  (string-join (seq-filter (lambda (st) (not (string-prefix-p ":" st))) (split-string str "\n")) "\n")
  )

(setq org-babel-process-comment-text 'my/remove-properties)

(setq org-roam-capture-templates
      '(
        ("l" "literature" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "literature/${slug}"
         :head "#+title: ${title}\n#+date: %<%m/%d/%Y>\nTime-stamp: <>\n"
         :empty-lines 1
         :unnarrowed t)
        ("m" "meeting" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "meeting/${slug}"
         :head "#+title: ${title}\n#+date: %<%m/%d/%Y>\nTime-stamp: <>\n"
         :empty-lines 1
         :unnarrowed t)
        ("p" "project" plain (function org-roam--capture-get-point)

         "%?"
         :file-name "project/${slug}"
         :head "#+title: ${title}\n#+date: %<%m/%d/%Y>\nTime-stamp: <>\n"
         :empty-lines 1
         :unnarrowed t)
        ("t" "topic" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "topic/${slug}"
         :head "#+title: ${title}\n#+date: %<%m/%d/%Y>\nTime-stamp: <>\n"
         :empty-lines 1
         :unnarrowed t)
        ))

(setq org-roam-dailies-capture-templates
      '(
        ("d" "daily" plain (function org-roam--capture-get-point)
         ""
         :immediate-finish t
         :file-name "journal/%<%Y-%m-%d>"
         :head "#+title: %<%Y-%m-%d>\n#+roam_tags\n")
      ))

(elfeed-goodies/setup)
