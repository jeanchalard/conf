#CONF static test "$HOST" = "cobalt"
function get()
{
    rsync -r --links --bwlimit=2000 --partial --progress --rsh=ssh 192.168.0.2:$1 .
}
