# dotfiles

#### brew
```sh
curl -sL skyfalconua.github.io/brewsetup | sh
```

#### oneliner
```sh
curl -sL skyfalconua.github.io/dotfiles | sh
```

or manually

#### 1. clone repo
```sh
git clone https://github.com/skyfalconua/dotfiles.git ~/.dotfiles
```

#### 2. update ~/.zshrc
```sh
echo 'source ~/.dotfiles/zsh/init.zsh' > ~/.zshrc && \
touch ~/.dotfiles/.local/_local.zsh
```

#### 3. copy configs
```sh
cd ~/.dotfiles/configs && bash setup-base.sh
```

#### 4. (optional) update config.fish
```sh
curl -sL https://git.io/fisher | source && \
fisher install jorgebucaran/fisher && \
echo 'source ~/.dotfiles/fish/init.fish' > ~/.config/fish/config.fish
```

#### 5. (optional) misc
```sh
# starship prompt
echo 'eval "$(starship init zsh)"' >> ~/.dotfiles/.local/_local.zsh
```
