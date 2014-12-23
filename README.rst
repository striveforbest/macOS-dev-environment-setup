===============================
Configuring OSX for Development
===============================

This doc assumes you are doing a clean install of `Homebrew <http://mxcl.github.io/homebrew/>`_ on a clean install of OSX 10.10.x (Yosemite) with Xcode 6.1.x.

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

.bash_profile
-------------

``~/.bash_profile`` is available on `Dotfiles repository <https://github.com/StriveForBest/dotfiles>`_

Now link ``.bash_profile`` and ``bin``::

    cd
    ln -s /path/to/dotfiles_repo/.bash_profile
    ln -s /path/to/dotfiles_repo/bin
    source ~/.bash_profile

Bash
----

Install::

    brew install bash

Update the default shell::

    sudo vi /etc/shells

Add the path to the shell you want to use if not already present, then set it::

    chsh -s /usr/local/bin/bash

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

wget
----

Handy to have in general (especially if you're copy/paste-ing someone else's commands... like below in this very document)::

    brew install wget

rsync
-----

OSX's default ``rsync`` is old and dumb. Replace it::

    brew tap homebrew/dupes
    brew install rsync
    brew untap homebrew/dupes

s3cmd
-----

``brew install s3cmd``

Programming Languages & Web Frameworks
======================================

Python
------

Homebrew installs pip and distribute by default when installing Python::

    brew install python --framework

pip::

    sudo pip install --upgrade setuptools
    sudo pip install --upgrade distribute
    sudo pip install --upgrade pip

virtualenv::

    easy_install virtualenv

iPython/iPDB::

    easy_install readline
    easy_install ipython ipdb

Django bash completion::

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

Sass::

    gem install sass

Node::

    brew install node

Npm::

    curl https://npmjs.org/install.sh | sh

Less::

    npm install -g less

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
    ssh-keygen -t rsa -C "typhoon.man@gmail.com"
    pbcopy < ~/.ssh/id_rsa.pub

Set global git settings::

    git config --global user.name "Alex Zagorodniuk"
    git config --global user.email "typhoon.man@gmail.com"
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

    [push]
        default = simple

    [merge]
        ff = true

SVN::

    brew install svn


Data Stores
===========

PostgreSQL
----------

Install::

    brew install postgres

Output::

    ==> Caveats
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/Homebrew/homebrew/issues/issue/2510

    To migrate existing data from a previous major version (pre-9.3) of PostgreSQL, see:
      http://www.postgresql.org/docs/9.3/static/upgrading.html

    When installing the postgres gem, including ARCHFLAGS is recommended:
      ARCHFLAGS="-arch x86_64" gem install pg

    To install gems without sudo, see the Homebrew wiki.

    To load postgresql:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    Or, if you don't want/need launchctl, you can just run:
        postgres -D /usr/local/var/postgres

Related spatial libraries::

    easy_install numpy
    brew install gdal geos

PostGIS::

    brew install postgis

Output::

    ==> Caveats
    To create a spatially-enabled database, see the documentation:
      http://postgis.refractions.net/documentation/manual-2.0/postgis_installation.html#create_new_db_extensions
    and to upgrade your existing spatial databases, see here:
      http://postgis.refractions.net/documentation/manual-2.0/postgis_installation.html#upgrading

    PostGIS SQL scripts installed to:
      /usr/local/share/postgis
    PostGIS plugin libraries installed to:
      /usr/local/opt/postgresql/lib
    PostGIS extension modules installed to:
      /usr/local/opt/postgresql/share/postgresql/extension

To create a database instance::

    initdb /usr/local/var/postgres -E utf8

You can now start the database server using::

    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

Or to set it to start automatically, see the output above after installing postgresql.

Create the spatially enabled template::

    createdb template_postgis
    psql -f /usr/local/share/postgis/postgis.sql template_postgis
    psql -f /usr/local/share/postgis/spatial_ref_sys.sql template_postgis

Create users::

    createuser -s web

To create a spatially enabled database::

    createdb -T template_postgis mydbname

If you are getting Permission Denied error, run::

    curl http://nextmarvel.net/blog/downloads/fixBrewLionPostgres.sh | sh

    psql -f /usr/local/share/postgis/postgis.sql template_postgis
    psql -f /usr/local/share/postgis/spatial_ref_sys.sql template_postgis
    psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
    psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
    psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"


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


Task Queues
===========

Rabbit MQ
---------

Install::

    brew install rabbitmq

Output::

    ==> Caveats
    Management Plugin enabled by default at http://localhost:15672

    Bash completion has been installed to:
      /usr/local/etc/bash_completion.d

    To have launchd start rabbitmq at login:
        ln -sfv /usr/local/opt/rabbitmq/*.plist ~/Library/LaunchAgents
    Then to load rabbitmq now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.rabbitmq.plist
    Or, if you don't want/need launchctl, you can just run:
        rabbitmq-server

ZeroMQ
------

Install::

    brew install zeromq

Output::

    ==> Caveats
    To install the zmq gem on 10.6 with the system Ruby on a 64-bit machine,
    you may need to do:

    ARCHFLAGS="-arch x86_64" gem install zmq -- --with-zmq-dir=/usr/local/opt/zeromq

Celery
------

Homepage => https://github.com/celery/django-celery/

Install::

    pip install -U Celery

To run::

    ./manage.py celeryd

To configure your Django project to work with Celery/RabbitMQ, see http://docs.celeryproject.org/en/latest/getting-started/brokers/rabbitmq.html


Search Engine Backends
======================

Xapian
------

Install::

    brew install xapian --python

You need to symlink the libraries into your project's virtualenv site-packages::

    ln -s /usr/local/lib/python2.7/site-packages/xapian `pwd`/env/lib/python2.7/site-packages/


Solr
----

Install::

    brew install solr36

Output::

    ==> Caveats
    To start solr:
      solr path/to/solr/config/dir

    See the solr homepage for more setup information:
      brew home solr

    To have launchd start solr36 at login:
        ln -sfv /usr/local/opt/solr36/*.plist ~/Library/LaunchAgents
    Then to load solr36 now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.solr36.plist

You need to copy the lang file::

    cp /usr/local/Cellar/solr/X.X.X/libexec/example/solr/conf/lang/stopwords_en.txt /usr/local/Cellar/solr/X.X.X/libexec/example/solr/conf/.

Now start solr::

    java -jar /usr/local/Cellar/solr/X.X.X/libexec/example/start.jar

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

Cheat
-----

A tool to view/create cheatsheets for *nix commands. Install with easy_install/pip::

    easy_install cheat

Use::

    cheat -l
    cheat tar

https://github.com/coolwanglu/pdf2htmlEX
``brew install pdf2htmlex``

Image processing utils
----------------------

Install for full support of PIL/Pillow::

    brew install imagemagick --with-jp2
    brew install freetype graphicsmagick jpegoptim lcms libjpeg libpng libtiff openjpeg optipng pngcrush webp

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

Google Chrome
-------------

DevTools UI Theme::

    https://github.com/mauricecruz/chrome-devtools-zerodarkmatrix-theme

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
