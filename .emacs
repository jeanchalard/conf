; My libs
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

;; Load packages
(load "font-lock")
(require 'iso-transl)
;(require 'un-define)
;(require 'un-tools)
;(require 'cedet)
;(require 'ede)
;(global-ede-mode 1)                      ; Enable the Project management system
;(semantic-load-enable-excessive-code-helpers)      ; Enable prototype help and smart completion
;
;(require 'semantic-ia)
(let ((path "/usr/local/share/emacs/site-lisp/scala"))
  (setq load-path (cons path load-path))
  (load "scala-mode-auto.el"))

(defun scala-turnoff-indent-tabs-mode ()
  (setq indent-tabs-mode nil))

;; scala mode hooks
(add-hook 'scala-mode-hook 'scala-turnoff-indent-tabs-mode)



;;
;; Sanity
;;
(set-foreground-color "white")
(set-background-color "black")
(menu-bar-mode nil)
(scroll-bar-mode nil)
(tool-bar-mode nil)
(setq next-line-add-newlines nil)

;;
;; User friendliness
;;
(pc-selection-mode)
(setq default-major-mode 'text-mode)
(global-font-lock-mode t)
(auto-image-file-mode t)

;;
;; Bindings
;;
(global-set-key "" 'backward-delete-char)
(global-set-key "d" 'delete-trailing-whitespace)
(global-set-key "" 'do_insert_time)
(global-set-key "" 'std-file-header)
(global-set-key [f3]		'font-lock-mode)
(global-set-key [f4]		'kill-this-buffer)
(global-set-key [f12]		'goto-line)
(global-set-key [delete]        'delete-char)
(global-set-key [home]          'beginning-of-line)
(global-set-key [end]           'end-of-line)
(global-set-key [C-home]         'beginning-of-buffer)
(global-set-key [C-end]          'end-of-buffer)
(global-set-key [kp-divide]     '(lambda nil (interactive) (insert ?/)))
(set-keyboard-coding-system	'utf-8)

;;
;; mail and news
;;

; Don't know what this means. Remove it sometime.
(setq smtpmail-local-domain "wni.co.jp")
(setq c-argdecl-indent 0)
(setq c-mode-hook		'(font-lock-mode))
(setq c++-mode-hook		'(font-lock-mode))
(setq makefile-mode-hook	'(font-lock-mode))
(setq user-full-name		"Jean Chalard")
(setq mail-host-address		"wni.co.jp")
(setq user-mail-address		"jeanc@wni.co.jp")
(setq gnus-article-display-hook         '(gnus-article-highlight gnus-article-hide-headers))
(add-hook 'text-mode-hook 'text-mode-hook-identify)
(add-hook 'text-mode-hook 'turn-on-auto-fill)



(defun substract-to-region (value)
 "This function substracts value to the number between point and mark"
 (interactive "p")
 (save-excursion
   (insert-string (int-to-string (- (string-to-int
    (delete-and-extract-region (point) (mark))) value)))))

(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.xhtml\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . html-mode))

;;
;; russian roulette
;;
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly) (defun up-one () (interactive)
(scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one) (defun up-a-lot () (interactive)
(scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;; Stop delete-trailing-whitespace from wiping the space after the
;; signature delimiter.
(defmacro get-current-line()
  "Current line string"
  (buffer-substring (save-excursion (beginning-of-line) (point))
                    (save-excursion (end-of-line) (point))))

(defun delete-trailing-whitespace ()
  "Delete all the trailing whitespace across the current buffer.
All whitespace after the last non-whitespace character in a line is
deleted.
This respects narrowing, created by \\[narrow-to-region] and friends.
A formfeed is not considered whitespace by this function.
News' signature compliant."
  (interactive "*")
  (save-match-data
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\\s-$" nil t)
        (if (string-match "^-- $" (get-current-line))
            (end-of-line)
          (skip-syntax-backward "-" (save-excursion (forward-line 0) (point)))
          ;; Don't delete formfeeds, even if they are considered whitespace.
          (save-match-data
            (if (looking-at ".*\f")
                (goto-char (match-end 0))))
          (delete-region (point) (match-end 0)))))))


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-image-file-mode nil nil (image-file))
 '(browse-url-browser-function (quote browse-url-kde))
 '(browse-url-galeon-program "konqueror")
 '(browse-url-mosaic-program "konqueror")
 '(browse-url-mozilla-program "konqueror")
 '(browse-url-netscape-program "konqueror")
 '(ecb-options-version "2.32")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(partial-completion-mode t nil (complete))
 '(show-trailing-whitespace t)
 '(track-eol t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "grey")))))
(prefer-coding-system 'utf-8)


;;(set-fontset-font "fontset-startup"
;;                  'mule-unicode-2500-33ff
;;                  "-*-*-medium-*-*-*-*-*-*-*-*-*-*-*")


;; Sample codes.
;; This is code that asks for a class name - defaulting to the class
;; the point seems to be currently in - and inserts some arbitrary
;; code depending on this class name. Then, it auto-indents it.
;; It binds this function on ^O.


;; (global-set-key "" 'foo)
;;
;; (defun find-class-name ()
;;   ""
;;   (save-excursion
;;     (re-search-backward "class \\([a-zA-Z]+\\)")
;;     (match-string 1)
;;   )
;; )
;; (defun find-superclass ()
;;   ""
;;   (save-excursion
;;     (re-search-backward ":\s*public \\([a-zA-Z]+\\)\s*{")
;;     (match-string 1)
;;   )
;; )
;;
;;
;; (defun foo ()
;;  "Foo"
;;  (interactive "")
;;  (indent-region
;;   (point)
;;   (save-excursion
;;     (insert-string (concat "virtual ostream& toString(ostream& out) const
;; {
;;   out << \"" (read-from-minibuffer "Class name : " (find-class-name)) " ::: (\";
;;   return " (find-superclass) "::toString(out) << \")\";
;; }
;; " ))
;;     (point))
;;   )
;; )



(load (expand-file-name "~/.emacs.d/sbt.el"))
;(if (load "scim-bridge" t)
;    (progn
;      (add-hook 'after-init-hook 'scim-mode-on)
;      (scim-define-common-key (kbd "C-\\") t)
;      (scim-define-common-key (kbd "C-SPC") nil)
;      )
;)
