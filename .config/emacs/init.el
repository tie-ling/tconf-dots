(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
    (shell-command-to-string "wl-paste -n | tr -d \r")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

(use-package emacs
  :custom
  (auto-fill-function 'do-auto-fill t)
  (calendar-week-start-day 1)
  (custom-enabled-themes '(modus-operandi) nil nil "Customized with use-package custom")
  (default-input-method "german")
  (enable-local-variables nil)
  (inhibit-startup-screen t)
  (menu-bar-mode nil)
  (ledger-report-use-strict t)
  (mail-envelope-from 'header)
  (mail-specify-envelope-from t)
  (message-sendmail-envelope-from 'header)
  (mode-line-compact 'long)
  (modus-themes-bold-constructs nil)
  (modus-themes-inhibit-reload nil)
  (modus-themes-italic-constructs t)
  (modus-themes-mixed-fonts t)
  (network-security-level 'paranoid)
  (notmuch-crypto-process-mime nil)
  (notmuch-saved-searches
   '((:name "inbox" :query "tag:inbox" :key "i")
     (:name "deleted" :query "tag:deleted")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "all mail" :query "*" :key "a")
     (:name "archived" :query
            "not tag:deleted not tag:inbox  not tag:sent")))
  (notmuch-show-logo nil)
  (org-agenda-files nil)
  (read-buffer-completion-ignore-case t)
  (ring-bell-function nil)
  (scroll-bar-mode nil)
  (send-mail-function 'sendmail-send-it)
  (sendmail-program "msmtp")
  (tab-always-indent 'complete)
  (tool-bar-mode nil)
  (tramp-mode nil)
  (user-mail-address "gyuchen86@gmail.com"))

(use-package pyim)
(use-package pyim-basedict
  :config
  (pyim-basedict-enable))

(use-package elec-pair
  :custom
  (electric-pair-mode t))

(use-package battery
  :custom
  (display-battery-mode t))

(use-package time
  :custom
  (display-time-mode t))

(use-package shr
  :custom
  (shr-cookie-policy nil)
  (shr-inhibit-images t)
  (shr-use-colors nil))

(use-package files
  :custom
  (require-final-newline t))

(use-package minibuffer
  :custom
  (read-file-name-completion-ignore-case t))

(use-package simple
  :custom
  (indent-tabs-mode nil))

(use-package ledger-mode
  :mode ("\\.ledger\\'"))

(use-package notmuch)

(use-package counsel
  :config
  (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) "))

(use-package ledger-mode
  :custom
  ((ledger-binary-path "hledger")
   (ledger-mode-should-check-version nil)
   (ledger-report-auto-width nil)
   (ledger-report-links-in-register nil)
   (ledger-default-date-string "%Y-%m-%d")
   (ledger-report-native-highlighting-arguments '("--color=always")))
  :mode ("\\.hledger\\'" "\\.ledger\\'"))

(use-package org
  :custom
  (org-latex-compiler "lualatex")
  (org-babel-load-languages '((haskell . t) (python . t) (emacs-lisp . t) (shell . t)))
  (org-export-initial-scope 'buffer)
  (org-modules
   '(ol-bbdb ol-bibtex ol-doi ol-eww ol-info ol-irc ol-mhe ol-rmail org-tempo))
  (org-structure-template-alist
   '(("a" . "export ascii")
     ("c" . "center")
     ("C" . "comment")
     ("e" . "example")
     ("E" . "export")
     ("h" . "export html")
     ("l" . "export latex")
     ("q" . "quote")
     ("s" . "src")
     ("v" . "verse")
     ("hs" . "src haskell")
     ("py" . "src python")))
  :hook
  ;; in org mode, do not use <> electric pairs, as this is used by
  ;; org-tempo for structure templates
  (org-mode . (lambda ()
           (setq-local electric-pair-inhibit-predicate
                   `(lambda (c)
                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c)))))))


(use-package text-mode)

(use-package context
  :hook
  ((ConTeXt-mode . turn-on-reftex)

   ;; show \alpha as α and \mathbb{R} as ℝ
   (ConTeXt-mode . prettify-symbols-mode)

   ;; shortcuts for symbols
   (ConTeXt-mode . LaTeX-math-mode))

  :custom
  ;; AUCTeX defaults to mkii; change to iv for iv and lmtx
  (ConTeXt-Mark-version "IV")

  ;; Enable electric left right brace
  (LaTeX-electric-left-right-brace t)

  ;; Do not unprettify symbol at point
  (prettify-symbols-unprettify-at-point nil)

  ;; Let AUCTeX properly detect formula environment as math mode
  (texmathp-tex-commands '(("\\startformula" sw-on) ("\\stopformula" sw-off)))

  ;; Set PDF viewer
  (TeX-view-program-selection '((output-pdf "Zathura")))

  ;; Don't as for permission, just save all files
  (TeX-save-query nil)

  ;; Auto-save
  (TeX-auto-save t)

  ;; Debug bad boxes and warnings after compilation via
  ;; C-c ` key
  (TeX-debug-bad-boxes t)
  (TeX-debug-warnings t)

  ;; Electric inline math, 
  (TeX-electric-math '("$" . "$"))

  ;; Electric sub and superscript, inserts {} after ^ and _
  ;; such as a^{}.
  (TeX-electric-sub-and-superscript t)

  ;; RefTex
  (reftex-plug-into-AUCTeX t)

  ;; Customize keyboard shortcuts for TeX math macros
  (LaTeX-math-list
   '(("o r" "mathbb{R}" nil nil)
     ("o Q" "qquad" nil nil)
     ("o q" "quad" nil nil)
     ("o n" "mathbb{N}" nil nil)
     (?= "coloneq" nil nil)
     ("o c" "mathbb{C}" nil nil)))

  :bind
  ;; Electric \left(\right) \left[\right] \left\{\right\}
  ;; only left brace; there is no right electric brace function
  (:map ConTeXt-mode-map ("(" . LaTeX-insert-left-brace))
  (:map ConTeXt-mode-map ("[" . LaTeX-insert-left-brace))
  (:map ConTeXt-mode-map ("{" . LaTeX-insert-left-brace))

  :config
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)

  ;; Prettify symbols mode, customizable.
  (with-eval-after-load "tex-mode"
    (dolist (symb
             '(("\\colon" . ?:)
               ("\\mathbb{C}" . ?ℂ)
               ("\\mathbb{K}" . ?𝕂)))
      (add-to-list 'tex--prettify-symbols-alist symb))))

(use-package haskell-mode
  :custom
  (haskell-literate-default 'tex))
