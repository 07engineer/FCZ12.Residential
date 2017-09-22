#' Convert to Jules to kW
#'
#' This function searches for fields in a dataframe representing an EnergyPlus output for units if [J] and then
#' converts them into units of [kW].
#' @param df The dataframe of EnergyPlus outputs to be converted
#' @keywords EnergyPlus,Model Data, Calibration
#' @export
#' @examples
#' JtoKW()

JtoKW <- function(df){
  J_columns <- grep(" \\[J\\]\\(Hourly\\)", names(df))
  numbers <- df[,J_columns] / (3600 * 1000)
  names(numbers) <- gsub(" \\[J\\]\\(Hourly\\)", "", names(numbers))
  df <- as_tibble(cbind(df[,"date"], numbers))
  
  return(df)
}

