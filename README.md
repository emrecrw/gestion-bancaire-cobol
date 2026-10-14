# Gestion bancaire en COBOL

Petit projet pour apprendre le COBOL. Le programme simule le traitement des opérations d'une banque sur une journée.

## Ce que fait le programme

- lit les comptes depuis `comptes.txt` et les met dans un tableau
- lit les opérations du jour dans `operations.txt` (D = dépôt, R = retrait)
- refuse les retraits si le solde est insuffisant, les comptes qui n'existent pas et les types inconnus
- affiche les soldes après traitement
- écrit les nouveaux soldes dans `comptes_maj.txt`

## Lancer le programme

Il faut GnuCOBOL (`sudo apt install gnucobol`).

```
cobc -x banque.cbl
./banque
```

## Format des fichiers

`comptes.txt` : numéro (5) + nom (20) + solde (9, les 2 derniers chiffres sont les centimes)

`operations.txt` : numéro (5) + type (1) + montant (7)

## Ce que j'ai appris

- la structure d'un programme COBOL (les 4 divisions)
- lire et écrire des fichiers séquentiels
- les tableaux avec `OCCURS`
- `EVALUATE`, `PERFORM VARYING`
- les PIC et les nombres avec virgule (`V99`)

## Idées pour la suite

- ajouter les virements entre comptes
- trier les opérations avec `SORT`
- faire un rapport dans un fichier
