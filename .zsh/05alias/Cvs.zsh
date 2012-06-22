#CONF static [[ "$HOST" == *.wni.co.jp ]]
function cvs()
{
  id wvgs >& /dev/null
  if [[ $? == 0 && $USER != wvgs ]]
  then
    print -u 2 "You're not wvgs : you're doing the Wrong Thing, go away"
  else
    user=${HOME/\/home\/}
    if [[ $HOME == /home/j ]]; then user=jeanc; fi
    for i in **/CVS/Root
    do
      grep $user $i >& /dev/null
      if [[ "$?" != "0" ]]
      then
        print -u 2 "Changing user in $i to $user"
        sed 's/:[^:@]*@/:'$user'@/' $i >! /tmp/j-cvs-tmp
        cat /tmp/j-cvs-tmp >! $i
      fi
    done
    rm -f /tmp/j-cvs-tmp
    command cvs $@
  fi
}
