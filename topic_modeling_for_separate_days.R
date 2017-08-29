options(digits=3)
# clean slate
rm(list=ls())

# path <- "~/Dropbox/GuoMaWang/Stocks_and_regime_support"
pkg <- c("methods", "foreign", "tm", "stm", "topicmodels", 
         "jiebaR", "ggplot2", "dplyr", "stringr", "quanteda",
         "reshape2", "data.table", "slam", "wordcloud")
lapply(pkg, require, character.only = TRUE)

sessionInfo()

# setwd(paste0(path, "/Text_analysis"))

# read data
# txt_2015_0626 <- read.csv("txt_2015_06_26.csv")
# txt_2015_0627 <- read.csv("txt_2015_06_27.csv")
# txt_2015_0628 <- read.csv("txt_2015_06_28.csv")
# txt_2015_0629 <- read.csv("txt_2015_06_29.csv")
# txt_2015_0630 <- read.csv("txt_2015_06_30.csv")
# txt_2015_0701 <- read.csv("txt_2015_07_01.csv")
# txt_2015_0702 <- read.csv("txt_2015_07_02.csv")
# txt_2015_0703 <- read.csv("txt_2015_07_03.csv")
# txt_2015_0704 <- read.csv("txt_2015_07_04.csv")
# 
# cutter <- worker(bylines = F, stop_word = "stopwords.txt")
# 
# txt <- rbind(txt_2015_0626, txt_2015_0627, txt_2015_0628, txt_2015_0629, txt_2015_0630, txt_2015_0701, txt_2015_0702, txt_2015_0703, txt_2015_0704)
# 
# 
# # sample_txt <- sample_frac(txt, 0.005)
# sample_txt <- txt
# 
# txt_date <- subset(sample_txt, select = c("post_date", "text", "stockid"))
# # require(reshape2)
# # txt_by_date <- melt(txt_date, id = c("post_date", "stockid"))
# 
# # aggregate by both post_date and stockid
# txt_by_date <- aggregate(text ~ post_date, data = txt_date, FUN = paste, collapse = "")
# # head(txt_by_date) 
# 
# # revise date format
# txt_by_date$post_date <- as.Date(as.character(txt_by_date$post_date))
# 
# 
# # remove certain things in the text
# txt_by_date <- data.frame(apply(txt_by_date,2,function(x) gsub('\\s+', '',x)), stringsAsFactors=FALSE)
# 
# # txt_date <- subset(sample_txt, select = c("text"))
# # 
# # txt_by_date <- paste(txt_date$text, collapse = "")
# # 
# # txt_by_date <- unlist(lapply(txt_by_date, function(x) gsub('\\s+', '',x)))
# 
# # use NLP driver cutter[] to tokenize
# document <- unlist(lapply(txt_by_date$text, function(x) str_c(cbind(cutter[x]), collapse = " ")))
# 
# corpus <- Corpus(VectorSource(document))
# save(corpus, file = "corpus_0626_0704_sample.RData")
# load("corpus_0626_0704_sample.RData")
# create a document term matrix


# load corpora
setwd("/scratch/qg251/webscraping_guba")
# obtain_content <- function(x){
#   load(x)
#   cps <- Corpus(VectorSource(corpus))
#   cps <- tm::tm_map(cps, content_transformer(removeNumbers))
#   content <- cps[[1]]$content
#   return(content)
# }
# 
# corpora_name <- c("corpus_0626.RData", "corpus_0627.RData", "corpus_0628.RData", "corpus_0629.RData", "corpus_0630.RData",
#   "corpus_0701.RData", "corpus_0702.RData", "corpus_0703.RData", "corpus_0704.RData")
# 
# content_0626_0704 <- unlist(lapply(corpora_name, obtain_content))
# 
# corpus_0626_0704 <- corpus(content_0626_0704)
# summary(corpus_0626_0704)
# 
# tks_0626_0704 <- tokens(corpus_0626_0704, what = "fastestword", remove_numbers = T,  remove_punct = T)
# save(tks_0626_0704, file = "tks_0626_0704.RData")

# load("tks_0626_0704.RData")
# dfm_0626_0704 <- dfm(tks_0626_0704, stem = TRUE)
# class(dfm_0626_0704)
# 
# docvars(dfm_0626_0704, "Date") <- seq(as.Date("2015/06/26"), as.Date("2015/07/04"), "day")
# 
# save(dfm_0626_0704, file = "dfm_0626_0704.RData")

load("dfm_0626_0704.RData")
topfeatures(dfm_0626_0704, 20) 

png("word_cloud_all_documents.png")
textplot_wordcloud(dfm_0626_0704, min.freq = 4000, random.order = FALSE,
                   rot.per = .25, comparison = F,
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))
dev.off()


dfm_trimed_100_4 <- dfm_trim(dfm_0626_0704, min_count = 100, min_docfreq = 4)
save(dfm_trimed_100_4, file = "dfm_trimed_100_4.RData")
load("dfm_trimed_100_4.RData")

ntoken(dfm_trimed_100_4)

dfm_trimed_200_4 <- dfm_trim(dfm_0626_0704, min_count = 200, min_docfreq = 4)
save(dfm_trimed_200_4, file = "dfm_trimed_200_4.RData")
load("dfm_trimed_200_4.RData")

ntoken(dfm_trimed_200_4)

dfm_trimed_500_4 <- dfm_trim(dfm_0626_0704, min_count = 500, min_docfreq = 4)
save(dfm_trimed_500_4, file = "dfm_trimed_500_4.RData")
load("dfm_trimed_500_4.RData")

ntoken(dfm_trimed_500_4)

# 
# dtm <- DocumentTermMatrix(corpus_0626_0704, control = list(weighting = weightTf, language = "cn", bounds = list(global = c(5,Inf))))
# term_tfidf <- tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(nDocs(dtm)/col_sums(dtm > 0))
# summary(term_tfidf)
# 
# hist(term_tfidf, breaks = 200)
# dtm <- dtm[, term_tfidf > quantile(term_tfidf, probs = 0.75)]
# 
# save(dtm, file = "dtm_0626_0704.RData")

# remove stop words
# conn <- file("stopwords.txt",open="r")
# lines <- readLines(conn, encoding = "UTF-8")
# stopwords.list <- unlist(lapply(lines, function(x) gsub(" ","", x)))
# 
# # very crude!
# stopwords.list[length(stopwords.list) + 1] <- "浦发" 
# 
# new.doc <- lapply(document, function (x) gsub("浦发银行","", x))
# 
# # note that the above two lines are unncessary because in the loop
# # below we are going to loop through every word in the 
# # stopwords.list
# 
# # begin the recursive loop
# for (i in 1:length(stopwords.list)) {
#   new.doc <-  lapply(new.doc, function (x) gsub(stopwords.list[i],"", x))
# }

# create a Corpus
# corpus <- Corpus(VectorSource(document))
# dtm <- DocumentTermMatrix(corpus, control = list(weighting = weightTfIdf, language = "cn", bounds = list(global = c(2,Inf))))

# setwd("/scratch/qg251/webscraping_guba")
# load("dtm_0626_0704.RData")

# run topic model, set number of topics 30
control = list(seed = 2016, burnin = 5000, thin = 10, iter = 10000)

lda30_100_4 <- list(Gibbs = LDA(dfm_trimed_100_4, 30, method = "Gibbs", control = control))
save(lda30_100_4, file = "lda30_100_4.RData")

lda30_200_4 <- list(Gibbs = LDA(dfm_trimed_200_4, 30, method = "Gibbs", control = control))
save(lda30_200_4, file = "lda30_200_4.RData")

lda30_500_4 <- list(Gibbs = LDA(dfm_trimed_500_4, 30, method = "Gibbs", control = control))
save(lda30_500_4, file = "lda30_500_4.RData")


# topics30_100_4 <- get_terms(lda30_100_4[["Gibbs"]], 50)
# write.csv(topics30, file = "topic30_0626_0704.csv")
# 
# topic_proportion_30 <- lda30[["Gibbs"]]@gamma
# write.csv(topic_proportion_30, file = "topic_proportion30_0626_0704.csv")


# run topic model, set number of topics 50
lda50_100_4 <- list(Gibbs = LDA(dfm_trimed_100_4, 50, method = "Gibbs", control = control))
save(lda50_100_4, file = "lda50_100_4.RData")

lda50_200_4 <- list(Gibbs = LDA(dfm_trimed_200_4, 50, method = "Gibbs", control = control))
save(lda50_200_4, file = "lda50_200_4.RData")

lda50_500_4 <- list(Gibbs = LDA(dfm_trimed_500_4, 50, method = "Gibbs", control = control))
save(lda50_500_4, file = "lda50_500_4.RData")


# run topic model, set number of topics 100
lda100_100_4 <- list(Gibbs = LDA(dfm_trimed_100_4, 100, method = "Gibbs", control = control))
save(lda100_100_4, file = "lda100_100_4.RData")

lda100_200_4 <- list(Gibbs = LDA(dfm_trimed_200_4, 100, method = "Gibbs", control = control))
save(lda100_200_4, file = "lda100_200_4.RData")

lda100_500_4 <- list(Gibbs = LDA(dfm_trimed_500_4, 100, method = "Gibbs", control = control))
save(lda100_500_4, file = "lda100_500_4.RData")


# wordclould for all these days
# png("sample_wc.png")
# wordcloud(corpus, scale=c(5,0.5), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
# dev.off()



