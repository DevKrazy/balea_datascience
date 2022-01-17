## = = = = = ACP = = = = = ##

#acp_nb <- PCA(balances[c(2, 4)])



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
