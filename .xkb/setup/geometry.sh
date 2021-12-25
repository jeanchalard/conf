#!/usr/bin/zsh
pushd `pwd` > /dev/null
cd `dirname $0`
cd ..
dir=`pwd`
popd > /dev/null

xkbcomp -I${dir} ${dir}/anterak.xkb ${dir}/anterak.xkm
xkbprint -label symbols -color -eps anterak.xkm anterak.eps
okular anterak.eps

