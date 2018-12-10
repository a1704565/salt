Copyright 2018 Juha-Pekka Pulkkinen https://github.com/a1704565 GNU General Public License v3.0

# Raportti -  Oma Moduuli

Aloitettu 10.12.2018 klo: 2:32

---


_Koneen tiedot:_

* Koneen malli: Fujitsu Scaleo P2 AMD690VM-FM
* CPU: AMD Athlon Dual Core 4850e @ 2x 2.5GHz
* RAM: 2GB
* GPU: AMD Radeon X1200
* Käyttöjärjestelmä: Xubuntu 18.04.01 LTS
* Lyvytila: 2x 250GB HDD 

Kone tulee olemaan myös jatkossa salt-master muille myöhemmin määritetyille koneile, joten työstettävä moduuli ajetaan sille vain kerran `salt-call --local` komennolla.

## Tilanteen kartoitus

Listaus asioista, jotka tahdon toimimaan alustavasti kotipalvelimella:

- LAMP
  - Apache2
  - PHP 7.2
    - yleiset moduulit
  - MariaBD (client ja server)
- OpenSSH-server
- samba
- git
- salt-master
- xubuntu-restricted-extras
- ufw
  - asetukset valmiiksi

Lista saattaa muuttua vielä työn edetessä.

## Toteutus

Luotu ShellScript, joka hoitaa perustarpeet kuntoon, eli asentaa salt-masterin ja gitin, sekä kloonaa tarvittavat tiedostot polkuun `/srv/salt/` j amäärittää gitille muutaman globaalin asetuksen.

```ShellScript
#!/bin/bash

echo "Running the start script! Please wait..."

setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
sleep 2s
sudo apt-get update
sudo apt-get install -y salt-master git
sudo git clone https://github.com/a1704565/salt.git /srv/salt

git config --global user.email "juha-pekka.pulkkinen@myy.haaga-helia.fi"
git config --global user.name "Juha-Pekka Pulkkinen"
git config --global credential.helper "cache --timeout=3600"

echo "Everything complete! Salt-master and git have been isntalled, clone from github is ready."
```

Tarkoitus on, että kyseisen skriptin voi hakea koneelle githubista komennolla `wget https://raw.githubusercontent.com/a1704565/salt/master/start/hsrv.sh` ja ajaa käyttämällä komentoa `bash`, jolloin edeltävät toiminnot ajetaan.
