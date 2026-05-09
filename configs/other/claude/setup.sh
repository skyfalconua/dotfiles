#!/bin/sh
todir="$HOME/.claude"
mkdir -p "$todir"

cp -vf "$(pwd)/settings.json" "$todir/settings.json"
cp -vf "$(pwd)/statusline.jq" "$todir/statusline.jq"

echo "Copied config to $todir"
