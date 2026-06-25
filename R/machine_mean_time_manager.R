# ============================================================================
# MACHINE MEAN PROCESSING TIME MANAGEMENT MODULE
# Handles display, editing, and validation of machine processing times
# ============================================================================

# ============================================================================
# MACHINE MEAN TIME DISPLAY AND EDITING FUNCTIONS
# ============================================================================

#' Create Planning Mean Times Data Frame
create_planning_mean_times_df <- function(planning_time_config) {
  plate_types <- names(planning_time_config)
  plate_sizes <- names(planning_time_config[[1]])
  
  data_list <- list()
  
  for (plate_type in plate_types) {
    for (plate_size in plate_sizes) {
      times <- planning_time_config[[plate_type]][[plate_size]]
      mean_time <- mean(times)
      
      data_list[[paste0(plate_type, "_", plate_size)]] <- data.frame(
        plate_type = plate_type,
        plate_size = plate_size,
        pl_01 = times[1],
        pl_02 = times[2],
        btmm = times[3],
        cnc_bdm_01 = times[4],
        mean_time = round(mean_time, 2),
        stringsAsFactors = FALSE
      )
    }
  }
  
  do.call(rbind, data_list) %>%
    rownames_to_column() %>%
    select(-rowname)
}

#' Create Grooving Mean Times Data Frame
create_grooving_mean_times_df <- function(grooving_time_config) {
  plate_types <- names(grooving_time_config)
  plate_sizes <- names(grooving_time_config[[1]])
  
  data_list <- list()
  
  for (plate_type in plate_types) {
    for (plate_size in plate_sizes) {
      times <- grooving_time_config[[plate_type]][[plate_size]]
      mean_time <- mean(times)
      
      data_list[[paste0(plate_type, "_", plate_size)]] <- data.frame(
        plate_type = plate_type,
        plate_size = plate_size,
        cnc_bdm_02 = times[1],
        cnc_bdm_03 = times[2],
        gcm = times[3],
        mean_time = round(mean_time, 2),
        stringsAsFactors = FALSE
      )
    }
  }
  
  do.call(rbind, data_list) %>%
    rownames_to_column() %>%
    select(-rowname)
}

#' Format mean times data frame for display
format_mean_times_for_display <- function(df) {
  colnames(df) <- c(
    "Plate Type",
    "Plate Size",
    colnames(df)[3:(ncol(df)-1)],
    "Mean Time (hrs)"
  )
  
  # Rename machine columns
  if ("pl_01" %in% colnames(df)) {
    df <- df %>%
      rename(
        "PL-01" = "pl_01",
        "PL-02" = "pl_02",
        "BTMM" = "btmm",
        "CNC BDM-01" = "cnc_bdm_01"
      )
  } else if ("cnc_bdm_02" %in% colnames(df)) {
    df <- df %>%
      rename(
        "CNC BDM-02" = "cnc_bdm_02",
        "CNC BDM-03" = "cnc_bdm_03",
        "GCM" = "gcm"
      )
  }
  
  return(df)
}

#' Update a single processing time
update_processing_time <- function(plate_type, plate_size, machine_index, new_time, 
                                  operation, config_list) {
  if (plate_type %in% names(config_list) && 
      plate_size %in% names(config_list[[plate_type]])) {
    config_list[[plate_type]][[plate_size]][machine_index] <- new_time
    return(config_list)
  }
  return(NULL)
}

#' Validate processing time input
validate_processing_time <- function(plate_type, plate_size, new_times) {
  errors <- c()
  
  if (plate_type == "" || is.null(plate_type)) {
    errors <- c(errors, "Plate type must be selected")
  }
  
  if (plate_size == "" || is.null(plate_size)) {
    errors <- c(errors, "Plate size must be selected")
  }
  
  if (any(is.na(new_times))) {
    errors <- c(errors, "All machine times must be entered")
  }
  
  if (any(new_times < 0)) {
    errors <- c(errors, "Processing times cannot be negative")
  }
  
  if (any(new_times > 100)) {
    errors <- c(errors, "Processing times seem unusually high (>100 hours). Please verify.")
  }
  
  return(errors)
}

#' Log processing time changes
log_time_change <- function(plate_type, plate_size, operation, machine, old_time, new_time) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  
  log_entry <- data.frame(
    timestamp = timestamp,
    plate_type = plate_type,
    plate_size = plate_size,
    operation = operation,
    machine = machine,
    old_time = round(old_time, 2),
    new_time = round(new_time, 2),
    change_percent = round((new_time - old_time) / old_time * 100, 1),
    user = "Administrator",
    stringsAsFactors = FALSE
  )
  
  return(log_entry)
}

#' Get machine processing statistics
get_machine_statistics <- function(time_config, operation) {
  stats <- list()
  
  for (plate_type in names(time_config)) {
    for (plate_size in names(time_config[[plate_type]])) {
      times <- time_config[[plate_type]][[plate_size]]
      
      stats[[paste0(plate_type, "_", plate_size)]] <- list(
        min_time = min(times),
        max_time = max(times),
        mean_time = mean(times),
        std_dev = sd(times),
        fastest_machine = which.min(times),
        slowest_machine = which.max(times)
      )
    }
  }
  
  return(stats)
}

# ============================================================================
# AUDIT LOG MANAGEMENT
# ============================================================================

#' Initialize audit log
initialize_audit_log <- function() {
  data.frame(
    timestamp = as.POSIXct(character()),
    plate_type = character(),
    plate_size = character(),
    operation = character(),
    machine = character(),
    old_time = numeric(),
    new_time = numeric(),
    change_percent = numeric(),
    user = character(),
    stringsAsFactors = FALSE
  )
}

#' Add entry to audit log
add_audit_log_entry <- function(audit_log, entry) {
  rbind(audit_log, entry)
}

#' Format audit log for display
format_audit_log_for_display <- function(audit_log) {
  if (nrow(audit_log) == 0) {
    return(data.frame(Message = "No changes recorded yet"))
  }
  
  audit_log %>%
    mutate(
      timestamp = format(timestamp, "%d-%b-%Y %H:%M:%S"),
      change_percent = paste0(change_percent, "%")
    ) %>%
    rename(
      "Timestamp" = "timestamp",
      "Plate Type" = "plate_type",
      "Plate Size" = "plate_size",
      "Operation" = "operation",
      "Machine" = "machine",
      "Old Time" = "old_time",
      "New Time" = "new_time",
      "Change (%)" = "change_percent",
      "User" = "user"
    ) %>%
    select("Timestamp", "Plate Type", "Plate Size", "Operation", "Machine", 
           "Old Time", "New Time", "Change (%)", "User")
}

# ============================================================================
# PASSWORD VERIFICATION
# ============================================================================

#' Verify administrator password
verify_admin_password <- function(input_password, correct_password) {
  # Direct comparison (in production, use hashing)
  return(input_password == correct_password)
}

#' Get password verification status
get_password_status <- function(is_verified) {
  if (is_verified) {
    return(
      div(
        class = "alert alert-success",
        h5("✅ Authentication Successful"),
        "You can now edit machine processing times. All changes will be logged."
      )
    )
  } else {
    return(
      div(
        class = "alert alert-danger",
        h5("❌ Authentication Failed"),
        "Incorrect password. Please try again."
      )
    )
  }
}
