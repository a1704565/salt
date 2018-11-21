# Hello Salt!

## Tehtäväksianto

c) Asenna Salt Master ja Slave pull-arkkitehtuurilla (eli master on server). Voit laittaa herran ja orjan myös samalle koneelle. Kokeile suorittamalla salt:illa komentoja etänä.

### Alustavat tiedot

Tein harjoituksen Keskiviikkona 2018-10-31 klo. 3:06 alkaen. Käytin kannettavaa tietokonetta Lenovo Z50-70, asennettu käyttöjärjestelmä oli Xubuntu 18.04 LTS.


Harjoitusta varten asennettu VirtualBox 5.2.10 ja luotu 3kpl virtuaalikonetta. Kahdessa oli käytössä Xubuntu 18.04 LTS ja yhdessä Linux Mint 19 XFCE. Jokaiselle koneelle oli määritetty 2GB mustia (koneessa asennettuna 16GB), sekä 1 ydin käyttöön prosessorilta (i5-4210U). Muuten kaikki säädöt on jätetty VirtualBoxin tarjoamiin oletusasetuksiin. Koneiden päivitykset olivat ajantasalla ja palomuuri oli otettu käyttöön kaikissa koneissa.

Harjoituksessa käytettyjen koneiden nimet: Lenovo, xubuntu1, xubuntu2, mint1


### Salt Master ja Slave (Minion) asentaminen

Lenovo Z50-70 (myöhemmin Lenovo), valittu Master-rooliin ja vituaalikoneet asetettu slave-rooliin.

**Master**

Ajettu seuraavat komennot onnistuneesti Lenovolla (Master).

```Shell
Lenovo$ sudo apt-get update
Lenovo$ sudo apt-get -y install salt-master
```

Master koneessa on käytössä palomuuri, joten siihen on tehty säännöt, joissa sallitaan tarvittavat TCP portit 4505 ja 4506. Tarkistettu myös sääntöjen lisäämisen jälkeen niiden status. Lähde: [Understanding SaltStack 2018](https://docs.saltstack.com/en/getstarted/system/communication.html).

```Shell
Lenovo$ sudo ufw allow 4505/tcp
Lenovo$ sudo ufw allow 4506/tcp
Lenovo$ sudo ufw status
To                         Action      From
--                         ------      ----
4505/tcp                   ALLOW       Anywhere
4506/tcp                   ALLOW       Anywhere
4505/tcp (v6)              ALLOW       Anywhere (v6)
4506/tcp (v6)              ALLOW       Anywhere (v6)
```

Otettu selvää master koneen IP-osoitteesta ajamalla komento. Tietoa käytetty myöhemmässä vaiheessa.

```Shell
Lenovo$ hostname -I
192.168.0.131
```

**Minion**

Kaikkiin kolmeen virtuaalikoneeseen asennettu salt-minion seuraavalla menetelmällä.

**xubuntu1**

```Shell
xubuntu1$ sudo apt-get update
xubuntu1$ sudo apt-get -y install salt-minion
```

**xubuntu2**

```Shell
xubuntu2$ sudo apt-get update
xubuntu2$ sudo apt-get -y install salt-minion
```

**mint1**

```Shell
mint1$ sudo apt-get update
mint1$ sudo apt-get -y install salt-minion
```

Saltia käytettäeessä slave koneiden eli minioneiden tulee tietää masterin IP-osoite, sekä niillä tulee olla määriteltynä nimi (id). Tämä tieto lisätty muokkaamalla tiedoston /etc/salt/minion asetuksia.  Harjoituksessa käytetty samoja nimiä, kuin itse koneiden nimet, mutta näin ei ole pakko tehdä.

```Shell
xubuntu1$ sudoedit /etc/salt/minion
master: 192.168.0.131
id: xubuntu1
```

```Shell
xubuntu2$ sudoedit /etc/salt/minion
master: 192.168.0.131
id: xubuntu2
```

```Shell
mint1$ sudoedit /etc/salt/minion
master: 192.168.0.131
id: mint1
```

Minioneilla käynnistetty uudestaan salt-minion palvelu, jotta tehdyt muutokset tulisivat voimaan.

```Shell
sudo systemctl restart salt-minion.service
```

Master koneella (Lenovo) ajettu komento, jotta vielä liittämättömät minionit voitiin liittää masterin alaisuuteen.

```Shell
Lenovo$ sudo salt-key -A
The following keys are going to be accepted:
Unaccepted Keys:
mint1
xubuntu1
xubuntu2
Lenovo$ Proceed? [n/Y] y
Key for minion mint1 accepted.
Key for minion xubuntu1 accepted.
Key for minion xubuntu2 accepted.
```

Testattu masterilla toimivuutta ajamalla yksinkertainen salt komento.

```Shell
Lenovo$ sudo salt '*' cmd.run 'whoami'
xubuntu2:
    root
xubuntu1:
    root
mint1:
    root
```

Lisää testausta. Asennettu testimielessä htop niminen pieni ohjelma. Kaikki näytti toimivan hyvin.

```Shell
Lenovo$ sudo salt '*' pkg.install htop
xubuntu1:
       ----------
    htop:
       ----------
        new:
            2.1.0-3
        old:
mint1:
       ----------
    htop:
       ----------
        new:
            2.1.0-3
        old:
xubuntu2:
       ----------
    htop:
       ----------
        new:
            2.1.0-3
        old:

```

## Tehtäväksianto

d) Kokeile jotain Laineen esimerkistä lainattua tilaa tai tee jostain tilasta oma muunnelma. Muista testata lopputuloksen toimivuus. Huomaa, että varastossa on myös keskeneräisiä esimerkkejä, kuten Battlenet-asennus Windowsille.

[Laineen 2017 varastossa olevia salt -asetuksia](https://github.com/joonaleppalahti/CCM/tree/master/salt/srv/salt)

### Taustatietoa

Tilanne jatkuu edellisen tehtävän pohjalta sellaisenaan ja välissä ei ole suoritettu mitään muita toimintoja.

## Workstation.sls muunnelma

Master koneella luotu tarpeellinen kansiorakenne, minne automaatisti ajettavat, sekä muut kutsuttavat tilat voidaan sijoittaa. Automaattisesti ajettavaa top.sls tilaa ei otettu käyttöön tässä harjoituksessa.

```Shell
sudo mkdir -p /srv/salt/
```

Luotu workstation.sls tiedosto, jonka sisältöä muunneltu poikkeamaan GitHub esimerkistä:

Muokkaamaton GitHubista löytyvä versio:

```Shell
install_workstation:
  pkg.installed:
    - pkgs:
      - ssh
      - gedit
      - libreoffice
      - xubuntu-desktop
```

Muokkaamani versio:

```Shell
install_workstation:
  pkg.installed:
    - pkgs:
      - openssh-server
      - leafpad
      - libreoffice
      - vlc
```

Testaus ajettu ensin pelkästään xubuntu1 id:llä.

```Shell
Lenovo$ sudo salt 'xubuntu1' state.apply workstation
xubuntu1:
----------
          ID: install_workstation
    Function: pkg.installed
      Result: True
     Comment: 4 targeted packages were installed/updated.
     Started: 05:33:35.843016
    Duration: 52985.526 ms Changes:

              ----------
```

```Shell
              ----------
Summary for xubuntu1
------------
Succeeded: 1 (changed=1)
Failed:    0
------------
Total states run:     1
Total run time: 52.986 s
```

Edeltävä testi toimi, joten ajettu sama komento kaikille koneille.

```Shell
Lenovo$ sudo salt '*' state.apply workstation
xubuntu1:
----------
          ID: install_workstation
    Function: pkg.installed
      Result: True
     Comment: All specified packages are already installed
     Started: 05:40:16.810493
    Duration: 926.169 ms Changes: 
Summary for xubuntu1
------------
Succeeded:     1
Failed:        0
------------
Total states run:     1
Total run time: 926.169 ms
mint1:
----------
          ID: install_workstation
    Function: pkg.installed
      Result: True
     Comment: 3 targeted packages were installed/updated.
              The following packages were already installed: vlc
     Started: 05:40:18.202726
    Duration: 23611.952 ms
     Changes:
              ----------
              leafpad:
                  ----------
                  new: 0.8.18.1-5
                  old:
              libreoffice:
                  ----------
                  new:
                      1:6.0.6-0ubuntu0.18.04.1
                  old:
              libreoffice-report-builder-bin:
                  ----------
                  new:
                      1:6.0.6-0ubuntu0.18.04.1
                  old:
              openssh-server:
                  ----------
                  new:
                      1:7.6p1-4
                  old:
                      openssh-sftp-server:
                  ----------
                  new:
                      1:7.6p1-4
                  old:
               ssh-server:
                  ----------
                  new:
                      1
                  old:
Summary for mint1
------------
Succeeded: 1 (changed=1)
Failed:    0
------------
Total states run:     1
Total run time:  23.612 s
xubuntu2:
----------
          ID: install_workstation
    Function: pkg.installed
      Result: True
     Comment: 4 targeted packages were installed/updated.
     Started: 05:40:18.452686
    Duration: 58028.419 ms
     Changes:
              ----------
```

```Shell
              ----------
Summary for xubuntu2
------------
Succeeded:  1 (changed=1)
Failed:     0
------------
Total states run:      1
Total run time:   58.028 s
```

Kaikki toimi hyvin, asennettuja ohjelmia pystyi ajamaan kaikilla minion virtuaalikoneilla ilman mitään ongelmia.


## Tehtäväksianto

e) Kerää laitetietoja koneilta saltin grains-mekanismilla.

### Grains-mekanismi

Keräsin tietoja grains-mekanismilla kaikista minioneista, käyttäen komentoa.

```Shell
Lenovo$ sudo salt '*' grains.items
```

Keräsin myös yksilöityjä tietoja minioneilta vastaavilla komennoilla.

```Shell
Lenovo$ sudo salt '*' grains.item uuid
xubuntu2:
    ----------
    uuid: d30b43e6-767b-4594-9d1e-62f072359eee
xubuntu1:
    ----------
    uuid: 5106fe20-d8d5-46e9-a95b-54aefc47c2f9
mint1:
    ----------
    uuid: 8ca090ad-5fbf-4a86-836c-3e4915b841bb
```

Testasin myös yksilöityä tietueen hakua yhdeltä minionilta vastaavasti.

```Shell
Lenovo$ sudo salt 'mint1' grains.item lsb_distrib_description
mint1:
    ----------
    lsb_distrib_description:
        Linux Mint 19 Tara
```

## Tehtäväksianto

f) Oikeaa elämää. Säädä Saltilla jotain pientä, mutta oikeaa esimerkiksi omalta koneeltasi tai omalta virtuaalipalvelimelta. (Kannattaa kokeilla Saltia oikeassa elämässä, mutta jos se ei onnistu, rakenna jotain oikeaa konettasi vastaava virtuaaliympäristö ja tee asetus siinä).

### Taustaitetoja

Minulla oli käytössäni juuri tähän tehtävään soveltuva tietokone, jonka päätin liittää minioniksi.

## Oikeaa elämää

Otin master koneelta ssh yhteyden, jonka jälkeen lisäsin kyseisen koneen minioniksi. Päätin antaa koneelle id:n slbot2000.

```Shell
Lenovo$ ssh user@slbot2000
slbot2000$ sudo apt-get update
slbot2000$ sudo apt-get -y install salt-minion
slbot2000$ sudoedit /etc/salt/minion
master: 192.168.0.131
id: slbot2000
slbot2000$ sudo systemctl restart salt-minion.service
```

slbot2000 hyväksyminen minioniksi.

```Shell
Lenovo$ sudo salt-key -A
The following keys are going to be accepted:
Unaccepted Keys:
slbot2000
Proceed? [n/Y] y
Key for minion slbot2000 accepted.
```

Kyseinen slbot2000 on palvelin, jossa on käytössä Apache 2 www-palvelin. Päätin testimielessä käyttää saltia korvaamaan /var/www/html/ kansiossa olevan index.html:n, joka toimii tällä hetkellä palvelimen aloitussivuna.

```Shell
Lenovo$ sudoedit /srv/salt/www.sls
/var/www/html/index.html:
  file.managed:
    - source: salt://www/index.html
```

Luotu kansio www, jonka sisään sijoitettu index.html.

```Shell
Lenovo$ sudo mkdir -p /srv/salt/www
```

```Shell
Lenovo$ sudoedit /srv/salt/www/index.html
```

Lisätty suppea html sisältö tiedostoon, jolla voidaan testata toimivuus.

```HTML
<!DOCTYPE html>
<html>
<body>

<h1>Salt minion test</h1>

<p>test!</p>

</body>
</html>
```

Ajettu luotu tila, muutokset listautuivat onnistuneesti.

```Shell
sudo salt 'slbot2000' state.apply www
slbot2000:
----------
          ID: /var/www/html/index.html
    Function: file.managed
      Result: True
     Comment: File /var/www/html/index.html updated
     Started: 07:30:45.412156
    Duration: 54.856 ms
     Changes:
----------
              diff:
                  ---
                  +++
                  @@ -1,15 +1,10 @@
                   <!DOCTYPE html>
                  -<html lang="fi">
                  -<head>
                  -<title>sluibatron2000</title>
                  -<meta charset="UTF-8" />
                  -
                  -</head> <html> <body>
                  -<p>Sluibaillaan minkä keretään ja testaillaan minkä jaksetaan!</p>
                  +<h1>Salt minion test</h1>
                  +
                  +<p>test!</p> </body> </html>
                  -

Summary for slbot2000
------------
Succeeded: 1 (changed=1)
Failed:    0
------------
Total states run:     1
Total run time:  54.856 ms
```

Kaikki näytti toimivan moitteettomasti, tehtävä saatu päätökseen klo: 7:35.
