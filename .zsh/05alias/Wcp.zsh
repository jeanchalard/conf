wcp()
{
    dest=$@[-1]
    source=$@[1,-2]
    machine=${dest%%:*}
    dir=${dest##*:}

    if [[ '' = ${dest//[^:]/} ]]
    then
	scp -r $source $dest
	return
    fi

    sourcedir=''
    mkdir -p /tmp/wcp
    sourcedir=`mktemp /tmp/wcp/XXXXXXXX`
    rm -f $sourcedir
    mkdir -p $sourcedir
    scp -r ${=source} $sourcedir
    cd $sourcedir

    tar -czf - {*,.*}(N) | ssh $machine sudo -u wvgs tar -C $dir -xzf -

    cd -
    rm -rf $sourcedir
}
compdef wcp=scp

