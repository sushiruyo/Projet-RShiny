library(shiny)


source("ui.R")
source("server.R")

# Fonction réactive pour charger les données depuis l'API JCDecaux
load_data <- function() {
  contract <- "Lyon"
  api_key <- "400699ac5a2d81c64cf5485dd8f6f20f3520e456"
  
  base_url <- "https://api.jcdecaux.com/vls/v1/stations?"
  url <- paste0(base_url, "contract=", contract, "&apiKey=", api_key)
  
  response <- httr::GET(url)
  Velov_list <- jsonlite::fromJSON(rawToChar(response$content), flatten = TRUE)
  df <- data.frame(Velov_list)
  return(df)
}

# Charger les données au démarrage de l'application
df <- load_data()

shinyApp(ui = ui, server = server)