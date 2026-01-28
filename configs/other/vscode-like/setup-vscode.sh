#!/bin/sh

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
  Darwin) userdir="$HOME/Library/Application Support/Code/User" ;;
  # Linux)  jetbrains_dir="$HOME/.config/..." ;;
  *) ;;
esac

if command -v cygpath >/dev/null 2>&1; then
   userprofile=$(cygpath "$USERPROFILE")
   userdir="$userprofile/AppData/Roaming/Code/User"
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
echo "Created '${userdir}' ${REPLACE}"
