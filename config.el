(setq user-full-name "Drew Bruce"
      user-mail-address "drew@drewbruce.com")
(defvar my/work-email "drew.bruce@nike.com")

(setq doom-font (font-spec :family "monospace" :size 14))
(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)

(setq org-directory "~/org/")
(setq deft-directory "~/org")
(setq org-roam-directory "~/org/notes")
(setq org-agenda-files '("~/org/tasks", "~/.doom.d/config.org"))

(setq deft-extensions '("txt" "tex" "org"))
(setq deft-recursive t)

(defvar my/refile-targets
  (mapcar 'abbreviate-file-name
          (split-string
           (shell-command-to-string "find -L ~/org -name '*.org'") "\n")))
(setq org-refile-targets '((my/refile-targets :maxlevel . 2)))

(map! :after org
      :map org-mode-map
      :n :desc "refile headline" "C-c r" #'org-refile
      :n :desc "insert snippet" "C-c s" #'yas-insert-snippet
      :n :desc "insert link & goto" "C-c i" #'org-roam-insert
      :n :desc "insert link" "C-c I" #'org-roam-insert-immediate)

(setq-hook! 'org-mode-hook
  spell-fu-faces-exclude '(org-src-block-faces))

(after! org-roam
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
        )))

(after! org-babel
    (defun my/remove-properties (str)
        (string-join (seq-filter (lambda (st) (not (string-prefix-p ":" st))) (split-string str "\n")) "\n"))
    (setq org-babel-process-comment-text 'my/remove-properties))

(map! :leader
      :desc "M-x" "x" #'counsel-M-x
      :desc "other-window" "w o" #'other-window
      :desc "org-capture" "n n" #'org-roam-capture
      :desc "org-today" "n j" #'org-roam-dailies-today)

(after! time-stamp
  (add-hook 'write-file-functions 'time-stamp))

(elfeed-goodies/setup)
