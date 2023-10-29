# Liste des packages requis
packages <- c("shinyFiles", "leaflet", "httr", "jsonlite", "RMySQL", "pool", "shinydashboard", "shiny", "shinyjs", "ggplot2")

# Vérifier et installer les packages manquants
for (package in packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
}

# Maintenant, charger les packages
lapply(packages, library, character.only = TRUE)

library(shinyFiles)
library(leaflet)
library(httr)
library(jsonlite)
library(RMySQL)
library(pool)
library(shinydashboard)
library(shiny)
library(shinyjs)
library(ggplot2)


ui <- dashboardPage(
  dashboardHeader(title = "MyVelov"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("MyMap", tabName = "mapTab"),
      menuItem("MyKPI's", tabName = "emptyTab"),
      selectInput("Choix",label="Choisissez une station",choices= df$name )
    )
  ),
  
  dashboardBody(
    # CSS personnalisé pour définir une hauteur fixe pour la carte
    tags$head(tags$style(HTML("
      .leaflet-container {
        height: 600px;  # Hauteur fixe pour la carte
        width: 100%;   # Largeur maximale pour la carte
      }
    "))),
    
    tabItems(
      # Contenu du premier onglet
      tabItem(tabName = "mapTab",
              leafletOutput("mymap", height = "600px"),
              actionButton("refresh_data","Actualiser les donnees"),  #refresh les donn??es# DC)finir une hauteur fixe pour la sortie de la carte
      ),
      
      # Contenu du deuxiC(me onglet
      tabItem(tabName = "emptyTab",
              includeCSS("www/custom.css"),
              fluidRow(
                infoBoxOutput("Nb_velo"),
                div(class = "custom-info-box",infoBoxOutput("Nb_stations"),infoBoxOutput("Nb_stations_fermee"))
              ),
              fluidRow(
                column(12,
                       box("TOP 10 des stations",plotOutput("histograme")),
                       column(12,
                              box("Stations bonus",plotOutput("pie"))))
              ),
              box(
                # Bouton d'exportation en PNG
                downloadButton("exporter_png", "Exporter en PNG"),
                width = 12,
              ),
              
              
      )
    )
    
  )
)
