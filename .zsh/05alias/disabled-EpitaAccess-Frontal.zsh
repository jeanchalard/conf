#CONF static test `hostname` = "hatsuki"
alias e='ssh -p 42 chalar_j@ssh.epita.fr'
eget () {
	total=""
	while [ -n "$1" ]
	do
		total="$total chalar_j@ssh.epita.fr:$1"
		shift
	done
	total="$total ."
	scp -P 42 `echo $total`
}
