#!/bin/sh
mkdir -p "$HOME/.config/wezterm"

to="$HOME/.config/wezterm/wezterm.lua"
cp -f "$(pwd)/wezterm.lua" $to
echo "Created $to"
