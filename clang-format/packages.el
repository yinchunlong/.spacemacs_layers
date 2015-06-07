;;; packages.el --- clang-format Layer packages File for Spacemacs
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

(defvar clang-format-packages
  '(
    clang-format
    projectile
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar clang-format-excluded-packages '()
  "List of packages to exclude.")

(defun compile-in-projectile-root()
  (interactive)
  (let* ((project-root (projectile-project-root))
         (ninja-file (concat project-root "/build.ninja"))
         (is-ninja (file-exists-p ninja-file))
         (compile-command (if is-ninja "ninja" "scons clang.debug -j4")))
    (compile
     (format "cd %s;%s" project-root compile-command))))


(defun swd/best-match (this-file proj-root candidates)
  "Given a file, a project root, and a set of candidates, find
the candidate closest to path of the given file."
  (flet ((dir-path (x) (butlast (split-string x "/")))
         ;; given a list of distances and a list of candidates
         ;; return the candidate with the smallest distance
         (get-best (d c bd bc)
                   (cond
                    ((not (or d c)) bc)
                    ((< (car d) bd) (get-best (cdr d) (cdr c) (car d) (car c)))
                    (t (get-best (cdr d) (cdr c) bd bc))))
         ;; given two paths (each component a list element)
         ;; rm the common prefix
         (strip-common (p1 p2)
                          (cond
                           ((not (or p1 p2)) (list nil nil))
                           ((equalp (car p1) (car p2))
                            (strip-common (cdr p1) (cdr p2)))
                           (t (list p1 p2))))
         (path-distance (p1 p2)
                           (let ((l (strip-common p1 p2)))
                             (+ (length (first l)) (length (second l))))))

    (let* ((proj-root-path (split-string proj-root "/"))
           (this-path (car (strip-common
                            (dir-path this-file)
                            proj-root-path)))
           (dists
            (mapcar (lambda (x)
                      (path-distance this-path (dir-path x)))
                    candidates)))
      (get-best dists candidates (car dists) (car candidates)))))

(defun swd/find-other-file (&optional flex-matching)
    "Switch between files with the same name but different extensions.
With FLEX-MATCHING, match any file that contains the base name of current file.
Other file extensions can be customized with the variable `projectile-other-file-alist'."
    (interactive "P")
    (-if-let (other-files (projectile-get-other-files (buffer-file-name) (projectile-current-project-files) flex-matching))
        (if (= (length other-files) 1)
            (find-file (expand-file-name (car other-files) (projectile-project-root)))
          (find-file
           (concat (projectile-project-root)
                   (swd/best-match (buffer-file-name) (projectile-project-root) other-files))))
          (error "No other file found")))

;; For each package, define a function clang-format/init-<package-clang-format>
;;
(defun clang-format/init-clang-format ()
  "Initialize my package"
  (use-package clang-format
    :defer t
    :init
    (evil-leader/set-key
      "of" 'clang-format-region
      "oF" 'clang-format-buffer))
  (use-package projectile
    :defer t
    :init
    (progn
      (autoload 'projectile-find-other-file "projectile")
      (evil-leader/set-key
        "oo" 'swd/find-other-file)
      (evil-leader/set-key
        "oc" 'compile-in-projectile-root)
      (evil-leader/set-key
        "ows" 'window-configuration-to-register)
      (evil-leader/set-key
        "owr" 'jump-to-register)
      )))
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
