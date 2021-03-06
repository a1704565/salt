Copyright 2018 Juha-Pekka Pulkkinen https://github.com/a1704565 GNU General Public License v3.0

# Raportti - Oma Moduuli

Aloitettu 10.12.2018 klo: 2:32

---


_Koneen tiedot:_

* Koneen malli: Fujitsu Scaleo P2 AMD690VM-FM
* CPU: AMD Athlon Dual Core 4850e @ 2x 2.5GHz
* RAM: 2GB
* GPU: AMD Radeon X1200
* Käyttöjärjestelmä: Xubuntu 18.04.01 LTS
* Levytila: 2x 250GB HDD 

Koneelle on annettu nimi `xuse` ja se tulee olemaan jatkossa salt-master muille myöhemmin määritetyille koneille, joten työstettävä moduuli ajetaan sille lopuksi komennolla `salt-call --local state.highstate`.

Ennen lopullista vaihetta, käytän tilanteen helpottamiseksi toista konetta masterina ja xuse on määritetty tässä vaiheessa minioniksi.

_Väliaikaisen masterin tiedot:_

* Koneen malli: Lenovo Z50-70
* CPU: Intel Core i5-4210U @ 4x 2.7GHz
* RAM: 16GB, 1600MHz DDR3
* GPU: Intel integrated graphics / nVidia GeForce 820
* Käyttöjärjestelmä: Xubuntu 18.04 LTS
* Levytila: noin 120GB (SSD), toinen vastaava osio varattu Windows 10 käyttöön

**Huom!** Manuaaliset komennot ajettu ssh-yhteyden yli kohdekoneella.

---

## Varaamani aihe

![varattu aihe](/img/varaus.png "varattu aihe")


## Tilanteen kartoitus

Listaus asioista, jotka tahdon toimimaan alustavasti kotipalvelimella:

- LAMP
  - Apache2
  - PHP 7.2
    - yleiset moduulit
  - MariaDB (client ja server)
- OpenSSH-server
- samba
  - samba-common
  - python-glade2
  - system-config-samba
- git
- salt-master
- xubuntu-restricted-extras
- ufw
  - asetukset valmiiksi

Lista saattaa muuttua vielä työn edetessä.

# Toteutus

Luotu Shell-skripti `hsrv.sh`, joka hoitaa perustarpeet kuntoon, eli asentaa salt-masterin ja gitin, sekä kloonaa tarvittavat tiedostot polkuun `/srv/salt/` ja määrittää gitille muutaman globaalin asetuksen. Uusin versio skriptistä löytyy [täältä](https://github.com/a1704565/salt/blob/master/start/hsrv.sh).

```Shell
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

* Ilmoitetaan echolla skriptin aloitus
* Näppäimistön kieli muuttuu suomeksi (ei välttämättä pakollinen, mutta ihan varalta)
* Aikavyöhyke asetetaan Europe/Helsinki (varalta)
* Päivitetään pakettilista
* Asennetaan salt-master ja git
* kloonataan githubista salt.git sisältö polkuun `/srv/salt`
* git globaali asetus user.email
* git globaali asetus user.name
* git globaali asetus, jolla määritetty odotusajaksi tunti ennen seuraavaa salasanakyselyä
* echo ilmoittaa, että kaikki on toimenpiteet on suoritettu


Tarkoitus on, että kyseisen skriptin voi hakea koneelle githubista komennolla `wget https://raw.githubusercontent.com/a1704565/salt/master/start/hsrv.sh` ja se voidaan ajaa käyttämällä komentoa `bash`, jolloin edeltävät toiminnot ajetaan.

## hsrv.sls

Salt-tilan kasaaminen aloitettu vanhojen tunneilla ja läksyinä tehtyjen moduulien pohjalta, joita olen muokannut paremmin tähän tarkoitukseen sopivaksi. Hsrv.sls nimi tulee käsitteestä home server. Uusin versio löytyy tästä [linkistä](https://github.com/a1704565/salt/blob/master/hsrv.sls).

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
  * haetaan php7.2.conf ja php7.2load sisältö polkuun `/etc/apache2/mods-available/` saltin polusta `salt://php/php7.2.conf`
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
* Yhdelle tiedostolle on määritetty oikeudet 644;
  * omistajalla = luku- ja kirjoitusoikeus
  * ryhmällä = lukuoikeus
  * julkisesti = lukuoikeus
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

Tarkastettu tilanne ssh-yhteyden yli kohde konella:

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

**Lähde:**
[How To Setup a Firewall with UFW on an Ubuntu and Debian Cloud Server](https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server)


## Samba

Koska samba on asetettu, niin päätin luoda sille alustavat asetukset kuntoon tähän tekeillä olevaan salt-tilaan.


### Manuaalinen tapa

Asennettu ensin tarvittavat paketit käsin komennolla `sudo apt-get install samba samba-common python-glade2 system-config-samba`.

Jatkoin kopioimalla talteen kohdekoneella originaalit samba asetukset komennolla `sudo cp -pf /etc/samba/smb.conf /etc/samba/smb.conf.bak`. Tämän jälkeen on turvallisempaa muokata tiedostoa, koska siitä on varmuuskopio.

Muokkasin tiedostoon `smb.conf` tähän tapaukseen sopivat asetukset:

```Shell
[global]
   workgroup = WORKGROUP
   server string = Samba Server %v
   netbios name = xuse
   security = user
   map to guest = bad user
   name resolve order = bcast host
   dns proxy = no
   bind interfaces only = yes

[Public]
   path = /samba/public
   writable = yes
   guest ok = yes
   guest only = yes
   read only = no
   create mode = 0777
   directory mode = 0777
   force user = nobody
```

**Selite:**

* Edeltävien asetusten avulla saadaan julkinen jako aikaiseksi ilman kirjautumista

**Lähde:**
[Samba Setup on Ubuntu 16.04 / 17.10 / 18.04 with Windows Systems](https://websiteforstudents.com/samba-setup-on-ubuntu-16-04-17-10-18-04-with-windows-systems/)


Tämän jälkeen ajoin pari komentoa:

```Shell
sudo mkdir -p /samba/public
sudo chown -R nobody:nogroup /samba/public
sudo chmod -R 0775 /samba/public
sudo systemctl restart smbd.service
```
**Selite:**

* `mkdir -p /samba/public` = ei ilmoita virhettä, jos polulla olevat kansiot ovat jo olemassa, mutta luo tarvittaessa polun  kansiot.
* `sudo chown -R nobody:nogroup /samba/public` = rekursiivinen tapa muuttaa omistajaksi `nobody` ja ryhmäksi `nogroup`
* `chmod -R 0775 /samba/public` = rekursiivinen tapa antaa oikeudet;
  * Omistaja = luku, kirjoitus, suoritus
  * Ryhmä = luku, kirjoitus, suoritus
  * julkinen = luku ja suoritus
* `sudo systemctl restart smbd.service` käynnistää uudestaan samban, jotta muutokset tulisivat voimaan.

**Lähde:**
[Samba Setup on Ubuntu 16.04 / 17.10 / 18.04 with Windows Systems](https://websiteforstudents.com/samba-setup-on-ubuntu-16-04-17-10-18-04-with-windows-systems/)


### Testaus

Väliaikaisella masterilla avattu Thunar ja avattu kohde `smb://xuse.local/public/` Lisätty satunnainen valokuva `public` kansioon nimeltä `DSC_1792.JPG`.

SSH-yhteyden kautta kohdekoneella tarkasteltu kansiota:

```Shell
ls -lah /samba/public/
total 8,7M
drwxrwxr-x 2 nobody nogroup 4,0K joulu 11 01:07 .
drwxr-xr-x 3 root   root    4,0K joulu 11 00:33 ..
-rwxrw-rw- 1 nobody nogroup 8,6M elo   23 23:59 DSC_1792.JPG
```
Kaikki näyttäisi toimivan.

Testattu myös toimiiko jako paikallisella Windows 7 koneella:

![Samba 01](/img/smb/smb01.png "Windows näkee jaon")

Windows näkee jaon.

![Samba 02](/img/smb/smb02.png "Jaettu tiedosto näkyy ja sen voi avata")

Windows näkee myös jaetun tiedoston ja sen voi avata.

Testattu seuraavaksi Android-puhelimella samaa:

![Samba 03](/img/smb/smb03.jpg "Android näkee jaon")

Android (FX File Explorer) näkee jaon.

![Samba 04](/img/smb/smb04.jpg "Jaettu tiedosto näkyy ja sne voi avata")

Android (FX File Explorer) näkee tiedoston ja sen voi myös avata.


Kaikki näyttäisi toimivan odotusten mukaisesti.

### Automatisointi

Lisätty seuraava koodi tiedostoon hsrv.sls, jotta paketit asentuisivat:

```YAML
samba:
  pkg.installed:
    - pkgs:
      - samba
      - samba-common
      - python-glade2
      - system-config-samba
```

Koska asetukset ovat jo sopivat manuaalisen tilanteen jälkeen, niin kopioin tiedoston `smb.conf` saltin omaan polkuun `salt://samba/smb.conf`.

Lisäsin seuraavan koodin automatisointiin, jotta asetukset kopioituvat kohteelle jatkossa oikein.

```Shell
/etc/samba/smb.conf:
  file.managed:
    - source: salt://samba/smb.conf
    - user: root
    - group: root
    - mode: 644
```

Loin Shell-skriptin nimeltä `smbpub.sh`, joka huolehtii kansioista ja oikeuksista, vaikka tämän voisi tietysti luoda suoraan saltilla, mutta hallitsen tämän tyylin paremmin.

```Shell
#!/bin/bash

sudo mkdir -p /samba/public
sudo chown -R nobody:nogroup /samba/public
sudo chmod -R 0775 /samba/public
```

Luotu hsrv.sls-tiedostoon seuraava kohta, jolla ajetaan tuo luotu Shell-skripti:

```
public-dir:
  cmd.script:
    - name: smbpub.sh
    - source: salt://samba/smbpub.sh
    - unless: ls /samba/public/
```
**Selite**

Logiikka koodissa toimii siten, että `cmd.script` ajaa tuon luodun skriptin `smbpub.sh`, paitsi jos polku samba/public on jo olemassa.


Muutokset tulevat voimaan vasta uudelleenkäynnistyksen jälkeen, joten tehty tähän seuraava koodi:

```YAML
samba-service:
  service.running:
    - name: smbd.service
    - onchanges:
      - file: /etc/samba/smb.conf
```
**Selite:**
Mikäli muutoksia tulee tiedostoon plussa `/etc/samba/smb.conf`, niin käynnistetään uudestaan samban palvelu `smbd.service`.

### Testaus

Ajettu higstatea monia kertoja, kun ensin on poisteltu kansioita ja muutettu asetuksia, ja kaikki toimii kuten pitääkin.

Lopullinen testi:

* Asennettu xubuntu 18.04.1 LTS uudestaan kohde koneelle
* Ladattu Shell-skripti githubista komennolla `wget https://raw.githubusercontent.com/a1704565/salt/master/start/hsrv.sh`
* Ajettu skripti komennolla `bash hsrv.sh`
* Todettu, että skripti suoritettiin loppuun onnistuneesti
* Annettu komento `salt-call --local state.highstate`

Tulos:

```Shell
Summary for local
-------------
Succeeded: 25 (changed=20)
Failed:     0
-------------
Total states run:     25
Total run time:  436.418 s
```

* Annettu uudestaa komento `salt-call --local state.highstate`, jotta nähdään tuleeko tarpeettomasti muutoksia virheen ansiosta

Tulos:

```Shell
Summary for local
-------------
Succeeded: 25
Failed:     0
-------------
Total states run:     25
Total run time:    1.595 s
```

* Tarkastettu palomuurin ominaisuudet ajamalla komento `sudo ufw status verbose`

Tulos:

```Shell
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

* Tarkastettu, että index.html ja hello.php näkyvät oikein
* Testattu samban toimivuus, lisätty satunnainen tiedosto jaettuun kansioon paikallisella tietokoneella, jossa käytössä Windows 10 Pro käyttöjärjestelmä
* Tarkastettu miten tiedosto näkyy palvelimella (xuse) ajamalla sillä komento `ls -lah /samba/public/`

```Shell
total 8,0M
drwxrwxr-x 2 nobody nogroup 4,0K joulu 11 06:43 .
drwxr-xr-x 3 root   root    4,0K joulu 11 06:35 ..
-rwxrw-rw- 1 nobody nogroup 8,0M elo   24 00:02 DSC_2329.JPG
```

* Tarkastettu htop toimivuus ajamalla komento `htop` tietokoneella xuse
* Tarkastettu tree toimivuus ajamalla komento `tree` tietokoneella xuse

Kaikki näyttäisi toimivan odotusten mukaisesti. Testaus voidaan päättää tähän.


# Lopputulos

Tuotettu koodi, sekä käytetyt asetustiedostot:

* [Shell-skripti - hsrv.sh](https://github.com/a1704565/salt/blob/master/start/hsrv.sh)
* [Salt-tila - hsrv.sls](https://github.com/a1704565/salt/blob/master/hsrv.sls)
* [HTML- ja PHP-sisältö](https://github.com/a1704565/salt/tree/master/www/hsrv)
* [PHP-asetukset](https://github.com/a1704565/salt/tree/master/php)
* [Samba asetukset ja Shell-skripti](https://github.com/a1704565/salt/tree/master/samba)
* [Palomuurin asetukset](https://github.com/a1704565/salt/tree/master/ufw)

Salt-tilan lopullinen versio:

```YAML
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


```

# Pohdintoja lopputuloksen jälkeen

Periaatteessa olisi mahdollista asettaa nykyinen master, eli kone nimeltä `xuse` myös omaksi minionikseen, jolloin ylläpito automatisoituisi edeltävien asetusten kannalta. En kuitenkaan ole vielä päättänyt, mitä muita ominaisuuksia lisään koneeseen tämän projektin päätyttyä, joten tilanne jää tämän osalta auki toistaiseksi.

Tarkoitus kuitenkin olisi, että kyseinen kone toimisi Salt-masterina jatkossa muille koneilleni ja ehkäpä jopa muiden sukulaisten ja tuttavien koneille, koska siitä olisi vain ylläpidollista hyötyä.

Suunnitelmissa on lisätä koneelle todennäköisesti vielä Nextcloud-palvelu ja ottaa käyttöön Dynaaminen DNS, joka mahdollistaa palvelimen helpomman käytön.

---

# Lähdeluettelo

- https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html
- https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server
- https://websiteforstudents.com/samba-setup-on-ubuntu-16-04-17-10-18-04-with-windows-systems/
