#Copyright 2018 Juha-Pekka Pulkkinen https://github.com/a1704565 GNU General Public License v3.0

apache2:
  pkg.installed

/var/www/html/index.html:
  file.managed:
    - source: salt://www/index.html

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

mariadb:
  pkg.installed:
    - pkgs:
      - mariadb-server
      - mariadb-client 

database:
  cmd.script:
    - name: database.sh
    - source: salt://www/database.sh
    - creates:
      - /etc/mysql/done.log

php:
  pkg.installed
