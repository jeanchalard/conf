alias commit='git commit -a'
alias push='git push origin master'
log()
{
  git log --oneline --decorate $@
}
logv()
{
  git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --stat
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
br()
{
  git branch --color -v | cat
}
