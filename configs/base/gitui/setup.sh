#!/bin/sh
if command -v cygpath &>/dev/null; then
  appdata=$(cygpath "$APPDATA")
  confdir="$appdata/gitui"
else
  confdir="$HOME/.config/gitui"
fi

mkdir -p "$confdir"

to="$confdir/key_bindings.ron"
cp -f "$(pwd)/key_bindings.ron" $to
echo "Created $to"
