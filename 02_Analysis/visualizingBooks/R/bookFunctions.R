# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'


#' @title downloadBooks
#' @description Download books from Gutenberg project
#' @param titles Titles of the books to be downloaded
#' @return books: A dataframe with all books stored with one line per row
#' @export
#' @importFrom gutenbergr gutenberg_works gutenberg_download
#' @import magrittr
#' @examples titles <- c("The Critique of Pure Reason","Around the World in Eighty Days","Don Quixote")
#' books <- download_books(titles)
download_books <- function(titles) {
  books <- gutenberg_works(title %in% titles) %>%
    gutenberg_download(meta_fields = "title")
  return(books)
}


#' @title split_words
#'
#' @param books Data frame of books to be processed
#'
#' @return split_books: data frame containing one row per word, space or punctuation mark in each book
#' @export
#' @import dplyr
#' @importFrom tidyr unnest
#' @examples split_books <- split_words(books)
split_words <- function(books) {
  split_books <- books %>%
    mutate(line=row_number(),word = strsplit(text,"(?=[[:space:]]+|[[:punct:]]+|[[:digit:]]+)",perl=TRUE)) %>%
    unnest(word) %>%
    mutate(id=row_number()) %>%
    group_by(line) %>%
    mutate(id_in_line=row_number()) %>%
    ungroup()
  return(split_books)
}


#' @title append_sentiments
#' @description Get sentiments from a given sentiment dictionary
#'
#' @param sentiments_dict
#'
#' @return sentiments: dataframe with a two column sentiment dictionry
#' @export
#' @import tidytext
#' @examples sentiment_dict <- "nrc"
#' sentiments <- append_sentiments(sentiment_dict)
append_sentiments <- function(sentiment_dict){
  sentiments_bin <- get_sentiments(sentiment_dict) %>%
    filter(sentiment %in% c("negative","positive")) %>%
    group_by(word) %>%
    summarise(sentiment_bin = paste(sentiment, collapse = ","))
  sentiments_mult <- get_sentiments(sentiment_dict) %>%
    filter(!(sentiment %in% c("negative","positive"))) %>%
    group_by(word) %>%
    summarise(sentiment = paste(sentiment, collapse = ","))
  sentiments <- sentiments_bin %>%
    left_join(sentiments_mult,c("word"))
  return(sentiments)
}




#' @title add_sentiments
#' @description joins sentiments given by a dictionary to the books main dataframe
#' @param split_books split_books: data frame containing one row per word, space or punctuation mark in each book
#' @param sentiments modified sentiments dictionary
#' @return sentiment_books: an extended books dataframe that includes sentiments
#' @export
#'
#' @examples sentiment_books <- add_sentiments(split_books,sentiments)
add_sentiments <- function(split_books,sentiments){
  sentiment_books <- split_books %>%
    left_join(sentiments,c("word"))
  return(sentiment_books)
}
