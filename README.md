# macOS Dev Environment Setup

Copy-paste setup for **macOS Tahoe (16.x)** on **Apple Silicon**. Last updated April 2026.

---

## Xcode CLT

```bash
xcode-select --install
```

## Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## iTerm2 + Nerd Font

```bash
brew install --cask iterm2
brew install --cask font-meslo-lg-nerd-font
```

In iTerm2: **Settings → Profiles → Text → Font** → **MesloLGS NF**.

## Zsh plugins

```bash
brew install zsh-completions zsh-autosuggestions zsh-syntax-highlighting
chmod -R go-w '/opt/homebrew/share/zsh'
```

## Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Powerlevel10k

```bash
brew install powerlevel10k
```

In `~/.zshrc`:

```bash
ZSH_THEME=""

# at the END of the file:
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

```bash
p10k configure
```

## Git + SSH

```bash
brew install git

git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global color.ui true

mkdir -p ~/.ssh && cd ~/.ssh
ssh-keygen -t ed25519 -C "you@example.com"
pbcopy < ~/.ssh/id_ed25519.pub
```

Add at https://github.com/settings/ssh/new

## GPG signing

```bash
brew install gnupg pinentry-mac

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
echo 'use-agent' > ~/.gnupg/gpg.conf
gpgconf --kill gpg-agent

gpg --full-generate-key
# 1, 4096, 0, y, name, email matching git, blank comment, passphrase

gpg --list-secret-keys --keyid-format LONG
# copy the ID after `sec rsa4096/`

git config --global gpg.program $(which gpg)
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
git config --global tag.gpgsign true

gpg --armor --export YOUR_KEY_ID | pbcopy
```

Add at https://github.com/settings/gpg/new

In `~/.zshrc`:

```bash
export GPG_TTY=$(tty)
```

## Dotfiles

```bash
DOTFILES="$HOME/projects/_personal/dotfiles"

ln -s "$DOTFILES/.zshrc"            ~/.zshrc
ln -s "$DOTFILES/.profile"          ~/.profile
ln -s "$DOTFILES/.aliases"          ~/.aliases
ln -s "$DOTFILES/.functions"        ~/.functions
ln -s "$DOTFILES/.gitignore_global" ~/.gitignore_global
ln -s "$DOTFILES/.gitconfig"        ~/.gitconfig
ln -s "$DOTFILES/bin"               ~/bin
ln -s "$DOTFILES/.gnupg/gpg-agent.conf" ~/.gnupg/gpg-agent.conf

source ~/.zshrc
```

## Python

```bash
brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper
```

In `~/.zshrc`:

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
```

```bash
pyenv install 3.14
pyenv global 3.14
```

## Node.js

```bash
brew install nvm
mkdir -p ~/.nvm
```

In `~/.zshrc`:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
```

```bash
source ~/.zshrc
nvm install --lts
nvm use --lts
```

## PostgreSQL

Download Postgres.app from https://postgresapp.com/

```bash
sudo mkdir -p /etc/paths.d
echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
```

## Redis

```bash
brew install redis
brew services start redis
```

## Elasticsearch

```bash
brew tap elastic/tap
brew install elastic/tap/elasticsearch-full
brew services start elastic/tap/elasticsearch-full
```

## Cloud CLIs

```bash
brew install awscli s3cmd
brew install --cask aws-vault
brew install --cask google-cloud-sdk
brew install azure-cli
brew install vault
brew install kubectl helm
brew install terraform
brew install --cask docker
```

## Common tools

```bash
brew install curl wget jq htop tree fzf ripgrep bat eza fd gh
brew install cheat fortune
brew install zlib openssl@3
```

## Image processing

```bash
brew install imagemagick
brew install freetype graphicsmagick jpegoptim lcms libjpeg libpng libtiff openjpeg optipng pngcrush webp
```

## Video processing

```bash
brew install ffmpeg
```

## Maintenance

```bash
brew update && brew outdated && brew upgrade && brew cleanup
brew doctor
```

## macOS defaults

```bash
defaults write com.apple.finder AppleShowAllFiles YES && killall Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

For "allow apps from unidentified developers": **System Settings → Privacy & Security**.