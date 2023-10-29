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

contract <- "Lyon"
api_key <- "400699ac5a2d81c64cf5485dd8f6f20f3520e456"



base_url <- "https://api.jcdecaux.com/vls/v1/stations?"
url <- paste0(base_url, "contract=", contract, "&apiKey=", api_key)

response <- GET(url)

print(response)

Velov_list <- fromJSON(rawToChar(response$content), flatten = TRUE)
df <- data.frame(Velov_list)