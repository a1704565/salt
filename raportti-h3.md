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



## Taustaa:

- Luotu Githubiin repository salt
- siirretty vanha /srv/salt kansio turvaan
- kloonattu githubista repository salt kansioon /srv/

		

- kopioitu vanhan saltin sisältö sinne
- määritetty git konfiguraatiot (käyttäjänimi / sähköposti)
- ajettu toiminnot


		git add .
		git commit
		git pull
		git push


Lopuksi  varmennettu että kaikki on paikoillaan ja ajantasalla

## C)

- siirrytty käyttämään virtuaalikonetta
- asennettu git
- määritetty git konfiguraatio
- asennettu salt-master
- kloonattu /srv kansioon github repository salt
- jatkettu thetäviä virtuaalikoneella

### Välitiedote

Ajettu komento:

	xubuntu3$ git config --global credential.helper "cache --timeout=3600"

selite: Remember password for one hour (60*60 seconds)
Lähde: http://terokarvinen.com/2016/publish-your-project-with-github

## D)

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

Tein muutoksia raportti-h3.md tiedostoon kirjoittamalla siihen turhuuksia. Ajoin ohjeen mukaisesti komennon:

	xubuntu3$ sudo git reset --hard
	HEAD is now at 273e4f9 edit raportti-h3 again.

Koska en ollut ajanut committia ennen komennon ajamista, palautui versionhallinnasta edellinen commit.

## F)


