library(shiny)
library(ggplot2)
library(dplyr)

#balea_data <- read.csv2("Data_balea_projetIG4.csv")
balea_data$TheoriticalTotalWeight = as.double(balea_data$Quantity)*as.double(balea_data$WeightProductTradeUnitUsed)
balea_data$WeightError = abs(as.double(balea_data$Weight)-balea_data$TheoriticalTotalWeight)
balea_data$TruckCorridorId = 

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
  
})
