#' Update EnergyPlus Schedules
#'
#' The analytic models produce schedules. We need to update the EnergyPlus schedule files with the new end-uses.
#'
#'
#' @param 
#' @keywords EnergyPlus, Parametrics, Calibration
#' @export
#' @examples
#' update_schedule()

update_schedule <- function(){
  energyplus_schedule <- read_csv("Residential_sch.csv") %>%
    mutate(date = as_date(mdy_hm(Schedule)))
  
  energyplus_start_date = min(energyplus_schedule$date)
  energyplus_end_date   = max(energyplus_schedule$date)
  
  analytic_schedule_path <- "L:/P/1631/Task 4 - Baseline Profiles/Residential Pre-Processor 091417/Results/Schedules/Final" 
  analytic_schedule_files <- dir(analytic_schedule_path)
  analytic_schedule <- read_csv(str_c(analytic_schedule_path, analytic_schedule_files[1], sep = "/")) %>% 
    # select(which(names(analytic_schedule) %in% names(energyplus_schedule))) %>% 
    filter(date >= energyplus_start_date, date <= energyplus_end_date)
  
  if(sum(analytic_schedule$date == energyplus_schedule$date) != 8760) stop("Schedule update failure... dates may not match")
  
  # In the analytic model, the hdd_base and cdd_base column are regression change point values. 
  # In the energy plus schedule, they are actual setpoints. 
  # John said not to update these. 
  
  do_not_update <- c("date", "hdd_base", "cdd_base")
  cols_to_update <- names(energyplus_schedule)[names(energyplus_schedule) %in% names(analytic_schedule)]
  cols_to_update <- cols_to_update[!(cols_to_update %in% do_not_update)]
  analytic_schedule <- analytic_schedule[, cols_to_update]
  
  #Check that no schedule values are outside zero and one
  fix_schedule_bounds <- function(vector){
    if(max(vector) > 1){
      warning("Analytic schedule had values > 1. They were set to 1.")
      vector[vector > 1] <- 1
      
    }
    if(min(vector) < 0){
      warning("Analytic schedule had values < 0. They were set to 0.")
      vector[vector < 0] <- 0
      
    }
    return(vector)
  }

  analytic_schedule <- as_tibble(apply(analytic_schedule, 2, fix_schedule_bounds))
  
  # Remember not to change the column order of the EnergyPlus file columns! They are referenced in the .idf file
  energyplus_schedule[, cols_to_update] <- analytic_schedule[, cols_to_update]
  
  write_csv(energyplus_schedule, "Residential_sch.csv")
}


