;;; packages.el --- pbcopy Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defvar pbcopy-packages
  '(
    pbcopy
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar pbcopy-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function pbcopy/init-<package-pbcopy>
;;
(defun pbcopy/init-pbcopy ()
  "Initialize my package"
  (use-package pbcopy
    :if (not (display-graphic-p))
    :init (turn-on-pbcopy)))
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
