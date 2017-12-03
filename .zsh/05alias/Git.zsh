alias commit='git commit -a'
alias push='git push origin master'
log()
{
  git log --oneline --decorate $@
}
alias amend='git commit --amend -a'
alias aamend='EDITOR=true git commit --amend -a'
rbi()
{
  git rebase -i m/master
}
rbcc()
{
  git add .
  git rebase --continue
}
rbc()
{
  git rebase --continue
}
c()
{
  git cherry-pick $@
}

