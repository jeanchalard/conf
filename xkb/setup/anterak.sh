#!/usr/bin/zsh
pushd `pwd` > /dev/null
cd `dirname $0`
cd ..
dir=`pwd`
popd > /dev/null

xkbcomp -I${dir} ${dir}/anterak.xkb $DISPLAY 2>&1 | grep -v 'Key .* not found\|Symbols ignored'
:

