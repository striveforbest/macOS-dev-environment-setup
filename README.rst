=================================
Configuring macOS for Development
=================================

This doc assumes you are doing a clean install of `Homebrew <http://mxcl.github.io/homebrew/>`_ on a clean install of macOS Ventura (13.3).

iTerm2
^^^^^^
- `Download <https://iterm2.com/downloads.html>`_ and install iTerm2.

- Set up `Shell Integration <https://iterm2.com/documentation-shell-integration.html>`_ and set up the shortcuts.


Xcode
^^^^^

Install Xcode from the App Store.
Install Command Line Tools::

    xcode-select --install

Homebrew
^^^^^^^^

Install::

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew doctor

Before we get around to setting up Z Shell, add Homebrew to PATH::

    export PATH=/opt/homebrew/bin:$PATH

Git
^^^

Install::

    brew install git

Set up new public SSH key (or restore existing)::

    mkdir -p ~/.ssh && cd ~/.ssh
    ssh-keygen -t rsa -b 4096 -C "alex@eagerminds.co"
    pbcopy < ~/.ssh/id_rsa.pub

`GPG Suite <https://gpgtools.org/>`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After installation, follow the instructions to `set up commit signing <https://docs.github.com/en/authentication/managing-commit-signature-verification>`_.

You'll need `pinentry`::

    brew install pinentry-mac


Set global git settings (or restore from `Dotfiles repository <https://github.com/StriveForBest/dotfiles>`_::

    git config --global user.name "Alex Zagoro"
    git config --global user.email "alex@eagerminds.co"
    git config --global color.ui true

Now, you can add your old-style SSH key as a subkey to GPG.

First, export your public key from `id_rsa` private key (you might be able to skip it if you already have pubkey)::

    ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub

Then, convert `id_rsa.pub` public key to the OpenPGP format::

    gpg --export-options export-minimal --export OpenPGP ~/.ssh/id_rsa.pub > ~/.ssh/id_rsa_opengpg.pub

Import it into your GPG keyring::

    gpg --import ~/.ssh/id_rsa_opengpg.pub

Associate the subkey with your GPG key.

First, obtain the Key ID::

    gpg --list-keys

Look for the line that starts with "pub" and contains your key's email address.
The Key ID is the 8-character hexadecimal code next to the email address.

Once you have the Key ID, add the subkey to your GPG key::

    gpg --edit-key <Key ID>

Inside the GPG key editing interface, enter the following command to add the subkey::

    addkey

Select the option for "RSA (sign only)" or "RSA (encrypt only)," depending on the purpose of the subkey.
Follow the prompts to enter a passphrase (optional) and complete the subkey creation process.

After the subkey is added, use the following command to save the changes and exit the GPG key editing interface::

    save

That's it! You have successfully added your old id_rsa key as a subkey to your GPG key.
You can verify the addition by listing your GPG keys::

    gpg --list-keys

cURL/wget
^^^^^^^^^

Install::

    brew install curl wget

Z shell
^^^^^^^

Mac OS Ventura+ has zsh preinstalled, but you should install some plugins::

    brew install zsh-completions zsh-autosuggestions zsh-syntax-highlighting

Output::

    ==> Caveats
    To activate the syntax highlighting, add the following at the end of your .zshrc:
      source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    If you receive "highlighters directory not found" error message,
    you may need to add the following to your .zshenv:
      export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
    ==> Summary
    🍺  /opt/homebrew/Cellar/zsh-syntax-highlighting/0.7.1: 27 files, 164.7KB
    ==> Running `brew cleanup zsh-syntax-highlighting`...
    ==> Caveats
    ==> zsh-completions
    To activate these completions, add the following to your .zshrc:

      if type brew &>/dev/null; then
        FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

        autoload -Uz compinit
        compinit
      fi

    You may also need to force rebuild `zcompdump`:

      rm -f ~/.zcompdump; compinit

    Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
    to load these completions, you may need to run this:

      chmod -R go-w '/opt/homebrew/share/zsh'
    ==> zsh-autosuggestions
    To activate the autosuggestions, add the following at the end of your .zshrc:

      source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    You will also need to restart your terminal for this change to take effect.
    ==> zsh-syntax-highlighting
    To activate the syntax highlighting, add the following at the end of your .zshrc:
      source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    If you receive "highlighters directory not found" error message,
    you may need to add the following to your .zshenv:
      export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

Update default shell::

    chsh -s $(which zsh)

Oh My Zsh
^^^^^^^^^

Oh My Zsh is an open source, community-driven framework for managing your zsh configuration. `Instructions <https://github.com/robbyrussell/oh-my-zsh>`_

Install::

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

powerlevel9k
^^^^^^^^^^^^

Oh My Zsh theme. `Instructions <https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#option-2-install-for-oh-my-zsh>`_

Install::

    $ git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

Install powerline `fonts <https://github.com/powerline/fonts>`_::

    git clone git@github.com:powerline/fonts.git  ~/.oh-my-zsh/custom/fonts
    cd ~/.oh-my-zsh/custom/fonts
    ./install.sh

Keep in mind, you'll need to set the fonts in your `iTerm` Settings -> Profiles -> Text -> Change Font -> Meslo LG S DZ Regular for Powerline.

Dot files
=========

Files are available in `Dotfiles repository <https://github.com/StriveForBest/dotfiles>`_::

    cd
    ln -s <PATH>/dotfiles/.zshrc
    ln -s <PATH>/dotfiles/.profile
    ln -s <PATH>/dotfiles/.aliases
    ln -s <PATH>/dotfiles/.functions
    ln -s <PATH>/dotfiles/bin
    ln -s <PATH>/dotfiles/.gitignore_global
    ln -s <PATH>/dotfiles/.gitconfig
    source ~/.zshrc

    Set up GPG config:
    mkdir -p ~/.gnupg
    ln -s <PATH>/dotfiles/.gnupg/gpg-agent.conf ~/.gnupg/.

AWS CLI
^^^^^^^

Install CLI and add profiles/credentials::

    brew install awscli s3cmd

Create `~/.aws/config` and `~/.aws/credentials` and set them up.

Programming Languages
=====================

Python
^^^^^^

Install pyenv first::

    brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper

Now, you can install multiple Python versions via::

    pyenv install 3.11

Frontend Tools
==============

Install NVM first::

    brew install nvm

Which now allows you to install multiple node/npm versions::
    nvm install 14.15.0
    nvm use 14.15.0

Npm-X (makes commands from local environment available)::

    npm install npx -g


Data Stores
===========

PostgreSQL
^^^^^^^^^^

Just download and install Postgres.app from https://postgresapp.com/ (which comes with Postgis)

Enable CLI::

    sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp

Redis
^^^^^

Install::

    brew install redis

Output::

    ==> Caveats
    To start redis now and restart at login:
        brew services start redis
    Or, if you don't want/need a background service you can just run:
        /opt/homebrew/opt/redis/bin/redis-server /opt/homebrew/etc/redis.conf


ElasticSearch
^^^^^^^^^^^^^

Install::

    brew install elasticsearch

Run in on system start::

    brew services start elasticsearch


Miscellaneous tools
===================

`Zlib <https://www.zlib.net/>`_::

    brew install zlib

`OpenSSL <https://www.openssl.org/>`_::

    brew install openssl

`JQ <https://jqlang.github.io/jq/>`_::

    brew install jq

`Vault <https://www.vaultproject.io/intro/index.html>`_::

    brew install vault

`Htop <https://htop.dev/>`_::

    brew install htop

`Cheat <https://github.com/cheat/cheat>`_::

    brew install cheat
    # Usage
    cheat -l
    cheat tar

`Fortune <https://github.com/bmc/fortune>`_::

    brew install fortune

Image processing utils
======================

Install for full support of PIL/Pillow::

    brew install imagemagick
    brew install freetype graphicsmagick jpegoptim lcms libjpeg libpng libtiff openjpeg optipng pngcrush webp

Video processing utils
======================

FFmpeg::

    brew install ffmpeg

To see a full list of FFmpeg options::

    brew options ffmpeg


Homebrew maintenance
====================

Get a checkup from the doctor and follow the doctor's instructions::

    brew doctor

To update your installed brews::

    brew update
    brew outdated
    brew upgrade
    brew cleanup


OS-specific settings
====================

Allow opening apps from unidentified developers::

    sudo spctl --master-disable
