(message "in personal/general_emacs.el")
;; Indentation width
;; You have to do it in this complicated way because of the
;; strange way the cc-mode initializes the value of `c-basic-offset'.
(add-hook 'c-mode-hook (lambda () (setq c-basic-offset 4)))

;; in theory tabs would be great (everyone gets their own identation width), but
;; editors fuck it up so much it's time for worse-is-better
(setq-default indent-tabs-mode nil)

;; highilght matching parentheses
(show-paren-mode 1)

;; hide the menu bar. never use it, wasted space.
(menu-bar-mode -1)

;; show the 80char column
(require 'fill-column-indicator nil t)

;; interactively-do
(require 'ido)
(ido-mode t)

;; truncate whitespace on save
(set-default 'truncate-lines t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; find files in projects (if we are in a project)
(global-set-key (kbd "C-x C-b") 'find-file-in-project)

;; default tab width of 4
(setq default-tab-width 4)

;; turn on rainbow delimters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; autocomplete!
(when (require 'auto-complete-config nil t)
  (ac-config-default)
  (setq ac-ignore-case nil)
  (add-to-list 'ac-modes 'enh-ruby-mode)
  (add-to-list 'ac-modes 'web-mode))


;; line numbers:
;; global-linum-mode is obsolete in Emacs 29+, use display-line-numbers-mode
(if (fboundp 'global-display-line-numbers-mode)
    (global-display-line-numbers-mode t)
  (when (fboundp 'global-linum-mode)
    (global-linum-mode t)))
