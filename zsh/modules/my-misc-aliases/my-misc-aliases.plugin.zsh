alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias grepr="GREP_COLOR='1;31' grep --color=always"
alias grepg="GREP_COLOR='1;32' grep --color=always"
alias grepy="GREP_COLOR='1;33' grep --color=always"
alias grepb="GREP_COLOR='1;34' grep --color=always"
alias grepm="GREP_COLOR='1;35' grep --color=always"
alias grepc="GREP_COLOR='1;36' grep --color=always"

alias rggt="rg -g '!**/generated/**' -g '!**/*Test.kt' -g '!**/test_*.py' -g '!**/*.spec.*' -g '!**/*.test.*'"
alias rgg="rg -g '!**/generated/**'"

alias podps="podman ps --format 'table {{.Image}}\t{{.Ports}}\t{{.Status}}\t{{.Names}}'"
alias deno-file-server="deno run -A jsr:@std/http/file-server"
alias fb2rmhref="sd '<a\s+[^>]*l:href[^>]*>(.*?)</a>' ''"
alias npm-lsglobal="npm list --global --depth 0"
alias vv="NVIM_APPNAME=nvim-minimax nvim"
alias qr8="qrencode -t ANSI256UTF8"
alias mc="command mc --nosubshell"
alias gitt="gitui --watcher"
alias bmk="bash makefile.sh"
alias syncto="dfb-syncto"
alias uvp="uv run poe"
alias m="micro"
alias y="yazi"

podman-machine-update() {
  if [ -z "$1" ]; then
    echo "usage: podman-machine-update x.y"
    return
  fi
  podman machine os apply "quay.io/podman/machine-os:$1"
}

str-lower() {
  awk '{print tolower($0)}'
}

str-upper() {
  awk '{print toupper($0)}'
}

str-trim() {
  sed -r 's/^ *//; s/ *$//'
}

command-exists() {
  command -v "$1" &> /dev/null
}

ps5() {
  ps aux | sort -nrk 3,3 | head -n 5
}

mo() {
  micro $(fzf --reverse --height 40%)
}

path-remove() {
  local pth=":$PATH"    # add leading colon
  pth=${pth//":$1"/""}  # remove path prefixed with colon
  PATH="${pth#:}"       # remove leading colon
}

path-prepend() {
  path-remove "$1"
  PATH="$1:$PATH"
}

# similar to utils in .zprezto/modules/helper/init.zsh
function is-cursor {
  [[ -n "${CURSOR_TRACE_ID}" ]]
}
function is-vscode {
  [[ "$TERM_PROGRAM" == vscode ]]
}
function is-zed {
  [[ "$TERM_PROGRAM" == zed ]]
}
function is-msys {
  [[ "$OSTYPE" == msys* ]] || [[ "$OSTYPE" == cygwin ]]
}

dfb-chmodx() {
  for f in `ls $HOME/.dotfiles/bin | grep -v .gitignore | grep -v tmp`
  do
    chmod +x "$HOME/.dotfiles/bin/$f"
    echo "$f"
  done
}

dfb-var-set() {
  local name="$1"
  local val="$2"

  if [ -z "$name" ] || [ -z "$val" ]; then
    echo 'Usage: dfb-var-set name value'
    return
  fi

  local fname="$HOME/.dotfiles/.vars/$name"
  printf '%s' "$val" > "$fname"
}

dfb-var() {
  local name="$1"
  local askorsilent="$2"

  local fname="$HOME/.dotfiles/.vars/$name"
  local val=""

  if [ -e $fname ]; then
    val=`cat $fname | xargs`
  fi

  if [ -n "$val" ] || [ "$askorsilent" = "--silent" ]; then
    eval "export $name=\"$val\""
    return
  fi

  if [ -z "$val" ] || [ "$askorsilent" = "--ask" ]; then
    local newval=""
    read "newval?Please enter $name ($val): "
    if [ -n "$newval" ]; then
      val="$newval"
      dfb-var-set "$name" "$val"
    fi
  fi

  if [ -z "$val" ]; then
    dfb-var "$name"
    return
  fi
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

kill-by-grep() {
  local process_name="$1"

  if [ -z "$process_name" ] ; then
    echo 'Usage: kill-by-grep <process-grep>'
    return
  fi

  ps aux | grep "$process_name" | grep -v grep | awk '{print $2}' | xargs kill -9
}

if is-linux; then
  open() {
    (xdg-open "$1" &>/dev/null &)
  }
fi

if is-darwin; then
  alias dequarantine="xattr -d com.apple.quarantine"

  tar() {
    COPYFILE_DISABLE=1 command tar --no-xattrs $@
  }

  pbcd() {
    cd $(dirname $(pbpaste))
  }

  osx-fix-menu-items() {
    local CoreServices="/System/Library/Frameworks/CoreServices.framework"
    local LaunchServices="${CoreServices}/Versions/A/Frameworks/LaunchServices.framework"
    local lsregister="${LaunchServices}/Versions/A/Support/lsregister"
    sudo $lsregister -kill -r -domain local -domain system -domain user
  }

  rmdsstore() {
    find "${@:-.}" -type f -name .DS_Store -delete
  }

  if command-exists arch; then
    x86() {
      (
        export _mythemerosettamarker="ř "
        eval "$(/usr/local/bin/brew shellenv)"
        arch --x86_64 $SHELL
      )
    }
  fi
fi

if is-msys; then
  alias pac="dfb-msys2-pac"

  open() {
    # pacman -S cygutils
    (cygstart "$1" &>/dev/null &)
  }
fi

# _alvim() {
#   alacritty --title nvim --working-directory $(pwd) -e $SHELL -lc "nvim"
# }
# alias alvim="(_alvim &)"

# list all zsh autocompletions
# for command in ${(k)_comps}; do
#   completions=${_comps[$command]}
#   printf "%-32s %s\n" $command $completions
# done | sort
