#CONF static [[ "$HOST" == *.google.com ]]
function deleteCL()
{
  p4 changes -u jchalard -s pending | grep $1 | sed 's/Change \([0-9]\+\).*jchalard@\([^ ]\+\).*/g4 -p 1 -c \2 revert -c \1/'
}
