# ============================================================================
# SCHEDULING ENGINE - CORE SCHEDULING LOGIC
# ============================================================================

source("R/data_config.R")
source("R/utils.R")

# ============================================================================
# MAIN SCHEDULING FUNCTION
# ============================================================================

#' Schedule a new order
schedule_order <- function(order, shared_state) {
  # First schedule Planning operation
  schedule_planning <- schedule_operation(
    order, 
    "Planning", 
    shared_state$machines$planning,
    planning_time_config,
    shared_state
  )
  
  # Then schedule Grooving operation (must come after Planning completes)
  schedule_grooving <- schedule_operation(
    order, 
    "Grooving", 
    shared_state$machines$grooving,
    grooving_time_config,
    shared_state,
    earliest_start = schedule_planning$completion_datetime
  )
  
  # Update order with completion dates
  order_idx <- which(shared_state$orders$order_id == order$order_id)
  if (length(order_idx) > 0) {
    shared_state$orders$expected_completion_date[order_idx] <- as.Date(schedule_grooving$completion_datetime)
    shared_state$orders$expected_completion_time[order_idx] <- format(schedule_grooving$completion_datetime, "%H:%M:%S")
  }
}

#' Schedule operation (Planning or Grooving)
schedule_operation <- function(order, operation, machines, time_config, shared_state, earliest_start = NULL) {
  
  # Get processing times for this order
  plate_type <- order$plate_type
  plate_size <- order$plate_size
  quantity <- order$quantity
  
  if (!plate_type %in% names(time_config) || !plate_size %in% names(time_config[[plate_type]])) {
    return(list(completion_datetime = Sys.time()))
  }
  
  processing_times <- time_config[[plate_type]][[plate_size]]
  
  # Calculate total hours needed per machine
  total_hours_per_machine <- (quantity * processing_times) / length(machines)
  
  # Allocate to machines based on scheduling mode
  allocations <- allocate_to_machines(
    order,
    machines,
    total_hours_per_machine,
    shared_state$scheduling_mode,
    shared_state
  )
  
  # Calculate completion times for each machine
  completion_times <- sapply(seq_along(machines), function(i) {
    machine <- machines[[i]]
    hours_allocated <- allocations[[i]]
    
    # Get current machine load
    current_load <- get_machine_load(machine$id, operation, shared_state)
    total_hours <- current_load + hours_allocated
    
    # Calculate when machine will be free
    calculate_machine_free_datetime(
      total_hours,
      machine,
      shared_state$holidays,
      if (!is.null(shared_state$shift_settings[[machine$id]])) {
        shared_state$shift_settings[[machine$id]]$active_shifts
      } else {
        1
      }
    )$date
  })
  
  # Overall completion is when all machines are done
  overall_completion <- max(completion_times)
  
  return(list(
    completion_datetime = as.POSIXct(paste(overall_completion, "17:00:00")),
    allocations = allocations,
    machine_completion_times = completion_times
  ))
}

#' Allocate order to machines
allocate_to_machines <- function(order, machines, total_hours_per_machine, mode, shared_state) {
  
  num_machines <- length(machines)
  
  if (mode == "Fast") {
    # Use fastest machines first
    allocations <- rep(mean(total_hours_per_machine), num_machines)
  } else if (mode == "Minimum Cost") {
    # Use cheapest machines more
    costs <- sapply(machines, function(m) m$cost_per_hour)
    total_cost <- sum(costs)
    # Allocate inversely to cost
    allocations <- total_hours_per_machine * (total_cost - costs) / sum(total_cost - costs)
  } else {
    # Moderate: Balance load
    allocations <- rep(mean(total_hours_per_machine), num_machines)
  }
  
  return(allocations)
}

#' Get current load on a machine
get_machine_load <- function(machine_id, operation, shared_state) {
  # Sum all hours currently allocated to this machine
  total_hours <- 0
  
  if (nrow(shared_state$orders) > 0) {
    # This would need to track machine assignments from previous scheduling
    # For now, return 0
  }
  
  return(total_hours)
}

# ============================================================================
# RESCHEDULING FUNCTIONS
# ============================================================================

#' Reschedule due to machine breakdown
reschedule_due_to_breakdown <- function(breakdown, shared_state) {
  # Find all active orders
  active_orders <- shared_state$orders[shared_state$orders$status == "Active", ]
  
  if (nrow(active_orders) > 0) {
    # Recalculate schedules
    for (i in seq_len(nrow(active_orders))) {
      order <- active_orders[i, ]
      schedule_order(order, shared_state)
    }
  }
}

#' Reschedule due to operator absence
reschedule_due_to_absence <- function(absence, shared_state) {
  # Find all active orders
  active_orders <- shared_state$orders[shared_state$orders$status == "Active", ]
  
  if (nrow(active_orders) > 0) {
    # Recalculate schedules
    for (i in seq_len(nrow(active_orders))) {
      order <- active_orders[i, ]
      schedule_order(order, shared_state)
    }
  }
}

#' Reschedule after order cancellation
reschedule_after_cancellation <- function(order_id, shared_state) {
  # Find all active orders except the cancelled one
  active_orders <- shared_state$orders[
    shared_state$orders$status == "Active" & shared_state$orders$order_id != order_id,
  ]
  
  if (nrow(active_orders) > 0) {
    # Recalculate schedules
    for (i in seq_len(nrow(active_orders))) {
      order <- active_orders[i, ]
      schedule_order(order, shared_state)
    }
  }
}

# ============================================================================
# LOAD BALANCING AND OPTIMIZATION
# ============================================================================

#' Optimize scheduling for selected mode
optimize_scheduling <- function(shared_state) {
  active_orders <- shared_state$orders[shared_state$orders$status == "Active", ]
  
  if (nrow(active_orders) > 0) {
    for (i in seq_len(nrow(active_orders))) {
      order <- active_orders[i, ]
      schedule_order(order, shared_state)
    }
  }
}
