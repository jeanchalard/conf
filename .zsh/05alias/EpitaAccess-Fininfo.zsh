#CONF static test `hostname` = "akiko"
alias e='ssh -p 10000 chalar_j@localhost'
eget () {
        total=""
        while [ -n "$1" ]
        do
                total="$total chalar_j@localhost:$1"
                shift
        done
        total="$total ." 
        scp -P 10000 `echo $total`
}
