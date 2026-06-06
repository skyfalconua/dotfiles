podman-machine-update() {
  if [ -z "$1" ]; then
    echo "usage: podman-machine-update x.y"
    return
  fi
  podman machine os apply "quay.io/podman/machine-os:$1"
}

s3put() {
  if [ -z "$S3_DEFAULT_BUCKET" ]; then
    echo "Please set $S3_DEFAULT_BUCKET variable"
    return
  fi

  local filename="$1"
  if [ -z "$filename" ]; then
    echo "Usage: s3put somefile.png"
    return
  fi

  s3cmd put --acl-public --guess-mime-type $filename $S3_DEFAULT_BUCKET
}

rsng() {
  if [ $# -lt 2 ]; then
    echo "Usage: rsng <src> <dst> [any-rsync-option]" && return
  fi
  rsync --archive --recursive --update --perms \
    --compress --verbose --progress --exclude='.git/' "$@"
}

rsnm() {
	if [ $# -lt 2 ]
	then
		echo "Usage: rsds <src> <dst> [any-rsync-option]" && return
	fi
	noglob rsync --archive --recursive --update --perms \
	  --compress --verbose --progress --exclude='.git/' --exclude='.venv/' --exclude='node_modules/'  "$@"
}

function ffcut() {
  if [ $# -ne 3 ]; then
    echo "Usage example: ffcut video.mp4 00:01:30 00:02:45"
    return 1
  fi
  local input="$1" from="$2" to="$3" prefix="${4:-cut}"

  if [ "$from" = "x" ]; then; from="00:00:00"; fi
  if [ "$to" = "x" ]; then; to="99:59:59"; fi

  ffmpeg -ss "$from" -to "$to" -i "$input" -c copy "${prefix}_$input"
}

function ffjoin() {
  if [ $# -ne 2 ]; then
    echo "Usage example: ffjoin part1.mp4 part2.mp4"
    return 1
  fi
  local files="file '$(pwd)/$1'\nfile '$(pwd)/$2'"
  ffmpeg -f concat -safe 0 -i <(echo "$files") -c copy "$1__$2"
}

function ffomit() {
  if [ $# -ne 3 ]; then
    echo "Usage: ffomit <input> <remove_start> <remove_end>"
    return 1
  fi

  ffcut "$1"  "00:00:00"  "$2"        "_pre"  || return 1
  ffcut "$1"  "$3"        "99:59:59"  "_post" || return 1

  ffjoin "_pre__$1" "_post__$1"
  rm -f  "_pre__$1" "_post__$1"
}

function ffcrop() {
  if [ $# -ne 2 ]; then
    echo "Usage: ffcrop <input> <width>:<height>:<x>:<y>"
    return 1
  fi

  ffmpeg -i "$1" -vf "crop=$2" "crop_$1"
}

if is-darwin; then
  metube() {
    echo 'metube - http://localhost:15015' && echo
    container run -it --rm -p 15015:8081 -v `pwd`:/downloads ghcr.io/alexta69/metube
  }
else
  metube() {
    echo 'metube - http://localhost:15015' && echo
    podman run -it --rm -p 15015:8081 -v `pwd`:/downloads ghcr.io/alexta69/metube
  }
fi

# -- optional config -- -- --
[ -s "$HOME/.dotfiles/.local/_local.zsh" ] && source "$HOME/.dotfiles/.local/_local.zsh"
