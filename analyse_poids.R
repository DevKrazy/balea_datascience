library(dplyr)
library(ggplot2)
library(FactoMineR)
library(ggpubr)
library(factoextra)

# chargement données
balea_data <- read.csv2("Data_balea_projetIG4.csv")

balea_data$BalanceId = paste(balea_data$TruckId, balea_data$CorridorNumber, sep="")
balea_data$TheoriticalTotalWeight = as.double(balea_data$Quantity)*as.double(balea_data$WeightProductTradeUnitUsed)
balea_data$WeightError = abs(as.double(balea_data$Weight)-balea_data$TheoriticalTotalWeight)
balea_data$WeightErrorPercentage = round(100*balea_data$WeightError/as.double(balea_data$TheoriticalTotalWeight), 2)


# = = = == = =  Pourcentage de mesures à + de 5% d'erreur = = = = = = = ##

balances_erreur_5 <- balea_data %>% filter(balea_data$WeightErrorPercentage >= 5)

nb_mesures <- nrow(balea_data)
nb_mesures_erreur_5 <- nrow(balances_erreur_5)
print(100*nb_mesures_erreur_5/nb_mesures)


# = = = = = Pour chaque balance % de fois ou erreur > 5% = = = == ##

balances_erreur_5 <- data.frame(table(balances_erreur_5$BalanceId))
colnames(balances_erreur_5) = c("BalanceId", "NbErreurs")

# pour chaque BalanceId, compte le nb d'ocurrences d'utilisations
balances <- data.frame(table(balea_data$BalanceId))
colnames(balances) = c("BalanceId", "NbUtilisations")

balances <- merge(x = balances, y = balances_erreur_5, by = "BalanceId")
balances$ErrorPercentage = 100*balances$NbErreurs/balances$NbUtilisations


## = = = = = quantiles du % d'erreur = = = = = #

probs_q_e <- seq(0, 1, 1/20) # idée mettre un slider pour gérer qté des quantiles
values_q_e <- quantile(balances$ErrorPercentage, probs = probs_q_e)
balances_erreur_quantiles <- data.frame(Quantile = probs_q_e, ErrorPercentage = values_q_e)

plot_q_e <- ggplot(balances_erreur_quantiles) +
  geom_line(aes(x = balances_erreur_quantiles$Quantile, y = balances_erreur_quantiles$ErrorPercentage))
plot_q_e

## = = = = = ACPs = = = = = ##

acp_nb <- PCA(balances[c(2, 4)])



