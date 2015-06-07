(defvar rtags-packages
  '(
    rtags
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar rtags-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function rtags/init-<package-rtags>
;;
(defun rtags/init-rtags ()
  "Initialize my package"
  (use-package rtags
    :defer t
    :init
    (progn
      (evil-leader/set-key
        "or," 'rtags-find-references-at-point
        "or/" 'rtags-find-all-references-at-point
        "or<" 'rtags-find-references
        "orB" 'rtags-show-rtags-buffer
        "orE" 'rtags-preprocess-file
        "orG" 'rtags-guess-function-at-point
        "orO" 'rtags-goto-offset
        "orR" 'rtags-rename-symbol
        "orT" 'rtags-taglist
        "orX" 'rtags-fix-fixit-at-point
        "or[" 'rtags-location-stack-back
        "ore" 'rtags-reparse-file
        "orv" 'rtags-find-virtuals-at-point
        "or." 'rtags-find-symbol-at-point
        "or;" 'rtags-find-file
        "or>" 'rtags-find-symbol
        "orD" 'rtags-diagnostics
        "orF" 'rtags-fixit
        "orI" 'rtags-imenu
        "orP" 'rtags-print-dependencies
        "orS" 'rtags-display-summary
        "orV" 'rtags-print-enum-value-at-point
        "orY" 'rtags-cycle-overlays-on-screen
        "or]" 'rtags-location-stack-forward
        "orp" 'rtags-print-current-project
        )
      (setq rtags-completions-enabled t)
      (require 'company-rtags)
      (rtags-diagnostics)
      )
    )
  )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
