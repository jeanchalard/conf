#!/usr/bin/zsh

pushd `pwd` > /dev/null
cd `dirname $0`
dir=`pwd`

ln -sf ${dir}/.css ${dir}/.ctwmrc ${dir}/.dosbox ${dir}/.emacs ${dir}/.gnus.el ${dir}/.irbrc ${dir}/.xmodmap ${dir}/.xmodmap-inverse ${dir}/.Xresources ${dir}/.zsh ${dir}/.zshrc $HOME

popd > /dev/null
