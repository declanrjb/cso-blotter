library(tidyverse)
library(rvest)

getCounts <- function(url) {
  
  page <- read_html(url)
  nodes <- page %>% html_nodes("p")
  for (j in 1:length(nodes)) {
    curr_node <- nodes[j]
    curr_text <- curr_node %>% html_text()
    if (grepl("Unlocks:",curr_text)) {
      counts <- curr_node
    }
  }
  count_text <- counts %>% html_text2()
  type_list <- strsplit(count_text,"\n")
  type_list <- type_list[[1]]
  
  type_df <- as.data.frame(type_list)
  type_df <- type_df %>% filter(type_list != "")
  
  type_df <- data.frame(do.call('rbind', strsplit(as.character(type_df$type_list),': ',fixed=TRUE)))
  colnames(type_df) <- c("Type","Incidents")
  
  return(type_df)
  
}

getDate <- function(url) {
  page <- read_html(url)
  date <- page %>% html_nodes(".lead") %>% html_text()
  date <- strsplit(date," - ",fixed=TRUE)[[1]]
  date <- mdy(date)
  return(date)
}

getStartDate <- function(url) {
  return(getDate(url)[1])
}

getEndDate <- function(url) {
  return(getDate(url)[2])
}

getCompleteTypeFrame <- function(url) {
  df <- getCounts(url)
  df <- cbind(df,startDate=NA)
  df$startDate <- getStartDate(url)
  df <- cbind(df,endDate=NA)
  df$endDate <- getEndDate(url)
  return(df)
}

url <- "https://www.reed.edu/community_safety/past-blotters-activity.html"
page <- read_html(url)

links_list <- page %>% html_nodes("p") %>% html_children() %>% html_attr("href")
links_df <- as.data.frame(links_list)
links_df <- links_df %>% filter(!is.na(links_list))
links_df <- links_df %>% filter(grepl("blotters",links_list))
links_df$links_list <- paste("https://reed.edu/community_safety/",links_df$links_list,sep="")

counts_df <- as.data.frame(matrix(ncol=4,nrow=0))
colnames(counts_df) <- c("Type","Incidents","startDate","endDate")

for (i in 1:length(links_df$links_list)) {
  temp_df <- getCompleteTypeFrame(links_df$links_list[i])
  counts_df <- rbind(counts_df,temp_df)
  message(i)
}





