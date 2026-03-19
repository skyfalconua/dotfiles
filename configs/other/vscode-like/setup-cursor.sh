#!/bin/sh

APPNAME="Cursor"

# -- read parameters -- -- --

REPLACE=""

for i in "$@"; do
  case $i in
    --replace) REPLACE="(replaced)"; shift;;
    *) ;;
  esac
done

# -- get userdir -- -- --

userdir=""

case "$(uname -s)" in
  Darwin) userdir="$HOME/Library/Application Support/$APPNAME/User" ;;
  # Linux)  userdir="$HOME/.config/..." ;;
  *) ;;
esac

if command -v cygpath &>/dev/null; then
  appdata=$(cygpath "$APPDATA")
  userdir="$appdata/$APPNAME/User"
fi

if [ -z "$userdir" ]; then
  echo "userdir is not found"
  exit
fi

# -- copy files -- -- --

mkdir -p "$userdir"

if [ -n "${REPLACE}" ]; then
  rm -rf "${userdir}" && mkdir "${userdir}"
elif [ ! -d "$userdir" ]; then
  mkdir "$userdir"
else
  echo "note: to replace settings run:"
  echo "  bash setup.sh --replace"
fi

cp -rf ./user-settings/* "${userdir}"

# for ext in $(cat "./extensions.txt"); do
#   todo --install-extension "$ext"
# done

echo "Created '${userdir}' ${REPLACE}"
