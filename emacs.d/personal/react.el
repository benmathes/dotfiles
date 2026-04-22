;; jsx in web-mode
(when (require 'web-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ios.js$" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.react.js$" . web-mode))

  ;; tweak part-face for jsx
  (advice-add 'web-mode-highlight-part :around
              (lambda (orig-fun &rest args)
                (if (equal web-mode-content-type "jsx")
                    (let ((web-mode-enable-part-face nil))
                      (apply orig-fun args))
                  (apply orig-fun args))))

  ;; ensure 'react.js' files are jsx-mode
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))))
