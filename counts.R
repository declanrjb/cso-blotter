summary_df <- as.data.frame(matrix(ncol=2,nrow=length(unique(counts_df$Type))))
colnames(summary_df) <- c("Type","Count")

summary_df$Type <- unique(counts_df$Type)

for (i in 1:length(summary_df$Type)) {
  curr_type <- summary_df[i,]$Type
  temp_df <- counts_df %>% filter(Type == curr_type)
  summary_df[i,]$Count <- sum(temp_df$Incidents)
  message(i)
}