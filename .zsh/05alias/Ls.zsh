if [[ `ls --color >& /dev/null ; print $?` == 0 ]]
then
  alias l='ls -l --color'
  alias la='ls -la --color'
else
  alias l='ls -l'
  alias la='ls -la'
fi
