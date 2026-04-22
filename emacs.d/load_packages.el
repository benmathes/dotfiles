;; Load el-get
;;(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;;
;;(unless (require 'el-get nil 'noerror)
;;  (require 'package)
;;  (add-to-list 'package-archives
;;	       '("melpa" . "http://melpa.org/packages/"))
;;  (package-refresh-contents)
;;  (package-initialize)
;;  (package-install 'el-get)
;;  (require 'el-get))
;;
;;(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;;(el-get 'sync)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path (expand-file-name "~/.emacs.d/el-get/el-get"))
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))

; derived from ELPA installation
; http://tromey.com/elpa/install.html
(defun eval-url (url)
  (let ((buffer (url-retrieve-synchronously url)))
  (save-excursion
    (set-buffer buffer)
    (goto-char (point-min))
    (re-search-forward "^$" nil 'move)
    (eval-region (point) (point-max))
    (kill-buffer (current-buffer)))))

;; Load ELPA
(add-to-list 'load-path "~/.emacs.d/elpa")

(defun install-elpa ()
  (eval-url "http://tromey.com/elpa/package-install.el"))

(defun install-el-get ()
  (eval-url
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"))

(unless (require 'el-get nil t)
  (install-el-get))

(el-get 'sync)
