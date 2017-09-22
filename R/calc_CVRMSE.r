#' Calc Errors: CVRSME
#'
#' This function calculates Coefficient of variation of the root mean square error. Metrics for checking model calibration.
#' From ASHRAE Guideline 14, pg 15, equations 5.4 and 5.5 http://www.eeperformance.org/uploads/8/6/5/0/8650231/ashrae_guideline_14-2002_measurement_of_energy_and_demand_saving.pdf
#' For hourly analyses the suggested heuristics are < 30% CVRSME.
#' @param model,actual
#' @keywords Autocalibration,EnergyPlus
#' @export
#' @examples
#' calc_CVRMSE()

calc_CVRMSE <- function(model, actual){
  error = model - actual
  n = length(model)
  p = 1
  mean = mean(actual, na.rm = TRUE)
  100 * sqrt(sum(error, na.rm = TRUE)^2 / (n - p)) / mean
}