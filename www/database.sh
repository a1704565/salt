#!/bin/bash
echo "CREATE DATABASE minion;" | sudo mariadb -u root
echo "GRANT ALL ON minion.* TO minionuser@localhost IDENTIFIED BY 'jotjH_goeYER-83jtej2-insert-better-password';" | sudo mariadb -u root
echo "database for testing purposes has been created" | sudo tee /etc/mysql/done.log
