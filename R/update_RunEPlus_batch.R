#' Update RunEPlus.bat file
#'
#' EnergyPlus is launched using a batch file. Inside are paths which need updating. 
#' This function uses the working directory to make these updates.
#'
#'
#' @param 
#' @keywords EnergyPlus, Parametrics, Calibration
#' @export
#' @examples
#' update_RunEPlus_batch()

update_RunEPlus_batch <- function(){
  working_directory <- getwd()
  working_directory_dos <- str_replace_all(working_directory, "/", "\\\\")
  
  bat <- read_file("RunEPlus.bat") 
  bat <-  str_split(bat, pattern = "\r\n")[[1]]
  
  bat[35] <- str_c(" set input_path=", working_directory_dos, "\\EP_input\\")
  bat[36] <- str_c(" set output_path=", working_directory_dos, "\\EP_output\\")
  bat[49] <- str_c(" set weather_path=", working_directory_dos, "\\")
  
  bat <- str_c(bat, collapse = "\r\n")
  write_file(bat, "RunEPlus.bat")
}
