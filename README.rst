===============================
Configuring OSX for Development
===============================

This doc assumes you are doing a clean install of `Homebrew <http://mxcl.github.io/homebrew/>`_ on a clean install of OSX Ventura (13.3).

Xcode
-----

Install Xcode from the App Store.
Install Command Line Tools::

    xcode-select --install

Homebrew
--------

Install::

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew doctor

Before we get around to setting up Z Shell, add Homebrew to PATH::

    export PATH=/opt/homebrew/bin:$PATH

Version Control
===============

Git::

    brew install git

Output::

    ==> Caveats
    The OS X keychain credential helper has been installed to:
      /usr/local/bin/git-credential-osxkeychain

    The 'contrib' directory has been installed to:
      /usr/local/share/git-core/contrib

    Bash completion has been installed to:
      /usr/local/etc/bash_completion.d

    zsh completion has been installed to:
      /usr/local/share/zsh/site-functions

Set up new public SSH key (or restore existing)::

    mkdir -p ~/.ssh && cd ~/.ssh
    ssh-keygen -t rsa -b 4096 -C "alex@eagerminds.co"
    pbcopy < ~/.ssh/id_rsa.pub

Set global git settings::

    git config --global user.name "Alex Zagoro"
    git config --global user.email "alex@eagerminds.co"
    git config --global color.ui true

GPG Signing::

There are many ways of installing GPG client, the easiest one is via Homebrew or `GPG Suite <https://gpgtools.org/>`_.
After generating the key, add it in `Github settings <https://github.com/settings/keys>`_ and then follow this `article <https://help.github.com/articles/telling-git-about-your-gpg-key/`_ to tell GPG about your key.

wget
----

Install::

    brew install wget

You can use either `bash` or `zshell`, your choice.

Bash
----

Install::

    brew install bash

Update the default shell::

    sudo vim /etc/shells

Paste in above all other entires::

    /usr/local/bin/bash


Add the path to the shell you want to use if not already present, then set it::

    chsh -s /usr/local/bin/bash


Z shell
-------

Install::

    brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting

Output::

    ==> Caveats
    To activate these completions, add the following to your .zshrc:

      fpath=(/usr/local/share/zsh-completions $fpath)

    You may also need to force rebuild `zcompdump`:

      rm -f ~/.zcompdump; compinit

    Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
    to load these completions, you may need to run this:

      chmod -R go-w '/opt/homebrew/share/zsh'

Update default shell::

    chsh -s $(which zsh)

Oh My Zsh
---------

Oh My Zsh is an open source, community-driven framework for managing your zsh configuration. `Instructions <https://github.com/robbyrussell/oh-my-zsh>`_

Install::

    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

powerlevel9k
------------

Oh My Zsh theme. `Instructions <https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#option-2-install-for-oh-my-zsh>`_

Install::

    git clone git@github.com:bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

Install powerline `fonts <https://github.com/powerline/fonts>`_::

    git clone git@github.com:powerline/fonts.git  ~/.oh-my-zsh/custom/fonts
    cd ~/.oh-my-zsh/custom/fonts
    ./install.sh

Keep in mind, you'll need to set the fonts in your `iTerm` Settings -> Profiles -> Text -> Change Font -> Meslo LG S DZ Regular for Powerline.

.zshrc
------

``~/.zshrc`` is available on `Dotfiles repository <https://github.com/StriveForBest/dotfiles>`_

Now link ``.zshrc`` and ``bin``::

    cd
    ln -s /path/to/dotfiles_repo/.zshrc
    ln -s /path/to/dotfiles_repo/bin
    source ~/.zshrc

    
rsync
-----

OSX's default ``rsync`` is old and dumb. Replace it::

    brew install rsync

s3cmd
-----

``brew install s3cmd``

Programming Languages & Web Frameworks
======================================

Python
------

Homebrew installs pip and distribute by default when installing Python::

    brew install python

pyenv (optional)::

    brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper

Hopefully, temporary fix:

    ln -s /usr/local/bin/pip3 /usr/local/bin/pip

pip::

    pip install --upgrade setuptools
    pip install --upgrade pip

virtualenvwrapper::

    pip install virtualenvwrapper

Frontend Tools
--------------

Node::

    brew install node

Npm::

    npm install npm -g

Npm-X (makes commands from local environment available)::

    npm install npx -g

NVM::
    
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash


Data Stores
===========

PostgreSQL
----------

Just download and install Postgres.app from https://postgresapp.com/ (which comes with Postgis)

Enable CLI::

	sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp

Redis
-----

Install::

    brew install redis

Output::

    ==> Caveats
    To start redis now and restart at login:
        brew services start redis
    Or, if you don't want/need a background service you can just run:
        /opt/homebrew/opt/redis/bin/redis-server /opt/homebrew/etc/redis.conf

Search Engine Backends
======================

ElasticSearch
-------------

Install::

    brew install elasticsearch

Run in on system start::

    brew services start elasticsearch


Miscellaneous tools
===================

Zlib
----

    brew install zlib

OpenSSL
----

    brew install openssl
    
JQ
--

jq is a tool for processing JSON inputs, applying the given filter to its JSON text inputs and producing the filter's results as JSON on standard output.

    brew install jq

Vault
-----

Vault is a tool for securely accessing secrets. `Documentaion <https://www.vaultproject.io/intro/index.html>`_

    brew install vault

Htop
----

A tool to display all running processes::

    brew install htop

Cheat
-----

A tool to view/create cheatsheets for *nix commands. Install with easy_install/pip::

    easy_install cheat

Use::

    cheat -l
    cheat tar

Fortune
-------

Some fortune telling wouldn't hurt::

    brew install fortune

Image processing utils
----------------------

Install for full support of PIL/Pillow::

    brew install imagemagick
    brew install freetype graphicsmagick jpegoptim lcms libjpeg libpng libtiff openjpeg optipng pngcrush webp

Video processing utils
---------------------

FFmpeg::

    brew install ffmpeg
    
To see a full list of FFmpeg options::

    brew options ffmpeg


Homebrew maintenance
--------------------

Get a checkup from the doctor and follow the doctor's instructions::

    brew doctor

To update your installed brews::

    brew update
    brew outdated
    brew upgrade
    brew cleanup


OSX-specific settings
=====================

Allow opening apps from unidentified developers::

    sudo spctl --master-disable
