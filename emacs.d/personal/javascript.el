(setq js-indent-level 2)

;; flow-minor-mode integration (if available)
(when (fboundp 'flow-minor-mode)
  (add-hook 'js2-mode-hook 'flow-minor-mode)
  (add-hook 'web-mode-hook 'flow-minor-mode)
  (add-hook 'rjsx-mode-hook 'flow-minor-mode)

  (with-eval-after-load 'flycheck
    (when (flycheck-valid-checker-p 'javascript-flow)
      (flycheck-add-mode 'javascript-flow 'flow-minor-mode)
      (flycheck-add-mode 'javascript-eslint 'flow-minor-mode)
      (flycheck-add-next-checker 'javascript-flow 'javascript-eslint))))
