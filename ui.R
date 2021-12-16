#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(
    title = "Data Science Project"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Accueil", tabName = "home", icon = icon("dashboard")),
      menuItem("Graphiques", tabName = "graphics", icon = icon("th"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    
    tabItems(
      # First tab content
      tabItem(tabName = "home",
        h1("Data Science Project - Balea"),
        h3("Analyse des balances potentiellement défectueuses des chariots utilisés dans un entrepôt de préparation de commande"),
        h3("Problématique : Comment identifier de façon automatique les balances potentiellement défectueuses ?")
        
      ),
      
      # Second tab content
      tabItem(tabName = "graphics",
        h2("Some graphics")
      )
    )
  )
)
