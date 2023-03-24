library(tidyverse)
library(rvest)

getCounts <- function(url) {
  
  page <- read_html(url)
  nodes <- page %>% html_nodes("p")
  counts <- nodes[5]
  count_text <- counts %>% html_text2()
  type_list <- strsplit(count_text,"\n")
  type_list <- type_list[[1]]
  
  for (i in 1:length(type_list)) {
    if (i < length(type_list)) {
      if (type_list[i] == "") {
        type_list <- type_list[-i]
      }
    }
  }
  
  for (i in 1:length(type_list)) {
    if (i < length(type_list)) {
      if (type_list[i] == "") {
        type_list <- type_list[-i]
      }
    }
  }
  
  type_df <- as.data.frame(type_list)
  type_df <- data.frame(do.call('rbind', strsplit(as.character(type_df$type_list),': ',fixed=TRUE)))
  colnames(type_df) <- c("Type","Incidents")
  
  return(type_df)
  
}

