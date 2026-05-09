#!/bin/sh
mkdir -p "$HOME/.config/opencode"
to="$HOME/.config/opencode/opencode.json"
cp -f "$(pwd)/opencode.jsonc" "$to"
echo "Created $to"
