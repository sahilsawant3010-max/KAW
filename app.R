# ============================================================================
# QUEUE SCHEDULER APPLICATION FOR MANUFACTURING OPERATIONS
# Multi-order queue scheduler with dynamic machine allocation
# ============================================================================

library(shiny)
library(shinyBS)
library(shinyalert)
library(tidyverse)
library(lubridate)
library(DT)
library(plotly)
library(shinythemes)
library(digest)

# ============================================================================
# SOURCE ALL MODULES AND UTILITIES
# ============================================================================

source("R/utils.R")
source("R/data_config.R")
source("R/scheduler_engine.R")
source("R/ui_login.R")
source("R/ui_dashboard.R")
source("R/ui_order_entry.R")
source("R/ui_machine_settings.R")
source("R/ui_shift_settings.R")
source("R/ui_holiday_settings.R")
source("R/ui_breakdown_management.R")
source("R/ui_operator_absence.R")
source("R/ui_active_production.R")
source("R/ui_production_history.R")
source("R/ui_machine_schedule.R")
source("R/ui_monthly_summary.R")
source("R/ui_timeline_tracking.R")

# ============================================================================
# GLOBAL REACTIVE STATE MANAGEMENT
# ============================================================================

shared_state <- reactiveValues(
  user_authenticated = FALSE,
  current_user = NULL,
  admin_password = "admin123",  # Change this in production!
  
  # Machine configurations
  machines = list(
    planning = list(
      list(id = "PL-01", name = "PL-01", cost_per_hour = 300, shift_type = "8-hour", active_shifts = 1),
      list(id = "PL-02", name = "PL-02", cost_per_hour = 300, shift_type = "8-hour", active_shifts = 1),
      list(id = "BTMM", name = "BTMM", cost_per_hour = 450, shift_type = "8-hour", active_shifts = 1),
      list(id = "CNC-BDM-01", name = "CNC BDM-01", cost_per_hour = 780, shift_type = "8-hour", active_shifts = 1)
    ),
    grooving = list(
      list(id = "CNC-BDM-02", name = "CNC BDM-02", cost_per_hour = 780, shift_type = "8-hour", active_shifts = 1),
      list(id = "CNC-BDM-03", name = "CNC BDM-03", cost_per_hour = 780, shift_type = "8-hour", active_shifts = 1),
      list(id = "GCM", name = "GCM", cost_per_hour = 450, shift_type = "8-hour", active_shifts = 1)
    )
  ),
  
  # Orders and schedules
  orders = data.frame(),
  machine_schedules = list(),
  breakdowns = data.frame(),
  operator_absences = data.frame(),
  holidays = as.Date(c()),
  
  # Shift configurations per machine
  shift_settings = list(),
  
  # Current scheduling mode
  scheduling_mode = "Moderate"
)

# ============================================================================
# MAIN APPLICATION UI
# ============================================================================

ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  # CSS and JavaScript
  tags$head(
    tags$style(HTML("
      body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
      .navbar { background-color: #2c3e50 !important; }
      .navbar-brand { font-weight: bold; }
      .btn-primary { background-color: #3498db; border-color: #2980b9; }
      .btn-primary:hover { background-color: #2980b9; }
      .panel-heading { background-color: #34495e; color: white; }
      .table-striped > tbody > tr:nth-of-type(odd) { background-color: #ecf0f1; }
      .alert { border-radius: 4px; }
      .machine-card { 
        border: 1px solid #bdc3c7; 
        border-radius: 4px; 
        padding: 15px; 
        margin: 10px 0;
        background-color: #f8f9fa;
      }
      .machine-card.active { border-left: 4px solid #27ae60; }
      .machine-card.breakdown { border-left: 4px solid #e74c3c; }
      .machine-free-date { 
        font-size: 18px; 
        font-weight: bold; 
        color: #2c3e50;
      }
      .gantt-chart { 
        height: 400px;
        margin-top: 20px;
      }
    "))
  ),
  
  # Conditional UI based on authentication
  uiOutput("conditional_ui")
)

# ============================================================================
# MAIN APPLICATION SERVER
# ============================================================================

server <- function(input, output, session) {
  
  # ========================================================================
  # AUTHENTICATION MODULE
  # ========================================================================
  
  output$conditional_ui <- renderUI({
    if (!shared_state$user_authenticated) {
      # Show login page
      create_login_ui()
    } else {
      # Show main dashboard
      create_main_ui()
    }
  })
  
  # Login handler
  observeEvent(input$login_btn, {
    password <- input$login_password
    if (digest::digest(password, algo = "sha256") == digest::digest(shared_state$admin_password, algo = "sha256") ||
        password == shared_state$admin_password) {
      shared_state$user_authenticated <- TRUE
      shared_state$current_user <- "Administrator"
      shinyalert("Success!", "Login successful. Welcome!", type = "success")
    } else {
      shinyalert("Error", "Invalid password. Please try again.", type = "error")
    }
  })
  
  # Logout handler
  observeEvent(input$logout_btn, {
    shared_state$user_authenticated <- FALSE
    shared_state$current_user <- NULL
    shinyalert("Logged Out", "You have been logged out successfully.", type = "info")
  })
  
  # ========================================================================
  # DASHBOARD MODULE
  # ========================================================================
  
  output$dashboard_title <- renderText({
    paste("Welcome,", shared_state$current_user)
  })
  
  # Dashboard statistics
  output$active_orders_count <- renderText({
    if (nrow(shared_state$orders) > 0) {
      nrow(shared_state$orders[shared_state$orders$status == "Active", ])
    } else {
      0
    }
  })
  
  output$completed_orders_count <- renderText({
    if (nrow(shared_state$orders) > 0) {
      nrow(shared_state$orders[shared_state$orders$status == "Completed", ])
    } else {
      0
    }
  })
  
  # ========================================================================
  # ORDER ENTRY MODULE
  # ========================================================================
  
  observeEvent(input$submit_order, {
    # Validate inputs
    if (input$order_plate_type == "" || input$order_plate_size == "" || 
        input$order_quantity < 1 || input$order_operation == "") {
      shinyalert("Error", "Please fill all required fields.", type = "error")
      return()
    }
    
    # Create order
    new_order <- data.frame(
      order_id = paste0("ORD-", format(Sys.time(), "%Y%m%d%H%M%S")),
      plate_type = input$order_plate_type,
      plate_size = input$order_plate_size,
      quantity = input$order_quantity,
      operation = input$order_operation,
      scheduling_mode = input$scheduling_mode,
      status = "Active",
      created_date = Sys.Date(),
      created_time = format(Sys.time(), "%H:%M:%S"),
      expected_completion_date = NA,
      expected_completion_time = NA,
      actual_completion_date = NA,
      actual_completion_time = NA,
      stringsAsFactors = FALSE
    )
    
    # Add to orders
    shared_state$orders <- rbind(shared_state$orders, new_order)
    
    # Trigger scheduling
    schedule_order(new_order, shared_state)
    
    shinyalert("Success!", paste("Order", new_order$order_id, "created successfully!"), type = "success")
    
    # Clear form
    updateSelectInput(session, "order_plate_type", selected = "")
    updateSelectInput(session, "order_plate_size", selected = "")
    updateNumericInput(session, "order_quantity", value = 0)
    updateSelectInput(session, "order_operation", selected = "")
  })
  
  # ========================================================================
  # MACHINE SETTINGS MODULE
  # ========================================================================
  
  output$machine_settings_ui <- renderUI({
    create_machine_settings_ui(shared_state$machines)
  })
  
  # ========================================================================
  # SHIFT SETTINGS MODULE
  # ========================================================================
  
  output$shift_settings_ui <- renderUI({
    create_shift_settings_ui(shared_state$machines)
  })
  
  # ========================================================================
  # HOLIDAY SETTINGS MODULE
  # ========================================================================
  
  output$holiday_settings_ui <- renderUI({
    create_holiday_settings_ui(shared_state$holidays)
  })
  
  # ========================================================================
  # BREAKDOWN MANAGEMENT MODULE
  # ========================================================================
  
  observeEvent(input$add_breakdown, {
    if (input$breakdown_machine == "" || is.na(input$breakdown_start_date) || 
        is.na(input$breakdown_end_date)) {
      shinyalert("Error", "Please fill all breakdown fields.", type = "error")
      return()
    }
    
    new_breakdown <- data.frame(
      machine_id = input$breakdown_machine,
      start_date = input$breakdown_start_date,
      end_date = input$breakdown_end_date,
      status = "Active",
      stringsAsFactors = FALSE
    )
    
    shared_state$breakdowns <- rbind(shared_state$breakdowns, new_breakdown)
    
    # Trigger rescheduling
    reschedule_due_to_breakdown(new_breakdown, shared_state)
    
    shinyalert("Success!", "Breakdown recorded. Orders will be rescheduled.", type = "success")
  })
  
  # ========================================================================
  # OPERATOR ABSENCE MODULE
  # ========================================================================
  
  observeEvent(input$add_operator_absence, {
    if (input$absence_machine == "" || is.na(input$absence_date) || 
        input$absence_shift == "") {
      shinyalert("Error", "Please fill all absence fields.", type = "error")
      return()
    }
    
    new_absence <- data.frame(
      machine_id = input$absence_machine,
      date = input$absence_date,
      shift = input$absence_shift,
      stringsAsFactors = FALSE
    )
    
    shared_state$operator_absences <- rbind(shared_state$operator_absences, new_absence)
    
    # Trigger rescheduling
    reschedule_due_to_absence(new_absence, shared_state)
    
    shinyalert("Success!", "Operator absence recorded. Orders will be rescheduled.", type = "success")
  })
  
  # ========================================================================
  # ACTIVE PRODUCTION MODULE
  # ========================================================================
  
  output$active_production_table <- renderDT({
    if (nrow(shared_state$orders) > 0) {
      active_orders <- shared_state$orders[shared_state$orders$status == "Active", ]
      datatable(
        active_orders,
        options = list(
          pageLength = 10,
          searching = TRUE,
          ordering = TRUE,
          autoWidth = TRUE
        ),
        rownames = FALSE
      )
    } else {
      datatable(data.frame(Message = "No active orders"), options = list(dom = 't'))
    }
  })
  
  # Cancel order handler
  observeEvent(input$cancel_order, {
    order_id <- input$cancel_order_id
    if (order_id != "") {
      idx <- which(shared_state$orders$order_id == order_id)
      if (length(idx) > 0) {
        shared_state$orders$status[idx] <- "Cancelled"
        reschedule_after_cancellation(order_id, shared_state)
        shinyalert("Success!", paste("Order", order_id, "cancelled."), type = "success")
      }
    }
  })
  
  # ========================================================================
  # PRODUCTION HISTORY MODULE
  # ========================================================================
  
  output$production_history_table <- renderDT({
    if (nrow(shared_state$orders) > 0) {
      completed_orders <- shared_state$orders[shared_state$orders$status %in% c("Completed", "Cancelled"), ]
      if (nrow(completed_orders) > 0) {
        datatable(
          completed_orders,
          options = list(
            pageLength = 10,
            searching = TRUE,
            ordering = TRUE,
            autoWidth = TRUE
          ),
          rownames = FALSE
        )
      } else {
        datatable(data.frame(Message = "No completed orders yet"), options = list(dom = 't'))
      }
    } else {
      datatable(data.frame(Message = "No orders"), options = list(dom = 't'))
    }
  })
  
  # ========================================================================
  # MACHINE SCHEDULE MODULE
  # ========================================================================
  
  output$machine_schedule_ui <- renderUI({
    create_machine_schedule_ui(shared_state$machines, shared_state$orders)
  })
  
  # ========================================================================
  # MONTHLY SUMMARY MODULE
  # ========================================================================
  
  output$monthly_summary_ui <- renderUI({
    create_monthly_summary_ui(shared_state$orders, shared_state$machines)
  })
  
  # ========================================================================
  # TIMELINE TRACKING MODULE
  # ========================================================================
  
  output$timeline_chart <- renderPlotly({
    create_gantt_chart(shared_state$orders, shared_state$machines)
  })
  
}

# ============================================================================
# RUN APPLICATION
# ============================================================================

shinyApp(ui = ui, server = server)
