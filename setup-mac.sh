#!/usr/bin/env bash
# setup-mac.sh — Apple Silicon · macOS Tahoe · April 2026
# Idempotent: safe to re-run.

set -euo pipefail

# ─── Convention ────────────────────────────────────────────────────
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects/_personal}"

# ─── Config (override via env) ─────────────────────────────────────
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/striveforbest/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$PROJECTS_DIR/dotfiles}"

# Optional: directory containing existing keys/credentials to restore
# Layout expected:
#   $RESTORE_FROM/.ssh/             ← SSH private + public keys
#   $RESTORE_FROM/.boto             ← GCS credentials
#   $RESTORE_FROM/gpg-private.asc   ← exported GPG private key (armored)
RESTORE_FROM="${RESTORE_FROM:-}"

# Auto-detect Google Drive if RESTORE_FROM not set
if [ -z "$RESTORE_FROM" ]; then
  for candidate in \
    "$HOME/Google Drive/My Drive/Development" \
    "$HOME/Library/CloudStorage/GoogleDrive-"*"/My Drive/Development"; do
    if [ -d "$candidate" ]; then
      RESTORE_FROM="$candidate"
      break
    fi
  done
fi

# Files & dirs to symlink from dotfiles → $HOME
DOTFILES_LINKS=(
  .zshrc
  .bash_profile
  .bashrc
  .aliases
  .functions
  .vimrc
  .gitconfig
  .gitignore_global
  bin
)
DOTFILES_NESTED=(
  .gnupg/gpg-agent.conf
)

# Python tools to install via pipx (uses pyenv's Python automatically)
PIPX_TOOLS=(pipenv poetry pdm)

# ─── Colors / logging ──────────────────────────────────────────────
B=$'\e[1m'; D=$'\e[2m'; R=$'\e[0m'
G=$'\e[32m'; Y=$'\e[33m'; C=$'\e[36m'; X=$'\e[31m'

log()  { printf "\n${B}${C}==>${R} ${B}%s${R}\n" "$*"; }
sub()  { printf "  ${G}✓${R} %s\n" "$*"; }
skip() { printf "  ${D}-${R} %s ${D}(already done)${R}\n" "$*"; }
warn() { printf "  ${Y}!${R} %s\n" "$*"; }
err()  { printf "  ${X}✗${R} %s\n" "$*"; }

confirm() {
  local prompt="${1:-Continue?}" default="${2:-y}" hint reply
  [ "$default" = "y" ] && hint="[Y/n]" || hint="[y/N]"
  read -r -p "$(printf "${B}${Y}?${R} %s ${D}%s${R} " "$prompt" "$hint")" reply
  reply="${reply:-$default}"
  [[ "$reply" =~ ^[Yy] ]]
}

prompt() {
  local var="$1" question="$2" default="${3:-}" reply
  if [ -n "$default" ]; then
    read -r -p "$(printf "${B}${Y}?${R} %s ${D}[%s]${R} " "$question" "$default")" reply
    reply="${reply:-$default}"
  else
    read -r -p "$(printf "${B}${Y}?${R} %s " "$question")" reply
  fi
  printf -v "$var" '%s' "$reply"
}

backup_if_needed() {
  local path="$1"
  if [ -L "$path" ]; then
    rm "$path"
  elif [ -e "$path" ]; then
    local backup="${path}.backup-$(date +%Y%m%d-%H%M%S)"
    mv "$path" "$backup"
    sub "backed up $path → $backup"
  fi
}

get_gpg_key_id() {
  gpg --list-secret-keys --keyid-format LONG 2>/dev/null \
    | awk '/^sec/ {split($2,a,"/"); print a[2]; exit}'
}

[ "$(uname)" = "Darwin" ] || { err "macOS only"; exit 1; }
[ "$(uname -m)" = "arm64" ] || warn "Not Apple Silicon — paths assume /opt/homebrew"

# ─── Preamble ──────────────────────────────────────────────────────
clear
cat <<EOF
${B}${C}╭────────────────────────────────────────────╮
│      macOS Dev Environment Setup           │
│      Apple Silicon · April 2026            │
╰────────────────────────────────────────────╯${R}

This will:
  1. Install Xcode CLT + Homebrew + Brewfile packages
  2. Install Oh My Zsh
  3. Restore SSH keys from backup (or generate new)
  4. Clone dotfiles to: ${B}$DOTFILES_DIR${R}
  5. Symlink dotfiles into \$HOME
  6. Restore GPG key from backup (or generate new)
  7. Install Python 3.14 (pyenv) + pipx tools (pipenv, poetry, pdm)
  8. Install Node LTS (nvm)
  9. Apply macOS defaults

Restore source: ${B}${RESTORE_FROM:-(none detected)}${R}
  Looking for:
    ${RESTORE_FROM:-?}/.ssh/             ← SSH keys
    ${RESTORE_FROM:-?}/.boto             ← GCS credentials
    ${RESTORE_FROM:-?}/gpg-private.asc   ← exported GPG private key

Idempotent: skips work that's already done. Existing files get
backed up to *.backup-<timestamp> before being replaced.
EOF

confirm "Ready?" || exit 0

mkdir -p "$PROJECTS_DIR"

# ─── 1. Xcode Command Line Tools ───────────────────────────────────
log "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
  skip "Xcode CLT installed"
else
  xcode-select --install || true
  warn "Click through the GUI installer, then re-run this script"
  exit 0
fi

# ─── 2. Homebrew ───────────────────────────────────────────────────
log "Homebrew"
if command -v brew &>/dev/null; then
  skip "brew installed at $(command -v brew)"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  sub "installed Homebrew"
fi

# ─── 3. Brewfile ───────────────────────────────────────────────────
log "Brew bundle (this is the long one)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/Brewfile" ]; then
  brew bundle --file="$SCRIPT_DIR/Brewfile"
  sub "Brewfile installed"
else
  warn "No Brewfile found in $SCRIPT_DIR"
fi

# ─── 4. Oh My Zsh ──────────────────────────────────────────────────
log "Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  skip "Oh My Zsh installed"
else
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  sub "installed Oh My Zsh"
fi

chmod -R go-w '/opt/homebrew/share/zsh' 2>/dev/null || true

# ─── 5. SSH key (restore or generate) ──────────────────────────────
log "SSH key"
if [ -f "$HOME/.ssh/id_ed25519" ] || [ -f "$HOME/.ssh/id_rsa" ]; then
  skip "SSH key(s) already in ~/.ssh"
elif [ -n "$RESTORE_FROM" ] && [ -d "$RESTORE_FROM/.ssh" ] && \
     confirm "Restore SSH keys from $RESTORE_FROM/.ssh?"; then
  mkdir -p ~/.ssh && chmod 700 ~/.ssh
  rsync -av --exclude 'known_hosts*' "$RESTORE_FROM/.ssh/" ~/.ssh/
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/id_* 2>/dev/null || true
  chmod 644 ~/.ssh/*.pub 2>/dev/null || true
  chmod 600 ~/.ssh/config 2>/dev/null || true
  sub "restored SSH keys (with proper permissions)"
else
  prompt SSH_COMMENT "Email/comment for new SSH key?" "$USER@$(hostname -s)"
  mkdir -p ~/.ssh && chmod 700 ~/.ssh
  ssh-keygen -t ed25519 -C "$SSH_COMMENT" -f ~/.ssh/id_ed25519 -N ""
  pbcopy < ~/.ssh/id_ed25519.pub
  sub "key generated, public key copied to clipboard"
  open "https://github.com/settings/ssh/new"
  warn "Paste in the GitHub tab, save, then press Enter"
  read -r

  if [ -n "$RESTORE_FROM" ] && confirm "Back up new SSH key to $RESTORE_FROM/.ssh/?"; then
    mkdir -p "$RESTORE_FROM/.ssh"
    cp ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub "$RESTORE_FROM/.ssh/"
    sub "backed up SSH key"
  fi
fi

# ─── 5b. .boto ─────────────────────────────────────────────────────
if [ -n "$RESTORE_FROM" ] && [ -f "$RESTORE_FROM/.boto" ] && [ ! -e "$HOME/.boto" ]; then
  if confirm "Symlink ~/.boto from $RESTORE_FROM/.boto?"; then
    ln -s "$RESTORE_FROM/.boto" "$HOME/.boto"
    sub "linked .boto"
  fi
fi

# ─── 6. Dotfiles ───────────────────────────────────────────────────
log "Dotfiles"
if [ -d "$DOTFILES_DIR/.git" ]; then
  skip "dotfiles already cloned at $DOTFILES_DIR"
  ( cd "$DOTFILES_DIR" && git pull --ff-only 2>/dev/null ) || warn "pull failed (uncommitted changes?)"
else
  ssh_repo="${DOTFILES_REPO/https:\/\/github.com\//git@github.com:}"
  if git clone "$ssh_repo" "$DOTFILES_DIR" 2>/dev/null; then
    sub "cloned via SSH"
  else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    sub "cloned via HTTPS"
  fi
fi

log "Symlinking dotfiles → \$HOME"
for entry in "${DOTFILES_LINKS[@]}"; do
  src="$DOTFILES_DIR/$entry"
  dst="$HOME/$entry"
  if [ ! -e "$src" ]; then
    warn "$entry not in dotfiles, skipping"
    continue
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "$entry"
    continue
  fi
  backup_if_needed "$dst"
  ln -s "$src" "$dst"
  sub "linked $entry"
done

mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
for entry in "${DOTFILES_NESTED[@]}"; do
  src="$DOTFILES_DIR/$entry"
  dst="$HOME/$entry"
  if [ ! -e "$src" ]; then
    warn "$entry not in dotfiles, skipping"
    continue
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "$entry"
    continue
  fi
  backup_if_needed "$dst"
  ln -s "$src" "$dst"
  sub "linked $entry"
done

# ─── 7. GPG (restore or generate) ──────────────────────────────────
log "GPG signing"
if ! grep -q pinentry-mac ~/.gnupg/gpg-agent.conf 2>/dev/null; then
  echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
  echo 'use-agent' > ~/.gnupg/gpg.conf
  sub "configured pinentry-mac"
fi
gpgconf --kill gpg-agent 2>/dev/null || true

KEY_ID="$(get_gpg_key_id)"

if [ -n "$KEY_ID" ]; then
  skip "GPG key already in keyring: $KEY_ID"
elif [ -n "$RESTORE_FROM" ] && [ -f "$RESTORE_FROM/gpg-private.asc" ] && \
     confirm "Import GPG private key from $RESTORE_FROM/gpg-private.asc?"; then
  gpg --import "$RESTORE_FROM/gpg-private.asc"
  KEY_ID="$(get_gpg_key_id)"
  sub "imported GPG key: $KEY_ID"
else
  GIT_EMAIL="$(git config --global user.email 2>/dev/null || echo "")"
  warn "Generating GPG key. Use email: ${GIT_EMAIL:-<your git email>}"
  warn "Pick: 1 (RSA+RSA), 4096, 0 (no expiry), y, name, email matching git, blank comment"
  gpg --full-generate-key
  KEY_ID="$(get_gpg_key_id)"
  sub "key generated: $KEY_ID"

  if [ -n "$RESTORE_FROM" ] && confirm "Back up new GPG private key to $RESTORE_FROM/gpg-private.asc?"; then
    gpg --armor --export-secret-key "$KEY_ID" > "$RESTORE_FROM/gpg-private.asc"
    chmod 600 "$RESTORE_FROM/gpg-private.asc"
    sub "backed up GPG key"
  fi
fi

if [ -n "$KEY_ID" ]; then
  git config --global gpg.program "$(which gpg)"
  git config --global user.signingkey "$KEY_ID"
  git config --global commit.gpgsign true
  git config --global tag.gpgsign true
  sub "git configured to sign with $KEY_ID"
  warn "Edits modified your dotfiles .gitconfig — review with: cd $DOTFILES_DIR && git diff"

  if confirm "Copy public key to clipboard and open GitHub?" "n"; then
    gpg --armor --export "$KEY_ID" | pbcopy
    open "https://github.com/settings/gpg/new"
    warn "Paste in the GitHub tab, then press Enter"
    read -r
  fi
fi

# ─── 8. Python (pyenv) ─────────────────────────────────────────────
log "Python (pyenv)"
if confirm "Install Python 3.14?"; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path 2>/dev/null || true)"
  if pyenv versions --bare | grep -q "^3.14"; then
    skip "Python 3.14 already installed"
  else
    pyenv install 3.14
    pyenv global 3.14
    sub "Python 3.14 installed and set as global"
  fi
fi

# ─── 8b. Python tools via pipx ─────────────────────────────────────
log "Python tools (pipx)"
if command -v pipx &>/dev/null; then
  for tool in "${PIPX_TOOLS[@]}"; do
    if pipx list --short 2>/dev/null | awk '{print $1}' | grep -qx "$tool"; then
      skip "$tool"
    else
      if pipx install "$tool" >/dev/null 2>&1; then
        sub "$tool"
      else
        warn "pipx install $tool failed"
      fi
    fi
  done
  pipx ensurepath >/dev/null 2>&1 || true
  sub "pipx PATH ensured (open a new shell to pick up changes)"
else
  warn "pipx not installed — skipping pipenv/poetry/pdm"
fi

# uv is a brew package, not pipx — just confirm it's installed
if command -v uv &>/dev/null; then
  skip "uv installed ($(uv --version 2>/dev/null | awk '{print $2}'))"
else
  warn "uv not installed (should be in Brewfile)"
fi

# ─── 9. Node (nvm) ─────────────────────────────────────────────────
log "Node.js (nvm)"
mkdir -p ~/.nvm
if confirm "Install Node LTS?"; then
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  . "/opt/homebrew/opt/nvm/nvm.sh"
  if nvm ls --no-colors 2>/dev/null | grep -q "lts"; then
    skip "Node LTS already installed"
  else
    nvm install --lts
    nvm use --lts
    sub "Node LTS installed"
  fi
fi

# ─── 10. PostgreSQL ────────────────────────────────────────────────
log "PostgreSQL"
if [ -d "/Applications/Postgres.app" ]; then
  skip "Postgres.app installed"
  if [ ! -f /etc/paths.d/postgresapp ]; then
    sudo mkdir -p /etc/paths.d
    echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp >/dev/null
    sub "added Postgres.app to PATH"
  fi
else
  warn "Postgres.app not installed. Download from https://postgresapp.com/ if you need it"
fi

# ─── 11. macOS defaults ────────────────────────────────────────────
log "macOS defaults"
if confirm "Apply Finder/keyboard defaults?"; then
  defaults write com.apple.finder AppleShowAllFiles YES
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write -g ApplePressAndHoldEnabled -bool false
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  killall Finder 2>/dev/null || true
  sub "defaults applied (some changes need a logout)"
fi

# ─── Summary ───────────────────────────────────────────────────────
cat <<EOF

${B}${G}✓ Done!${R}

${B}Manual steps still to do:${R}
  1. iTerm → Settings → Profiles → Text → Font → ${B}MesloLGS NF${R}
  2. Restart iTerm, then run: ${B}p10k configure${R}
  3. Apps from unidentified developers: System Settings → Privacy & Security
  4. Test signed commit:
       ${D}cd /any/repo && git commit --allow-empty -m "test"
       git log --show-signature -1${R}
  5. Review and commit dotfiles changes:
       ${D}cd $DOTFILES_DIR && git diff${R}

EOF
