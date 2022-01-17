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
balea_data$WeightRatioErreur = round(100*balea_data$WeightError/as.double(balea_data$TheoriticalTotalWeight), 2)


## = = = = = = = = Création colonne NbUtilisations = = = = = = ##

# pour chaque balance, compte le nb d'utilisations
balances <- data.frame(table(balea_data$BalanceId))
colnames(balances) = c("BalanceId", "NbUtilisations")



## = = = = = = = = Création colonne NbErreurs = = = = = = ##

# pourcentage de mesures à + de 5% d'erreur
balances_erreur_5 <- balea_data %>% filter(balea_data$WeightRatioErreur >= 5)

# pour chaque compte le nb d'utilisations où erreur > 5%
balances_erreur_5 <- data.frame(table(balances_erreur_5$BalanceId))
colnames(balances_erreur_5) = c("BalanceId", "NbErreurs")

# fusion des tables balance_erreur_5 et balances sur attribut BalanceId
balances <- merge(x = balances, y = balances_erreur_5, by = "BalanceId")



## = = = = = = = = Création colonne RatioErreur = = = = = = ##

balances$RatioErreur = 100*balances$NbErreurs/balances$NbUtilisations



## = = = = = = = = Création colonne NbTarages = = = = = = ##

# enlève les utilisations de balances qui n'ont pas nécessité de tarage
balea_data_tarees <- balea_data %>% filter(TARException ==  1)
# pour chaque BalanceId, compte le nb d'ocurrences de tarages
balances_tarees <- data.frame(table(balea_data_tarees$BalanceId))
colnames(balances_tarees) = c("BalanceId", "NbTarages")

# fusion des tables balances_tarees et balances sur attribut BalanceId
balances <- merge(x = balances, y = balances_tarees, by = "BalanceId")

## = = = = = = = = Création colonne RatioTarage = = = = = = ##
balances$RatioTarage = 100*balances$NbTarages/balances$NbUtilisations



## = = = = = = = = Création colonne NbForcages = = = = = = ##

# enlève les utilisations de balances qui n'ont pas nécessité de forcage
balea_data_forcage <- balea_data %>% filter(FlagWeightOverriden ==  1)
# pour chaque BalanceId, compte le nb d'ocurrences de tarages
balances_forcees <- data.frame(table(balea_data_forcage$BalanceId))
colnames(balances_forcees) = c("BalanceId", "NbForcages")

# fusion des tables balances_forcees et balances sur attribut BalanceId
balances <- merge(x = balances, y = balances_forcees, by = "BalanceId")

## = = = = = = = = Création colonne RatioForcage = = = = = = ##
balances$RatioForcage = 100*balances$NbForcages/balances$NbUtilisations


## mets le balanceId en tant que colonne d'indices
rownames(balances) <- balances$BalanceId



## = = = = = ACP = = = = = ##

acp_nb <- PCA(balances[c(2, 5, 7)])




## = = = = = K-means = = = = ##

balancesKm <- balances[c(2, 4)]

set.seed(123) # ??
resKm <- kmeans(scale(balancesKm), 4, nstart=25)

#balancesKm$Cluster = resKm$cluster

# ggplot(balancesKm) +
#   geom_point(aes(x = balancesKm$NbUtilisations, y = balancesKm$RatioErreur,
#                  colour = as.factor(balancesKm$Cluster)))

fviz_cluster(resKm, data = balancesKm,
             palette = c("#f06262", "#cfc4c4","#b0a7a7", "#8cf584"),
             geom = "point",
             ellipse.type = "convex",
             ggtheme = theme_bw()
)
