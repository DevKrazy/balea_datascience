library(dplyr)
library(ggplot2)

# chargement données
balea_data <- read.csv2("Data_balea_projetIG4.csv")
# création colonne BalanceId (concaténations des IDs)
balea_data$BalanceId = paste(balea_data$TruckId, balea_data$CorridorNumber, sep="") 


# enlève les utilisations de balances qui n'ont pas nécessité de tarage
balance_tarees <- balea_data %>% filter(TARException ==  1)

# utiisations de balances tarées, grouped by balanceId
balance_tarees_gb_df <- data.frame(table(balance_tarees$BalanceId))
colnames(balance_tarees_gb_df) = c("BalanceId", "NbTarages")

# pour chaque BalanceId, compte le nb d'ocurrences
balances_gb <- table(balea_data$BalanceId)

grouped_by_data_df <- data.frame(balances_gb)
colnames(grouped_by_data_df) = c("BalanceId", "NbUtilisations")

grouped_by_data_df <- merge(x = grouped_by_data_df, y = balance_tarees_gb_df, by = "BalanceId")

grouped_by_data_df$RatioTarage = 100*grouped_by_data_df$NbTarages/grouped_by_data_df$NbUtilisations


### = = = = = = =  =###

balance_101 <- balea_data %>% filter(balea_data$BalanceId == "65")
balance_101 <- balance_101[c("BalanceId", "PickingDate", "TARException")]
balance_101 <- balance_101[order(balance_101$PickingDate),]
balance_101$TARSum = cumsum(balance_101$TARException)
balance_101$NumUtilisation = seq.int(nrow(balance_101)) 

p <- ggplot(balance_101) + geom_line(aes(x = balance_101$NumUtilisation, y = balance_101$TARSum))
p



