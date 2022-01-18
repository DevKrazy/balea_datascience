library(shiny)
library(ggplot2)
library(dplyr)

balea_data <- read.csv2("Data_balea_projetIG4.csv")
balea_data$TheoriticalTotalWeight = as.double(balea_data$Quantity)*as.double(balea_data$WeightProductTradeUnitUsed)
balea_data$WeightError = abs(as.double(balea_data$Weight)-balea_data$TheoriticalTotalWeight)
balea_data$BalanceId = paste(balea_data$TruckId, balea_data$CorridorNumber)

# average error for each truck
#print(aggregate(balea_data$WeightError, list(balea_data$TruckId), mean))


#truck_42 <- balea_data %>% filter(balea_data$TruckId == 42)
#print(truck_42)
#print(aggregate(truck_42$WeightError, list(truck_42$CorridorNumber), mean))

faulty <- balea_data %>% filter(balea_data$WeightError > 1)
print(count(balea_data))
#print(count(faulty, "CorridorNumber"))
print(sapply(faulty, function(x) sum(!duplicated(x))))

shinyServer(function(input, output) {
  
  output$firstPlot <- renderPlot({
    
    # affichage du plot
    ggplot(data = balea_data, mapping = aes(x = balea_data$TruckId, y = balea_data$WeightError, group = TruckId)) +
      geom_line() +
      ggtitle("Evolution of growth\nby symbol") +
      ylab("WeightError") +
      xlab("Weight")
  })
  
  
  source("entete.R")
  output$plot_tarage_balance <- renderPlot(plot_tarage_balance)
  output$plot_q_e <- renderPlot(plot_q_e)
  output$acp_nb_ind <- renderPlot(acp_nb_aff_ind)
  output$acp_nb_var <- renderPlot(acp_nb_aff_var)
  
  output$acp_ratios_ind <- renderPlot(acp_ratios_aff_ind)
  output$acp_ratios_var <- renderPlot(acp_ratios_aff_var)
  
  output$acp_poids_ind <- renderPlot(acp_poids_aff_ind)
  output$acp_poids_var <- renderPlot(acp_poids_aff_var)
  
  output$kmeans <- renderPlot(kmeans)
  
  output$texte <- renderUI({
    validate(
      need(input$numBalance, 'Donnez un numéro de balance valide !'),
    )
    
    classe <- reactive({classe <- input$numBalance})
    validate(
      need(is.na(resKm$cluster[classe()]) == FALSE, 'Donnez un numéro de balance valide !'),
    )
    if(resKm$cluster[classe()] == 1){
      "Balances avec un taux d’erreur très important, un nombre d’utilisation relativement bas-modéré. Représenté en rouge sur le graphique"
    }
    else if (resKm$cluster[classe()] == 2){
      "Balances fiables, beaucoup d’utilisation et un taux d’erreur faible. Représenté en vert sur le graphique."
    }
    else if (resKm$cluster[classe()] == 3){
      "Balances peu utilisés avec un faible taux d’erreur, pas réellement analysable. Représenté en bleu sur le grpahique."
    }
    else if (resKm$cluster[classe()]== 4){
      "Balance peu utilisé avec quelques erreurs mais pas suffisamenent d'utilisation pour la classé défectueuse. Représenté en violet sur le graphique."
    }
    else{
      ""
    }
  })
  
})
