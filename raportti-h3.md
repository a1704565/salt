# Raportti

## Taustaa:

- Luotu Githubiin repository salt
- siirretty vanha /srv/salt kansio turvaan
- kloonattu githubista repository salt kansioon /srv/
- kopioitu vanhan saltin sisältö sinne
- määritetty git konfiguraatiot (käyttäjänimi / sähköposti)

	git add .
	git commit
	git pull
	git push

- varmennettu että kaikki on paikoillaan ja ajantasalla

## C)

- siirrytty käyttämään virtuaalikonetta
- asennettu git
- määritetty git konfiguraatio
- asennettu salt-master
- kloonattu /srv kansioon github repository salt
- jatkettu thetäviä virtuaalikoneella


## D)

	/srv/salt$ git log
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

