#' Transfer Bill PreProcessor Schedule Results
#'
#' This function ...
#' @param PP_output_file,EP_schedule_file The name of the file containing billing data to be read in. Must be .csv format.
#' @keywords
#' @export
#' @examples
#' transfer_preprocessor_results()

transfer_preprocessor_results <- function(PP_output_file, EP_schedule_file){
  schedule <- read_csv(EP_schedule_file) %>% 
    mutate(schedule = mdy_hm(schedule))
  
  year <- year(schedule$schedule[1])
  
  PP_output <- read_csv(PP_output_file) %>% 
    mutate(date = ymd_hm(date)) %>% 
    filter(year(date) == year)
  
  schedule <- schedule %>% 
    mutate(lighting = PP_output$IntLight,
           equipment = PP_output$OffEquip)
  
  
  # Barnes said to disable the temperature columns from updating
  
  # schedule <- schedule %>% 
  #   mutate(lighting = PP_output$IntLight,
  #          equipment = PP_output$OffEquip,
  #          heating = PP_output$hdd_base,
  #          cooling = PP_output$cdd_base)
  
}

