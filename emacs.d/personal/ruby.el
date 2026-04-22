(when (require 'flymake-ruby nil t)
  (add-hook 'ruby-mode-hook 'flymake-ruby-load))

;; fix indentation
(setq ruby-deep-indent-paren nil)

;; ruby IRB buffer
(global-set-key (kbd "C-c r r") 'inf-ruby)

;; rvm integration
(when (require 'rvm nil t)
  (rvm-use-default)
  ;; activate proper rvm when in ruby mode
  (add-hook 'ruby-mode-hook 'rvm-activate-corresponding-ruby))

(when (require 'grizzl nil t)
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'grizzl)
  (global-set-key (kbd "C-c r p") 'projectile-find-file)
  (global-set-key (kbd "C-c r b") 'projectile-switch-to-buffer))

;; turn projectile and robe on w/ ruby
(add-hook 'ruby-mode-hook 'robe-mode)

;; turn ruby-specific projectile functions on
(add-hook 'projectile-mode-hook 'projectile-rails-on)

;; for running ruby processes (e.g. a rails dev server)
(add-hook 'after-init-hook 'inf-ruby-switch-setup)

;; emacs-pry (ruby debugger)
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-pry")
(require 'pry nil t)

;; ruby style enforcement
(add-hook 'ruby-mode-hook 'rubocop-mode)

