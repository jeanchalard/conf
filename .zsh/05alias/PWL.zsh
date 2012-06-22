#CONF static test "$HOST" = "nayuki"
function unrpm()
{
    if [ "$2" = "" ];
    then
	echo "Usage : unrpm directory package";
    else
	mkdirhier $1/usr/src/redhat/
	if [ "$1[1]" != "/" ]
	then
	    rpm -i --force --noscripts --nodeps --notriggers --ignorearch --ignoreos --root `pwd`/$1 $2
	else
	    rpm -i --force --noscripts --nodeps --notriggers --ignorearch --ignoreos --root $1 $2
	fi
    fi
}
