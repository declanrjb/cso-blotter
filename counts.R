final_bar_df <- as.data.frame(matrix(ncol=3,nrow=0))
colnames(final_bar_df) <- c("Type","Count","Year")

if (is.character(counts_df$Incidents)) {
  counts_df$Incidents <- parse_number(counts_df$Incidents)  
}


for (j in 2021:2023) {
  message(j)
  curr_df <- counts_df %>% filter(Year == j)
  
  summary_df <- as.data.frame(matrix(ncol=3,nrow=length(unique(curr_df$Type))))
  colnames(summary_df) <- c("Type","Count","Year")
  summary_df$Type <- unique(curr_df$Type)
  
  for (i in 1:length(summary_df$Type)) {
    curr_type <- summary_df[i,]$Type
    temp_df <- curr_df %>% filter(Type == curr_type)
    summary_df[i,]$Count <- sum(temp_df$Incidents)
    summary_df[i,]$Year <- j
    message(i)
  }
  final_bar_df <- rbind(final_bar_df,summary_df)
}


