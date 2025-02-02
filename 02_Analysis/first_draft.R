
#' Imports required libraries. Installs them if required
packages <- c("readr", "devtools","stringr", "tidyr", "tidytext","devtools","dplyr","gutenbergr","tm","topicmodels","tokenizers","RDRPOSTagger","ggplot2","rstudioapi")
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
  sentiments <- get_sentiments(sentiment_dict) %>%
    filter(!(sentiment %in% c("negative","positive")))
  sentiment_book <- tidy_book %>%
  inner_join(sentiments)
  return(sentiment_book)
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
add_sentiments_bin <- function(tidy_book,sentiment_dict){
  sentiments <- get_sentiments(sentiment_dict) %>%
    filter(sentiment %in% c("negative","positive"))
  sentiment_book <- tidy_book %>%
    inner_join(sentiments,c("word"))
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


titles <- c("The Critique of Pure Reason",
            "Around the World in Eighty Days",
            "Don Quixote")

##"The Adventures of Sherlock Holmes",
##"The Return of Sherlock Holmes",
##"Flatland: A Romance of Many Dimensions",

#'Reads books by name
books <- gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title")

#'What books do we have?
unique(books[c("gutenberg_id","title")])
#gutenberg_id title
#
# 103 Around the World in Eighty Days
# 996 Don Quixote
# 4280 The Critique of Pure Reason

#'Regex to detect chapter
reg <- regex("^chapter ", ignore_case = TRUE)

#'Subdivides in chapters
by_chapter <- books %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, reg))) %>%
  ungroup() %>%
  filter(chapter > 0) %>%
  unite(document, title, chapter)

by_chapter_word <- by_chapter %>%
  unnest_tokens(word, text) %>%
  mutate(token_id = row_number()) %>%
  anti_join(stop_words) %>%
  add_sentiments(sentiment_dict) %>%
  add_sentiments_bin(sentiment_dict) %>%
  rename(sentiment = sentiment.x, sentiment_bin = sentiment.y)#Will give more weight to words with more sentiments
  #count(document, word, sort = FALSE) %>%
  #ungroup()# %>%


word_counts <- by_chapter_word %>%
  count(document, word) %>%
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
  left_join(word_counts) %>%
  rename(freq_chapter = n) %>%
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE) %>%
  left_join(assignments) %>%
  group_by(title,word) %>%
  mutate(freq_book = n()) %>%
  ungroup()

final_around <- final %>% filter(gutenberg_id == 103)
write.csv(final_around,file = paste(getwd(),"/Books/","around_with_sentiments_topics",".csv",sep=""))

final_quixote <- final %>% filter(gutenberg_id == 996)
write.csv(final_quixote,file = paste(getwd(),"/Books/","quixote_with_sentiments_topics",".csv",sep=""))

final_reason <- final %>% filter(gutenberg_id == 4280)
write.csv(final_reason,file = paste(getwd(),"/Books/","reason_with_sentiments_topics",".csv",sep=""))



sentiment_dict <- "nrc"
final_with_sentiments <- add_sentiments(final,sentiment_dict)
write.csv(final_with_sentiments,file = paste(getwd(),"/Books/","with_sentiments_topics",".csv",sep=""))

final_with_sent_clean <- final_with_sentiments %>%
  filter(!is.na(sentiment))
write.csv(final_with_sent_clean,file = paste(getwd(),"/Books/","with_sentiments_topics_clean",".csv",sep=""))

devtools::install_github("bnosac/RDRPOSTagger")
library("RDRPOSTagger")


#' POS_tagging Part of speech tagging for a given book
#'
#' @param book A book separated by lines
#' @param name Name for the csv file
#'
#' @return tags A dataframe containing the POS tag for each token in the original text
#' @export tags A csv version of the tags dataframe
#'
#' @examples
pos_tagging <- function(book){
  #reg <- regex("^chapter ", ignore_case = TRUE)
  unipostag_types <- c("ADJ" = "adjective", "ADP" = "adposition", "ADV" = "adverb", "AUX" = "auxiliary", "CONJ" = "coordinating conjunction", "DET" = "determiner", "INTJ" = "interjection", "NOUN" = "noun", "NUM" = "numeral", "PART" = "particle", "PRON" = "pronoun", "PROPN" = "proper noun", "PUNCT" = "punctuation", "SCONJ" = "subordinating conjunction", "SYM" = "symbol", "VERB" = "verb", "X" = "other")
  unipostagger <- rdr_model(language = "English", annotation = "UniversalPOS")
  reg <- regex("^chapter ", ignore_case = TRUE)
  tags <- book %>%
    #paste(.$text, collapse = " ") %>%
    #tokenize_sentences(simplify = TRUE) #%>%
    {if(reg != "") mutate(.,chapter = cumsum(str_detect(.$text, regex(reg,ignore_case = TRUE)))) else .} %>%
    #mutate(linenumber = row_number()) #%>%
    group_by_at(vars(-text)) %>%
    summarise(text = paste(text, collapse = " ")) %>%
    filter(chapter != 0,!is.na(text)) %>%
    unnest_tokens(word,text,token = "sentences") %>%
    ungroup() %>%
    group_by_at(vars(-word)) %>%
    do(rdr_pos(unipostagger,.$word)) %>% #summarise used the full
    ungroup() %>%
    mutate(pos=unipostag_types[pos])
    #filter(!is.na(pos))

  write.csv(tags,file = paste(getwd(),"/Books/",deparse(substitute(book)),"_pos.csv",sep=""))
  return(tags)
}
#Tagging: 103 Around the World in Eighty Days
around_the_world <- books[books$gutenberg_id == 103,]
around_tags <- pos_tagging(around_the_world)
around_joined <- around_tags %>%
  select(-c(doc_id,token_id)) %>%
  rename(word = token) %>%
  left_join(final_around)
write.csv(around_joined,file = paste(getwd(),"/Books/final_around_the_world.csv",sep=""))


quixote <- books[books$gutenberg_id == 996,]
quixote_tags <- pos_tagging(quixote)

reason <- books[books$gutenberg_id == 4280,]
reason_tags <- pos_tagging(reason)


reg <- regex("^chapter ", ignore_case = TRUE)
tidied_book <- around_the_world %>%
  #paste(.$text, collapse = " ") %>%
  #tokenize_sentences(simplify = TRUE) #%>%
  {if(reg != "") mutate(.,chapter = cumsum(str_detect(.$text, regex(reg,ignore_case = TRUE)))) else .} %>%
  #mutate(linenumber = row_number()) #%>%
  group_by_at(vars(-text)) %>%
  summarise(text = paste(text, collapse = " ")) %>%
  filter(chapter != 0,!is.na(text)) %>%
  unnest_tokens(word,text,token = "sentences") %>%
  ungroup() #%>%
final <- tidied_book %>%
  filter(chapter <= 2)  %>%
  group_by_at(vars(-word)) %>%
  do(rdr_pos(unipostagger,.$word)) %>%
  ungroup() %>%
  mutate(pos=unipostag_types[pos]) %>%
  filter(!is.na(pos))

final$pos <- unipostag_types[final$pos]

###Current Test
unipostag_types <- c("ADJ" = "adjective", "ADP" = "adposition", "ADV" = "adverb", "AUX" = "auxiliary", "CONJ" = "coordinating conjunction", "DET" = "determiner", "INTJ" = "interjection", "NOUN" = "noun", "NUM" = "numeral", "PART" = "particle", "PRON" = "pronoun", "PROPN" = "proper noun", "PUNCT" = "punctuation", "SCONJ" = "subordinating conjunction", "SYM" = "symbol", "VERB" = "verb", "X" = "other")
unipostagger <- rdr_model(language = "English", annotation = "UniversalPOS")
test <- around_the_world %>%
  {if(reg != "") mutate(.,chapter = cumsum(str_detect(.$text, regex(reg,ignore_case = TRUE)))) else .} %>%
  mutate(linenumber = row_number()) %>%
  filter(chapter != 0,!is.na(text),text != "") %>%
  unnest_tokens(word,text,token = "sentences") %>%
  ungroup() %>%
  filter(chapter == 3) %>% print(n = Inf) #%>%
  group_by_at(vars(-word)) %>%
  do(rdr_pos(unipostagger,.$word)) %>%
  ungroup() %>%
  mutate(pos=unipostag_types[pos]) %>%
  select(-c(doc_id,token_id))

a <- tokenize_sentences(tidied_book$full_text[2],simplify = TRUE)




unipostag_types <- c("ADJ" = "adjective", "ADP" = "adposition", "ADV" = "adverb", "AUX" = "auxiliary", "CONJ" = "coordinating conjunction", "DET" = "determiner", "INTJ" = "interjection", "NOUN" = "noun", "NUM" = "numeral", "PART" = "particle", "PRON" = "pronoun", "PROPN" = "proper noun", "PUNCT" = "punctuation", "SCONJ" = "subordinating conjunction", "SYM" = "symbol", "VERB" = "verb", "X" = "other")
unipostagger <- rdr_model(language = "English", annotation = "UniversalPOS")
unipostags <- rdr_pos(unipostagger, tidied_book$word)
unipostags$pos <- unipostag_types[unipostags$pos]

write.csv(unipostags %>% filter(!is.na(pos)),file = paste(getwd(),"/Books/","adventures_pos",".csv",sep=""))
#adventures <- read_book(link_adventures, skip_init_lines,skip_final_lines)
#tidied_book <- tidy_book(adventures, chapter_regex)
#sentiment_book <- add_sentiments(tidy_book,sentiment_dict)

unique(final$gutenberg_id)

assign("last.warning", NULL, envir = baseenv())

###DB connnection

library(DBI)
library(RPostgres)
#' An R rds connection
#'
#' This function allows you to create a connection between R and rds given an appropriate
#' keys file. Connection created with the package RPostgres.
#' @param jsonFile File name of the file containing the keys. Defaults to ''.
#' @keywords rds, rs
#' @return A rds connection.
#' @export
#' @examples
#' create_rs_connection('~/keys/envs.json')
create_rs_connection <- function(json_file = '') {
  JsonData <- rjson::fromJSON(file= json_file)
  rds_details <- JsonData$RDS_DETAILS
  rds_profiles <- JsonData$AWS_CREDS
  rs_conn <- RPostgres::dbConnect(RPostgres::Postgres(),
                                  host = rds_details$host,
                                  port = rds_details$port,
                                  user = rds_details$username,
                                  password = rds_details$password,
                                  #user = rds_profiles$alias,
                                  #password = rds_profiles$password,
                                  #dbname = rds_details$database,
                                  sslmode='require')
  rs_conn
}

file  <- '~/Visualizing-Books/aws_info.json'

#' The result of a redshift query
#'
#' This function allows you to create a dataframe out of the result of a given redshift query.
#' @param rs_conn An R Redshift connection (as given by the package RPostgres).
#' @param query A Redshift query.
#' @keywords redshift, rs, sql, query, postgres
#' @return A tibble that stores the query results.
#' @export
#' @examples
#' df_from_query(rs_conn, query = "SELECT COUNT(*) FROM dims.opportunities")
df_from_query <- function(rs_conn, query = "SELECT COUNT(*) FROM final_around_the_world") {
  res <- RPostgres::dbSendQuery(rs_conn, query)
  df <- tibble::as_tibble(RPostgres::dbFetch(res))
  RPostgres::dbClearResult(res)
  df
}




