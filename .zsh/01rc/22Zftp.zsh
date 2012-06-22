#CONF static test "$MACHTYPE" != "alpha"
# zftp. I like it, from time to time.
autoload zfinit
zmodload zsh/zftp
autoload -U zfanon zfautocheck zfcd zfcd_match zfcget zfclose zfcput zfdir zffcache zfgcp zfget zfget_match zfgoto zfhere zfinit zfls zfmark zfopen zfparams zfpcp zfput zfrglob zfrtime zfsession zfstat zftp_chpwd zftp_progress zftransfer zftype zfuget zfuput
