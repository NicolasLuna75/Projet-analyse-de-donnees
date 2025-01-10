# Projet analyse de données

DURAND ALexis, PIERRECY Etienne, LUNA Nicolas

## Génèse

Pour notre projet, nous avons souhaité automatiser le calcul de la rentabilité de l'achat d'un bien immobilier qui serait mis en location.
Pour ce faire, nous avons déscéder de combiner l'utilisation d'un formulaire que remplirait l'investisseur avec le scrapping automatique des informations d'une annonce immobillière du site ouestfrance-immo.com pour laquelle l'investisseur voudrais établir sa rentabilité en location.
Aussi, pour faire nos calculs, nous avons chargé la base de donnée des informations des taux de taxe foncière des communes françaises.


## Dictionnaire des données

* tax_fonc : dataframe des taux de taxe foncière.

Pour le formulaire:
* url : url de l'annonce immobilière.
* plocm2 : prix de location au mètre carré que souhaite l'investisseur.
* pventem2 : prix de vente au mètre carré que souhaite l'investisseur (attention, ce n'est pas le prix d'achat du bien immobilier, celui-ci étant récupéré automatiquement).
* ptravaux : prix des travaux de rénovation (si l'investisseur souhaite en réaliser, instrire 0 s'il ne souhaite pas).
* dureecredit : 


## Description du code

### Première partie

La première partie vise à charger toutes les librairies nécessaires ainsi que la base de donnée des taux de taxe foncière.


### Seconde partie 

Pour que notre code fonctionne, il est imparatif d'utiliser l'url d'une annonce immobilière provenant du site ouestfrance-immo (par exemple celle-ci : https://www.ouestfrance-immo.com/immobilier/vente/maison/saint-jean-d-angely-17-17347/18494638.htm) dans le formulaire.


## Utilisation du code

















