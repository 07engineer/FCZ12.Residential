#' Run Parametric PreProcessor
#'
#' Takes a list of input file names, including the parametric pre-processor, combines the files, and runs the parametric pre-processor.
#'
#' @param input_file_names Input files. Must be .csv format.
#' @param processed_file_name Name of output file
#' @param PP_Location Location of energy plus parametricpreprocessor.exe
#' @keywords EnergyPlus, Parametrics, Calibration
#' @export
#' @examples
#' run_parametric_preprocessor

run_parametric_preprocessor <- function(input_file_names, processed_file_name,
                                        PP_Location = "C:\\EnergyPlusV8-5-0\\PreProcess\\ParametricPreProcessor\\parametricpreprocessor"){
  read_input_files <- sapply(input_file_names, function(x) read_file(x))
  input_combined <- paste(read_input_files, collapse = "\n")
  write_file(input_combined, processed_file_name)
  system(paste(PP_Location, processed_file_name))
}

