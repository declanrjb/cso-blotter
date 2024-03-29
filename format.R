counts_df <- read_csv("counts_df.csv")
counts_df$Type <- gsub(" ","_",counts_df$Type)
counts_df$Type <- gsub("/","_",counts_df$Type)

response_types <- unique(counts_df$Type)
df <- as.data.frame(matrix(ncol=(length(unique(counts_df$Type))+1),nrow=length(unique(counts_df$endDate))))
response_types <- gsub(" ","_",response_types)
response_types <- gsub("/","_",response_types)
colnames(df) <- c("Date",response_types)

df$Date <- unique(counts_df$endDate)
df <- df %>% arrange(Date)

for (i in 1:length(df$Date)) {

  curr_date <- df[i,]$Date
  temp_df <- counts_df %>% filter(endDate == curr_date)
  
  for (j in 1:ncol(df)) {
    name <- colnames(df)[j]
    if (name %in% temp_df$Type) {
      df[i,j] <- (temp_df %>% filter(Type == name))$Incidents
    }
  }
  
  message(i)

}

df <- cbind(df,Year=year(df$Date))

write_out_csv <- function(df,output_name) {
  colnames(df) <- gsub("_"," ",colnames(df))
  colnames(df) <- str_to_title(colnames(df))
  write.csv(df,output_name,row.names=FALSE)
}
