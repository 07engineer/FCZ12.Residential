
#' Combine EnergyPlus Input File Sections
#'
#' At ADM we divide the EnergyPlus input files into various sections to make things easier. 
#'   
#'
#' @param run_name Name of the EnergyPlus run
#' @keywords EnergyPlus, Parametrics, Calibration
#' @export
#' @examples
#' combine_sections()


combine_sections <- function(run_name){
  filenames <- str_c("sections", dir("sections"), sep = "/")
  read_input_files <- sapply(filenames, function(x) read_file(x))
  input_combined <- paste(read_input_files, collapse = "\n")
  write_file(input_combined, str_c("EP_input", "/", run_name, ".idf"))
}