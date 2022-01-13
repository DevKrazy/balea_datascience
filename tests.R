library(dplyr)
library(ggplot2)
library(FactoMineR)

# chargement données
balea_data <- read.csv2("Data_balea_projetIG4.csv")
# création colonne BalanceId (concaténations des IDs)
balea_data$BalanceId = paste(balea_data$TruckId, balea_data$CorridorNumber, sep="")
# enlève les utilisations de balances qui n'ont pas nécessité de tarage
balea_data_tarees <- balea_data %>% filter(TARException ==  1)

# pour chaque BalanceId, compte le nb d'ocurrences de tarages
balance_tarees_gb_df <- data.frame(table(balea_data_tarees$BalanceId))
colnames(balance_tarees_gb_df) = c("BalanceId", "NbTarages")

# pour chaque BalanceId, compte le nb d'ocurrences d'utilisations
balances_gb_df <- data.frame(table(balea_data$BalanceId))
colnames(balances_gb_df) = c("BalanceId", "NbUtilisations")

# join des dataframes des balances et balances tarées sur le BalanceId
balances_gb_df <- merge(x = balances_gb_df, y = balance_tarees_gb_df, by = "BalanceId")

# ajout colonne RatioTarage
balances_gb_df$RatioTarage = 100*balances_gb_df$NbTarages/balances_gb_df$NbUtilisations
balances_gb_df$BalanceId = as.character(balances_gb_df$BalanceId)
balances_gb_df$Test = "Test"

### = = = = Plot pour une balance = = = = ###
balance <- balea_data %>% filter(balea_data$BalanceId == "65")
balance <- balance[c("BalanceId", "PickingDate", "TARException")]
balance <- balance[order(balance$PickingDate),]
balance$TARSum = cumsum(balance$TARException)
balance$NumUtilisation = seq.int(nrow(balance)) 

p <- ggplot(balance) +
  geom_line(aes(x = balance$NumUtilisation, y = balance$TARSum))
p

### = = = = ACP = = = = ###
acp <- PCA(balances_gb_df[,2:3], quali.sup = ,1)



