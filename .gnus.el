(setq user-mail-address "jean.chalard@gmail.com")
(setq user-full-name "Jean Chalard")
(load-library "smtpmail")
(load-library "nnimap")
(load-library "starttls")
(setq gnus-select-method '(nnimap "imap.gmail.com"
           (nnimap-address "imap.gmail.com")
           (nnimap-server-port 993)
           (nnimap-authinfo-file "~/.authinfo")
           (nnimap-stream ssl)))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587 "jean.chalard@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-local-domain "cobalt.jeanchalard.org")

(setq gnus-posting-styles
      '((".*"
         (signature-file "~/.signature")
         (name "Jean Chalard")
	 (address "jean.chalard@gmail.com")
         )))

(setq mail-yank-prefix "> ")
(setq gnus-treat-display-smileys nil)
(setq-default case-fold-search t)
(setq gnus-topic-display-empty-topics t)
(setq gnus-article-display-hook         '(gnus-article-highlight gnus-article-hide-headers))
(setq message-hidden-headers "\\(X-\\)?Face")
(setq nnmail-crosspost nil)
(setq nnimap-split-crosspost nil)
(setq nnmail-resplit-incoming t)
(setq gnus-article-skip-boring t)

(custom-set-variables
 '(gnus-group-line-format "%M%S%p%P%5y: %(%C%)%l
"))

(cond (window-system
       (setq custom-background-mode 'light)
       (defface read-group-face
	 '((t (:foreground "PaleGreen3" :bold t))) "Read groups")
       (defface unread-group-face
	 '((t (:foreground "SteelBlue1" :bold t))) "Unread groups")))

(setq gnus-group-highlight
      '(((zerop unread) . read-group-face)
	(t . unread-group-face)))

;(setq gnus-message-archive-method '(nnimap ""
;					   (nnimap-inhibit-expiry t)))
;(setq gnus-message-archive-group "INBOX/Sent")

;(setq nnimap-split-inbox '("INBOX"))
;(setq nnimap-split-rule
;      '(("INBOX/Bouygues subscriber report" "^Subject:.*BOUYGUES-FR-SUB.*")
;	("INBOX/Gnus" "^From: .*gnus.org")
;	("INBOX/machine reports" "^Subject: .*run output")
;	("INBOX/J" "^To: .*jeanc.*\\|Cc: .*jeanc.*\\|CC: .*jeanc.*\\|From: wvgs@mwsjpgen.*")
;	("INBOX/junk" "")))
;;(setq nnmail-split-methods
;      '(("Bouygues subscriber report" "^Subject:.*BOUYGUES-FR-SUB.*")
;	("mws" "^Subject: .*MWS-PROJ.*")
;	("mobileengine" "Subject: .*MOBILEENGINE-ERRORS.*")
;	("junk" "^Subject:.*I-Mode subscriptions.*\\|^From:.*maedam@mobdev.*\\|^From: withstation@wni.com\\|^From: mobile-support@wni.com\\|^Subject:.*mirror_.*")
;	("junk" "")))
;

(require 'nnir)

;(setq smtpmail-local-domain "epita.fr")
;(setq mail-host-address     "epita.fr")
;(setq user-full-name        "J")
;(setq nnml-directory        "~/Mail")
;(setq nnmail-spool-file     "/var/mail/chalar_j")
;(setq mail-default-reply-to "jean.chalard@epita.fr")
;(setq user-mail-address "jean.chalard@epita.fr")
;(custom-set-variables
; '(smtpmail-smtp-server "smtp.epita.fr")
; '(smtpmail-debug-info t)
; '(display-time-day-and-date t)
; '(display-time-mode t nil (time))
; '(mail-signature nil)
; '(smtpmail-default-smtp-server "smtp.epita.fr")
; '(smtpmail-smtp-service 25)
; '(rmail-delete-after-output t) ;to move file when copyed
; '(mail-host-address     "epita.fr")
; )

;  (define-mail-alias "Jash" "van-ma_j")
;  (define-mail-alias "Bourin" "idris_r")
;  (define-mail-alias "Larry" "migeot_o")
;  (define-mail-alias "Rubix" "leclan_o")
;  (define-mail-alias "Elrond" "poss_r")
;  (define-mail-alias "Astrid" "wang_a")
;  (define-mail-alias "Nico" "barada_n")

;; on change la configuration du buffer sommaire pour conserver
;; l'affichage des groupes sur la gauche et l'affichage du sommaire
;; à droite
;(gnus-add-configuration
; '(summary
;   (horizontal 1.0
;	       (vertical 0.3 (group 1.0))
;	       (vertical 1.0 (summary 1.0 point)))))

;; on change la configuration du buffer article pour conserver
;; l'affichage des groupes sur la gauche, l'affichage du sommaire en
;; haut à droite et l'affichage des messages en bas à droite
;(gnus-add-configuration
; '(article
;   (horizontal 1.0
;	       (vertical 25 (group 1.0))
;	       (vertical 1.0
;			 (summary 0.16 point)
;			 (article 1.0)))))

;(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; (defvar gnus-x-face-file (expand-file-name "~/News/J.x-face"))
;; (defun eole-message-insert-x-face ()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (search-forward mail-header-separator)
;;     (beginning-of-line nil)
;;     (insert "X-Face: ")
;;     (insert-file gnus-x-face-file)))
;; (add-hook 'message-setup-hook 'eole-message-insert-x-face)

;(setq gnus-secondary-select-methods
;      '((nnml "private") ))
;(setq gnus-message-archive-method
;      '(nnfolder "archive"
;		 (nnfolder-inhibit-expiry t)
;		 (nnfolder-active-file "~/News/sent-mail/active")
;		 (nnfolder-directory "~/News/sent-mail/")))

;(setq gnus-message-archive-group "sent")

;;(setq nnmail-split-methods
;;      '(
;;	("Jashugan" "^From:.*[Vv]an-[mM]a")
;;	("Jashugan" "^From:.*[Jj]ash.*")
;;
;;	("Epita" "^From:.*@epita.fr.*")
;;
;;	("Other" "")
;;	)
;;      )

;; (setq message-default-headers
;;       (with-temp-buffer
;; 	(insert "X-Face: ")
;; 	(insert-file-contents "~/News/J.x-face")
;; 	(beginning-of-line nil)
;; 	(insert "Face: ")
;; 	(insert-file-contents "~/News/NecroBorg.face")
;; 	(buffer-string)))

;; (setq gnus-home-score-file
;;       "SCORE")
