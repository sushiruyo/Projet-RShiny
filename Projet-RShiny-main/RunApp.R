library(shiny)

source("df.R")
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)