# Projet analyse de données

<br>

## Sommaire
- [I. Génèse](#i-génèse)
- [II. Description du code](#ii-description-du-code)
- [III. Utilisation du code](#iii-utilisation-du-code)
- [IV. Dictionnaire des données](#iv-dictionnaire-des-données)
 
---
DURAND Alexis, PIERRECY Etienne, LUNA Nicolas  
M1 APE MPE

<br>

## I. Génèse


Pour notre projet, nous avons souhaité automatiser le calcul de la rentabilité de l'achat d'un bien immobilier qui serait mis en location.
Pour ce faire, nous avons décidé de combiner l'utilisation d'un formulaire que remplirait l'investisseur avec le scraping automatique des informations d'une annonce immobillière du site ouestfrance-immo.com pour laquelle l'investisseur voudrait établir sa rentabilité en location.
Aussi, pour faire nos calculs, nous avons chargé la base de données des informations des taux de taxe foncière des communes françaises.

<br>

## II. Description du code

<br>

*(nota bene : cette section (II) est uniquement descriptive, la section qui explique comment s'utilise le code (III) arrive juste après. De plus, un dictionnaire des variables est disponible en fin de document (IV))*

<br>

Le code se décompose en trois fonctions principales emboitées : la fonction *run_script* inclue les deux autres, à savoir *run_last* et *formulaire_tcltk*.  
<br>
La fonction *run_last* se décompose comme suit :
* La première partie sert à charger la base regroupant les taux de taxe foncière en fonction des communes ;
* La seconde partie est relative au scraping des informations de l'annonce immobilière (pour que le scrip fonctionne, il est impératif que l'annonce immobilière provienne du site ouestfrance-immo : https://www.ouestfrance-immo.com). Sont récupérés le prix du bien ainsi que le prix au mètre carré, avec lesquels est calculée la surface, et la commune du bien. Le script permet de s'assurer que la commune du bien apparaisse dans le tableau récapitulatif *form_scrap_data* en majuscule et sans accent afin de correspondre à la typologie utilisée dans la base de donnée des taxes foncières, permettant ainsi de faire fonctionner la recherche automatique du taux correspondant à la commune du bien ;
* La partie suivante permet de définir un certain nombre de variables, déterminées notamment avec les informations issues du scraping et du formulaire ;
* Suit la partie relative à l'établissement du tableau d'amortissement de l'emprunt qui sera disponible au téléchargement dans la fenêtre de présentation des résultats ;
* Arrive enfin le code permettant de calculer les différentes rentabilités et la fonction relative à la création de la fenêtre de présentation des résultats.

La fonction *formulaire_tcltk* se décompose comme suit :
* Nous définissons d'abord la fenêtre du formulaire ;
* Puis nous créons les différentes variables à remplir ;
* Nous utilisons une fonction pour incorporer les variables dans le tableau *form_scrap_data ;
* Et enfin nous donnons un titre aux différentes lignes du formulaire correspondant aux variables.

<br>

## III. Utilisation du code

<br>

*(nota bene : pour utiliser notre code, il est important de se placer dans la tête d'un investisseur qui souhaite se renseigner sur la rentabilité d'un projet immobilier)*

<br>

Pour ce faire, il faut exécuter la ligne 1 "run_script <- function() {" qui permet de définir la fonction qui exécute le script dans sa totalité, et ainsi exécuter la fonction *run_script*.  
S'ouvre alors le formulaire dans une nouvelle fenêtre. ATTENTION : la fenêtre ne s'ouvre pas toujours en premier plan et le copier/coller de l'url dans le formulaire ne fonctionne pas sur mac ! 

Remplissage du formulaire : dans la rublique : 
* "Url de l'annonce" : renseigner l'url de l'annonce ;  
* "Prix de location au mètre carré" : prix que l'investisseur à lui-même défini avec sa connaissance du marché ;
* "Prix de revente espéré au mètre carré" : prix que l'investisseur à lui-même défini avec sa connaissance du marché ;
* "Prix des travaux de rénovation" : montant des travaux si l'investisseur souhaite en réaliser (inscrire 0 sinon) ;
* "Durée du crédit (en année)" : nombre d'annuités de l'emprunt ;
* "Taux du crédit" : taux auquel l'investisseur emprunte, le calcul des intérêts se fait ici via la méthode des annuités constantes ;
* "Apport pour cet achat" : apport fait par l'investisseur lors de la souscription de l'emprunt ;
* "Taux de placement espéré" : taux de placement des bénéfices mensuels (s'ils sont positifs) réinvestis.

Pour gagner du temps, voici une annonce et les informations du fomulaires que vous pouvez utiliser :

"Url de l'annonce" : https://www.ouestfrance-immo.com/immobilier/vente/maison/saint-jean-d-angely-17-17347/18494638.htm  
"Prix de location au mètre carré" : 10  
"Prix de revente espéré au mètre carré" : 1800  
"Prix des travaux de rénovation" : 10000  
"Durée du crédit (en année)" : 20  
"Taux du crédit" : 2.70  
"Apport pour cet achat" : 30000  
"Taux de placement espéré" : 2,75

<br>

## IV. Dictionnaire des données

<br>

Pour le formulaire:
* url : url de l'annonce immobilière
* Prix de location au mètre carré : celui que l'investisseur souhaitera appliquer
* prix de revente espéré au mètre carré : celui que souhaite l'investisseur (attention, ce n'est pas le prix d'achat du bien immobilier, celui-ci étant récupéré automatiquement)
* Prix des travaux de rénovation : si l'investisseur souhaite en réaliser, inscrire 0 s'il ne souhaite pas
* Taux de placement : taux d'intérêt si l'investisseur placait son apport plutôt que d'investir dans le bien immobilier


Les autres variables :
* tax_fonc : dataframe des taux de taxe foncière
* plocm2 : prix de location au m²
* pventem2 : prix de revente espéré au m²
* ptravaux : prix des travaux
* dureecredit : durée de l'emprunt en année
* txcredit : taux d'emprunt
* apport : apport pour l'emprunt
* txplacement : taux d'interêt si l'apport est investit ailleurs que dans l'emprunt
* prix : prix du bien
* prix_m2 : prix du bien au m²
* texte_sans_accent_majuscule : nom de la commune du bien sans accent et en majuscule
* form_scrap_data : tableaux regroupant à la fois les informations remplies dans le formulaire et celles issues du scraping de l'annonce
* tx_tf : taux de taxe foncière (correspondant automatiquement à celui de la commune de l'annonce)
* loyer_m : loyer mensuel
* ali : assurance loyer impayé
* tf : montant de la taxe foncière (par an)
* apno : assurance propriétaire non-occupant
* montant de l'emprunt
* ticm : taux d'intérêt mensuel de l'emprunt
* duree_emprunt : durée de l'emprunt en mois
* mensualite : montant du coût mensuel de l'emprunt
* resultat_mensuel : bénéfice ou perte de la mise en location du bien
* txpm : taux de placement mensuel
* rentabilite_des_K_investis_totale : rentabilité de l'opération pour la durée du crédit sur les capitaux investis
* rentabilite_K_investis_totale_pourcent : "rentabilite_des_K_investis_totale" multipliée par 100 et arrondie à deux chiffres après la virgule pour être affichée dans la fenêtre des résultats
* rentabilité_K_investis_totale_annuel : "rentabilite_K_investis_totale_pourcent" annualisée
* rentabilite_brute : loyer annuel sur le prix du bien
* rentabilite_nette : loyer annuel moins les différentes charges sur le prix du bien




