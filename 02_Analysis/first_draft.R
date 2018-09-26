
#' Imports required libraries. Installs them if required
packages <- c("readr", "devtools","stringr", "tidyr", "tidytext","devtools","dplyr","rstudioapi","gutenbergr","tm","topicmodels")
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


#' read_book: imports books from the Gutenberg project
#'
#' @param link Link to the book
#' @param skip_init_lines Number of initial lines to skip (depends on the book)
#' @param skip_final_lines Number of final lines to omit (most of the times it's the same)
#'
#' @return book: A tibble containing the book
#' @export
#'
#' @examples link_adventures <- "https://ia800501.us.archive.org/27/items/theadventuresofs01661gut/pg1661.txt"
#'skip_init_lines <- 57 
#'skip_final_lines <- 364
#'read_book(link_adventures,skip_init_lines,skip_final_lines)
read_book <- function(link, skip_init_lines = 30,skip_final_lines = 364){
  book <- read_lines(link, skip = skip_init_lines) %>% 
    .[1:(length(.)-skip_final_lines)] %>% #Drops the final lines of the book
    na.omit()
  return(book)
}


#' tidy_book: Returns a book in tidy format, i.e. one row per word, one column per variable. Stop words are removed
#'
#' @param book A tibble containing the book
#' @param chapter_regex A regex to identify changes in chapter
#'
#' @return tidied_book: A book in tidy format
#' @export
#'
#' @examples chapter_regex <- "^ADVENTURE"
#' tidy_book(book, chapter_regex)
tidy_book <- function(book,chapter_regex){
  tidied_book <- book %>% 
    data_frame(text=.) %>% 
    {if(chapter_regex != "") mutate(.,chapter = cumsum(str_detect(.$text, regex(chapter_regex,ignore_case = TRUE)))) else .} %>% 
    mutate(linenumber = row_number()) %>% 
    unnest_tokens(word,text) %>% 
    anti_join(stop_words)
  return(tidied_book)
}


#' add_sentiments: Adds a column of sentiments to a tidy book
#'
#' @param tidy_book A book in tidy format
#' @param sentiment_dict A dictionary for sentiment analysis
#'
#' @return sentiment_book: A book in tidy format with a column for sentiments
#' @export 
#'
#' @examples sentiment_dict <- "nrc"
#' add_sentiments(tidy_book,sentiment_dict)
add_sentiments <- function(tidy_book,sentiment_dict){
  sentiments <- get_sentiments(sentiment_dict)
  sentiment_book <- tidy_book %>% 
  left_join(sentiments)
  return(sentiment_book)
}

#' process_book Imports a book, tidies it, includes sentiments and saves a csv version
#'
#' @param link_adventures Link to the book 
#' @param skip_init_lines Number of initial lines to skip (depends on the book)
#' @param skip_final_lines Number of final lines to omit (most of the times it's the same)
#' @param chapter_regex A regex to identify changes in chapter
#' @param sentiment_dict A dictionary for sentiment analysis
#' @param name An alias for the final csv file
#'
#' @return processed_book: A processed book
#' @export processed_book A csv file conatining the processed book
#'
#' @examples name <- "adventures_sherlock"
#'link_adventures <- "https://ia800501.us.archive.org/27/items/theadventuresofs01661gut/pg1661.txt"
#'skip_init_lines <- 57 
#'skip_final_lines <- 364
#'chapter_regex <- "^ADVENTURE" 
#'sentiment_dict <- "nrc"
#'processed_adventures <- process_book(link_adventures, skip_init_lines, skip_final_lines, chapter_regex, sentiment_dict, name)

process_book <- function(link_adventures, skip_init_lines, skip_final_lines, chapter_regex, sentiment_dict, name){
  processed_book <- read_book(link_adventures, skip_init_lines,skip_final_lines) %>% 
    tidy_book(chapter_regex) %>% 
    add_sentiments(sentiment_dict) 
  write.csv(processed_book,file = paste(getwd(),"/Books/",name,".csv",sep=""))
  return(processed_book)
}
  
#### Examples

name <- "adventures_sherlock"
link_adventures <- "https://ia800501.us.archive.org/27/items/theadventuresofs01661gut/pg1661.txt"
skip_init_lines <- 57 
skip_final_lines <- 364
chapter_regex <- "^ADVENTURE" 
sentiment_dict <- "nrc"
processed_adventures <- process_book(link_adventures, skip_init_lines, skip_final_lines, chapter_regex, sentiment_dict, name)


name <- "flatland"
link_flatland <- "http://www.gutenberg.org/cache/epub/97/pg97.txt"
chapter_regex <- "^SECTION"
skip_init_lines <- 60 
processed_flatland <- process_book(link_flatland, skip_init_lines, skip_final_lines, chapter_regex, sentiment_dict, name)

name <- "kant"
link_kant <- "https://www.gutenberg.org/files/4280/4280-0.txt"
skip_init_lines <- 2000
chapter_regex <- ""
processed_kant <- process_book(link_kant, skip_init_lines, skip_final_lines, chapter_regex, sentiment_dict, name)

name <- "kafka"
link_kafka <- "http://www.gutenberg.org/cache/epub/5200/pg5200.txt"
skip_init_lines <- 43
chapter_regex <- ""
processed_kant <- process_book(link_kafka, skip_init_lines, skip_final_lines, chapter_regex, sentiment_dict, name)


titles <- c("The Adventures of Sherlock Holmes",
            "The Return of Sherlock Holmes",
            "Flatland: A Romance of Many Dimensions",
            "The Critique of Pure Reason",
            "Around the World in Eighty Days",
            "Don Quixote")

books <- gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title")
reg <- regex("^chapter ", ignore_case = TRUE)
by_chapter <- books %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, reg))) %>%
  ungroup() %>%
  filter(chapter > 0) %>%
  unite(document, title, chapter)
by_chapter_word <- by_chapter %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words)

word_counts <- by_chapter_word %>% 
  count(document, word, sort = TRUE) %>% 
  ungroup()

chapters_dtm <- word_counts %>%
  cast_dtm(document, word, n)

chapters_lda <- LDA(chapters_dtm, k = 10, control = list(seed = 1234))

chapter_topics <- tidy(chapters_lda, matrix = "beta")

top_terms <- chapter_topics %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>%
  mutate(term = reorder(term, beta)) %>% 
  ggplot(aes(term, beta, fill = factor(topic))) + geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") + coord_flip()

assignments <- augment(chapters_lda, data = chapters_dtm) %>% 
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE) %>% 
  rename(word = term, freq_chapter = count)
  
final <- by_chapter_word %>% 
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE) %>% 
  left_join(assignments) %>% 
  group_by(title,word) %>% 
  mutate(freq_book = n()) %>% 
  ungroup()

sentiment_dict <- "nrc"
final_with_sentiments <- add_sentiments(final,sentiment_dict)
write.csv(final_with_sentiments,file = paste(getwd(),"/Books/","with_sentiments_topics",".csv",sep=""))

final_with_sent_clean <- final_with_sentiments %>% 
  filter(!is.na(sentiment))
write.csv(final_with_sent_clean,file = paste(getwd(),"/Books/","with_sentiments_topics_clean",".csv",sep=""))

devtools::install_github("bnosac/RDRPOSTagger")
library("RDRPOSTagger")

unipostag_types <- c("ADJ" = "adjective", "ADP" = "adposition", "ADV" = "adverb", "AUX" = "auxiliary", "CONJ" = "coordinating conjunction", "DET" = "determiner", "INTJ" = "interjection", "NOUN" = "noun", "NUM" = "numeral", "PART" = "particle", "PRON" = "pronoun", "PROPN" = "proper noun", "PUNCT" = "punctuation", "SCONJ" = "subordinating conjunction", "SYM" = "symbol", "VERB" = "verb", "X" = "other")
unipostagger <- rdr_model(language = "English", annotation = "UniversalPOS")
unipostags <- rdr_pos(unipostagger, tidied_book$word)
#adventures <- read_book(link_adventures, skip_init_lines,skip_final_lines)
#tidied_book <- tidy_book(adventures, chapter_regex)
#sentiment_book <- add_sentiments(tidy_book,sentiment_dict)

unique(final$gutenberg_id)





