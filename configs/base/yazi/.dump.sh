#!/bin/sh

if [ ! -d "$HOME/.config/yazi" ]; then
  echo "yazi config not found"
  exit
fi

cp -rf "$HOME/.config/yazi/." .
rm -f "package.toml"

mv -f "./flavors/catppuccin-frappe.yazi" "./catppuccin-frappe.yazi"
rm -f "./catppuccin-frappe.yazi/preview.png"

rm -rf "./flavors" && mkdir "./flavors"
mv -f "./catppuccin-frappe.yazi" "./flavors/catppuccin-frappe.yazi"

echo "yazi config copied"
