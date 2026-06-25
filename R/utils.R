# ============================================================================
# UTILITY FUNCTIONS FOR QUEUE SCHEDULER
# ============================================================================

# Shift time configurations
SHIFT_CONFIG_8HR <- list(
  shift_1 = list(start = "07:30", end = "16:30"),  # 07:30 AM - 04:30 PM
  shift_2 = list(start = "16:30", end = "23:30"),  # 04:30 PM - 11:30 PM
  shift_3 = list(start = "23:30", end = "07:30")   # 11:30 PM - 07:30 AM
)

SHIFT_CONFIG_12HR <- list(
  shift_1 = list(start = "07:30", end = "19:30"),  # 07:30 AM - 07:30 PM
  shift_2 = list(start = "19:30", end = "07:30")   # 07:30 PM - 07:30 AM
)

LUNCH_BREAK_MINUTES <- 30
WEEKLY_OFF <- "Monday"

# ============================================================================
# TIME CALCULATION UTILITIES
# ============================================================================

#' Check if a date is Monday (weekly off)
is_weekly_off <- function(date) {
  weekdays(as.Date(date)) == WEEKLY_OFF
}

#' Check if a date is a holiday
is_holiday <- function(date, holidays) {
  as.Date(date) %in% holidays
}

#' Check if a date is working day
is_working_day <- function(date, holidays) {
  !is_weekly_off(date) && !is_holiday(date, holidays)
}

#' Get next working day
get_next_working_day <- function(date, holidays) {
  date <- as.Date(date)
  while (!is_working_day(date, holidays)) {
    date <- date + 1
  }
  return(date)
}

#' Convert time string (HH:MM) to POSIXct
time_to_posixct <- function(date, time_str) {
  as.POSIXct(paste(date, time_str), format = "%Y-%m-%d %H:%M")
}

#' Get working hours in a shift
get_shift_working_hours <- function(shift_start, shift_end, holidays) {
  # 8 hours - 30 minutes lunch break = 7.5 hours
  7.5
}

#' Calculate machine free date and time
calculate_machine_free_datetime <- function(current_load_hours, machine, holidays, active_shifts = 1) {
  # Calculate when machine will be free based on current load
  # This is a simplified version
  
  start_date <- Sys.Date()
  total_hours_needed <- current_load_hours
  
  # Get working hours per day based on shift type
  if (machine$shift_type == "8-hour") {
    hours_per_day <- 7.5 * active_shifts  # Each 8-hour shift has 7.5 working hours
  } else {
    hours_per_day <- 11.5 * active_shifts  # Each 12-hour shift has 11.5 working hours
  }
  
  current_date <- start_date
  remaining_hours <- total_hours_needed
  
  while (remaining_hours > 0) {
    if (is_working_day(current_date, c())) {
      if (remaining_hours <= hours_per_day) {
        # Machine will be free on this day
        hours_used <- remaining_hours
        remaining_hours <- 0
      } else {
        remaining_hours <- remaining_hours - hours_per_day
      }
    }
    current_date <- current_date + 1
  }
  
  return(list(date = current_date, hours_used = hours_used))
}

# ============================================================================
# LOAD BALANCING UTILITIES
# ============================================================================

#' Calculate load for each machine
calculate_machine_loads <- function(orders, machines, operation) {
  loads <- setNames(numeric(length(machines[[operation]])), 
                    sapply(machines[[operation]], function(m) m$id))
  
  # Sum processing times for each machine
  for (i in seq_along(loads)) {
    machine_id <- names(loads)[i]
    # Filter orders for this machine
    total_time <- 0
    loads[i] <- total_time
  }
  
  return(loads)
}

#' Allocate order to machines with minimum load
allocate_to_minimum_load <- function(order, machines_operation, loads) {
  # Find machine with minimum load
  min_machine_idx <- which.min(loads)
  return(min_machine_idx)
}

#' Balance load across all machines
balance_machine_loads <- function(orders, machines, operation) {
  # Redistribute work to balance loads
  loads <- calculate_machine_loads(orders, machines, operation)
  mean_load <- mean(loads)
  
  # Find overloaded and underloaded machines
  overloaded <- names(loads[loads > mean_load * 1.2])  # 20% over average
  underloaded <- names(loads[loads < mean_load * 0.8]) # 20% below average
  
  return(list(overloaded = overloaded, underloaded = underloaded, loads = loads))
}

# ============================================================================
# SCHEDULING MODE UTILITIES
# ============================================================================

#' Apply Fast Mode scheduling
apply_fast_mode <- function(orders, machines) {
  # Complete orders as early as possible
  # Prioritize speed over cost
  # Allocate to fastest machines first
  return(orders)
}

#' Apply Moderate Mode scheduling
apply_moderate_mode <- function(orders, machines) {
  # Balance cost and completion time
  # Try to finish all machines on same day
  return(orders)
}

#' Apply Minimum Cost Mode scheduling
apply_minimum_cost_mode <- function(orders, machines) {
  # Minimize cost but try to finish on same day
  # Prefer cheaper machines
  return(orders)
}

# ============================================================================
# VALIDATION UTILITIES
# ============================================================================

#' Validate order input
validate_order <- function(plate_type, plate_size, quantity, operation) {
  errors <- c()
  
  if (plate_type == "" || is.null(plate_type)) {
    errors <- c(errors, "Plate type is required")
  }
  
  if (plate_size == "" || is.null(plate_size)) {
    errors <- c(errors, "Plate size is required")
  }
  
  if (quantity < 1) {
    errors <- c(errors, "Quantity must be at least 1")
  }
  
  if (operation == "" || is.null(operation)) {
    errors <- c(errors, "Operation type is required")
  }
  
  return(errors)
}

# ============================================================================
# DATA FORMATTING UTILITIES
# ============================================================================

#' Format datetime for display
format_datetime_display <- function(date, time) {
  if (is.na(date) || is.na(time)) {
    return("Not scheduled")
  }
  paste(format(as.Date(date), "%d-%b-%Y"), time)
}

#' Get processing time for a plate
get_processing_time <- function(plate_type, plate_size, operation, machine_index, time_config) {
  if (plate_type %in% names(time_config) && 
      plate_size %in% names(time_config[[plate_type]])) {
    times <- time_config[[plate_type]][[plate_size]]
    if (machine_index <= length(times)) {
      return(times[machine_index])
    }
  }
  return(5)  # Default processing time
}
