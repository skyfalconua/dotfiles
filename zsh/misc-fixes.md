### install terminal utils
```sh
brew install fzf zoxide carapace ripgrep micro yazi gitui git-delta sd fd
```

### fix line endings
```sh
find . -name "*.zsh" | xargs dos2unix -f
find . -name "*.sh" | xargs dos2unix -f
```

### debug zsh
```sh
  brew install moreutils
  zsh -xv 2>&1 | ts -i "%.s" > zsh_startup.log
```

### fix permissions
```sh
autoload -Uz compinit
compaudit | xargs chmod g-w,o-w
```

### fix zshrc loading in IDEs
```sh
sudo su
echo 'source "$HOME/.zshrc"' > /etc/zshrc_zed
echo 'source "$HOME/.zshrc"' > /etc/zshrc_vscode
```

### fix apps which don't recognize Ghostty terminal yet
```sh
# 1. the best soution - copy terminfo to server
infocmp -x | ssh YOUR-SERVER -- tic -x -

# 2 or failback in .ssh/config
Host YOUR-SERVER
  SetEnv TERM=xterm-256color

# 3. or failback in tmux
echo "set -g default-terminal xterm-256color" >> ~/.tmux.conf

# 4. or failback in zsh
echo "export TERM=xterm-256color" >> ~/.dotfiles/zsh/_local.zsh
```
