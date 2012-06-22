#CONF static test "$HOST" = "cobalt"
function put()
{
    rsync -r --links --bwlimit=2000 --partial --progress --rsh=ssh $1 192.168.0.2:$2
}
