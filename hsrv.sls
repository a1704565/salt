#Copyright 2018 Juha-Pekka Pulkkinen https://github.com/a1704565 GNU General Public License v3.0


#things to install

installer:
  pkg.installed:
    - pkgs:
      - xubuntu-restricted-extras
      - openssh-server
      - tree
      - htop

#Apache2 setup

apache2:
  pkg.installed

/var/www/html/index.html:
  file.managed:
    - source: salt://www/hsrv/index.html

/etc/apache2/mods-enabled/userdir.conf:
  file.symlink:
    - target: ../mods-available/userdir.conf

/etc/apache2/mods-enabled/userdir.load:
  file.symlink:
    - target: ../mods-available/userdir.load

apache2service:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/mods-enabled/userdir.conf
      - file: /etc/apache2/mods-enabled/userdir.load

#PHP setup

php-packages:
  pkg.installed:
    - pkgs:
      - php
      - php-pear
      - php7.2-dev
      - php7.2-zip
      - php7.2-curl
      - php7.2-gd
      - php7.2-mysql
      - php7.2-xml
      - libapache2-mod-php7.2

/etc/apache2/mods-available/php7.2.conf:
  file.managed:
    - source: salt://php/php7.2.conf

/etc/apache2/mods-available/php7.2.load:
  file.managed:
    - source: salt://php/php7.2.load

/etc/apache2/mods-enabled/php7.2.conf:
  file.symlink:
    - target: ../mods-available/php7.2.conf

/etc/apache2/mods-enabled/php7.2.load:
  file.symlink:
    - target: ../mods-available/php7.2.load

php-apache2service:
  service.running:
    - name: apache2
    - onchanges:
      - file: /etc/apache2/mods-available/php7.2.conf
      - file: /etc/apache2/mods-available/php7.2.load

/var/www/html/test.php:
  file.managed:
    - source: salt://www/hsrv/test.php

#Mariadb default setup

mariadb:
  pkg.installed:
    - pkgs:
      - mariadb-server
      - mariadb-client

#Samba setup

samba:
  pkg.installed:
    - pkgs:
      - samba
      - samba-common
      - python-glade2
      - system-config-samba

public-dir:
  cmd.script:
    - name: smbpub.sh
    - source: salt://samba/smbpub.sh
    - unless: ls /samba/public/

/etc/samba/smb.conf:
  file.managed:
    - source: salt://samba/smb.conf
    - user: root
    - group: root
    - mode: 644

samba-service:
  service.running:
    - name: smbd.service
    - onchanges:
      - file: /etc/samba/smb.conf

#ufw setup

/etc/ufw/after6.rules:
  file.managed:
    - source: salt://ufw/after6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/after.rules:
  file.managed:
    - source: salt://ufw/after.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/ufw.conf:
  file.managed:
    - source: salt://ufw/ufw.conf
    - user: root
    - group: root
    - mode: 644

/etc/ufw/user6.rules:
  file.managed:
    - source: salt://ufw/user6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/user.rules:
  file.managed:
    - source: salt://ufw/user.rules
    - user: root
    - group: root
    - mode: 640

ufw-service:
  cmd.run:
    - name: sudo ufw enable
    - onchanges:
      - file: /etc/ufw/after6.rules
      - file: /etc/ufw/after.rules
      - file: /etc/ufw/ufw.conf
      - file: /etc/ufw/user6.rules
      - file: /etc/ufw/user.rules

