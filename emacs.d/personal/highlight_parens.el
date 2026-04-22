;;(add-hook 'highlight-parentheses-mode-hook
;;          '(lambda ()
;;             (setq autopair-handle-action-fns
;;                   (append
;;                    (if autopair-handle-action-fns
;;                        autopair-handle-action-fns
;;                        '(autopair-default-handle-action))
;;                    '((lambda (action pair pos-before)
;;                        (hl-paren-color-update)))))))
;;
;;
;;(define-globalized-minor-mode global-highlight-parentheses-mode
;;  highlight-parentheses-mode
;;  (lambda ()
;;    (highlight-parentheses-mode t)))
;;
;;(global-highlight-parentheses-mode t)


