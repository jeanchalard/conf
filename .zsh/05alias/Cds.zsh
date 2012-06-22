#CONF static which iselect
cds () {
   local DIR="$PWD"
   if [[ ! -z "$dirstack" ]]; then
       DIR=$(print -rl $dirstack | tac \
           | iselect -a -f -n chdir -Q "$PWD" -t "Change directory to..." -p ${#dirstack})
   fi
   cd "$DIR"
}
