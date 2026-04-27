#!/bin/sh
to="$HOME/.config/wezterm"
mkdir -p "$to"
cp -rf "./."  "$to/."
rm "$to/setup.sh"
echo "Copied configs $to"
