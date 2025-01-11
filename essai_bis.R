run_script <- function() {
  
  install_if_needed_multiple <- function(packages) {
    for (package in packages) {
      if (!requireNamespace(package, quietly = TRUE)) {
        install.packages(package)
      }
    }
  }
  
  install_if_needed_multiple(c("openxlsx", "tcltk"))
  
  library(tcltk)
  library(tidyverse)
  library(rvest)
  library(readxl)
  library(stringi)
  library(tcltk)
  library(crayon)
  library(openxlsx)
  
  
  rm(list=ls())
  
  run_last <- function() {
    
    
    url2 <- "https://raw.githubusercontent.com/Alexisdurand1/projet/main/tf_clean.xlsx"
    
    file_path <- tempfile(fileext = ".xlsx")
    
    download.file(url2, file_path, mode = "wb")
    
    tax_fonc <- read_excel(file_path)
    
    url <- form_scrap_data$url
    
    page <- read_html(url)
    
    prix <- page %>%
      html_element(".detail-prix") %>%  # Sélectionner l'élément contenant le prix
      html_text(trim = TRUE) %>%
      str_extract("[0-9]+(?:[\\s][0-9]+)*") %>%  # Extraire le nombre avec espaces
      str_replace_all("\\s", "")  # Supprimer les espaces pour obtenir un nombre entier
    
    prix_m2 <- page %>%
      html_elements(".detail-prix__prix-m2") %>%  # Cibler l'élément contenant le prix au m²
      html_text(trim = TRUE) %>%  # Extraire le texte
      str_extract("[0-9\\s]+") %>%  # Extraire uniquement les chiffres et espaces
      str_replace_all("\\s", "") # Nettoyer les espaces inutiles
    
    prix_m2 <- prix_m2[1]
    
    texte <- page %>%
      html_elements(".detail-annonces-similaires__title") %>%
      html_text(trim = TRUE) %>%
      str_extract("(?<=à ).*")  # Extraire tout après "à" avec lookbehind
    
    texte_sans_accent_majuscule <- stri_trans_general(str_to_upper(texte), "Latin-ASCII")
    
    form_scrap_data$prix <- as.numeric(prix)  # Convertir en numérique
    form_scrap_data$prix_m2 <- as.numeric(prix_m2)
    form_scrap_data$surface_habitable <- as.numeric(prix) / as.numeric(prix_m2)  # Calcul de la surface
    form_scrap_data$ville <- texte_sans_accent_majuscule  # Assignation des villes
    
    tx_tf <- tax_fonc$taux[tax_fonc$commune == form_scrap_data$ville]/100
    loyer_m <- form_scrap_data$plocm2*form_scrap_data$surface_habitable
    ali <- loyer_m*12*0.0035
    tf <- form_scrap_data$surface_habitable*form_scrap_data$plocm2*tx_tf
    apno <- 0.02*loyer_m*12
    emprunt <- form_scrap_data$prix*1.08+form_scrap_data$ptravaux-form_scrap_data$apport
    ticm <- (1+(form_scrap_data$txcredit)/100)^(1/12)-1
    duree_emprunt <- form_scrap_data$dureecredit*12
    mensualite <- (emprunt * ticm) / (1 - (1 + ticm)^(-duree_emprunt))
    resultat_mensuel <- loyer_m-(mensualite+tf/12+ali/12+apno/12)
    txpm <- (1+(form_scrap_data$txplacement)/100)^(1/12)-1
    
    act <- 0
    for (i in 1:duree_emprunt) {
      act <- act + resultat_mensuel * (1 + txpm)^(duree_emprunt - i)
    }
    
    cap <- 0
    for (i in 1:duree_emprunt) {
      cap <- cap + resultat_mensuel / (1+txpm)^i
    }
    
    tab_amo <- data.frame(
      n_mensualite = 1:duree_emprunt,
      mensualite = rep(mensualite, duree_emprunt),
      interets = numeric(duree_emprunt),
      amortissement = numeric(duree_emprunt),
      capital_restant_du_debut_de_periode = numeric(duree_emprunt)
    )
    
    tab_amo$capital_restant_du_debut_de_periode[1] <- emprunt
    
    for (i in 1:duree_emprunt) {
      tab_amo$interets[i] <- ticm * tab_amo$capital_restant_du_debut_de_periode[i]
      tab_amo$amortissement[i] <- tab_amo$mensualite[i] - tab_amo$interets[i]
      
      if (i < duree_emprunt) {
        tab_amo$capital_restant_du_debut_de_periode[i + 1] <- tab_amo$capital_restant_du_debut_de_periode[i] - tab_amo$amortissement[i]
      }
    }
    
    tab_amo$mensualite <- round(tab_amo$mensualite, 2)
    tab_amo$interets <- round(tab_amo$interets, 2)
    tab_amo$amortissement <- round(tab_amo$amortissement, 2)
    tab_amo$capital_restant_du_debut_de_periode <- round(tab_amo$capital_restant_du_debut_de_periode, 2)
    
    write.xlsx(tab_amo, file = "Tableau_Amortissement.xlsx")
    
    rentabilite_des_K_investis_totale <- NULL
    if (resultat_mensuel < 0) {
      rentabilite_des_K_investis_totale <- form_scrap_data$surface_habitable * form_scrap_data$pventem2 /
        (form_scrap_data$apport + abs(act))
    } else {
      rentabilite_des_K_investis_totale <- (form_scrap_data$surface_habitable * form_scrap_data$pventem2 +
                                              cap)/form_scrap_data$apport
    }
    
    rentabilite_K_investis_totale_pourcent <- paste0(round((rentabilite_des_K_investis_totale-1)*100, 2), "%")
    
    rentabilité_K_investis_totale_annuel <- paste0(round((rentabilite_des_K_investis_totale^(1/form_scrap_data$dureecredit)-1)*100, 2), "%")
    
    rentabilite_brute <- paste0(round((loyer_m*12*100)/form_scrap_data$prix, 2), "%")
    
    rentabilite_nette <- paste0(round((resultat_mensuel*100*12)/(form_scrap_data$prix*1.08+form_scrap_data$ptravaux), 2), "%")
    
    afficher_rentabilites <- function() {
      win <- tktoplevel()
      tkwm.title(win, "Résultats de rentabilité")
      tkconfigure(win, bg = "#f4f4f4")
      
      tkgrid(
        tklabel(win, text = "Résultats de rentabilité", font = "Helvetica 16 bold", bg = "#f4f4f4", fg = "#333"),
        pady = 20
      )
      
      tkgrid(
        tklabel(win, text = "La rentabilité brute estimée est :", font = "Helvetica 12", bg = "#f4f4f4", fg = "#333"),
        pady = 10
      )
      tkgrid(
        tklabel(win, text = rentabilite_brute, font = "Helvetica 14 bold", bg = "#f4f4f4", fg = "#0073e6"),
        pady = 10
      )
      
      tkgrid(
        tklabel(win, text = "La rentabilité nette estimée est :", font = "Helvetica 12", bg = "#f4f4f4", fg = "#333"),
        pady = 10
      )
      tkgrid(
        tklabel(win, text = rentabilite_nette, font = "Helvetica 14 bold", bg = "#f4f4f4", fg = "#0073e6"),
        pady = 10
      )
      
      tkgrid(
        tklabel(win, text = "La rentabilité des capitaux investis sur la totalité de l'investissement estimée est :", font = "Helvetica 12", bg = "#f4f4f4", fg = "#333"),
        pady = 10
      )
      tkgrid(
        tklabel(win, text = rentabilite_K_investis_totale_pourcent, font = "Helvetica 14 bold", bg = "#f4f4f4", fg = "#0073e6"),
        pady = 10
      )
      
      tkgrid(
        tklabel(win, text = "La rentabilité moyenne annuelle des capitaux investis estimée est :", font = "Helvetica 12", bg = "#f4f4f4", fg = "#333"),
        pady = 10
      )
      tkgrid(
        tklabel(win, text = rentabilité_K_investis_totale_annuel, font = "Helvetica 14 bold", bg = "#f4f4f4", fg = "#0073e6"),
        pady = 10
      )
      
      tkgrid(
        tkbutton(
          win, text = "Enregistrer le tableau d'amortissement",
          command = function() {
            library(openxlsx)
            write.xlsx(tab_amo, file = "Tableau_Amortissement.xlsx")
            tkmessageBox(
              title = "Exportation réussie",
              message = "Votre tableau a été enregistré sous le nom 'Tableau_Amortissement.xlsx'.",
              icon = "info",
              type = "ok"
            )
          },
          bg = "#0073e6", fg = "white", relief = "flat"
        ),
        pady = 20
      )
      
      tkgrid(
        tkbutton(win, text = "Fermer", command = function() tkdestroy(win), bg = "#0073e6", fg = "white", relief = "flat"),
        pady = 20
      )
    }
    
    afficher_rentabilites()
    
  }
  
  
  # Créer une fonction pour afficher le formulaire
  formulaire_tcltk <- function() {
    # Créer une fenêtre pour le formulaire
    win <- tktoplevel()
    tkwm.title(win, "Formulaire")
    tkconfigure(win, bg = "#f4f4f4")  # Couleur d'arrière-plan
    
    # Variables pour stocker les données
    url <- tclVar("")
    plocm2 <- tclVar("")
    pventem2 <- tclVar("")
    ptravaux <- tclVar("")
    dureecredit <- tclVar("")
    txcredit <- tclVar("")
    apport <- tclVar("")
    txplacement <- tclVar("")
    
    # Fonction pour enregistrer les données dans un data.frame
    enregistrer_donnees <- function() {
      # Créer un data.frame avec les valeurs du formulaire
      form_scrap_data <- data.frame(
        url = tclvalue(url),
        plocm2 = as.numeric(gsub(",", ".", tclvalue(plocm2))),
        pventem2 = as.numeric(tclvalue(pventem2)),
        ptravaux = as.numeric(tclvalue(ptravaux)),
        dureecredit = as.numeric(tclvalue(dureecredit)),
        txcredit = as.numeric(gsub(",", ".", tclvalue(txcredit))),
        apport = as.numeric(tclvalue(apport)),
        txplacement = as.numeric(gsub(",", ".", tclvalue(txplacement))),
        stringsAsFactors = FALSE
      )
      
      # Assigner le data frame dans l'environnement global
      assign("form_scrap_data", form_scrap_data, envir = .GlobalEnv)
      
      tkdestroy(win)  # Fermer la fenêtre du formulaire après soumission
    }
    
    # Ajouter un titre
    tkgrid(
      tklabel(win, text = "Formulaire d'Analyse Immobilière", font = "Helvetica 16 bold", bg = "#f4f4f4", fg = "#333"),
      pady = 20
    )
    
    # Créer les éléments du formulaire
    champs <- list(
      "Url de l'annonce :" = url,
      "Prix de location au mètre carré :" = plocm2,
      "Prix de revente espéré au mètre carré :" = pventem2,
      "Prix des travaux de rénovation :" = ptravaux,
      "Durée du crédit (en année) :" = dureecredit,
      "Taux du crédit :" = txcredit,
      "Apport pour cet achat :" = apport,
      "Taux de placement espéré :" = txplacement
    )
    
    for (champ in names(champs)) {
      tkgrid(
        tklabel(win, text = champ, font = "Helvetica 12", bg = "#f4f4f4", fg = "#333"),
        tkentry(win, textvariable = champs[[champ]]),
        padx = 10, pady = 5
      )
    }
    
    # Créer un bouton pour soumettre les données
    tkgrid(
      tkbutton(win, text = "Valider", command = function(){
        enregistrer_donnees()
        run_last()}, bg = "#0073e6", fg = "white", relief = "flat"),
      pady = 20
    )
    
    # Afficher le formulaire
    tkwait.window(win)
  }
  
  # Lancer le formulaire
  formulaire_tcltk()
  
}




run_script()
