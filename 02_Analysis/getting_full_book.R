packages <- c("readr", "devtools","stringr", "tidyr", "tidytext","devtools","dplyr","rstudioapi","gutenbergr","tm","topicmodels","tokenizers","RDRPOSTagger","ggplot2")
for(i in packages) {
  if(!require(i,character.only = TRUE)) install.packages(i)
  library(i,character.only = TRUE)
}
rm(packages, i)

#' Sets working directory
set_wd <- function() {
  #library(rstudioapi) # make sure you have it installed
  current_path <- getActiveDocumentContext()$path
  setwd(dirname(current_path ))
  print( getwd() )
}
set_wd()

titles <- c("The Critique of Pure Reason",
            "Around the World in Eighty Days",
            "Don Quixote")

##"The Adventures of Sherlock Holmes",
##"The Return of Sherlock Holmes",
##"Flatland: A Romance of Many Dimensions",

#'Reads books by name
books <- gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title")

new_books <- books %>%
  mutate(line=row_number(),word = strsplit(text,"(?=[[:space:]]+|[[:punct:]]+|[[:digit:]]+)",perl=TRUE)) %>%
  unnest(word) %>%
  mutate(id=row_number()) %>%
  group_by(line) %>%
  mutate(id_in_line=row_number()) %>%
  ungroup()


sentiment_dict <- "nrc"
sentiments_bin <- get_sentiments(sentiment_dict) %>%
  filter(sentiment %in% c("negative","positive")) %>%
  group_by(word) %>%
  summarise(sentiment_bin = paste(sentiment, collapse = ","))
sentiments <- get_sentiments(sentiment_dict) %>%
  filter(!(sentiment %in% c("negative","positive"))) %>%
  group_by(word) %>%
  summarise(sentiment = paste(sentiment, collapse = ","))

sentiment_books <- new_books %>%
  left_join(sentiments_bin,c("word")) %>%
  left_join(sentiments,c("word"))

write.csv(sentiment_books %>% filter(gutenberg_id == 103),file = paste(getwd(),"/Books/","around_the_world_full",".csv",sep=""))

#https://www.r-bloggers.com/strsplit-but-keeping-the-delimiter/  lookahead regex
#This regex allows to split every element of a sentence.
strsplit(books[150,2][[1]],"(?=[[:space:]]+|[[:punct:]]+|[[:digit:]]+)",perl=TRUE)
