#' Update Enduse Coefficients
#'
#' End use coefficients are calculated with a regression approach in the analytical calculator. This function reads them in, 
#' and updates the EnergyPlus input file with the new values.  
#'

#' @param 
#' 
#' 
#' 
#' @keywords EnergyPlus, Parametrics, Calibration
#' @export
#' @examples
#' update_enduse_coefficients()


#coeff_path = coefficients_path
#coeff_file_name = coefficients_file

update_enduse_coefficients <- function(coeff_path, coeff_file_name, sections_folder){
  
  files_coefficients <- dir(coeff_path)
  EPD_constituents <- c("Cooking", 
                        "Dishwasher", 
                        "Dryer", 
                        "Freezer", 
                        "Miscellaneous", 
                        "Refrigerator", 
                        "Television", 
                        "Washer") 
  
  coeffs <- read_csv(str_c(coeff_path, coeff_file_name, sep = "/")) %>% 
    filter(cec_end_use %in% EPD_constituents, year == 2014 )%>% 
    mutate(weight_ratio = weight / sum(weight)) %>% 
    select(cec_end_use, weight_ratio) %>%
    mutate(EP_schedule_name = str_replace_all(cec_end_use, "[a-z]", toupper),
           EP_schedule_name = str_c(EP_schedule_name, ","),
           parametric_name  = str_replace_all(cec_end_use, "[A-Z]", tolower))  
  
  file_name <- str_c(sections_folder, "/", dir(sections_folder)[str_detect(dir(sections_folder), "00_")])
  file <- str_split(read_file(file_name),  "\r\n")[[1]]
  
  for(i in 1:nrow(coeffs)){
    rows_to_change = grep(coeffs$EP_schedule_name[i], file) + 3
    #row_replacement = str_c("    =$EPD*", coeffs$weight_ratio[i], ",    !- Watts per Zone Floor Area {W/m2}")
    row_replacement = str_c("    =$EPD*=$", coeffs$parametric_name[i], ",    !- Watts per Zone Floor Area {W/m2}")
    
    file[rows_to_change] <- row_replacement
  }

  file <- str_c(file, collapse = "\r\n")
  write_file(file, file_name)
}

