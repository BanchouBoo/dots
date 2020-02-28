;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! dotnet)
(package! edit-server)
(package! xresources-theme :recipe (:host github :repo "BanchouBoo/xresources-theme")) ; my fork uses xrdb instead of x-get-resource, which makes it work in terminal
