;; angular-mode.el

;; Angular Mode is based on JavaScript mode. It adds keyword
;; highlighting for important functions that are part of core
;; AngularJS.

;; Copyright (C) 2013 Rudolf Olah <omouse@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

(defvar angular-font-lock-keywords
  (list
   ;; global api
   (regexp-opt
    '("angular.bind"
      "angular.bootstrap"
      "angular.copy"
      "angular.element"
      "angular.equals"
      "angular.extend"
      "angular.forEach"
      ".forEach"
      "angular.fromJson"
      "angular.identity"
      "angular.injector"
      "angular.isArray"
      "angular.isDate"
      "angular.isDefined"
      "angular.isElement"
      "angular.isFunction"
      "angular.isNumber"
      "angular.isObject"
      "angular.isString"
      "angular.isUndefined"
      "angular.lowercase"
      "angular.mock"
      "angular.module"
      ".module"
      "angular.noop"
      "angular.toJson"
      "angular.uppercase"
      "angular.version"))
   ;; services
   "$anchorScroll"
   "$animate"
   "$cacheFactory"
   "$compile"
   "$controller"
   "$document"
   "$exceptionHandler"
   "$filter"
   (regexp-opt '("$http" "$httpBackend"))
   (regexp-opt '("$interpolate" "$interval"))
   (regexp-opt '("$locale" "$location"))
   "$log"
   "$parse"
   "$q"
   (regexp-opt '("rootElement" "rootScope"))
   (regexp-opt '("sce" "sceDelegate"))
   "$templateCache"
   "$timeout"
   "$window"
   ;; controllers
   "$scope"
))

(define-derived-mode angular-mode
  javascript-mode
  "JavaScript[Angular]"
  "Major mode for AngularJS.
\\{javascript-mode-map}"
  (setq font-lock-defaults (list
                            (cons 'angular-font-lock-keywords
                                  js--font-lock-keywords))))

(provide 'angular-mode)
