vlcconf:
  file.managed:
    - name: '%appdata%\vlc\vlcrc'
    - source: salt://vlc/vlcrc
