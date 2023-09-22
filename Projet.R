library(shiny)
library(leaflet)
library(httr)
library(jsonlite)
library(RMySQL)
library(pool)

contract <- "Lyon"
api_key <- "400699ac5a2d81c64cf5485dd8f6f20f3520e456"

base_url <- "https://api.jcdecaux.com/vls/v1/stations?"
url <- paste0(base_url, "contract=", contract, "&apiKey=", api_key)

response <- GET(url)

print(response)

Velov_list <- fromJSON(rawToChar(response$content), flatten = TRUE)
df <- data.frame(Velov_list)

con <- dbConnect(MySQL(), 
                 user = "sql11646648",
                 password = "evq3U456nu",
                 host = "sql11.freesqldatabase.com",
                 dbname = "sql11646648")

# connexion bdd Anne-Danielle
con<- dbConnect(MySQL(),
                user= 'sql11646660',
                password= 'EP9eSuDAJ5',
                host="sql11.freedatabase.com",
                dbname="sql11646660")
#deconnexion

pool <- dbPool(
  drv = RMySQL::MySQL(),
  dbname = "sql11646660",
  host = "sql11.freedatabase.com",
  username = "sql11646660",
  password = "EP9eSuDAJ5"
)
poolClose(pool)



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
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
  
  output$dist2plot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    pie(x, breaks = bins, col = 'red', border = 'white',
        xlab = 'Waiting time to next eruption (in mins)',
        main = 'Test')
  })
}






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

server <- function(input, output, session) {
  
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

shinyApp(ui, server)







# Run the application 
shinyApp(ui = ui, server = server)

# Se déconnecter de la BDD (important à utiliser car on est limités à 15 connexions)
pool <- dbPool(
  drv = RMySQL::MySQL(),
  dbname = "sql11646648",
  host = "sql11.freesqldatabase.com",
  username = "sql11646648",
  password = "evq3U456nu"
)

poolClose(pool)