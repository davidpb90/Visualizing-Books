library(readr)
library(devtools)
library(stringr)
library(gutenbergr)
library(tidyr)
library(tidytext)
adventures <- read_lines("https://ia800501.us.archive.org/27/items/theadventuresofs01661gut/pg1661.txt", skip = 65) 
#%>% 
 # data_frame()

adventures <- adventures[1:(length(adventures) - 364)]
adventures <- adventures[!is.na(adventures)]
#trial <- as_tibble(adventures) #%>%
#  str_replace_all("[^[:alpha:]| ]"," ") #%>% 
#  str_split(" ")
#trial <- adventures %>% str_extract_all(pattern = "([:alpha:]| )*") %>% str_split(" ")
#trial <- str_split(adventures," ")
#trial <- str_replace_all(adventures,"[^[:alpha:]| ]"," ") %>% 
#  str_split(" ") #%>% 
#  sapply(function(words){return(words[words!=""])},simplify = "array") #%>% 
#  data_frame #%>% 
  #as.tibble(names=c("lines"))
#line<-function(line)(return(list(line[1])))
#text_df <- data_frame(line = 1:length(adventures), text = adventures)
#text_df %>%
#  unnest_tokens(word, text)

tidy_book <- adventures %>% 
  data_frame(text=.) %>% 
  mutate(linenumber = row_number(),chapter = cumsum(str_detect(text, regex("^ADVENTURE",ignore_case = TRUE)))) %>% 
  unnest_tokens(word,text)

data(stop_words)

tidy_book <- tidy_book %>%
  anti_join(stop_words)

nrcjoy <- get_sentiments("nrc")
sentiment_book <- tidy_book %>% 
  left_join(nrcjoy)
write.csv(sentiment_book,file = "~/Desktop/piping.csv")

