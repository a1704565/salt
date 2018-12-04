# Raportti h6

Copyright 2018 Juha-Pekka Pulkkinen [https://github.com/a1704565](https://github.com/a1704565) GNU General Public License v3.0

**Raportoitavissa tehtävissä käytettyjen tietokoneiden tiedot:**

**Master:**

Lenovon kannettava tietokone, jota on käytetty aikaisemmissakin tehtävissä.

_Koneen tiedot:_

* Koneen malli: Lenovo Z50-70
* CPU: Intel Core i5-4210U @ 4x 2.7GHz
* RAM: 16GB, 1600MHz DDR3
* GPU: Intel integrated graphics / nVidia GeForce 820
* Käyttöjärjestelmä: Xubuntu 18.04 LTS
* Lyvytila: noin 120GB (SSD), toinen vastaava osio varattu Windows 10 käyttöön

**Minion**

Itse kasattu pöytäkone, jossa asennettuna Windows 10 Pro, mutta nyt bootattu live-tikulla, jossa Xubuntu 18.04.01 LTS.

_Koneen tieddot:_

* CPU: Intel Core i5-4460 @ 4x 3.2GHz
* Emolevy: Asus Z97M-PLUS, LGA 1150 (BIOS date 02/22/2016)
* RAM: 16GB, 1600MHz (timing 10-10-10-27) DDR3
* GPU: Asus nVidia GeForce GTX 1060 6GB
* Käyttöjärjestelmä: USB-tikulta käynnistetty Xubuntu 18.04.01 LTS
* Lyvytila: 500GB SSD

Master = Lenovo
Minion = labrabuntu

---

Tehtäväksianto löytyy kohdassa h6 tästä linkistä; [terokarvinen.com](http://terokarvinen.com/2018/aikataulu--palvelinten-hallinta-ict4tn022-3004-ti-ja-3002-to--loppukevat-2018-5p) (tarkistettu viimeksi 4.12.2018)


---

## Tehtäväksianto

Asenna LAMP Saltilla.


**Taustatiedot**

Tehtävän tekeminen aloitettu: _klo. 6:38 4.12.2018_

Labrabuntu kone on määritetty tässä vaiheessa minioniksi koneelle Lenovo.

Minulla oli jo omassa gituhubissa jossain vaiheessa testailuun luomani salt tila [lamp.sls](https://github.com/a1704565/salt/blob/master/lamp-old.sls), jota muokkaamalla lähdin toetuttamaan tehtävää.

**Muokattu lamp.sls:**

```SlatStack

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

php:
  pkg.installed

```

**Selitteet:**

- Asennetaan apache2
- Haetaan Masterin salt kansiosta index.html sisältö ja viedään se Minionin polkuun /var/www/html/index.html
- Otetaan käyttöön userdir ominaisuus apachessa, luomalla symbooliset linkit tarpeellisiin kansioihin
- käynnistetään uudestaan apachen palvelu, mikäli valvottavat kohteet userdit.conf tai userdi.load ovat muuttuneet
- asennetaan mariadb client ja server
- asennetaan php

Testaus:

Ajettu ensin lamp.sls salt-tila.

```Shell
Lenovo$ sudo salt '*' state.apply lamp

Summary for labrabuntu
------------
Succeeded: 7 (changed=7)
Failed:    0
------------
Total states run:     7
Total run time:  56.154 s
```

Testattu curlilla, että minionin IP-osoitteessa sivusto (index.html) toimii ja asetukset ovat siis vaihtuneet.

```Shell
Lenovo$ curl 192.168.0.101
<!DOCTYPE html>
<html>
<body>

<h1>Salt minion test</h1>

<p>test!</p>

</body>
</html>
```

Viimeisenä testattu userdir toimivuus minionilla, luomalla ensin sisältö tätä tarkoitusta varten.

```Shell
labrabuntu$ mkdir public_html
labrabuntu$ cd public_html
labrabuntu$ echo asd > index.html
labrabuntu$ cat index.html
asd
```

Curl-testi minionin IP-osoite/käyttäjä/index.html

```Shell
Lenovo$ curl 192.168.0.101/~user/index.html
asd
```

Tässä vaiheessa kaikki hyvin ja homma toimii.