
------------------------------------------------------------------------

# INF3500 - labo 5 - hiver 2022
# Équipe **nom-d-équipe-ici**

Membre #1 : **nom, prénom, matricule**

Membre #2 : **nom, prénom, matricule**

------------------------------------------------------------------------

## Partie 1

### Diagramme de blocs du système

Voici notre diagramme :

<img src="figures/diagramme.png" alt="notre diagramme" width="600">

### Description des modules

Voici, en un paragraphe pour chacun, le rôle et le fonctionnement de chacun des modules :
- generateur_horloge_precis;
- monopulseur;
- uart_rx_char;
- uart_tx_char;
- uart_tx_message;
- interface_utilisateur;

### Analyse de quelques lignes de code

Voici notre analyse des lignes de code VHDL suivantes.

```
signal c1, c2 : character;
signal r1, r2 : std_logic_vector(7 downto 0);
...
r1 <= std_logic_vector(to_unsigned(character'pos(c1), 8));
c2 <= character'val(to_integer(unsigned(r2)));
```

La définition de la fonction `character_to_hex()` se trouve  ....


## Partie 2

Voici les modifications que nous avons apportées aux fichiers.

- fichier1.vhd
    - ceci
    - cela

- fichier2.vhd
    - ceci
    - cela

- fichier3.vhd
    - ceci
    - cela


## Partie 3 : Bonus

*Faire un choix et garder seulement une option.*
- Nous n'avons pas complété le bonus. Nous nous concentrons sur notre réussite dans ce cours et dans d'autres.
- Nous sommes vraiment en avance dans nos études, dans ce cours et tous les autres, et nous adorons les défis dans ce cours, donc nous avons complété une ou plusieurs parties du bonus.

### Partie 3a

Notre approche consiste à ...

### Partie 3b

Notre approche consiste à ...



## Observations et discussion générale

Dans ce laboratoire, nous avons remarqué que ...

Nous avons appris que ....

Nous avons trouvé plus difficile de ...

Nous recommandons que ...

