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

Koneelle on annettu nimi `xuse` ja se tulee olemaan jatkossa salt-master muille myöhemmin määritetyille koneile, joten työstettävä moduuli ajetaan sille lopuksi komennolla `salt-call --local state.highstate`.

Ennen lopullista vaihetta, käytän tilanteen helpottamiseksi toista konetta masterina ja xuse on määritetty tässä vaiheessa minioniksi.

_Väliaikaisen masterin tiedot:_

* Koneen malli: Lenovo Z50-70
* CPU: Intel Core i5-4210U @ 4x 2.7GHz
* RAM: 16GB, 1600MHz DDR3
* GPU: Intel integrated graphics / nVidia GeForce 820
* Käyttöjärjestelmä: Xubuntu 18.04 LTS
* Lyvytila: noin 120GB (SSD), toinen vastaava osio varattu Windows 10 käyttöön

**Huom!** Manuaaliset komennot ajettu ssh-yhteyden yli kohdekoneella.

---

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

# Toteutus

Luotu ShellScript, joka hoitaa perustarpeet kuntoon, eli asentaa salt-masterin ja gitin, sekä kloonaa tarvittavat tiedostot polkuun `/srv/salt/` ja määrittää gitille muutaman globaalin asetuksen.

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

**Selite**

* Ilmoitetaan echolla scriptin aloitus
* Näppäimistön kieli muuttuu suomeksi (ei välttämättä pakollinen, mutta ihan varalta)
* Aikavyöhyke asetetaan Europe/Helsinki (varalta)
* Päivitetään pakettilista
* Asennetaan salt-master ja git
* kloonataan githubista salt.git sisältö polkuun `/srv/salt`
* git globaali asetus user.email
* git globaali asetus user.name
* git globaali asetus, jolla määritetty odotusajaksi tunti ennen seuraavaa salasanakyselyä
* echo ilmoittaa että kaikki on toimenpiteet on suoritettu


Tarkoitus on, että kyseisen skriptin voi hakea koneelle githubista komennolla `wget https://raw.githubusercontent.com/a1704565/salt/master/start/hsrv.sh` ja se voidaan ajaa käyttämällä komentoa `bash`, jolloin edeltävät toiminnot ajetaan.

## hsrv.sls

Salt-tilan kasaaminen aloitettu vanhojen tunneilla ja läksyinä tehtyjen moduulien pohjalta, joita olen muokannut paremmin tähän tarkoitukseen sopivaksi. Hsrv.sls nimi tulee käsitteestä home server. Uusin versio saatavilla tästä [linkistä](https://github.com/a1704565/salt/blob/master/hsrv.sls).

**Keskeneräinen salt-tila**

```YAML
#things to install

installer:
  pkg.installed:
    - pkgs:
      - xubuntu-restricted-extras
      - openssh-server
      - samba

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
    - watch:
      - file: /etc/apache2/mods-enabled/php7.2.conf
      - file: /etc/apache2/mods-enabled/php7.2.load

/var/www/html/test.php:
  file.managed:
    - source: salt://www/hsrv/test.php

#Mariadb default setup

mariadb:
  pkg.installed:
    - pkgs:
      - mariadb-server
      - mariadb-client
```
**Selite**

1. #things to install
  * asennetaan xubuntu-restricted-extras
  * asennetaan openssh-server
  * asennetaan samba
2. #Apache2 setup
  * asennetaan apache2
  * vaihdetaan etusivuksi index.html, joka löytyy saltin polusta `salt://www/hsrv/index.html`.
  * otetaan käyttöön userdir-moduuli
  * mikäli muutosta tapahtuu, käynnistetän palvelu apache2 uudestaan
3. #PHP setup
  * Asennetaan php, php-pear, php7.2-dev, php7.2-zip, php7.2-curl, php7.2-gd, php7.2-mysql, php7.2-xml & libapache2-mod-php7.2
  * haetaan php7.2.conf ja php7.2load sisältö polkuun `/etc/apache2/mods-available/`saltin polusta `salt://php/php7.2.conf`
  * varmistetaan että jos muutoksia on, niin apache2 käynnistyy uudestaan (sama kaava kuin vaiheessa 2.)
  * haetaan testi.php polkuun `/var/www/html/test.php` saltin polusta `salt://www/hsrv/test.php`
4. #Mariadb default setup
  * asennetaan mariadb-server ja mariadb-client, asetuksia ei muuteta

**Testaus**

Ajettu edeltävää useamman kerran komennolla `sudo salt '*' state.highstate` käyttäen väliaikaista master konetta. Tämä toimii, koska top.sls on määritetty seuraavasti:

```YAML
base:
  '*':
    - workstation

  'xuse':
    - hsrv
```
**Selite**

Top.sls sisältöön on määritetty, että kaikille koneille suoritetaan tila workstation, mutta koneelle xuse ajetaan tila nimeltä hsrv.

**Tulokset**

Tulokset muutaman ajon jälkeen ovat samat, kuin ensimmäiselläkin ajolla, toki runtime on tässä huomattavasti pienempi kuin ensimmäisellä kerralla;

```Shell
Summary for xuse
-------------
Succeeded: 15
Failed:     0
-------------
Total states run:     15
Total run time:    1.860 s
```


## Palomuurin asetukset

Aluksi ajettu tahdotut asetukset käsin, jotta automatisointi onnistuu myöhemmin:

```Shell
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 'Apache Full'
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Samba'
sudo ufw allow 4505/tcp
sudo ufw allow 4506/tcp
sudo ufw enable

sudo ufw status verbose

Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
80,443/tcp (Apache Full)   ALLOW IN    Anywhere
22/tcp (OpenSSH)           ALLOW IN    Anywhere
137,138/udp (Samba)        ALLOW IN    Anywhere
139,445/tcp (Samba)        ALLOW IN    Anywhere
4505/tcp                   ALLOW IN    Anywhere
4506/tcp                   ALLOW IN    Anywhere
80,443/tcp (Apache Full (v6)) ALLOW IN    Anywhere (v6)
22/tcp (OpenSSH (v6))      ALLOW IN    Anywhere (v6)
137,138/udp (Samba (v6))   ALLOW IN    Anywhere (v6)
139,445/tcp (Samba (v6))   ALLOW IN    Anywhere (v6)
4505/tcp (v6)              ALLOW IN    Anywhere (v6)
4506/tcp (v6)              ALLOW IN    Anywhere (v6)
```
**Selite**
* `ufw default deny incoming` Estetään oletuksena kaikki tuleva liikenne
* `ufw default allow outgoing` Sallitaan oletuksena lähtevä liikenne
* `ufw allow 'Apache Full'` Sallitaan Apache Full, eli TCP portit 80 ja 443
* `ufw allow 'OpenSSH'` Sallitaan OpenSSH, eli TCP portti 22
* `ufw allow 'Samba'` Sallitaan Samba, eli UDP portit 137 ja 138, sekä TCP portit 139 ja 445
* `ufw allow 4505/tcp` + `ufw allow 4506/tcp` Sallitaan Salt-masterin käyttämät TCP portit 4505 ja 4506
* `ufw enable` käynnistetty palomuuri sääntöineen
* `ufw status verbose` tarkastettu palomuurin nykyinen tila

**Pohdintaa**
Ufw tekee asetukset useampaan tiedostoon sijainnissa `/etc/ufw` tässä tapauksessa tärkeässä roolissa näyttäisi olevan viisi tiedostoa, sillä näiden sisältö oli muuttunut tekemieni manuaalisten sääntöjen jälkeen.

```Shell
-rw-r-----   1 root root  915 joulu 10 09:37 after6.rules
-rw-r-----   1 root root 1004 joulu 10 09:37 after.rules
-rw-r--r--   1 root root  313 joulu 10 09:40 ufw.conf
-rw-r-----   1 root root 2,1K joulu 10 09:40 user6.rules
-rw-r-----   1 root root 2,1K joulu 10 09:40 user.rules
```

Kopioitu nämä tiedostot talteen luomaani kansioon `ufw`, joka löytyy saltin kansiorakenteen sisältä.

**Palomuuriasetusten automaatio**

Tämä osuus lisätty tiedostoon hsrv.sls:

```YAML
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
```

**selite**

* Kaikki 5kpl tiedostoja on kopioitu kohteen polkuun `/etc/ufw/` saltin polusta `salt://ufw/`.
* Kaikille tiedostoille on määritetty omistajaksi ja ryhmäksi root
* Yhdelle teidostolle on määritetty oikeudet 644;
  * omistajalla = luku- ja kirjoitusoikeus
  * ryhmällä = lukuoikeus
  * julkisesti = lukuoikeis
* Muilla tiedostoilla on oikeudet 640;
  * omistajalla = luku- ja kirjoitusoikeus
  * ryhmällä = lukuoikeus
* Mikäli muutoksia `onchanges` tulee edellä mainittuihin tieostoihin, niin suoritetaan komento `sudo ufw enable`, joka määrittää palomuurin takaisin käyttöön.

**Testaus**

Ajettu ensin highstate sellaisenaan:

```Shell
sudo salt '*' state.highstate

###

Summary for xuse
-------------
Succeeded: 21
Failed:     0
-------------
Total states run:     21
Total run time:    2.007 s
```

Muutettu aluksi palomuurin asetuksia ja poistettu se käytöstä, ennen highstaten ajamista uudelleen:

```Shell
sudo salt '*' state.highstate

###

Summary for xuse
-------------
Succeeded: 21 (changed=4)
Failed:     0
-------------
Total states run:     21
Total run time:    3.065 s
```

Tarkastettu tilanne ssh-yhteyden yli kohdekonella:

```Shell
sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
80,443/tcp (Apache Full)   ALLOW IN    Anywhere
22/tcp (OpenSSH)           ALLOW IN    Anywhere
137,138/udp (Samba)        ALLOW IN    Anywhere
139,445/tcp (Samba)        ALLOW IN    Anywhere
4505/tcp                   ALLOW IN    Anywhere
4506/tcp                   ALLOW IN    Anywhere
80,443/tcp (Apache Full (v6)) ALLOW IN    Anywhere (v6)
22/tcp (OpenSSH (v6))      ALLOW IN    Anywhere (v6)
137,138/udp (Samba (v6))   ALLOW IN    Anywhere (v6)
139,445/tcp (Samba (v6))   ALLOW IN    Anywhere (v6)
4505/tcp (v6)              ALLOW IN    Anywhere (v6)
4506/tcp (v6)              ALLOW IN    Anywhere (v6)
```
Kaikki näyttäisi toimivan tähän asti hyvin.

## Samba


