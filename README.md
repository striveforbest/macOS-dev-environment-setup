# macOS Dev Environment Setup

Apple Silicon · macOS Tahoe · April 2026

Pairs with my [dotfiles](https://github.com/striveforbest/dotfiles) repo. Both repos are expected at `$HOME/projects/_personal/`.

---

## Two ways to use this

### Path A: One command (recommended)

```bash
mkdir -p ~/projects/_personal
cd ~/projects/_personal
git clone https://github.com/striveforbest/macOS-dev-environment-setup.git
cd macOS-dev-environment-setup
./setup-mac.sh
```

Idempotent, prompts before each section, restores keys from backup if available.

### Path B: Step-by-step

Skip to [Manual setup](#manual-setup) and run commands one section at a time.

---

## Project layout

```
~/projects/_personal/
├── dotfiles/                       (cloned by script)
└── macOS-dev-environment-setup/    (this repo)
```

Override with `PROJECTS_DIR` or `DOTFILES_DIR` env vars.

---

## Key restore (Path A)

The script auto-detects Google Drive and offers to restore existing keys instead of generating new ones each setup.

**Auto-detected paths:**
- `~/Google Drive/My Drive/Development/`
- `~/Library/CloudStorage/GoogleDrive-*/My Drive/Development/`

**Expected layout in that directory:**

```
.../My Drive/Development/
├── .ssh/             ← SSH keys (id_ed25519, id_ed25519.pub, config, etc.)
├── .boto             ← GCS credentials
└── gpg-private.asc   ← exported GPG private key (armored)
```

After generating fresh keys for the first time, the script offers to back them up to this directory so future re-runs / new machines can restore from the same source.

**Manual GPG key export** (if you have keys elsewhere):

```bash
gpg --armor --export-secret-key YOUR_KEY_ID > ~/Google\ Drive/My\ Drive/Development/gpg-private.asc
```

**Override the restore source:**

```bash
RESTORE_FROM=~/Dropbox/backup ./setup-mac.sh
```

---

## All env var overrides

```bash
PROJECTS_DIR=~/code \
DOTFILES_REPO=git@github.com:you/dotfiles.git \
DOTFILES_DIR=~/code/dotfiles \
RESTORE_FROM=~/Dropbox/backup \
./setup-mac.sh
```

---

## Manual steps the script can't do

1. **Font**: iTerm → Settings → Profiles → Text → Font → **MesloLGS NF**
2. **Powerlevel10k wizard**: `p10k configure` after first iTerm restart
3. **GPG passphrase**: enter when generating key (save in 1Password)
4. **GitHub key uploads**: paste in browser tabs the script opens
5. **Unidentified developer apps**: System Settings → Privacy & Security

---

## Manual setup

The canonical command list, in order. Run these instead of `./setup-mac.sh` if you'd rather do it step by step.

### Project structure

```bash
mkdir -p ~/projects/_personal
cd ~/projects/_personal
```

### Xcode CLT

```bash
xcode-select --install
```

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Brewfile install

```bash
brew bundle --file=./Brewfile
```

### iTerm2 + Nerd Font

iTerm: **Settings → Profiles → Text → Font → MesloLGS NF**

### Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Restore SSH keys (if backed up)

```bash
SRC="$HOME/Google Drive/My Drive/Development"
mkdir -p ~/.ssh
rsync -av --exclude 'known_hosts*' "$SRC/.ssh/" ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

### Or generate fresh SSH key

```bash
ssh-keygen -t ed25519 -C "you@example.com"
pbcopy < ~/.ssh/id_ed25519.pub
```

Paste at https://github.com/settings/ssh/new

Optional backup:

```bash
cp ~/.ssh/id_ed25519* "$HOME/Google Drive/My Drive/Development/.ssh/"
```

### Dotfiles

```bash
cd ~/projects/_personal
git clone git@github.com:striveforbest/dotfiles.git

DOTFILES="$HOME/projects/_personal/dotfiles"
ln -s "$DOTFILES/.zshrc"            ~/.zshrc
ln -s "$DOTFILES/.bash_profile"     ~/.bash_profile
ln -s "$DOTFILES/.bashrc"           ~/.bashrc
ln -s "$DOTFILES/.aliases"          ~/.aliases
ln -s "$DOTFILES/.functions"        ~/.functions
ln -s "$DOTFILES/.vimrc"            ~/.vimrc
ln -s "$DOTFILES/.gitconfig"        ~/.gitconfig
ln -s "$DOTFILES/.gitignore_global" ~/.gitignore_global
ln -s "$DOTFILES/bin"               ~/bin

mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
ln -s "$DOTFILES/.gnupg/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
```

### GPG signing

```bash
mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
echo 'use-agent' > ~/.gnupg/gpg.conf
gpgconf --kill gpg-agent
```

**Restore from backup:**

```bash
gpg --import "$HOME/Google Drive/My Drive/Development/gpg-private.asc"
```

**Or generate fresh:**

```bash
gpg --full-generate-key
# 1, 4096, 0, y, name, email matching git, blank comment, passphrase
```

**Then configure git:**

```bash
gpg --list-secret-keys --keyid-format LONG
# copy ID after `sec rsa4096/`

git config --global gpg.program $(which gpg)
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
git config --global tag.gpgsign true

gpg --armor --export YOUR_KEY_ID | pbcopy
```

Paste at https://github.com/settings/gpg/new

Optional backup:

```bash
gpg --armor --export-secret-key YOUR_KEY_ID > "$HOME/Google Drive/My Drive/Development/gpg-private.asc"
```

### Powerlevel10k wizard

```bash
p10k configure
```

### Python (pyenv)

```bash
pyenv install 3.14
pyenv global 3.14
```

### Node (nvm)

```bash
mkdir -p ~/.nvm
source ~/.zshrc
nvm install --lts
nvm use --lts
```

### PostgreSQL

Download Postgres.app from https://postgresapp.com/

```bash
sudo mkdir -p /etc/paths.d
echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
```

### Elasticsearch

```bash
brew tap elastic/tap
brew install elastic/tap/elasticsearch-full
brew services start elastic/tap/elasticsearch-full
```

### macOS defaults

```bash
defaults write com.apple.finder AppleShowAllFiles YES && killall Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

### Maintenance

```bash
brew update && brew outdated && brew upgrade && brew cleanup
brew doctor
```

---

## Common gotchas

- **`npm: command not found` after `brew install nvm`** — nvm is a shell function, source it in `.zshrc`
- **Literal `$(build_right_prompt)` in prompt** — powerlevel9k is broken on modern zsh, use p10k
- **`?` boxes instead of icons** — install MesloLGS NF and select it in iTerm
- **`fatal: cannot exec '/usr/local/bin/gpg'`** — `git config --global gpg.program $(which gpg)`
- **`[oh-my-zsh] plugin 'zsh-syntax-highlighting' not found`** — brew-installed plugins go at the *end* of `.zshrc`, not in OMZ `plugins=(...)`
- **SSH keys restored from cloud storage and SSH refuses them** — permissions got mangled; `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*`

- **`pygmentize: command not found`** — install pygments: `brew install pygments` (already in Brewfile)
