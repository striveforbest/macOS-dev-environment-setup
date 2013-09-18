===============================
Configuring OSX for Development
===============================

This doc assumes you are doing a clean install of `Homebrew <http://mxcl.github.io/homebrew/>`_ on a clean install of OSX 10.8.x (Mountain Lion) with Xcode 4.6.x.

Install Xcode
-------------

Install Xcode from the App Store.
Open Xcode and select ``Xcode -> Preferences -> Downloads -> Components`` and install Command Line Tools.

Homebrew
--------

Install::

    ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
    brew doctor

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

Add to your ``~/.bash_profile``::

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

Now activate it::

    source ~/.bash_profile

You should also add (to enable colors in the shell)::

    export CLICOLOR=1

wget
----

Handy to have in general (especially if you're copy/paste-ing someone else's commands...like below in this very document)::

    brew install wget

rsync
-----

OSX's default ``rsync`` is old and dumb. Replace it::

    brew tap homebrew/dupes
    brew install rsync
    brew untap homebrew/dupes


Programming Languages & Web Frameworks
======================================

Python
------

Homebrew installs pip and distribute by default when installing Python::

    brew install python --framework

pip::

    pip install --upgrade setuptools
    pip install --upgrade distribute
    pip install --upgrade pip

virtualenv::

    pip install virtualenv

iPython/iPDB::

    easy_install readline
    pip install ipython ipdb

iPython notebook (install zeromq first, see directions below)::

    pip install pyzmq tornado Jinja2


Django bash completion::

    mkdir ~/.django

    wget --no-check-certificate https://raw.github.com/django/django/c09f6ff0a58d016eeb7536f1df1fa956f94f671c/extras/django_bash_completion -O ~/.django/django_bash_completion

Add to ``~/.bash_profile``::

    if [ -f ~/.django/django_bash_completion ]; then
        . ~/.django/django_bash_completion
    fi

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

Add to ``~/.bash_profile``::

    export NODE_PATH="/usr/local/lib/node_modules"

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
    ssh-keygen -t rsa -C "your_email@domain.com"
    pbcopy < ~/.ssh/id_rsa.pub

Set global git settings::

    git config --global user.name "Full Name"
    git config --global user.email "your_email@domain.com"
    git config --global color.ui true

SVN::

    brew install svn


Data Stores
===========

PostgreSQL
----------

Install::
    pip install numpy
    brew install postgresql9

Output::

    ==> Caveats
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/mxcl/homebrew/issues/issue/2510

    To build plpython against a specific Python, set PYTHON prior to brewing:
      PYTHON=/usr/local/bin/python  brew install postgresql
    See:
      http://www.postgresql.org/docs/9.0/static/install-procedure.html


    If this is your first install, create a database with:
      initdb /usr/local/var/postgres9

    If this is your first install, automatically load on login with:
      mkdir -p ~/Library/LaunchAgents
      cp /usr/local/Cellar/postgresql9/9.0.13/org.postgresql.postgres.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

    If this is an upgrade and you already have the org.postgresql.postgres.plist loaded:
      launchctl unload -w ~/Library/LaunchAgents/org.postgresql.postgres.plist
      cp /usr/local/Cellar/postgresql9/9.0.13/org.postgresql.postgres.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

    Or start manually with:
      pg_ctl -D /usr/local/var/postgres9 -l /usr/local/var/postgres9/server.log start

    And stop with:
      pg_ctl -D /usr/local/var/postgres9 stop -s -m fast


    Some machines may require provisioning of shared memory:
      http://www.postgresql.org/docs/current/static/kernel-resources.html#SYSVIPC

    If you want to install the postgres gem, including ARCHFLAGS is recommended:
        env ARCHFLAGS="-arch x86_64" gem install pg

    To install gems without sudo, see the Homebrew wiki.

    To have launchd start postgresql9 at login:
        ln -sfv /usr/local/opt/postgresql9/*.plist ~/Library/LaunchAgents
    Then to load postgresql9 now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql9.plist

PostGIS::

    brew install libgeoip
    brew install postgis15

Output::

    ==> Caveats
    To create a spatially-enabled database, see the documentation:
      http://postgis.refractions.net/documentation/manual-1.5/ch02.html#id2630392
    and to upgrade your existing spatial databases, see here:
      http://postgis.refractions.net/documentation/manual-1.5/ch02.html#upgrading

    PostGIS SQL scripts installed to:
      /usr/local/share/postgis
    PostGIS plugin libraries installed to:
      /usr/local/Cellar/postgresql9/9.0.13/lib

Untap the keg::

    brew untap homebrew/versions

To create a database instance::

    initdb /usr/local/var/postgres9

You can now start the database server using::

    pg_ctl -D /usr/local/var/postgres9 -l /usr/local/var/postgres9/server.log start

Or to set it to start automatically, see the output above after installing postgresql.

If you do not need to support projects using Django < 1.5, you can use the latest PostgreSQL and PostGIS available through homebrew::

    brew install postgres

Output::

    ==> Caveats
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/mxcl/homebrew/issues/issue/2510


    If this is your first install, create a database with:
      initdb /usr/local/var/postgres -E utf8


    To migrate existing data from a previous major version (pre-9.2) of PostgreSQL, see:
      http://www.postgresql.org/docs/9.2/static/upgrading.html


    Some machines may require provisioning of shared memory:
      http://www.postgresql.org/docs/9.2/static/kernel-resources.html#SYSVIPC
    When installing the postgres gem, including ARCHFLAGS is recommended:
      ARCHFLAGS="-arch x86_64" gem install pg

    To install gems without sudo, see the Homebrew wiki.

    To have launchd start postgresql at login:
        ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    Then to load postgresql now:
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    Or, if you don't want/need launchctl, you can just run:
        pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

If you get shared memory error, do next::
    sudo sysctl -w kern.sysv.shmall=65536
    sudo sysctl -w kern.sysv.shmmax=16777216

    And add following to /etc/sysctl.conf (if file doesn’t exist, create it):
    kern.sysv.shmall=65536
    kern.sysv.shmmax=16777216

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

Related spatial libraries::

    pip install numpy
    brew install gdal geos

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


Web Servers
===========

nginx
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

https://github.com/coolwanglu/pdf2htmlEX
``brew install pdf2htmlex``

Image processing utils
----------------------

``brew install optipng jpegoptim pngcrush ImageMagick``

Homebrew maintenance
--------------------

To update your installed brews::

    brew update
    brew outdated
    brew upgrade

Get a checkup from the doctor and follow the doctor's instructions::

    brew doctor

iTerm2
------

Themes::

    git@github.com:baskerville/iTerm-2-Color-Themes.git
    https://github.com/kevintuhumury/osx-settings/tree/master/iterm2

Sublime2
--------

Add Open In Sublime service::

    https://tutsplus.com/lesson/services-and-opening-sublime-from-the-terminal/

Themes::

    https://github.com/mrlundis/Monokai-Dark-Soda.tmTheme

    https://github.com/buymeasoda/soda-theme/
    https://github.com/daylerees/colour-schemes

Linter::

    https://github.com/dreadatour/Flake8Lint

Settings::

    Settings - User::

    {
        "auto_complete_commit_on_tab": true,
        "caret_style": "wide",
        "color_scheme": "Packages/User/Monokai Soda.tmTheme",
        "draw_white_space": "all",
        "ensure_newline_at_eof_on_save": true,
        "file_exclude_patterns":
        [
            ".DS_Store",
            "*.a",
            "*.class",
            "*.db",
            "*.dll",
            "*.dylib",
            "*.exe",
            "*.idb",
            "*.lib",
            "*.log",
            "*.mp4",
            "*.ncb",
            "*.o",
            "*.obj",
            "*.ogv",
            "*.otf",
            "*.pdb",
            "*.psd",
            "*.pyc",
            "*.pyo",
            "*.sdf",
            "*.so",
            "*.sql",
            "*.suo",
            "*.ttf",
            "*.webm"
        ],
        "folder_exclude_patterns":
        [
            "CACHE"
        ],
        "font_size": 11.0,
        "highlight_modified_tabs": true,
        "ignored_packages":
        [
            "Vintage"
        ],
        "indent_guide_options":
        [
            "draw_active"
        ],
        "indent_to_bracket": true,
        "remember_open_files": false,
        "rulers":
        [
            180
        ],
        "soda_classic_tabs": true,
        "tab_size": 4,
        "theme": "Soda Dark.sublime-theme",
        "translate_tabs_to_spaces": true,
        "trim_trailing_white_space_on_save": true,
        "use_tab_stops": true,
        "word_separators": "./\\()\"'-:,.;<>~!@#$%^&*|+=[]{}`~?",
        "wrap_width": 180
    }

    Key Bindings - User::

    [
        { "keys": ["super+k", "super+o"], "command": "swap_case" },
        { "keys": ["super+k", "super+t"], "command": "title_case" },
        { "keys": ["super+\\"], "command": "reindent" },
        { "keys": ["ctrl+n"], "command": "side_bar_new_file2" },
        { "keys": ["ctrl+shift+r"], "command": "side_bar_rename" }
    ]
