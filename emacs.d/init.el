;; first load all elpa/melpa packages
;; Note: package-initialize is called automatically in Emacs 27+
;; Suppress "Package autoload is deprecated" warning from el-get
(let ((warning-suppress-log-types '((obsolete)))
      (warning-suppress-types '((obsolete))))
  (load-file (expand-file-name "~/.emacs.d/load_packages.el")))

;; my personal customizations
(add-to-list 'load-path (expand-file-name "~/.emacs.d/personal/"))
;; adding to load path doesn't actually load those files, just
;; tells emacs to include that directory when searching for files.
;; Here we manually load all files in /personal
(mapc 'load (file-expand-wildcards "~/.emacs.d/personal/*.el"))


(defun package-upgrade-all ()
  "Upgrade all packages automatically without showing *Packages* buffer."
  (interactive)
  (package-refresh-contents)
  (let (upgrades)
    (cl-flet ((get-version (name where)
                (let ((pkg (cadr (assq name where))))
                  (when pkg
                    (package-desc-version pkg)))))
      (dolist (package (mapcar #'car package-alist))
        (let ((in-archive (get-version package package-archive-contents)))
          (when (and in-archive
                     (version-list-< (get-version package package-alist)
                                     in-archive))
            (push (cadr (assq package package-archive-contents))
                  upgrades)))))
    (if upgrades
        (when (yes-or-no-p
               (message "Upgrade %d package%s (%s)? "
                        (length upgrades)
                        (if (= (length upgrades) 1) "" "s")
                        (mapconcat #'package-desc-full-name upgrades ", ")))
          (save-window-excursion
            (dolist (package-desc upgrades)
              (let ((old-package (cadr (assq (package-desc-name package-desc)
                                             package-alist))))
                (package-install package-desc)
                (package-delete  old-package)))))
      (message "All packages are up to date"))))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(global-rainbow-delimiters-mode nil)
 '(package-selected-packages
   '(ag agent-shell alchemist anaconda-mode auto-complete autopair
        claude-shell clojure-test-mode coffee-mode column-marker
        columnify desktop elpy emacsql enh-ruby-mode ess
        fill-column-indicator find-file-in-git-repo flow-minor-mode
        flx-ido flycheck flymake flymake-jslint flymake-ruby
        flymake-sass fuzzy gh-md git-blame
        git-commit-training-wheels-mode git-rebase-mode
        gitattributes-mode gitconfig-mode gitignore-mode go-mode
        grizzl haskell-mode highlight-parentheses icicles idomenu
        iedit ipython jinja2-mode js2-mode json-rpc jsx-mode jump
        less-css-mode markdown-mode markdown-preview-eww nlinum nose
        pg php-mode prettier-js projectile-rails py-autopep8
        pyenv-mode pymacs queue rainbow-delimiters rainbow-mode
        rjsx-mode robe rubocop ruby-compilation ruby-mode rvm
        sass-mode scala-mode scss-mode sublimity swift-mode virtualenv
        virtualenvwrapper visual-regexp visual-regexp-steroids
        web-mode yaml-mode))
 '(web-mode-attr-indent-offset 2)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-enable-auto-indentation t)
 '(web-mode-markup-indent-offset 2)
 '(web-mode-sql-indent-offset 2))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-black ((t (:background "gray" :foreground "black"))))
 '(diff-added ((t (:inherit diff-changed :foreground "green"))))
 '(diff-header ((t nil)))
 '(diff-indicator-added ((t (:inherit diff-added :foreground "green"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red"))))
 '(enh-ruby-op-face ((t (:foreground "color-89"))))
 '(enh-ruby-string-delimiter-face ((t (:foreground "color-75"))))
 '(flymake-error ((t (:underline "brightred"))))
 '(flymake-warning ((t (:underline "brightred"))))
 '(font-lock-comment-face ((t (:foreground "brightblack"))))
 '(font-lock-doc-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-function-name-face ((t (:foreground "color-99"))))
 '(font-lock-keyword-face ((t (:foreground "color-93"))))
 '(font-lock-string-face ((t (:foreground "color-75"))))
 '(font-lock-type-face ((t (:foreground "#ffff00"))))
 '(font-lock-variable-name-face ((t (:foreground "sienna"))))
 '(font-lock-warning-face ((t (:inherit error :foreground "green"))))
 '(highlight-indentation-face ((t nil)))
 '(js2-object-property ((t (:foreground "color-130"))))
 '(minibuffer-prompt ((t (:foreground "brightcyan"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "#aa3456"))))
 '(rainbow-delimiters-mismatched-face ((t (:background "#ff0000" :foreground "#ffff00"))))
 '(rjsx-tag ((t (:foreground "color-100"))))
 '(rjsx-tag-bracket-face ((t (:inherit rjsx-tag))))
 '(rst-level-2 ((t (:foreground "color-62"))))
 '(smerge-markers ((t (:background "#333"))))
 '(smerge-mine ((t (:background "color-53"))) t)
 '(smerge-other ((t (:background "color-64"))) t)
 '(smerge-refined-added ((t (:inherit smerge-refined-change :background "color-17"))))
 '(smerge-refined-removed ((t (:inherit smerge-refined-change :background "#100"))))
 '(vc-annotate-face-CCFFDE ((t (:background "color-28"))) t)
 '(vc-annotate-face-D2FFCC ((t (:background "color-22"))) t)
 '(vc-annotate-face-EAFFCC ((t (:background "color-34"))) t)
 '(vc-annotate-face-FF3F3F ((t (:foreground "#FF3F3F"))) t)
 '(vc-annotate-face-FFCCCC ((t (:background "color-88"))) t)
 '(web-mode-html-tag-bracket-face ((t (:foreground "color-58"))))
 '(web-mode-html-tag-face ((t (:foreground "color-58")))))
