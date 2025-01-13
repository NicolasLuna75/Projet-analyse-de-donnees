# Projet analyse de données

<br>

DURAND Alexis, PIERRECY Etienne, LUNA Nicolas  
M1 APE MPE

<br>

## I. Génèse


Pour notre projet, nous avons souhaité automatiser le calcul de la rentabilité de l'achat d'un bien immobilier qui serait mis en location.
Pour ce faire, nous avons décider de combiner l'utilisation d'un formulaire que remplirait l'investisseur avec le scraping automatique des informations d'une annonce immobilière du site ouestfrance-immo.com pour laquelle l'investisseur voudrait établir sa rentabilité en location.
Aussi, pour faire nos calculs, nous avons chargé la base de données des informations des taux de taxe foncière des communes françaises.

<br>

## II. Description du code

<br>

*(nota bene : cette section (II) est uniquement descriptive, la section qui explique l'uitlisation du code (III) arrive juste après. De plus, un dictionnaire des données est disponible en fin de document (IV))*

<br>

* **Première partie :**

La première partie vise à charger toutes les librairies nécessaires ainsi que la base de données des taux de taxe foncière.

* **Seconde partie :**

Cette partie vise à établir le formulaire et à le lancer.  
Elle établie aussi la tableau *form_scrap_data* qui regroupera toutes les informations nécessaires aux différents calculs.

* **Troisième partie :**

Cette partie concerne le scraping de l'annonce immobilière. Le scraping nous permet ici de récuperer le prix du bien et le prix au mètre carré, avec lesquels on déduit la surface. Ces trois éléments sont inétégrés à *form_scrap_data*. Le code permet aussi de s'assurer de ne prendre que les chiffres, sans les symboles et les espaces, sans quoi il est impossible de les convertir en numérique. De même, avec cette partie du code, on s'assure que le texte de la ville apparaisse dans le tableau en majuscule et sans accent pour se conformer à la typologie de la base de donnée de la taxe foncière.

*(nota bene : pour que notre code fonctionne, il est imparatif d'utiliser l'url d'une annonce immobilière provenant du site ouestfrance-immo (https://www.ouestfrance-immo.com))*

* **Quatrième partie :**

Cette partie que nous avons appelé *assignation* a pour but de créer les variables utiles aux calculs, qui sont calculées à partir des données du tableau *form_scrap_data*. 

* **Cinquième partie :**
*********************************************************************************
Cette partie contient deux boucles pour déterminer la somme des résultats actualisés et capitalisés. les résultats capitalisés correspondent aux excédents mensuels (résultat mensuel > 0) placés et rémunérés au taux de placement défini dans le formulaire. La somme des résultats actualisés correspond à la situation où les résultats mensuels sont négatifs, et donc où le montant d'argent comblant les pertes est actualisé à la période de l'apport.
*********************************************************************************

* **Sixième partie :**

Cette partie vise à créer le tableau d'amortissement de l'emprunt, qui sera disponible au téléchargement dans la fenêtre qui rend compte des résultats.

* **Septième partie :**

Cette partie sert à calculer les différentes rentabilités de l'investissement immobilier.

* **Huitième partie :**

La dernière partie du code vise à créer une fenêntre affichant les différents résultats calculés dans les parties précédentes.

<br>

## III. Utilisation du code

<br>

## IV. Dictionnaire des données


| **Arguments**                        | **Description**                                                                                   |
|--------------------------------------|---------------------------------------------------------------------------------------------------|
| **URL**                              | URL de l'annonce immobilière.                                                                    |
| **Prix de location au mètre carré**  | Celui que l'investisseur souhaitera appliquer.                                                   |
| **Prix de revente espéré au mètre carré** | Celui que souhaite l'investisseur (attention, ce n'est pas le prix d'achat du bien immobilier, celui-ci étant récupéré automatiquement). |
| **Prix des travaux de rénovation**   | Si l'investisseur souhaite en réaliser, inscrire 0 s'il ne souhaite pas.                         |
| **Taux de placement**                | Taux d'intérêt si l'investisseur plaçait son apport plutôt que d'investir dans le bien immobilier.|


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















