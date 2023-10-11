# Installer les packages si nécessaire
if(!require(shiny)){install.packages("shiny")}
if(!require(leaflet)){install.packages("leaflet")}
if(!require(httr)){install.packages("httr")}
if(!require(jsonlite)){install.packages("jsonlite")}
if(!require(RMySQL)){install.packages("RMySQL")}
if(!require(pool)){install.packages("pool")}
if(!require(shinydashboard)){install.packages("shinydashboard")}

# Charger les bibliothèques nécessaires
library(leaflet)
library(httr)
library(jsonlite)
library(RMySQL)
library(pool)
library(shinydashboard)
library(shiny)

# Définir l'interface utilisateur de l'application
ui <- dashboardPage(
  dashboardHeader(title = "Dashboard Velov"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("MyMap", tabName = "mapTab"),
      menuItem("Onglet Vide", tabName = "emptyTab")
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
              leafletOutput("mymap", height = "600px")  # Définir une hauteur fixe pour la sortie de la carte
      ),
      
      # Contenu du deuxième onglet
      tabItem(tabName = "emptyTab",
              h2("Cet onglet est vide.")
      )
    )
  )
)
