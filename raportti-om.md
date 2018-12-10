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
