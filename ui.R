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
      menuItem("Accueil", tabName = "home", icon = icon("fas fa-home")),
      menuItem("Graphiques", tabName = "graphics", icon = icon("far fa-chart-bar"))
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
        h3("Problématique : Comment identifier de façon automatique les balances potentiellement défectueuses ?"),
        box(
          title = "Contexte", solidHeader = TRUE,
          "Balea est une PME languedocienne qui fabrique et développe des chariots connectés de préparation de commandes pour les entrepôts logistiques. Ces chariots utilisent des balances ayant pour but de minimiser les erreurs humaines et favoriser l'exactitude des commandes préparées. Chaque chariot possède plusieurs balances connectées à un système embarqué qui permet d'enregistrer et de contrôler ces poids. Ce système de contrôle permet à Balea d'assurer une grande fiabilité dans la justesse des commandes préparées par les opérateurs. Dans la pratique, il arrive qu’une balance soit défectueuse. Cela engendre des erreurs de mesures de poids et par conséquent des interventions humaines sont nécessaires telles que le tarage manuel des balances ou le forçage de la commande (sans le contrôle de poids) afin de débloquer le tour de préparation de commande."
        )
      ),
      # Second tab content
      tabItem(tabName = "graphics",
              h2("Some graphics"),
              box(plotOutput("firstPlot"))
      )
    )
  )
)

