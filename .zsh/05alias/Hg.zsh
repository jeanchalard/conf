#CONF static which hg
alias resl='hg resolve -l'
res()
{
    mode=$1
    if [[ $# -gt 0 ]]; then
        shift
    fi
    case $mode in
        l) hg resolve -l;;
        m) hg resolve --mark $@;;
        e) x=`hg resolve -l | grep \^U | head -n 1 | cut -c 3-`;
           print $x;
           emacs ~/az/$x;;
        f) hg resolve -l | grep \^U | head -n 1 | cut -c 3-;;
        ff) hg resolve --mark ~/az/`hg resolve -l | grep \^U | head -n 1 | cut -c 3-`;;
        *) print "res l : list files to resolve";
           print "res m <files> : mark files as resolved";
           print "res f : show first file to resolve";
           print "res ff : resolve first file ; equivalent to 'res m ~/az/\`res f\`'";
           print "res e : emacs first file to resolve";;
    esac
}
graft()
{
  hg graft -r $1 .
}
untag ()
{
  cl=$1
  f=~/az/.hg/localtags
  cp $f ${f}.adopt.save
  cat ${f}.adopt.save | sed 's# cl/'$cl'$##' >| $f
}
adopt ()
{
  cl=${2#cl/}
  change=$1
  untag $2
  hg tag --local -r $change cl/$cl
}

deobsolete ()
{
  desc=$1
  if [[ $desc = '' ]]; then
    print "Usage : deobsolete <pattern>"
    print "Finds changes matching pattern, figures out the CL, and tags it on the non-obsolete change."
    print "If multiple non-obsolete changes match the pattern, will print out all SHAs ; TODO : support passing the SHA as a second arg to disambiguate."
    return
  fi
  prev=''
  cl=''
  typeset -a shas
  hg xl | while read i; do
    if [[ $i = *$desc* ]]; then
      if [[ $prev = *\ cl/* ]]; then
        if [[ $cl != '' ]]; then
          print "Multiple CLs found :" $cl ${${prev##* cl/}%% *}
          return
        fi
        cl=${${prev##* cl/}%% *}
      else
        shas=($shas ${${prev%% jchalard*}##* })
      fi
    fi
    prev=$i
  done
  if [[ $cl == "" ]]; then
    print "Can't find CL"
  fi
  if [[ $#shas = 0 ]]; then
    print "Can't find a non-obsolete commit"
    return
  elif [[ $#shas != 1 ]]; then
    print "Multiple commits found :" $shas
    return
  fi
  print Assigning cl/$cl to $shas
  f=~/az/.hg/localtags
  cp $f ${f}.adopt.save
  cat ${f}.adopt.save | sed 's# cl/'$cl'$##' >| $f
  hg tag --local -r $shas cl/$cl
}


cl: ()
{
  desc=$1
  if [[ $desc = '' ]]; then
    print "Usage : cl:<pattern>"
    print "Finds the commit matching the pattern. Returns 0 if found exactly one, 255 otherwise."
    return
  fi
  prev=''
  typeset -a shas
  hg xl | while read i; do
    if [[ $i = *$desc* ]]; then
      shas=($shas ${${prev%% jchalard*}##* })
    fi
    prev=$i
  done
  if [[ $#shas = 0 ]]; then
    print "Can't find a commit"
    return 255
  elif [[ $#shas != 1 ]]; then
    print "Multiple commits found :" $shas
    return 255
  fi
  print $shas
}
co()
{
    hg checkout `cl: $1`
}
