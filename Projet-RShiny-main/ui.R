if(!require(shiny)){install.packages("shiny")}
if(!require(leaflet)){install.packages("leaflet")}
if(!require(httr)){install.packages("httr")}
if(!require(jsonlite)){install.packages("jsonlite")}
if(!require(RMySQL)){install.packages("RMySQL")}
if(!require(pool)){install.packages("pool")}
if(!require(shinydashboard)){install.packages("shinydashboard")}
if(!require(shinydashboard)){install.packages("shinyFiles")}
if(!require(shinydashboard)){install.packages("shinyjs")}
if(!require(shinydashboard)){install.packages("ggplot2")}

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
