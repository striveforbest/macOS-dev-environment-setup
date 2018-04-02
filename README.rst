===============================
Configuring OSX for Development
===============================

This doc assumes you are doing a clean install of `Homebrew <http://mxcl.github.io/homebrew/>`_ on a clean install of OSX 10.12.x (Yosemite) with Xcode 8.3.x.

Xcode
-----

Install Xcode from the App Store.
Install Command Line Tools::

    xcode-select --install

Homebrew
--------

Install::

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor

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

wget
----

Handy to have in general (especially if you're copy/paste-ing someone else's commands... like below in this very document)::

    brew install wget

.bash_profile (If using Z Shell, skip to `here <https://github.com/StriveForBest/osx-dev-environment-setup#z-shell>`_).
-------------

``~/.bash_profile`` is available on `Dotfiles repository <https://github.com/StriveForBest/dotfiles>`_

Now link ``.bash_profile`` and ``bin``::

    cd
    ln -s /path/to/dotfiles_repo/.bash_profile
    ln -s /path/to/dotfiles_repo/bin
    source ~/.bash_profile

Bash completion
---------------

Install::

    brew install bash-completion

Output::

    ==> Caveats
    Add the following lines to your ~/.bash_profile:
      if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
      fi

    Homebrew's own bash completion script has been installed to
      /usr/local/etc/bash_completion.d

    Bash completion has been installed to:
      /usr/local/etc/bash_completion.d

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

      chmod go-w '/usr/local/share'

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

    brew install python@2

pyenv::

    brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper

pip::

    pip install --upgrade setuptools
    pip install --upgrade pip

virtualenvwrapper::

    pip install virtualenvwrapper

iPython/iPDB::

    pip install readline ipython ipdb

Django bash completion (Z Shell users can skip)::

    mkdir ~/.django

    wget --no-check-certificate https://raw.github.com/django/django/c09f6ff0a58d016eeb7536f1df1fa956f94f671c/extras/django_bash_completion -O ~/.django/django_bash_completion

Ruby & Rails
------------

Install ruby gems without sudo::

    sudo gem update --system
    sudo chown -R $USER /Library/Ruby /Library/Perl /Library/Python

    echo "gem: -n/usr/local/bin" >> ~/.gemrc

This installs both Ruby and Rails in one go::

    \curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled

Frontend Tools
--------------

Node::

    brew install node

Npm::

    npm install npm -g

Npm-X (makes commands from local environment available)::

    npm install npx -g

Less::

    npm install less -g

Bower::

    npm install bower -g

Version Control
===============

Mercurial::

    brew install mercurial

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

    cd ~/.ssh
    ssh-keygen -t rsa -C "alex.zagoro@eagerminds.nyc"
    pbcopy < ~/.ssh/id_rsa.pub

Set global git settings::

    git config --global user.name "Alex Zagor"
    git config --global user.email "alex.zagoro@eagerminds.nyc"
    git config --global color.ui true

Add git aliases and default settings to ``~/.gitconfig``::

    [alias]
        co = checkout
        ci = commit
        st = status
        br = branch
        hist = log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short
        type = cat-file -t
        dump = cat-file -p
        delremotebranch = push origin --delete

    [push]
        default = simple

    [merge]
        ff = true

Git Flow::

    brew install git-flow

SVN::

    brew install svn


Data Stores
===========

PostgreSQL
----------

Just download and install Postgres.app from http://postgresapp.com/ (which comes with Postgis)

Enable CLI::

	sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp


MySQL
-----

PostgreSQL is always preferred but sometimes you don't have a choice::

    brew install mysql

Output::

    ==> Caveats
    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    To connect:
      mysql -uroot

    To have launchd start mysql at login:
      ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    Then to load mysql now:
      launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
    Or, if you don't want/need launchctl, you can just run:
      mysql.server start

Create a database and set permissions for development::

    mysql -uroot

    CREATE DATABASE project CHARACTER SET UTF8;
    GRANT ALL PRIVILEGES ON project.* TO 'web'@'localhost' WITH GRANT OPTION;

MongoDB
-------

Install::

    brew install mongodb

Output::

    ==> Caveats
    To have launchd start mongodb at login:
        ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
    Then to load mongodb now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
    Or, if you don't want/need launchctl, you can just run:
        mongod


You have to create a data directory. By default it expects the data to be stored in ``/data/db``
Otherwise, create a directory and pass the path when running the server::

    mongod --dbpath=/Users/sallysue/Projects/data/mongodb

Redis
-----

Install::

    brew install redis

Output::

    ==> Caveats
    To have launchd start redis at login:
        ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
    Then to load redis now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
    Or, if you don't want/need launchctl, you can just run:
        redis-server /usr/local/etc/redis.conf

Memcached
---------

Install::

    brew install memcached

Output::

    To have launchd start memcached at login:
        ln -sfv /usr/local/opt/memcached/*.plist ~/Library/LaunchAgents
    Then to load memcached now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist
    Or, if you don't want/need launchctl, you can just run:
        /usr/local/opt/memcached/bin/memcached


Search Engine Backends
======================

ElasticSearch
-------------

Install::

    brew install elasticsearch

Run in on system start::

    brew services start elasticsearch


Web Servers
===========

Nginx
-----

Install::

    gem install passenger
    brew install nginx --with-passenger --with-debug --with-spdy --with-gunzip

Output::

    ==> Caveats
    Docroot is: /usr/local/var/www

    The default port has been set to 8080 so that nginx can run without sudo.

    If you want to host pages on your local machine to the wider network you
    can change the port to 80 in: /usr/local/etc/nginx/nginx.conf

    You will then need to run nginx as root: `sudo nginx`.

    To have launchd start nginx at login:
        ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
    Then to load nginx now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist

Apache
------

Homebrew relies on the supplied OSX version of Apache, it just adds modules to it from a tap.
See https://github.com/Homebrew/homebrew-apache for more information.


Miscellaneous tools
===================

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

    brew install imagemagick --with-jp2
    brew install freetype graphicsmagick jpegoptim lcms libjpeg libpng libtiff openjpeg optipng pngcrush webp

Vide processing utils
---------------------

FFmpeg::

	brew install ffmpeg --with-fdk-aac --with-tools --with-theora –-with-openssl --with-openjpeg --with-libvpx  --with-libvorbis --with-libass --with-freetype --with-fdk-aac

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

iTerm2
------

Themes::

    git@github.com:baskerville/iTerm-2-Color-Themes.git
    https://github.com/kevintuhumury/osx-settings/tree/master/iterm2

Sublime3
--------

Open Sublime3 from Terminal::

    ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

Sync Sublime3 Packages using Google Drive::

First Machine::

    cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/
    mkdir -p ~/Google\ Drive/Install/sublime3
    mv User ~/Google\ Drive/Install/sublime3/
    ln -s ~/Google\ Drive/Install/sublime3/User

Other Machine(s)::

    cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/
    rm -r User
    ln -s ~/Google\ Drive/Install/sublime3/User

Install Package Control::

Open Sublime console ``ctrl+``` and paste::

    import urllib.request,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

Themes::

    cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    git clone https://github.com/mrlundis/Monokai-Dark-Soda.tmTheme

    cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/
    git clone https://github.com/buymeasoda/soda-theme/ "Theme - Soda"

Alternative themes are available at ``https://github.com/daylerees/colour-schemes``.

User settings, Key Bindings and most of the packages are synced via Google Drive but here is a list of packages::

    {
        "installed_packages":
        [
            "AdvancedNewFile",
            "ApacheConf.tmLanguage",
            "BracketHighlighter",
            "Dayle Rees Color Schemes",
            "Djaneiro",
            "DocBlockr",
            "Emmet",
            "GitGutter",
            "Gitignore",
            "Gutter Color",
            "Hayaku - tools for writing CSS faster",
            "HTML5",
            "Jinja2",
            "JSONLint",
            "Laravel Blade Highlighter",
            "LESS",
            "Less2Css",
            "lessc",
            "Pretty JSON",
            "Python Flake8 Lint",
            "Sass",
            "SCSS",
            "SideBarEnhancements",
            "SideBarGit",
            "Slug",
            "SublimeCodeIntel",
            "SublimeLinter",
            "SublimeLinter-flake8",
            "SublimeLinter-gjslint",
            "SublimeLinter-jshint",
            "SublimeLinter-json",
            "SublimeLinter-pep8",
            "SublimeLinter-php",
            "SublimeLinter-rst",
            "SublimePythonIDE",
            "Syntax Highlighting for Sass",
            "TernJS",
            "Theme - Flatland",
            "Theme - Spacegray"
        ]
    }
