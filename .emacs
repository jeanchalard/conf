;;;
; To allow loading libs not present everywhere.
(defun try-require (feature)
  "Attempt to load a library or module. Return true if the
library given as argument is successfully loaded. If not, instead
of an error, just add the package to a list of missing packages."
  (condition-case err
      ;; protected form
      (progn
        (message "Checking for library `%s'..." feature)
        (if (stringp feature)
            (load-library feature)
          (require feature))
        (message "Checking for library `%s'... Found" feature))
    ;; error handler
    (file-error  ; condition
     (message "Checking for library `%s'... Missing" feature)
     nil)))


;;;
; Load packages
;
; iso-transl : makes dead key work
(try-require 'iso-transl)
;
; iso-transl is missing dead-cedilla >.>
(add-to-list 'iso-transl-dead-key-alist '(?\, . dead-cedilla))
(iso-transl-define-keys iso-transl-char-map)
;
; uniquify : better buffer names for identical file names in different places
(try-require 'uniquify)
;
; CEDET : dev env
(try-require 'cedet)
(if (try-require 'ede)
    (progn
      (global-ede-mode 1)                      ; Enable the Project management system
;      (semantic-load-enable-excessive-code-helpers)      ; Enable prototype help and smart completion
      (try-require 'semantic-ia)
))
;
; Scala : inactive for now. Reactivate next time :)
; (let ((path "/usr/local/share/emacs/site-lisp/scala"))
;   (setq load-path (cons path load-path))
;   (load "scala-mode-auto.el"))
; (defun scala-turnoff-indent-tabs-mode ()
;   (setq indent-tabs-mode nil))
; ;; scala mode hooks
; (add-hook 'scala-mode-hook 'scala-turnoff-indent-tabs-mode)

(add-hook 'java-mode-hook
          (lambda ()
            (c-set-offset 'arglist-intro '++)
            (c-set-offset 'arglist-cont '++)
            (c-set-offset 'arglist-cont-nonempty '++)))

;;;
; Sanity
(set-foreground-color "white")
(set-background-color "black")
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(delete-selection-mode t)
(setq next-line-add-newlines nil)
(setq default-major-mode 'text-mode)
(global-font-lock-mode t)
(prefer-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq focus-follows-mouse t) ; Sloppy focus
(setq mouse-autoselect-window t) ; Sloppy focus
(column-number-mode t)
(auto-image-file-mode nil) ; Don't open images as images - not using emacs for that
(setq sentence-end-double-space nil) ; For filling, don't double space after periods

;;;
; Bindings
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


;;;
; Various modes setup
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.xhtml\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . html-mode))
; Text-mode
(add-hook 'text-mode-hook 'text-mode-hook-identify)
; Ruby-mode
(require 'ruby-mode)
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))
(setq ruby-insert-encoding-magic-comment nil)

;;;
; My functions
;
; Substract n from a region
(defun substract-to-region (value)
 "This function substracts value to the number between point and mark"
 (interactive "p")
 (save-excursion
   (insert-string (int-to-string (- (string-to-int
    (delete-and-extract-region (point) (mark))) value)))))


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
 '(browse-url-browser-function (quote browse-url-kde))
 '(browse-url-galeon-program "konqueror")
 '(browse-url-mosaic-program "konqueror")
 '(browse-url-mozilla-program "konqueror")
 '(browse-url-netscape-program "konqueror")
 '(fill-column 98)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(partial-completion-mode t)
 '(show-trailing-whitespace t)
 '(track-eol t)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "grey"))))
 '(trailing-whitespace ((((class color) (background dark)) (:background "darkgreen")))))

; Don't remove trailing whitespace on inserting new line
(defun turnoff-electric-indent-mode () (setq electric-indent-mode nil))
(add-hook 'text-mode-hook 'turnoff-electric-indent-mode)
(turnoff-electric-indent-mode)

; The following works with emacs 23+, not with emacs 22
(setq split-height-threshold nil)
(setq split-width-threshold 0)


;;;
; Test area. Don't leave too much crud accumulate here ; either make it
; permanent by moving it up in the appropriate place, or remove it.
(iswitchb-mode 1)
(require 'edmacro)
(defun iswitchb-local-keys ()
  (mapc (lambda (K)
          (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
        '(("<right>" . iswitchb-next-match)
          ("<left>"  . iswitchb-prev-match)
          ("<up>"    . ignore             )
          ("<down>"  . ignore             ))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)
(defadvice iswitchb-kill-buffer (after rescan-after-kill activate)
  "*Regenerate the list of matching buffer names after a kill.
    Necessary if using `uniquify' with `uniquify-after-kill-buffer-p'
    set to non-nil."
  (setq iswitchb-buflist iswitchb-matches)
  (iswitchb-rescan))
(defun iswitchb-rescan ()
  "*Regenerate the list of matching buffer names."
  (interactive)
  (iswitchb-make-buflist iswitchb-default)
  (setq iswitchb-rescan t))

;; Backups into a separate directory
(add-to-list 'backup-directory-alist '("." . "~/.saves") :append)
(customize-set-variable 'backup-by-copying t)
(customize-set-variable 'delete-old-versions t)
(customize-set-variable 'kept-new-versions 6)
(customize-set-variable 'kept-old-versions 2)
(customize-set-variable 'version-control t)
