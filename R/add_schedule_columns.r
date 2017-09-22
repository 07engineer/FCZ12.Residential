#' Add Schedule Columns
#'
#' This function ...
#' @param df
#' @keywords Autocalibration,EnergyPlus
#' @export
#' @examples
#' add_schedule_columns()

add_schedule_columns <- function(df){
  df <- mutate(df, month = month(date, label = TRUE),
               wday = as.character(wday(date, label = TRUE)),
               hour = hour(date),
               weekend = ifelse(wday == "Sat" | wday == "Sun", "weekend", "weekday"))
  return(df)
}


# #' Add Schedule Columns
# #'
# #' This function ...
# #' @param df
# #' @keywords Autocalibration,EnergyPlus
# #' @export
# #' @examples
# #' add_schedule_columns()
# 
# add_schedule_columns <- function(df){
#   df <- mutate(df, month = month(date, label = TRUE),
#                wday = as.character(wday(date, label = TRUE)),
#                hour = hour(date),
#                weekend = ifelse(wday == "Sat" | wday == "Sun", "weekend", "weekday"),
#                season = "Winter",
#                daylightsavings = "normal")
#   
#   df[df$month == "Mar" | df$month == "Apr" | df$month == "May", "season"] <- "Spring"
#   df[df$month == "Jun" | df$month == "Jul" | df$month == "Aug", "season"] <- "Summer"
#   df[df$month == "Sep" | df$month == "Oct" | df$month == "Nov", "season"] <- "Fall"
#   
#   holidays <- read_csv("holidays.csv") %>%
#     gather(year, date, -holidayName) %>%
#     mutate(date = mdy(date))
#   
#   df[as_date(df$date) %in% holidays$date, "wday"] <- "Holiday"
#   df[df$wday == "Holiday", "weekend"] <- "weekend"
#   
#   analysisyear = year(df$date[5]) #Use year from datafile. Index is arbitrary, but not 1 because the first one is sometimes an exception
#   daylightsavings <- read_csv("daylightSavingsDates.csv") %>%
#     mutate(start = mdy_hm(start),
#            end = mdy_hm(end)) %>%
#     filter(year == analysisyear)
#   
#   
#   df[df$date > daylightsavings$start[1] & df$date <= daylightsavings$end[1], "daylightsavings"] <- "daylightsavings"
#   return(df)
# }