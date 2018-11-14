mariadb-server:
  pkg.installed

/etc/mysql/mariadb.cnf:
  file.managed:
    - source: salt://mariadb.cnf

mariadb_service:
  service.running:
    - name: mariadb.service
    - watch:
      - file: /etc/mysql/mariadb.cnf
