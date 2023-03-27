for (i in 1:length(reports_df$Hour)) {
  hour <- reports_df[i,]$Hour
  hour_index <- which(hours_df$Hour == hour)
  reports_df[i,]$y <- hours_df[hour_index,]$Frequency
  hours_df[hour_index,]$Frequency <- hours_df[hour_index,]$Frequency * -1
  if (hours_df[hour_index,]$Frequency > 0) {
    hours_df[hour_index,]$Frequency <- hours_df[hour_index,]$Frequency + 1 
  }
  message(i)
}