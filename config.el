;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jason Kenyon"
      user-mail-address "jason0kenyon@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq display-time-default-load-average nil)
(add-hook 'after-init-hook 'display-time-mode)
(after! doom-modeline
  (remove-hook 'doom-modeline-mode-hook #'size-indication-mode)
  (remove-hook 'doom-modeline-mode-hook #'column-number-mode)
  (line-number-mode -1)
  (setq
      doom-modeline-height 40
      display-time-default-load-average nil
      doom-modeline-time t)
  )
  (setq doom-theme 'doom-challenger-deep)
  (setq display-line-numbers-type 'relative)
(solaire-global-mode +1)

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(setq doom-font (font-spec :family "JetBrainsMono" :weight 'normal :size 40 ))
(setq doom-variable-pitch-font (font-spec :family "Vollkorn" :weight 'normal :size 50 ))

(after! org
  (setq org-ellipsis " ▼"
        org-hide-emphasis-markers t
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-item-bullet-alist '((?+ . ?◆) (?- . ?•))
        org-superstar-special-todo-items 'hide)
  (dolist (face '((org-level-1 . 2.0)
                    (org-level-2 . 1.8)
                    (org-level-3 . 1.5)
                    (org-level-4 . 1.2)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil :font "Vollkorn" :weight 'medium :height (cdr face)))
)
(add-hook 'org-mode-hook  'org-superstar-mode)
(add-hook 'org-mode-hook  'mixed-pitch-mode)

(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))
(map!
 :leader
 (:prefix ("n r" . "node roam")
  :desc "quick insert" "i" #'org-roam-node-insert-immediate))
(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)

(after! org
(setq org-directory "~/projects/org/"
      org-agenda-files '("~/projects/org/org-roam")
      org-roam-directory "~/projects/org/org-roam")

 (setq org-roam-capture-templates
              '(("t" "default" plain
                 "%?"
                :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
                :unnarrowed t)

                ("d" "daily" plain
                 "* Journal\n\n%?\n\n* Tasks\n** TODO [/]\n1. [ ] Mindfulness(10min)\n2. [ ] Journaling(5min)\n3. [ ] Check Out\n** Notes"
                 :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Daily\n#+category: Daily")
                 :unnarrowed t)

                ("w" "weekly" plain
                 "* Brainstorm\n\n%?\n\n* Note Review\n\n* Agenda"
                 :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Weekly\n#+category: Weekly")
                 :unnarrowed t)

                ("a" "aim" plain
                 "* Priority III\n\n* Statement\n\n%?\n\n* Action Plan\n** Maintenance\n** Overview\n\n* Week\n** One\n*** TODO\n*** Commments & Meta-cognition\n\n* Deadlines"
                 :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Aim\n#+category: Aim")
                 :unnarrowed t)
                ))
 )

(after! org-fancy-priorities
   (setq org-fancy-priorities-list '("⚡" "⚠" "❗")))
(after! org
(setq org-clock-sound "~/.doom.d/alarm.wav")
(setq
  org-agenda-block-separator ?\u25AA
  org-todo-keywords
          '((sequence
             "TODO(t)"
             "WAIT(w)"
             "|"
             "DONE(d)"
             "CANCELLED(c)"
             )))
(setq org-agenda-custom-commands
      '(("v" "Main"
        ((tags-todo "+PRIORITY=\"A\""
        ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("WAIT")))
         (org-agenda-overriding-header "High Priority Tasks:")))
        (tags-todo "+PRIORITY=\"B\""
         ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("WAIT")))
          (org-agenda-overriding-header "Medium Priority Tasks:")))
        (tags-todo "+PRIORITY=\"C\""
        ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("WAIT")))
        (org-agenda-overriding-header "Low Priority Tasks:")))
        (agenda "")
        (todo "WAIT"
        ((org-agenda-overriding-header "On Hold:")))
        )
        )
        ("l" "Waitlist"
         ((todo "WAIT"
        ((org-agenda-overriding-header "On Hold:"))))
        )
        )
)
)

(setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t)

(add-hook 'pdf-view-mode-hook 'auto-revert-mode)
(add-hook 'TeX-mode-hook 'mixed-pitch-mode)
(add-hook 'TeX-mode-hook 'prettify-symbols-mode)

(add-hook 'TeX-mode-hook
          (lambda ()
            (push '("\\mathbb{C}" . ?ℂ) prettify-symbols-alist)
            (push '("\\mathbb{F}" . ?𝔽) prettify-symbols-alist)
            ))
(add-hook 'after-init-hook 'global-company-mode)

(add-hook 'company-mode-hook 'company-box-mode)
(after! company
(setq
  company-minimum-prefix-length 3
  company-idle-delay 0.5)
(map!
 :map 'company-active-map
 "<tab>" 'company-complete-selection
 "C-k"  'company-select-previous
 "C-j" 'company-select-next)
)

(citar-org-roam-mode)
(setq citar-bibliography "~/projects/templates/refs.bib")
(setq citar-library-paths '("~/library/papers/"))
(setq citar-symbols
      `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
        (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . "🖋️")
        (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " ")))
(setq citar-symbol-separator "  ")

(require 'cdlatex)
(require 'org-table)

(defun lazytab-position-cursor-and-edit ()
  ;; (if (search-backward "\?" (- (point) 100) t)
  ;;     (delete-char 1))
  (cdlatex-position-cursor)
  (lazytab-orgtbl-edit))

(defun lazytab-orgtbl-edit ()
  (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'lazytab-orgtbl-replace)
  (orgtbl-mode 1)
  (open-line 1)
  (insert "\n|"))

(defun lazytab-orgtbl-replace (_)
  (interactive "P")
  (unless (org-at-table-p) (user-error "Not at a table"))
  (let* ((table (org-table-to-lisp))
         params
         (replacement-table
          (if (texmathp)
              (lazytab-orgtbl-to-amsmath table params)
            (orgtbl-to-latex table params))))
    (kill-region (org-table-begin) (org-table-end))
    (open-line 1)
    (push-mark)
    (insert replacement-table)
    (align-regexp (region-beginning) (region-end) "\\([:space:]*\\)& ")
    (advice-remove 'orgtbl-ctrl-c-ctrl-c #'lazytab-orgtbl-replace)))

(defun lazytab-orgtbl-to-amsmath (table params)
  (orgtbl-to-generic
   table
   (org-combine-plists
    '(:splice t
      :lstart ""
      :lend " \\\\"
      :sep " & "
      :hline nil
      :llend "")
    params)))

(defun lazytab-cdlatex-or-orgtbl-next-field ()
  (when (and (bound-and-true-p orgtbl-mode)
             (org-table-p)
             (looking-at "[[:space:]]*\\(?:|\\|$\\)")
             (let ((s (thing-at-point 'sexp)))
               (not (and s (assoc s cdlatex-command-alist-comb)))))
    (call-interactively #'org-table-next-field)
    t))

;;;###autoload
(defun lazytab-org-table-next-field-maybe ()
  (interactive)
  (if (bound-and-true-p cdlatex-mode)
      (cdlatex-tab)
    (org-table-next-field)))


;;;###autoload
(define-minor-mode lazytab-mode
  "Type in matrices, arrays and tables in LaTeX buffers with
orgtbl syntax."
  :global nil
  (if lazytab-mode
      (progn  (require 'org-table)
              (define-key orgtbl-mode-map (kbd "<tab>") 'lazytab-org-table-next-field-maybe)
              (define-key orgtbl-mode-map (kbd "TAB") 'lazytab-org-table-next-field-maybe)
              (add-hook 'cdlatex-tab-hook 'lazytab-cdlatex-or-orgtbl-next-field))
    (define-key orgtbl-mode-map (kbd "<tab>") 'org-table-next-field)
    (define-key orgtbl-mode-map (kbd "TAB") 'org-table-next-field)
    (remove-hook 'cdlatex-tab-hook 'lazytab-cdlatex-or-orgtbl-next-field)))


(provide 'lazytab)

(map! :leader
      :desc "Convert table to matrix" "l" #'lazytab-orgtbl-replace)
(add-hook 'TeX-mode-hook 'orgtbl-mode)

(add-hook 'mu4e-compose-mode-hook 'turn-off-auto-fill)
(set-email-account! "binghamton"
  '((mu4e-sent-folder       . "/jkenyon3/[Gmail]/Sent Mail")
    (mu4e-drafts-folder     . "/jkenyon3/Drafts")
    (mu4e-trash-folder      . "/jkenyon3/[Gmail]/Trash")
    (mu4e-refile-folder     . "/jkenyon3/[Gmail]/All Mail")
    (smtpmail-smtp-user     . "jkenyon3@binghamton.edu")
    (user-mail-address      . "jkenyon3@binghamton.edu"))
  t)
(set-email-account! "personal"
  '((mu4e-sent-folder       . "/jason0kenyon/[Gmail]/Sent Mail")
    (mu4e-drafts-folder     . "/jason0kenyon/Drafts")
    (mu4e-trash-folder      . "/jason0kenyon/[Gmail]/Trash")
    (mu4e-refile-folder     . "/jason0kenyon/[Gmail]/All Mail")
    (smtpmail-smtp-user     . "jason0kenyon@gmail.com")
    (user-mail-address      . "jason0kenyon@gmail.com"))
  t)
(after! mu4e

(setq mu4e-maildir-shortcuts
        '(("/jason0kenyon/Inbox"             . ?i)
          ("/jkenyon3/Inbox"             . ?I)
          ("/jason0kenyon/[Gmail]/Sent Mail" . ?s)
          ("/jkenyon3/[Gmail]/Sent Mail" . ?S)))
)

(defun mu4e-headers-mark-all-unread-read ()
  "Put a ! \(read) mark on all visible unread messages."
  (interactive)
  (mu4e-headers-mark-for-each-if
   (cons 'read nil)
   (lambda (msg param)
     (memq 'unread (mu4e-msg-field msg :flags)))))

(defun mu4e-headers-flag-all-read ()
  "Flag all visible messages as \"read\"."
  (interactive)
  (mu4e-headers-mark-all-unread-read)
  (mu4e-mark-execute-all t))

(setq rmh-elfeed-org-files '("~/.doom.d/elfeed.org"))
