;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zhang Zhaoheng"
      user-mail-address "zzh699@gmail.com")

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

(setq doom-leader-alt-key "C-q")

;; (desktop-save-mode 1)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(use-package! org
  :config
  (setq org-directory "~/org/")
  (global-set-key (kbd "C-c a") #'org-agenda)
  (add-hook! 'org-mode-hook 'visual-fill-column-mode)
  (remove-hook 'org-mode-hook 'evil-org-mode))

;; org-roam

(after! org-roam
  ;; (setq org-roam-directory (file-truename "~/iCloud/roam"))
  (org-roam-db-autosync-enable)
  ;; Do not open org-roam buffer on file open
  (setq +org-roam-open-buffer-on-find-file nil)
  (defun org-roam-tag-replace ()
    (interactive)
    ;; TODO how to show prompts like: select tag to replace/add:
    (call-interactively 'org-roam-tag-remove)
    (call-interactively 'org-roam-tag-add)
    (save-buffer)))

(after! org-timer
  (define-key global-map (kbd "C-c C-x ;") #'org-timer-set-timer))

(after! which-key
  (setq which-key-idle-delay 0.2))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(after! company
  (setq company-dabbrev-other-buffers t)
  (setq company-idle-delay 0.01)
  (define-key company-active-map (kbd "TAB") #'company-complete)
  (setq company-backends '((company-capf company-dabbrev company-yasnippet))))

;; (use-package corfu
;;     ;; Optional customizations
;;   :custom
;;   (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
;;   (corfu-auto t)                 ;; Enable auto completion
;;   (corfu-auto-delay 0.0)
;;   (corfu-auto-prefix 2)
;;   (corfu-separator ?c)          ;; Orderless field separator
;;   ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
;;   ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
;;   (corfu-preview-current nil)    ;; Disable current candidate preview
;;   ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
;;   ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
;;   ;; (corfu-scroll-margin 5)        ;; Use scroll margin

;;   ;; Enable Corfu only for certain modes.
;;   ;; :hook ((prog-mode . corfu-mode)
;;   ;;        (shell-mode . corfu-mode)
;;   ;;        (eshell-mode . corfu-mode))

;;   ;; Recommended: Enable Corfu globally.
;;   ;; This is recommended since Dabbrev can be used globally (M-/).
;;   ;; See also `global-corfu-modes'.
;;   :init
;;   (global-corfu-mode))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(map! :n "s-," #'xref-go-back)
(map! :n "s-." #'xref-find-definitions)
(map! :g "s-;" #'er/expand-region)
(map! :g "C-x C-l" #'+workspace/switch-to)
(map! :g "s-\\" #'lsp-eslint-apply-all-fixes)
(map! :g "C-/" #'hippie-expand)

(setq gc-cons-threshold (* 300 1024 1024))
(setq auto-save-default nil)

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
(after! lsp-mode
  (map! :n "s-f" #'lsp-find-references)
  (setq lsp-ui-sideline-diagnostic-max-lines 8)
  (setq lsp-eslint-auto-fix-on-save t)
  (setq gc-cons-threshold 500000000)
  (setq read-process-output-max (* 1024 1024))
  (setq lsp-idle-delay 0.2)
  (setq lsp-file-watch-threshold 2000)
  (add-to-list 'lsp-file-watch-ignored-directories "tila-submodule/packages/tila-vscode")
  (add-to-list 'lsp-file-watch-ignored-directories "tila-devtools"))

;;
(define-key minibuffer-local-map (kbd "s-n") #'next-history-element)
(define-key minibuffer-local-map (kbd "s-p") #'previous-history-element)

;; ctrl-x-map
(define-key ctl-x-map (kbd "/") #'+default/search-project)

;; evil
(define-key evil-insert-state-map (kbd "C-d") #'delete-char)
(define-key evil-insert-state-map (kbd "C-k") #'evil-deleteline)
(define-key evil-normal-state-map (kbd "j") #'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") #'evil-previous-visual-line)
(map! "s-d" #'evil-multiedit-match-symbol-and-next
      "s-D" #'evil-multiedit-match-symbol-and-prev
      "s-`" #'evil-switch-to-windows-last-buffer
      "s-1" #'+workspace/switch-to-0
      "s-2" #'+workspace/switch-to-1
      "s-3" #'+workspace/switch-to-2
      "s-4" #'+workspace/switch-to-3
      "s-5" #'+workspace/switch-to-4
      "s-6" #'+workspace/switch-to-5
      "s-7" #'+workspace/switch-to-6
      "s-8" #'+workspace/switch-to-7)
(map! :n "[ e" #'flymake-goto-prev-error
      :n "] e" #'flymake-goto-next-error)
(map! :map eglot-mode-map :n "SPC c a" #'eglot-code-action-quickfix)

(use-package flycheck
  :config
  (flycheck-add-mode 'javascript-eslint 'typescript-ts-mode)
  (global-flycheck-mode t))

(defun eslint-fix-file ()
  (interactive)
  (message "eslint --fixing the file %s" (buffer-file-name))
  (shell-command (concat "eslint --fix " (buffer-file-name))))

(use-package! sgml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.ttml\\'" . sgml-mode)))

(use-package! css-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.ttss\\'" . css-ts-mode)))

(use-package info
  :config
  (evil-set-initial-state 'Info-mode 'emacs))


(after! projectile
  (setq projectile-project-search-path '("~/dev")))

;; org
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
;; (setq inferior-lisp-program "/usr/local/bin/sbcl")

;; typescript
;;; auto formatting on saving in typescript files
(after! typescript-mode
  (setq typescript-indent-level 2))

(after! vertico-repeat
  (setq vertico-repeat-filter (remove 'execute-extended-command vertico-repeat-filter)))

(use-package! vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
         ("C-l" . vertico-directory-up)))

(after! evil-snipe
  (setq evil-snipe-scope 'visible))

;; (use-package! websocket
;;     :after org-roam)

;; (use-package! org-roam-ui
;;     :after org-roam ;; or :after org
;; ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;; ;;         a hookable mode anymore, you're advised to pick something yourself
;; ;;         if you don't care about startup time, use
;; ;;  :hook (after-init . org-roam-ui-mode)
;;     :config
;;     (setq org-roam-ui-sync-theme t
;;           org-roam-ui-follow t
;;           org-roam-ui-update-on-save t
;;           org-roam-ui-open-on-start t))

(defun echo-file-path ()
  (interactive)
  (message (buffer-file-name)))
(map! :g "C-x e" #'echo-file-path)

;; May cause buffer open to be slow
(after! yasnippet
  (yas-global-mode))

(use-package turbo-log
  :bind (("C-s-l" . turbo-log-print)
         ("C-s-i" . turbo-log-print-immediately)
         ("C-s-h" . turbo-log-comment-all-logs)
         ("C-s-s" . turbo-log-uncomment-all-logs)
         ("C-s-[" . turbo-log-paste-as-logger)
         ("C-s-]" . turbo-log-paste-as-logger-immediately)
         ("C-s-x" . turbo-log-delete-all-logs))
  :config
  (setq turbo-log-msg-format-template "\": %s\"")
  (setq turbo-log-allow-insert-without-tree-sitter-p t))

 (use-package consult-dash
    :bind (("M-s d" . consult-dash))
    :config
    ;; Use the symbol at point as initial search term
    (consult-customize consult-dash :initial (thing-at-point 'symbol)))

(defun open-vela-user-dir ()
  (interactive)
  (pop-to-buffer-same-window
   (find-file-noselect (read-file-name "Find file: " "~/Library/Application Support/@byted/vela/User/"))))

(defun get-screen-num (&optional screen)
  "Return the number of a screen to operate on.

SCREEN denotes the position of element from (display-monitor-attributes-list)
If SCREEN is provided, return it directly.
If there is only one element in (display-monitor-attributes-list)), return 1.
Else prompt user to select which screen to use. The user should select a number.
And the prompt should show which screen is related to which number. "
  (let* ((number-of-screens (length (display-monitor-attributes-list))))
    (or 1 (and (equal number-of-screens 1) number-of-screens)
         screen
         ;; TODO: restrict the selection to the correct range
         (read-number
          (format
           "Select which screen to use (%s): "
           (--reduce
            (format "%s | %s" acc it)
            (-map-indexed
             (lambda (index it) (format "%s - %s" (1+ index) (cdr it)))
             (-select-column 4 (display-monitor-attributes-list)))))))))

(defun my-resize-emacs-window (&optional screen)
  "Set frame to the 3/4 position in horizontally on the right and in
full-height vertically. When called interactivly, it prompts user to
select when screen it should use when there are more than one screen."
  (interactive)
  ;; Assume the MacOS dock is about 50 pixels tall
  (let* ((screen-num (get-screen-num screen))
         ;; Get monitor attributes
         (monitor-attrs (nth (1- screen-num) (display-monitor-attributes-list)))
         ;; (monitor-x (nth 1 (assq 'workarea monitor-attrs)))
         ;; (monitor-y (nth 2 (assq 'workarea monitor-attrs)))
         (monitor-width (nth 3 (assq 'workarea monitor-attrs)))
         (monitor-height (nth 4 (assq 'workarea monitor-attrs)))
         ;; Set the frame width to 3/4 of the monitor width, and height to the usable height
         (frame-chars-wide (/ (* 3 monitor-width) 4 (frame-char-width)))
         (frame-chars-tall (/ monitor-height (frame-char-height))))
    (set-frame-position (selected-frame) (- (/ monitor-width 4) 20) 0)
    (set-frame-size (selected-frame) frame-chars-wide frame-chars-tall)))

(my-resize-emacs-window 1)

(defun disable-evil-org-key-theme ()
  (message "executed disable hook")
  (evil-org-set-key-theme '(navigation)))
(after! evil-org-mode
  (message "evil-org-mode loaded")
  (add-hook 'evil-org-mode-hook #'disable-evil-org-key-theme))

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(use-package evil-textobj-tree-sitter
  :ensure t
  :config
  (define-key evil-outer-text-objects-map "x"
              (evil-textobj-tree-sitter-get-textobj
                "jsx_attribute"
                '((tsx-ts-mode . ((jsx_attribute) @jsx_attribute)))))
  (define-key evil-inner-text-objects-map "x"
              (evil-textobj-tree-sitter-get-textobj
                "jsx_attribute"
                '((tsx-ts-mode . ((jsx_attribute) @jsx_attribute))))))

(use-package! eglot
  :config
  (add-hook 'typescript-ts-base-mode-hook 'eglot-ensure)
  (setq eglot-confirm-server-initiated-edits nil)
  (add-to-list 'eglot-stay-out-of 'imenu)
  (define-key eglot-mode-map (kbd "s-f") #'xref-find-references)
  (add-hook 'typescript-ts-base-mode-hook (lambda() (flymake-eslint-enable)))
  (map! :n "g i" #'eglot-find-implementation))

(use-package! symbol-overlay
  :config
  (setq symbol-overlay-idle-time 0.2)
  (add-hook! 'prog-mode-hook #'symbol-overlay-mode))

(map! :map symbol-overlay-mode-map
      :nv
      "<tab>" #'symbol-overlay-jump-next
      "<backtab>" #'symbol-overlay-jump-prev)

(defun open-packagejson-in-current-project ()
  (interactive)
  (pop-to-buffer-same-window (find-file-noselect (concat (project-root (project-current)) "package.json"))))

(map! :n "g p" #'open-packagejson-in-current-project)

(defun microapp-jump-to-definition ()
  (interactive)
  (let* ((node (treesit-node-at (point) 'html))
         (text (treesit-node-text node))
         (plain-text (substring-no-properties text))
         (current-file (buffer-file-name))
         (directory (file-name-directory current-file))
         (base-name (file-name-base current-file))
         (js-file (concat directory base-name ".js")))
    (find-file js-file)
    (microapp-goto-property-identifier-matching-target plain-text)))

(defun microapp-goto-property-identifier-matching-target (target)
  (let* ((query '((call_expression
                   (identifier) @id (:equal @id "Page")
                   (arguments (object (pair (property_identifier) @p))))))
         (nodes (treesit-query-capture (treesit-buffer-root-node) query))
         (matched-node (cl-find target nodes
                                :test (lambda (text node)
                                        (string= text (treesit-node-text (cdr node)))))))
    (when matched-node
      (let* ((node (cdr matched-node))
             (start (treesit-node-start node)))
        (goto-char start)))))

(map! :n "C-." #'microapp-jump-to-definition)


(require 'cl-lib)

(defvar command-stats-file (expand-file-name "~/command-stats.elc")
  "File to save command statistics.")

(defvar command-stats (make-hash-table :test 'equal)
  "Hash table to hold command statistics.")

(defun load-command-stats ()
  "Load command statistics from `command-stats-file'."
  (when (file-exists-p command-stats-file)
    (let ((data (with-temp-buffer
                  (insert-file-contents command-stats-file)
                  (read (current-buffer)))))
      (clrhash command-stats)
      (dolist (item data)
        (puthash (car item) (cdr item) command-stats)))))

(defun save-command-stats ()
  "Save command statistics to `command-stats-file'."
  (with-temp-file command-stats-file
    (prin1 (let (result)
             (maphash (lambda (key value)
                        (push (cons key value) result))
                      command-stats)
             result)
            (current-buffer))))

(defun record-command-stats ()
  "Record command statistics."
  (unless (eq this-command 'self-insert-command)
    (let* ((date (format-time-string "%Y-%m-%d"))
         (command-name (symbol-name this-command))
         (key-sequence (key-description (this-command-keys)))
         (hash-key (concat date "|" command-name))
         (current-stats (gethash hash-key command-stats)))
    (if current-stats
        (progn
          (cl-incf (cdr current-stats))
          (unless (member key-sequence (car current-stats))
            (push key-sequence (car current-stats))))
      (puthash hash-key (cons (list key-sequence) 1) command-stats)))
    ))

(add-hook 'post-command-hook 'record-command-stats)

(defun display-command-stats ()
  "Display command statistics in a new buffer."
  (interactive)
  (let ((buffer (get-buffer-create "*Command Stats*")))
    (with-current-buffer buffer
      (erase-buffer)
      (insert (format "%-40s %-40s %-40s %s\n" "Date" "Command" "Key Sequence" "Invoked Times"))
      (maphash (lambda (key value)
                 (let* ((split-key (split-string key "|"))
                        (date (car split-key))
                        (command (cadr split-key)))
                   (dolist (key-sequence (car value))
                     (insert (format "%-40s %-40s %-40s %d\n" date command key-sequence (cdr value))))))
               command-stats))
    (switch-to-buffer buffer)))

(load-command-stats)

;; Save the command statistics periodically and when Emacs exits.
(run-at-time t 600 'save-command-stats)
(add-hook 'kill-emacs-hook 'save-command-stats)
