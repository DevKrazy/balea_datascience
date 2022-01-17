# enlève les utilisations de balances qui n'ont pas nécessité de tarage
balea_data_tarees <- balea_data %>% filter(TARException ==  1)
# pour chaque BalanceId, compte le nb d'ocurrences de tarages
balance_tarees_gb_df <- data.frame(table(balea_data_tarees$BalanceId))
colnames(balance_tarees_gb_df) = c("BalanceId", "NbTarages")


# enlève les utilisations de balances qui n'ont pas nécessité de forcage
balea_data_forcage <- balea_data %>% filter(FlagWeightOverriden ==  1)
# pour chaque BalanceId, compte le nb d'ocurrences de tarages
balance_forcage_gb_df <- data.frame(table(balea_data_forcage$BalanceId))
colnames(balance_forcage_gb_df) = c("BalanceId", "NbForcages")


# pour chaque BalanceId, compte le nb d'ocurrences d'utilisations
balances <- data.frame(table(balea_data$BalanceId))
colnames(balances) = c("BalanceId", "NbUtilisations")

# join des dataframes des balances et balances tarées sur le BalanceId
balances <- merge(x = balances, y = balance_tarees_gb_df, by = "BalanceId")
balances <- merge(x = balances, y = balance_forcage_gb_df, by = "BalanceId")

# ajout colonne RatioTarage
balances$RatioTarage = 100*balances$NbTarages/balances$NbUtilisations
# ajout colonne RatioForcage
balances$RatioForcage = 100*balances$NbForcages/balances$NbUtilisations
# conversion des BalanceIDs en string
balances$BalanceId = as.character(balances$BalanceId)

### = = = = Quantile sur ratio tarage = = = = = ###
#balances_seuil_tarage <- balances %>% filter(RatioTarage >= 8)

# seq : on va de 0 à 1 par écarts de 1/10
probs_q_t <- seq(0, 1, 1/20)
values_q_t <- quantile(balances$RatioTarage, probs = probs_q_t)
balances_tarage_quantiles <- data.frame(Quantile = probs_q_t, RatioTarage = values_q_t)
print(balances_tarage_quantiles)

plot_q_t <- ggplot(balances_tarage_quantiles) +
  geom_line(aes(x = balances_tarage_quantiles$Quantile, y = balances_tarage_quantiles$RatioTarage))
plot_q_t


### = = = = Quantile sur ratio tarage = = = = = ###
#balances_seuil_tarage <- balances %>% filter(RatioTarage >= 8)

# seq : on va de 0 à 1 par écarts de 1/10
probs_q_f <- seq(0, 1, 1/20)
values_q_f <- quantile(balances$RatioForcage, probs = probs_q_f)
balances_forcage_quantiles <- data.frame(Quantile = probs_q_f, RatioForcage = values_q_f)
print(balances_forcage_quantiles)

plot_q_f <- ggplot(balances_forcage_quantiles) +
  geom_line(aes(x = balances_forcage_quantiles$Quantile, y = balances_forcage_quantiles$RatioForcage))
plot_q_f


### = = = = Plot pour une balance = = = = ###
# On ne garde que notre balance (TODO Modifier numBalance pour le connecter au front)
# On part du principe qu'on a déjà lancé le fichier classification.R 
# pour avoir toutes les modifications sur le tableau de base
numBalance <- "66"
balance <- balea_data %>% filter(balea_data$BalanceId == numBalance)
balance <- balance[c("BalanceId", "PickingDate", "TARException", "FlagWeightOverriden", "WeightRatioErreur")]
balance <- balance[order(balance$PickingDate),]
balance$TARSum = cumsum(balance$TARException)
balance$FORCSum = cumsum(balance$FlagWeightOverriden)
balance$NumUtilisation = seq.int(nrow(balance)) 
balance$ErrorSup5 <- with(balance, ifelse(WeightRatioErreur >= 5, 1, 0))
balance$ERRORSum = cumsum(balance$ErrorSup5)

plot_tarage_balance <- ggplot(balance) +
  geom_line(aes(x = NumUtilisation, y = TARSum)) + 
  ylab(paste("Somme du nombre de tarages balance ", numBalance)) + 
  xlab("Nombre d'utilisation")
plot_forcage_balance <- ggplot(balance) +
  geom_line(aes(x = NumUtilisation, y = FORCSum)) + 
  ylab(paste("Somme du nombre de forçages balance ", numBalance)) + 
  xlab("Nombre d'utilisation")
plot_erreur_5 <- ggplot(balance) +
  geom_line(aes(x = NumUtilisation, y = ERRORSum)) + 
  ylab(paste("Somme du nombre d'erreur supérieur à 5% balance ", numBalance)) + 
  xlab("Nombre d'utilisation")

plot_tarage_balance
plot_forcage_balance
plot_erreur_5


### = = = = ACP = = = = ###

acp_nb <- PCA(balances[,2:4], quali.sup = ,1)

acp_ratios <- PCA(balances[,5:6])

acp_nb_aff_ind <- fviz_pca_ind(acp_nb,
                       col.ind = "cos2", 
                       gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                       repel = TRUE     
)
acp_nb_aff_var <- fviz_pca_var(acp_nb,
                               col.var = "contrib", 
                               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                               repel = TRUE     
)

acp_ratios <- PCA(balances[,5:6])
acp_ratios_aff_ind <- fviz_pca_ind(acp_ratios,
                           col.ind = "cos2", 
                           gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                           repel = TRUE     
)
acp_ratios_aff_var <- fviz_pca_var(acp_ratios,
                               col.var = "contrib", 
                               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                               repel = TRUE     
)



