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
      menuItem("Graphiques", tabName = "graphics", icon = icon("far fa-chart-bar")),
      menuItem("Tarages et Forçages", tabName = "tarage_forcage", icon = icon("far fa-chart-bar")),
      menuItem("Erreur de poids", tabName = "err_poids", icon = icon("far fa-chart-bar"))
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
        shinydashboard::box(
          title = "Contexte", solidHeader = TRUE,
          "Balea est une PME languedocienne qui fabrique et développe des chariots connectés de préparation de commandes pour les entrepôts logistiques. Ces chariots utilisent des balances ayant pour but de minimiser les erreurs humaines et favoriser l'exactitude des commandes préparées. Chaque chariot possède plusieurs balances connectées à un système embarqué qui permet d'enregistrer et de contrôler ces poids. Ce système de contrôle permet à Balea d'assurer une grande fiabilité dans la justesse des commandes préparées par les opérateurs. Dans la pratique, il arrive qu’une balance soit défectueuse. Cela engendre des erreurs de mesures de poids et par conséquent des interventions humaines sont nécessaires telles que le tarage manuel des balances ou le forçage de la commande (sans le contrôle de poids) afin de débloquer le tour de préparation de commande."
        )
      ),
      
      
      # Second tab content
      tabItem(tabName = "graphics",
        h2("Some graphics"),
        shinydashboard::box(plotOutput("firstPlot"))
      ),
      
      # ---- Analyse des nombres de tarages, forçages et utilisation ----#
      tabItem(tabName = "tarage_forcage",
        h2("Analyse des tarages et des forçages"),
        fluidRow(
          shinydashboard::box(width = 12,
            column(width = 8,
              h3("Graphique du nombre d’utilisation en fonction du nombre de tarage (Balance n°65)"),
              plotOutput("plotq_t")
            ),
            column(width = 4,
              h3("Observation"),
              "On remarque un profil plutôt linéaire, ce qui laisse présager que la proportion de tarage par rapport au nombre d’utilisation n’évolue pas avec le temps. Dans le cas où une balance deviendrait plus défectueuse avec le temps on aurait observé un profil se rapprochant de la forme d’une courbe exponentielle."
            )
          )
        ),
        fluidRow(
          shinydashboard::box(width = 12,
            column(width = 4,
              h3("ACP nombre d’utilisation, nombre de tarage et nombre de forçage"),
              plotOutput("acp_nb_ind"),
              "Graphique des individus. Coloration en fonction du cos2 (qualité de représentation). Les individus similaires sont groupés ensemble."
            ),
            column(width = 4,
                 h3("Variables - PCA"),
                 plotOutput("acp_nb_var"),
                 "Graphique des variables. Coloration en fonction de la contribution des variables. Les variables corrélées positivement sont du même côté du graphique. Les variables corrélées négativement sont sur des côtés opposés du graphique."
            ),
            column(width = 4,
                   h3("Observation"),
                 "On se rend compte que le nombre de tarages et le nombre de forçages sont assez corrélés (calculer cos(angle_flèches), Seith nous avait dit qu’environ 70% des tarages donnaient lieu à un forçage (recalculer ce pourcentage nous même pour le confirmer ou l’infirmer). On ne peut pas conclure grand chose de cette ACP."
            )
          )
        ),
        fluidRow(
          shinydashboard::box(width = 12,
            column(width = 4,
               
                   h3("ACP ratio tarage et ratio forcage "),
                   plotOutput("acp_ratios_ind"),
                   "Graphique des individus. Coloration en fonction du cos2 (qualité de représentation). Les individus similaires sont groupés ensemble."
               
            ),
            column(width = 4,
                 h3("Variables - PCA"),
                 plotOutput("acp_ratios_var"),
                 "Graphique des variables. Coloration en fonction de la contribution des variables. Les variables corrélées positivement sont du même côté du graphique. Les variables corrélées négativement sont sur des côtés opposés du graphique."
             ),
            column(width = 4,
                 h3("Observation"),
                "On voit que les 2 ratios sont corrélés (angle 45° donc cos ~ 0,7), pareil que l’ACP du nb d’utilisations, de forçages et de tarages, on ne peut pas en conclure grand chose."
            )
          )
        )
      ),
      
      
      # ---- Analyse des erreurs de poids des balances ----#
      tabItem(tabName = "err_poids",
        h2("Analyse des erreurs de poids des balances"),
        fluidRow(
          shinydashboard::box(width = 12,
            column(width = 4,
               h3("Graphique du nombre d’utilisation en fonction du nombre de tarage (Balance n°65)"),
               plotOutput("acp_poids_ind")
            ),
            column(width = 4,
               h3("Variables - PCA"),
               plotOutput("acp_poids_var")
            ),
            column(width = 4,
               h3("Obersavtion"),
               "On remarque que le pourcentage d’erreur et le nombre d’utilisation sont non corrélés, on remarque angle pi/2 ⇒ Cos(teta) = 0. Donc notre hypothèse où plus on utiliserai une balance plus cette dernière deviendrait défectueuse est fausse. Donc nous allons pouvoir extraire des profils de balances défectueuses et classifier."
            )
          )
        )
      )
    )
  )
)

