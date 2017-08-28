options(digits=3)
# clean slate
rm(list=ls())


# path <- "~/Dropbox/GuoMaWang/Stocks_and_regime_support"
pkg <- c("foreign", "tm", "stm", "topicmodels", 
         "jiebaR", "ggplot2", "dplyr", "stringr", 
         "reshape2", "data.table", "slam", "wordcloud", "LDAvis", "quanteda")
lapply(pkg, require, character.only = TRUE)

setwd("/scratch/qg251/webscraping_guba")
load("dtm_0626_0704.RData")

# 30 topics
load("lda30.0626.0704.RData")

topics30 <- get_terms(lda30[["Gibbs"]], 100)
topic_proportion_30 <- lda30[["Gibbs"]]@gamma

# 50 topics
load("lda50.0626.0704.RData")

topics50 <- get_terms(lda50[["Gibbs"]], 50)
topic_proportion_50 <- lda50[["Gibbs"]]@gamma


# 100 topics
load("lda100.0626.0704.RData")

topics100 <- get_terms(lda100[["Gibbs"]], 50)
topic_proportion_100 <- lda100[["Gibbs"]]@gamma


# wordclould for all these days
# png("sample_wc.png")
# wordcloud(corpus, scale=c(5,0.5), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
# dev.off()

m <- as.matrix(dtm)

json30 <- createJSON(phi = posterior(lda30[["Gibbs"]])$terms,
                   theta = posterior(lda30[["Gibbs"]])$topics,
                   doc.length = rowSums(m),
                   vocab = colnames(posterior(lda30[["Gibbs"]])$terms),
                   term.frequency = colSums(m))
serVis(json30, out.dir = 'vis')


json50 <- createJSON(phi = posterior(lda50[["Gibbs"]])$terms,
                     theta = posterior(lda50[["Gibbs"]])$topics,
                     doc.length = rowSums(m),
                     vocab = colnames(posterior(lda50[["Gibbs"]])$terms),
                     term.frequency = colSums(m))
serVis(json50, out.dir = 'vis')


