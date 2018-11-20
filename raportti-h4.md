#Raportti h4

Tämän raportin tehtävissä on käytetty edellisistä tehtävistä tuttua Lenovon kannettavaa tietokonetta:


**Tietokoneen tiedot:**

* Koneen malli: Lenovo Z50-70
* CPU: Intel Core i5-4210U @ 4x 2.7GHz
* RAM: 16GB, 1600MHz DDR3
* GPU: Intel integrated graphics / nVidia GeForce 820
* Käyttöjärjestelmä: Xubuntu 18.04 LTS
* Lyvytila: noin 120GB (SSD), toinen vastaava osio varattu Windows 10 käyttöön

Tehtäväksianto löytyy kohdassa h4 osoitteessa (tarkistettu viimeksi 20.11.2018):
[http://terokarvinen.com/2018/aikataulu-%e2%80%93-palvelinten-hallinta-ict4tn022-3004-ti-ja-3002-to-%e2%80%93-loppukevat-2018-5p](URL) [1]

Raportin koostaminen aloitettu klo. 11:08 20.11.2018
Varsinaisesti kohdan a) tehtävää on tehty koulssa samalla kannettavalla koneella, jolla raportti kirjoitettu. Tehtävää on tehty osissa eri kellonaikoina samana päivänä.

##Tehtäväksianto a)
a) Tee skripti, joka tekee koneestasi salt-orjan. **Lähde:** Tero Karvinen [1]


Kasaamani skripti on tehhty lähinnä omaan hyötykäyttöön, joten siinä on muutakin toiminnallisuutta mukana. Selitteet löytyvät koodin jälkeen.


Skriptiä on testattu ajaa ensin asteittain käsin hyväksikäyttäen vagrant/virtualbox menetelmää ja sen jälkeen koottu .sh shellscript tiedostoksi, jolle ajettu ajoittain git commit. Uusin versio johon teen jatkossa muutoksia löytyy tästä linkistä: [https://github.com/a1704565/salt/blob/master/start/start.sh](URL)



Version sisältö raportoinin hetkellä noin klo. 11:30

```Shell

#!/bin/bash
#Copyright 2018 Juha-Pekka Pulkkinen https://github.com/a1704565 GNU General Public License v3.0
#Based on work by Tero Karvinen:
#https://github.com/terokarvinen/sirotin/blob/master/run.sh
#http://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux


echo "Running the start script! Please wait..."

setxkbmap fi
sudo apt-get update
sudo apt-get install -y salt-master salt-minion git
sudo timedatectl set-timezone Europe/Helsinki
sudo git clone https://github.com/a1704565/salt.git /srv/salt

git config --global user.email "juha-pekka.pulkkinen@myy.haaga-helia.fi"
git config --global user.name "Juha-Pekka Pulkkinen"
git config --global credential.helper "cache --timeout=3600"

echo -e 'master: localhost\nid: labrabuntu'|sudo tee /etc/salt/minion

sudo systemctl restart salt-minion.service
sleep 5s
sudo salt-key -yA

echo "Start script completed... You can start working now!"

```

**Selite:**

* echo komennlla ilmoitetaan skriptin käyttäjälle, että prosessi on lähtenyt käyntiin.
* setxkmap fi määrittää käytettävän koneen näppäimistön suomeksi.
* apt-get komento päivittää listan ja seuraava apt-get asentaat salt-master ja salt-minion ohjlemistot.
* timedatectl avulla laitetaan aikavyöhyke oikeaksi.
* git komennoilla ajetaan perus konfiguraatiot kohdalleen omia tarkoituksiani varten
	* määritetty käyttäjän sähköposti
	* määritetty käyttäjän nimi
	* määritys että git ei kysele salasanaa liian useasti
* echo ja tee komennoilla ajetaan salt masterin tiedot oikeaan kansioon
* systemctl restart komennolla käynnistetään uudestaan tarvittava palvelu
* sleep komento laittaa skriptin odottamaan 5 sekuntia, jotta edellinen toiminto ehtii suorittautua loppuun.
* salt-key -yA komento automaattisesti hyväksyy minionin
* viimeinen echo kertoo että homma on valmis.

Tauko noin klo. 12:25



---
#Lähdeluettelo

* Tero Karvinen: [http://terokarvinen.com/2018/aikataulu-%e2%80%93-palvelinten-hallinta-ict4tn022-3004-ti-ja-3002-to-%e2%80%93-loppukevat-2018-5p](URL) [1]
* 