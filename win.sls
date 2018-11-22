# Based on work by Tero Karvinen: http://terokarvinen.com/2018/control-windows-with-salt
# This is just for testing at the moment
 
win:
  pkg.installed:
    - pkgs:
      - firefox
      - steam
      - vlc
      - inkscape
      - winscp
      - putty
      - adobereader
      - libreoffice
      - thunderbird
