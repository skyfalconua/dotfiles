#!/bin/sh

email=$(git config --global --get 'user.email')
name=$(git config --global --get 'user.name')

echo_gitconfig() {
  cat "$(pwd)/_gitconfig" \
    | sed -e "s#__EMAIL__#${email}#" \
    | sed -e "s#__NAME__#${name}#"
}

gitto="$HOME/.gitconfig"
echo_gitconfig > $gitto
echo "Created $gitto"

# copy on Windows
if command -v cygpath &>/dev/null; then
  userprofile=$(cygpath "$USERPROFILE")
  gitto="$userprofile\\.gitconfig"

  echo_gitconfig > $gitto
  echo "Created $gitto"
fi
