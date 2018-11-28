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
  mutate(line=row_number()) %>%
  transform(text = strsplit(text,"(?=[[:space:]]+|[[:punct:]]+|[[:digit:]]+)",perl=TRUE)) %>%
  unnest(text) %>%
  mutate(id=row_number()) %>%
  group_by(line) %>%
  mutate(id_in_line=row_number()) %>%
  ungroup()
#https://www.r-bloggers.com/strsplit-but-keeping-the-delimiter/  lookahead regex
#This regex allows to split every element of a sentence.
strsplit(books[150,2][[1]],"(?=[[:space:]]+|[[:punct:]]+|[[:digit:]]+)",perl=TRUE)
