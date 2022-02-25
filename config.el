;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zhang Zhaoheng"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(use-package! org
  :config
  (setq org-directory "~/org/")
  (global-set-key (kbd "C-c a") #'org-agenda)
  (add-hook! 'org-mode-hook
    (auto-fill-mode 1)))

;; org-roam

;; Do not open org-roam buffer on file open
(after! org-roam
  (setq org-roam-directory (file-truename "~/iCloud/roam"))
  (org-roam-db-autosync-enable)
  (setq +org-roam-open-buffer-on-find-file nil))

(after! org-timer
  (define-key global-map (kbd "C-c C-x ;") #'org-timer-set-timer))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(map! :n "s-," #'xref-go-back)
(map! :n "s-." #'xref-find-definitions)

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; consult
(define-key global-map (kbd "C-s") #'consult-line)

;; lsp
(after! lsp
  (define-key lsp-mode-map (kbd "s-.") #'lsp-goto-implementation))

;;
(define-key minibuffer-local-map (kbd "s-n") #'next-history-element)
(define-key minibuffer-local-map (kbd "s-p") #'previous-history-element)

;; evil
(define-key evil-insert-state-map (kbd "C-d") #'delete-char)
(define-key evil-insert-state-map (kbd "C-k") #'evil-deleteline)
(define-key evil-normal-state-map (kbd "] e") #'flycheck-next-error)
(define-key evil-normal-state-map (kbd "[ e") #'flycheck-previous-error)

(after! evil-commands
  (global-set-key (kbd "s-`") #'evil-switch-to-windows-last-buffer))

;; (use-package! powerline
;;   :config
;;   (powerline-default-theme))

(after! projectile
  (setq projectile-project-search-path '("~/dev")))

(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq filename
        (concat
         (make-temp-name
          (concat (buffer-file-name)
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (call-process "import" nil nil nil filename)
  (insert (concat "[[" filename "]]"))
  (org-display-inline-images))

;; lisp
(setq inferior-lisp-program "/usr/local/bin/sbcl")

;; typescript
;;; auto formatting on saving in typescript files

(use-package! tree-sitter)

(use-package! tree-sitter-langs)

(use-package! vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
         ("C-l" . vertico-directory-up)))

(after! evil-snipe
  (setq evil-snipe-scope 'visible))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
