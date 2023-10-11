if(!require(shiny)){install.packages("shiny")}
if(!require(leaflet)){install.packages("leaflet")}
if(!require(httr)){install.packages("httr")}
if(!require(jsonlite)){install.packages("jsonlite")}
if(!require(RMySQL)){install.packages("RMySQL")}
if(!require(pool)){install.packages("pool")}
if(!require(shinydashboard)){install.packages("shinydashboard")}

library(leaflet)
library(httr)
library(jsonlite)
library(RMySQL)
library(pool)
library(shinydashboard)
library(shiny)

contract <- "Lyon"
api_key <- "400699ac5a2d81c64cf5485dd8f6f20f3520e456"

base_url <- "https://api.jcdecaux.com/vls/v1/stations?"
url <- paste0(base_url, "contract=", contract, "&apiKey=", api_key)

response <- GET(url)

print(response)

Velov_list <- fromJSON(rawToChar(response$content), flatten = TRUE)
df <- data.frame(Velov_list)



# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Assuming df is your data frame with lat and long data
  positions <- data.frame(
    lat = df$position.lat,
    long = df$position.lng
  )
  
  df$color_point <- ifelse(df$status == "OPEN", 
                           "<span style='color:green'>&#9679;</span>", 
                           "<span style='color:red'>&#9679;</span>")
  
  df$popup_content <- paste0(
    "<div style='font-family:Arial; border: 1px solid #333; padding: 10px; border-radius: 5px;'>",
    "<h4 style='margin-top: 0; color: #007BFF;'>Station ", df$name, "</h2>",  # Station name as title
    df$color_point, 
    "<strong style='color: #555;'>Status: </strong>", df$status, "<br>",
    "<strong style='color: #555;'>Nombre de vélos disponibles: </strong>", df$available_bikes, "<br>",
    "<strong style='color: #555;'>Nombre de stands disponibles: </strong>", df$available_bike_stands,
    "</div>"
  )
  
  
  points <- reactive({
    positions
  })
  
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
}