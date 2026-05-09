#!/bin/sh
_setup() { (echo "---- $1 ----" && cd base/$1 && bash setup.sh) }

_setup nano
_setup micro
_setup git
_setup gitui
_setup mc
_setup tmux
_setup htop
_setup yazi
_setup zed
_setup wezterm

unset _setup
