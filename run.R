source("~/Documents/R/cso-blotter/script.R")

url <- "https://www.reed.edu/community_safety/past-blotters-activity.html"
page <- read_html(url)

links_list <- page %>% html_nodes("p") %>% html_children() %>% html_attr("href")
links_df <- as.data.frame(links_list)
links_df <- links_df %>% filter(!is.na(links_list))
links_df <- links_df %>% filter(grepl("blotters",links_list))
links_df$links_list <- paste("https://reed.edu/community_safety/",links_df$links_list,sep="")

counts_df <- as.data.frame(matrix(ncol=4,nrow=0))
colnames(counts_df) <- c("Type","Incidents","startDate","endDate")

reports_df <- as.data.frame(matrix(ncol=7,nrow=0))
colnames(reports_df) <- c("Case#","Date","Time","Description","Location","Date_Time","Notes")

for (i in 1:length(links_df$links_list)) {
  message(i)
  url <- links_df$links_list[i]
  cursed <- c("https://reed.edu/community_safety/blotters/blotter-11.28-12.04.22.html","https://reed.edu/community_safety/blotters/blotter-03.14-03.20.html","https://reed.edu/community_safety/blotters/blotter-11.22-11.28.html","https://reed.edu/community_safety/blotters/blotter-10.25-10.31.21.html")
  if (url %in% cursed) {
    message("cursed url")
  } else {
    message(url)
    temp_df <- getCompleteTypeFrame(url)
    temp_reports <- getFullReports(url)
    counts_df <- rbind(counts_df,temp_df)
    reports_df <- rbind(reports_df,temp_reports) 
  }
}

write.csv(counts_df,"counts-df-backup.csv",row.names=FALSE)

reports_df <- cbind(reports_df,Hour=hour(reports_df$Date_Time))
reports_df <- cbind(reports_df,Minute=minute(reports_df$Date_Time))
reports_df <- cbind(reports_df,Year=year(reports_df$Date_Time))
reports_df <- cbind(reports_df,Time_Numeric=NA)
reports_df$Time_Numeric <- reports_df$Hour + (reports_df$Minute/60)
reports_df <- cbind(reports_df,Type="Incident")

counts_df <- cbind(counts_df,Year=year(counts_df$startDate))
