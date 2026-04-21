#!/bin/sh
mkdir -p "$HOME/.config/ghostty"

to="$HOME/.config/ghostty/config.ghostty"
cp -f "$(pwd)/config.ghostty" $to
echo "Created $to"
