;;; runs eslint --fix on the current file after save
;;; alpha quality -- use at your own risk

(defun eslint-fix-file ()
  (interactive)
  (message "eslint --fixing the file" (buffer-file-name))
  (shell-command (concat "$grdd/assets/node_modules/eslint/bin/eslint.js --fix " (buffer-file-name))))

(defun eslint-fix-file-and-revert ()
  (interactive)
  (eslint-fix-file)
  (revert-buffer t t))

;; TODO: make this only add a hook to on save in web-mode
;; (add-hook 'web-mode, #'eslint-fix-file)
;;          (lambda ()
;;            (add-hook 'after-save-hook #'eslint-fix-file-and-revert)))
