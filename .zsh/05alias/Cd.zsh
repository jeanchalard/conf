alias 'cd..'='builtin cd ..'
alias -- '-'='cd -'
cd () {
        if [[ ${1[$(($#1-1)),$#1]} = '/l' && ! -d $1 ]]
        then
                builtin cd ${1%%/l}
                ls -l
        else
                if [[ ! -d $1 && -f $1 ]]
                then
                        builtin cd `dirname $1`
                else
                        builtin cd $@
                fi
        fi
}
