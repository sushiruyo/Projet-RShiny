library(shiny)
library(leaflet)
library(httr)
library(jsonlite)
library(RMySQL)
library(pool)
library(shinydashboard)





ui <- fluidPage(
  
  # Application title
  titlePanel("R SHINY PROJECT"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Nombre de bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("distPlot")),
                  tabPanel("2e", plotOutput("dist2plot")),
                  tabPanel("Mymap",leafletOutput("mymap")),
      )
    )
  )
)




# Carte

# Exemple de dataframe. Remplacez ceci par votre propre dataframe.
positions <- data.frame(
  lat = df$position.lat,
  long = df$position.lng
)

ui <- fluidPage(
  
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
)
  
  # Utilisez votre dataframe ici plutôt que de générer des points aléatoires
  points <- reactive({
    positions
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      # Utilisez les données de votre dataframe ici
      addMarkers(data = points())
  })
}