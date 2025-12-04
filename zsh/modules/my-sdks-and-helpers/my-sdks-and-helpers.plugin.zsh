# brew install nvm pyenv android-studio

# -- -- setup nvm -- -- -- --

# if [ "$(uname)" = "Darwin" ]; then
#   export NODE_PATH="/usr/local/lib/node_modules"
#   export NVM_DIR=~/.nvm

#   _nvmsh=$(brew --prefix nvm)/nvm.sh
#   [ -s "$_nvmsh" ] && \. "$_nvmsh"

# else
#   # https://github.com/nvm-sh/nvm#installation-and-update

#   export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] \
#     && printf %s "${HOME}/.nvm" \
#     || printf %s "${XDG_CONFIG_HOME}/nvm")"

#   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# fi

# -- -- fix pyenv -- -- -- --

if command-exists pyenv; then
  # fix before loading python module second time (ex. in tmux)
  path-remove "$HOME/.pyenv/shims"
fi

# -- -- setup jdk -- -- -- --

_check_java_home() {
  [ -z "$JAVA_HOME" ] || [ ! -d "$JAVA_HOME" ]
}

if _check_java_home && [ -f "/usr/libexec/java_home" ] ; then
  export JAVA_HOME=`/usr/libexec/java_home 2>/dev/null`
fi

_jbr="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
if _check_java_home && [ -d "$_jbr" ] ; then
  export JAVA_HOME="$_jbr"
fi

# -- -- setup fzf -- -- -- --

if command-exists fzf; then
  export FZF_COMPLETION_TRIGGER='~~'
  # --zsh option is only available in version >= 0.48.0
  source <(fzf --zsh 2>/dev/null)

  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
      cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
      export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
      ssh)          fzf --preview 'dig {}'                   "$@" ;;
      *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
    esac
  }
fi

# -- -- carapace for autocompletions -- -- -- --

if command-exists carapace; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

# -- -- smarter cd command -- -- -- --

if command-exists zoxide; then
  export _ZO_DATA_DIR="$HOME/.local/share"
  source <(zoxide init zsh)
fi
