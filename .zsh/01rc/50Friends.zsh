#CONF static test -f $HOME/perso/friends
# My friends
while read i;
do
  alias -g ${i/ /=};
  eval "export ${i/ /=~}";
done < $HOME/perso/friends
