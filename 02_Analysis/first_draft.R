
packages <- c("readr", "devtools","stringr", "tidyr", "tidytext","devtools","dplyr","rstudioapi")
for(i in packages) {
  if(!require(i,character.only = TRUE)) install.packages(i)
  library(i,character.only = TRUE)
}
rm(packages, i)

set_wd <- function() {
  #library(rstudioapi) # make sure you have it installed
  current_path <- getActiveDocumentContext()$path 
  setwd(dirname(current_path ))
  print( getwd() )
}
set_wd()


read_book <- function(link, skip_init_lines = 30,skip_final_lines = 364){
  book <- read_lines(link, skip = skip_init_lines) %>% 
    .[1:(length(.)-skip_final_lines)] %>% #Drops the final lines of the book
    na.omit()
  return(book)
}

tidy_book <- function(book,chapter_regex){
  tidied_book <- book %>% 
    data_frame(text=.) %>% 
    {if(chapter_regex != "") mutate(.,chapter = cumsum(str_detect(.$text, regex(chapter_regex,ignore_case = TRUE)))) else .} %>% 
    mutate(linenumber = row_number()) %>% 
    unnest_tokens(word,text) %>% 
    anti_join(stop_words)
  return(tidied_book)
}

add_sentiments <- function(tidy_book,sentiment_dict){
  sentiments <- get_sentiments(sentiment_dict)
  sentiment_book <- tidy_book %>% 
  left_join(sentiments)
  return(sentiment_book)
}

process_book <- function(link_adventures, skip_init_lines, skip_final_lines, chapter_regex, sentiment_dict, name){
  processed_book <- read_book(link_adventures, skip_init_lines,skip_final_lines) %>% 
    tidy_book(chapter_regex) %>% 
    add_sentiments(sentiment_dict) 
  write.csv(processed_book,file = paste(getwd(),"/Books/",name,".csv",sep=""))
  return(processed_book)
}
  
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



#adventures <- read_book(link_adventures, skip_init_lines,skip_final_lines)
#tidied_book <- tidy_book(adventures, chapter_regex)
#sentiment_book <- add_sentiments(tidy_book,sentiment_dict)







