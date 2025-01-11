# Projet analyse de données

DURAND ALexis, PIERRECY Etienne, LUNA Nicolas  
M1 APE MPE

## I. Génèse

Pour notre projet, nous avons souhaité automatiser le calcul de la rentabilité de l'achat d'un bien immobilier qui serait mis en location.
Pour ce faire, nous avons déscéder de combiner l'utilisation d'un formulaire que remplirait l'investisseur avec le scrapping automatique des informations d'une annonce immobillière du site ouestfrance-immo.com pour laquelle l'investisseur voudrais établir sa rentabilité en location.
Aussi, pour faire nos calculs, nous avons chargé la base de donnée des informations des taux de taxe foncière des communes françaises.

  
## II. Description du code

*(nota bene : cette section (II) est uniquement descriptive, la section qui explique l'uitlisation du code (III) arrive juste après. De plus, un dictionnaire des donnée est disponible en fin de document (IV))*

* Première partie :

La première partie vise à charger toutes les librairies nécessaires ainsi que la base de donnée des taux de taxe foncière.

* Seconde partie :

Cette partie vise à établir le formulaire et à le lancer.  
Elle établie aussi la tableau *form_scrap_data* qui regroupera toutes les informations nécessaires aux différents  calculs.

* Troisième partie :

Cette partie concerne le scraping de l'annonce immobilière. Le scraping nous permet ici de récuperer le prix du bien et le prix au mètre carré, avec lesquels on en déduit la surface. Ces trois éléments sont inétégrés à *form_scrap_data*. Le code permet aussi de s'assurer de ne prendre que les chiffres, sans les symboles et les espaces, sans quoi il est impossible de les convertir en numérique. De même, avec cette partie du code, on s'assure que le texte de la ville apparaisse dans le tableau en majuscule et sans accent pour se conformer à la typologie de la base de donnée de la taxe foncière.

*(nota bene : pour que notre code fonctionne, il est imparatif d'utiliser l'url d'une annonce immobilière provenant du site ouestfrance-immo (https://www.ouestfrance-immo.com))*

* Quatrième partie :

Cette partie que nous avons appelé *assignation* a pour but de créer les variables utiles aux calculs, qui reprennent dans leur détermination les données du tableau *form_scrap_data*. 


## III. Utilisation du code



## IV. Dictionnaire des données

Pour le formulaire:
* url : url de l'annonce immobilière.
* Prix de location au mètre carré : celui que l'investisseur souhaitera appliquer.
* prix de revente espéré au mètre carré : celui que souhaite l'investisseur (attention, ce n'est pas le prix d'achat du bien immobilier, celui-ci étant récupéré automatiquement).
* Prix des travaux de rénovation : si l'investisseur souhaite en réaliser, inscrire 0 s'il ne souhaite pas.
* Taux de placement : taux d'intérêt si l'investisseur placait son apport plutôt que d'investir dans le bien immobilier.


Les autres variables :
* tax_fonc : dataframe des taux de taxe foncière.
* plocm2 : prix de location au m².
* pventem2 : prix de revente espéré au m².
* ptravaux : prix des travaux.
* dureecredit : durée de l'emprunt en année.
* txcredit : taux d'emprunt.
* apport : apport pour l'emprunt.
* txplacement : taux d'interêt si l'apport est investit ailleurs que dans l'emprunt.
* prix : prix du bien.
* prix_m2 : prix du bien au m².
* texte_sans_accent_majuscule : nom de la commune du bien sans accent et en majuscule.
* form_scrap_data : tableaux regroupant à la fois les informations remplies dans le formulaire et celles issuent du scraping de l'annonce.
* tx_tf : taux de taxe foncière (correspondant automatiquement à celui de la commune de l'annonce).
* loyer_m : loyer mensuel.
* ali : assurance loyer impayé.
* tf : montant de la taxe foncière (par an).
* apno : assurance propriétaire non-occupant.
* montant de l'emprunt.
* ticm : taux d'intérêt mensuel de l'emprunt.
* duree_emprunt : durée de l'emprunt en mois.
* mensualite : montant du coût mensuel de l'emprunt.
* resultat_mensuel : bénéfice ou perte de la mise en location du bien.
* txpm : taux de placement mensuel.
* rentabilite_des_K_investis_totale :
* rentabilite_K_investis_totale_pourcent :
* rentabilité_K_investis_totale_annuel :
* rentabilite_brute :
* rentabilite_nette :















