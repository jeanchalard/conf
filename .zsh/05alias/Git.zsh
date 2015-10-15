alias commit='git commit -a'
alias push='git push origin master'
log()
{
  git log --oneline --decorate $@
}

