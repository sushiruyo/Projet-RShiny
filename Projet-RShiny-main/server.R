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


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  shinyDirChoose(input, "outputDir", roots = c(wd = getwd()))
  # Assuming df is your data frame with lat and long data
  positions <- data.frame(
    lat = df$position.lat,
    long = df$position.lng
  )
  
  
  ## Point vert ou rouge selon dispo station
  df$color_point <- ifelse(df$status == "OPEN", 
                           "<span style='color:green'>&#9679;</span>", 
                           "<span style='color:red'>&#9679;</span>")
  
  ## Popup d'une station sur la carte
  df$popup_content <- paste0(
    "<div style='font-family:Arial; border: 1px solid #333; padding: 10px; border-radius: 5px;'>",
    "<h4 style='margin-top: 0; color: #007BFF;'>Station ", df$name, "</h2>",  # Station name as title
    df$color_point, 
    "<strong style='color: #555;'>Status: </strong>", df$status, "<br>",
    "<strong style='color: #555;'>Nombre de vélos disponibles: </strong>", df$available_bikes, "<br>",
    "<strong style='color: #555;'>Nombre de stands disponibles: </strong>", df$available_bike_stands,
    "</div>"
  )
  
  output$Nb_velo<- renderInfoBox({
    infoBox(
      title = "Nb de vélos disponible",
      value = sum(df$available_bikes),  
      icon = icon("bicycle"),
      color = "blue"
    )
  })
  output$Nb_stations<- renderInfoBox({
    infoBox(
      title = "Nb de stations",
      value = nrow(df),  
      icon = icon("home"),
      color = "blue",
    )
  })
  output$Nb_stations_fermee<- renderInfoBox({
    infoBox(
      title = "Nb de stations avec terminale de paiement",
      value = sum(df$banking=="TRUE"),  
      icon = icon("credit-card"),
      color = "green",
    )
  })
  
  #refresh les données 
  dataReactive <- reactiveVal(df)
  
  refreshData <- function(){
    response <- GET(url)
    Velov_list <- fromJSON(rawToChar(response$content), flatten = TRUE) 
    dataReactive(Velov_list)
  }
  observeEvent(input$refresh_data, {
    refreshData()
  })
  
  
  ## Points utilisés pour la carte 
  points <- reactive({
    data <- dataReactive()
    positions <- data.frame(
      lat = data$position.lat,
      long = data$position.lng
    )
    positions
  })
  
  ## Carte
  output$mymap <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE))
    
    # Add clustered markers with popups
    m %>% addCircleMarkers(
      data = points(),
      clusterOptions = markerClusterOptions(),
      popup = ~df$popup_content
    )
  })
  
  ## Histogramme
  output$histogram <- renderPlot({
    # Créer un tableau de fréquence des vélos disponibles
    tab <- sort(table(df$available_bikes))
    
    # Créer un graphique d'histogramme vertical avec ggplot2
    ggplot(data = data.frame(Frequency = as.numeric(df$names(tab)), Count = as.numeric(tab)),
           aes(x = Frequency, y = Count)) +
      geom_bar(stat = "identity") +
      labs(x = "Fréquence", y = "Nombre de vélos") +
      theme_minimal()
  })
  
  
  
  
  ## Graphique Pie 
  output$pie <- renderPlot({
    # Créez un dataframe avec les données du tableau des bonus
    df_pie <- as.data.frame(table(df$bonus))
    
    # Créez un graphique de secteurs avec ggplot2
    camembert <<- ggplot(df_pie, aes(x = "", y = Freq, fill = Var1)) +
      geom_bar(stat = "identity") +
      coord_polar("y") +
      labs(fill = "Bonus") +
      theme_minimal() +
      theme(legend.position = "right")  # Positionnez la légende sur le côté droit
    
    # Rendre le graphique
    print(camembert)
  })
  
  ## Fonctionnalité export PNG
  output$exporter_png <- downloadHandler(
    filename = function() {
      paste("graphique_dynamique.png")
    },
    content = function(file) {
      # Sauvegardez le graphique en tant que fichier PNG
      png(file, width = 800, height = 600)
      print(camembert)  # Remplacez ggplot_graph par le nom de votre objet graphique ggplot2
      dev.off()
    })
  
}