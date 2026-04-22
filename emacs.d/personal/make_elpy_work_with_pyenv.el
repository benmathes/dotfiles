;; elpy + pyenv integration
(when (fboundp 'elpy-enable)
  (condition-case nil (elpy-enable) (error nil)))
(when (fboundp 'pyenv-mode)
  (condition-case nil (pyenv-mode) (error nil)))
(when (and (fboundp 'pyvenv-activate)
           (file-directory-p "/Users/bmathes/.pyenv/versions/global/"))
  (condition-case nil (pyvenv-activate "/Users/bmathes/.pyenv/versions/global/") (error nil)))
