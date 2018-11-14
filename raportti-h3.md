# Raportti

Tehtäviä tehdessä on käytetty samaa kannettavaa tietokonetta, kuten edellisissäkin tehtävissä (Lenovo). Lisäksi tätä tehtävää varten on käytetty myös samaa virtuaalikonetta kuin aikaisemmassa tehtävässä h2 (xubuntu3).

Lenovon tiedot:
- Koneen malli: Lenovo Z50-70
- CPU: Intel Core i5-4210U @ 4x 2.7GHz
- RAM: 16GB, 1600MHz DDR3
- GPU: Intel integrated graphics / nVidia GeForce 820
- Käyttöjärjestelmä: Xubuntu 18.04 LTS
- Lyvytila: noin 120GB (SSD), toinen vastaava osio varattu Windows 10 käyttöön

Virtuaalikoneen xubuntu3 tiedot:
- Ympäristö: VirtualBox 5.2.10
- Käyttöjärjestelmä: Xubuntu 18.04 LTS
- 2048MB muistia
- 128MB video muistia
- 1x prosessoriydin käytössä
- dynaamista levytilaa noin 20GB
- network = Bridged adapter tilassa

Molempiin on ajettu uusimmat päivitykset ennen tehtävän aloittamista.


## b)
Tehtäväksianto:

MarkDown. Tee tämän tehtävän raportti MarkDownina. Helpointa on tehdä raportti samaan GitHub-varastoon kuin Salt-modulit. Tiedostoon .md-pääte. Tyhjä rivi tekee kappalejaon, risuaita ‘#’ tekee otsikon, sisennys merkitsee koodinpätkän.


Suoritettu kyseinen tehtäväksianto tähän raportti-h3.md tiedostoon.



## C)
Tehtäväksianto:

Laita /srv/salt/ gittiin. Tee uusi moduli. Kloonaa varastosi toiselle koneelle (tai poista /srv/salt ja palauta se kloonaamalla) ja jatka sillä.


Toimenpiteet koneella Lenovo:

- Luotu githubiin repository nimeltä salt
- siirretty jo olemassa oleva /srv/salt kansion sisältö hetkellisesti turvaan 

		Lenovo$ cd /srv/
		Lenovo$ sudo mv salt/ /home/user/

- kloonattu salt repository githubista

		Lenovo$ sudo git clone https://github.com/a1704565/salt.git

- kopioitu takaisin alkuperäinen kansion sisältö

		Lenovo$ sudo cp -r /home/jpp/salt .

- aettu tarpeelliset konfiguraatiot

		Lenovo$ git config --global user.email "juha-pekka.pulkkinen@myy.haaga-helia.fi"
		Lenovo$ git config --global user.name "Juha-Pekka Pulkkinen"

- suoritettu seuraavat toimenpiteet

		Lenovo$ sudo git add .
		Lenovo$ sudo git commit
		[master 7846de5] add salt modules
		 8 files changed, 120 insertions(+)
		 create mode 100644 apache2.sls
		 create mode 100644 mariadb.cnf
		 create mode 100644 mariadb.sls
		 create mode 100644 sshd.sls
		 create mode 100644 sshd_config
		 create mode 100644 workstation.sls
		 create mode 100644 www.sls
		 create mode 100644 www/index.html
		Lenovo$ sudo git pull
		Already up to date.
		Lenovo$ sudo git push
		Username for 'https://github.com': a1704565
		Password for 'https://a1704565@github.com': 
		Counting objects: 11, done.
		Delta compression using up to 4 threads.
		Compressing objects: 100% (10/10), done.
		Writing objects: 100% (11/11), 2.11 KiB | 1.05 MiB/s, done.
		Total 11 (delta 0), reused 0 (delta 0)
		To https://github.com/a1704565/salt.git
		 62ebff5..7846de5 master -> master

- Tarkastettu tilanne githubista ja kaikki näytti hyvältä


Seuraavat toiminnot on suoritettu virtuaalikoneella xubuntu3:


- asennettu git ja ajettu asetukset kuntoon

		xubuntu3$ sudo apt-get -y install git
		xubuntu3$ git config --global user.email "juha-pekka.pulkkinen@myy.haaga-helia.fi"
		xubuntu3$ git config --global user.name "Juha-Pekka Pulkkinen"

- asennettu salt-master

		xubuntu3$ sudo apt-get -y install salt-master

- siirryin kansion /srv/ ja kloonattu githubista salt, jonka jälkeen siirrytty kansioon /srv/salt ja tarkastin sisällön

		xubuntu3$ sudo git clone https://github.com/a1704565/salt.git
		Cloning into 'salt'...
		remote: Enumerating objects: 15, done.
		remote: Counting objects: 100% (15/15), done.
		remote: Compressing objects: 100% (13/13), done.
		remote: Total 15 (delta 1), reused 11 (delta 0), pack-reused 0
		Unpacking objects: 100% (15/15), done.
		xubuntu3$ cd salt/
		xubuntu3$ ls -a

### Välitiedote

Ajettu komento:

	xubuntu3$ git config --global credential.helper "cache --timeout=3600"

selite: Remember password for one hour (60*60 seconds)
Lähde: http://terokarvinen.com/2016/publish-your-project-with-github


Seuraavat tehtävät on kaikki tehty ja commitattu virtuaalikoneelta.


## D)
Tehtäväksianto:
Näytä omalla salt-varastollasi esimerkit komennoista ‘git log’, ‘git diff’ ja ‘git blame’. Selitä tulokset.


### git log

Esimerkki git log toiminnosta:

	xubuntu3$ /srv/salt$ git log
	commit a9fdcd1fe2ea4adc5052725305eb3e8454a6edef (HEAD -> master, origin/master, origin/HEAD)
	Author: Juha-Pekka Pulkkinen <juha-pekka.pulkkinen@myy.haaga-helia.fi>
	Date:   Wed Nov 14 05:54:35 2018 +0200

	    edit raportti-h3.md

	commit 69b2abc0da6016fa704f2a6ae44a8796ec11ad2d
	Author: Juha-Pekka Pulkkinen <juha-pekka.pulkkinen@myy.haaga-helia.fi>
	Date:   Wed Nov 14 05:41:44 2018 +0200

	    add raportti-h3.md

	commit 7846de5efe161a5a0a8816dbc199c4804a9a6881
	Author: Juha-Pekka Pulkkinen <juha-pekka.pulkkinen@myy.haaga-helia.fi>
	Date:   Wed Nov 14 05:11:07 2018 +0200

	    add salt modules

	commit 62ebff581fd6144d3a17376ce57fee11e869ac68
	Author: a1704565 <44860290+a1704565@users.noreply.github.com>
	Date:   Wed Nov 14 04:32:13 2018 +0200

	    Initial commit


- git log komento näyttää lokin tapahtumaketjusta; mitä, milloin ja kuka. Git log toiminnolla voi myös tehdä muita edistyneempiä toimenpiteitä.

Lähde: https://www.atlassian.com/git/tutorials/git-log

### git diff

Kun edellisen esimerkin tavoin  git log toiminnon ja sen jälkeen git diff toiminnon ja alitsee useamman commitin, näkee sillä erot

Esimerkki git diff käytöstä:

	xubuntu3$ /srv/salt$ git diff a9fdcd1fe2ea4adc5052725305eb3e8454a6edef 69b2abc0da6016fa704f2a6ae44a8796ec11ad2d
	diff --git a/raportti-h3.md b/raportti-h3.md
	index e556ba2..84cb4ff 100644
	--- a/raportti-h3.md
	+++ b/raportti-h3.md
	@@ -1,6 +1,6 @@
	 # Raportti
 
	-## Taustaa:
	+Taustaa:
 
	 - Luotu Githubiin repository salt
	 - siirretty vanha /srv/salt kansio turvaan

Lähde: https://www.atlassian.com/git/tutorials/saving-changes/git-diff

### git blame


Git blamella on virheiden etsinnässä käytettävä työkalu.

esimerkki git blame käytöstä:

	xubuntu3$ /srv/salt$ git blame README.md
	^62ebff5 (a1704565 2018-11-14 04:32:13 +0200 1) # salt
	^62ebff5 (a1704565 2018-11-14 04:32:13 +0200 2) Slat repositary for testing purposes


Edellisessä esimerkissä ajamalla git blame -komento tulostuu tiedot muutoksista tiedostossa. Tiedot esitetään järjestyksessä ID, Käytttäjän nimi/nimimerkki, aika jolloin muutos tehty, ja tieto mitä on muutettu.

Git blamella voi tehdä muitakin edistyneempiä asioita.

Lähde: https://www.atlassian.com/git/tutorials/inspecting-a-repository/git-blame


## E)
Tehtäväksianto:
Tee tyhmä muutos gittiin, älä tee commit:tia. Tuhoa huonot muutokset ‘git reset –hard’. Huomaa, että tässä toiminnossa ei ole peruutusnappia.



Tein muutoksia raportti-h3.md tiedostoon kirjoittamalla siihen turhuuksia. Ajoin ohjeen mukaisesti komennon:

	xubuntu3$ sudo git reset --hard
	HEAD is now at 273e4f9 edit raportti-h3 again.

Koska en ollut ajanut committia ennen komennon ajamista, palautui versionhallinnasta edellinen commit.

## F)
Tehtäväksianto:
Tee uusi salt-moduli. Voit asentaa ja konfiguroida minkä vain uuden ohjelman: demonin, työpöytäohjelman tai komentokehotteesta toimivan ohjelman. Käytä tarvittaessa ‘find -printf “%T+ %p\n”|sort’ löytääksesi uudet asetustiedostot.

