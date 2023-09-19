library(shiny)
library(httr)
library(jsonlite)
library(RMySQL)

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


"Tables : communes, stations, état (api key sur état pour refresh)"


