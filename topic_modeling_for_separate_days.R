options(digits=3)
# clean slate
rm(list=ls())


# path <- "~/Dropbox/GuoMaWang/Stocks_and_regime_support"
pkg <- c("foreign", "tm", "stm", "topicmodels", 
         "jiebaR", "ggplot2", "dplyr", "stringr", 
         "reshape2", "data.table", "slam")
lapply(pkg, require, character.only = TRUE)

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
obtain_content <- function(x){
  load(x)
  cps <- corpus
  cps <- tm_map(cps, removeNumbers)
  content <- cps[[1]]$content
  return(content)
}

corpora_name <- c("corpus_0626.RData", "corpus_0627.RData", "corpus_0628.RData", "corpus_0629.RData", "corpus_0630.RData",
  "corpus_0701.RData", "corpus_0702.RData", "corpus_0703.RData", "corpus_0704.RData")

content_0626_0704 <- unlist(lapply(corpora_name, obtain_content))

corpus_0626_0704 <- Corpus(VectorSource(content_0626_0704))

dtm <- DocumentTermMatrix(corpus_0626_0704, control = list(weighting = weightTf, language = "cn", bounds = list(global = c(5,Inf))))
term_tfidf <- tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(nDocs(dtm)/col_sums(dtm > 0))
summary(term_tfidf)

hist(term_tfidf, breaks = 200)
dtm <- dtm[, term_tfidf > quantile(term_tfidf, probs = 0.75)]

save(dtm, file = "dtm_0626_0704.RData")

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

# run topic model, set number of topics 30
control = list(seed = 2016, burnin = 5000, thin = 10, iter = 5000)
lda30 <- list(Gibbs = LDA(dtm, 30, method = "Gibbs", control = control))
save(lda30, file = "lda30.0626.0704.RData")

# load("lda30.0626.0704.RData")

topics30 <- get_terms(lda30[["Gibbs"]], 50)
write.csv(topics30, file = "topic30_0626_0704.csv")

topic_proportion_30 <- lda30[["Gibbs"]]@gamma
write.csv(topic_proportion_30, file = "topic_proportion30_0626_0704.csv")


# run topic model, set number of topics 50
control = list(seed = 2016, burnin = 5000, thin = 10, iter = 5000)
lda50 <- list(Gibbs = LDA(dtm, 50, method = "Gibbs", control = control))
save(lda50, file = "lda50.0626.0704.RData")

topics50 <- get_terms(lda50[["Gibbs"]], 50)
write.csv(topics50, file = "topic50_0626_0704.csv")

topic_proportion_50 <- lda50[["Gibbs"]]@gamma
write.csv(topic_proportion_50, file = "topic_proportion50_0626_0704.csv")




# wordclould for all these days
# png("sample_wc.png")
# wordcloud(corpus, scale=c(5,0.5), max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
# dev.off()

