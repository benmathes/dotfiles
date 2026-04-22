(when (require 'coffee-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.js.coffee$" . coffee-mode))
  (defun coffee-custom ()
    "coffee-mode-hook"
    (set (make-local-variable 'tab-width) 2))
  (add-hook 'coffee-mode-hook
            '(lambda() (coffee-custom))))
