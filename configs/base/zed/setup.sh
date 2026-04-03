#!/bin/sh
if command -v cygpath &>/dev/null; then
  appdata=$(cygpath "$APPDATA")
  zdir="$appdata/Zed"
else
  zdir="$HOME/.config/zed"
fi

mkdir -p "$zdir/themes"

cpzed() {
  local to="$zdir/$1"
  cp -f "$(pwd)/$1" $to
  echo "Created $to"
}

cpzed "themes/my-mixed-theme.json"
cpzed "settings.json"
cpzed "keymap.json"

