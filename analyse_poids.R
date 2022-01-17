# = = = == = =  Pourcentage de mesures à + de 5% d'erreur = = = = = = = ##

balances_erreur_5 <- balea_data %>% filter(balea_data$WeightRatioErreur >= 5)

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
acp_poids_aff_ind <- fviz_pca_ind(acp_nb,
                                   col.ind = "cos2", 
                                   gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                                   repel = TRUE)

acp_poids_aff_var <- fviz_pca_var(acp_nb,
                                   col.var = "contrib", 
                                   gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                                   repel = TRUE)
